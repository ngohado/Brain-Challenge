//
//  ChatViewController.swift
//  Brain Challenge
//
//  Created by Hado on 3/8/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import JSQMessagesViewController
import SwiftGifOrigin
import RxSwift
import RxCocoa
import Kingfisher
import Alamofire
import RealmSwift
import SVPullToRefresh

class ChatViewController: JSQMessagesViewController {
    
    var photoMessageMap = [String: JSQPhotoMediaItem]()
    
    var messages: [JSQMessage] = []
    var messagesSub: [Message] = []
    
    var msgTyping: Message?
    
    var idReceiver: String?
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SocketUtil.setMessageProtocol(listener: self)
        SocketUtil.setTypingProtocol(listener: self)
        
        self.senderId = MainViewController.idMe
        self.senderDisplayName = ""
        
        collectionView.contentInset.top = getTopInsect()
        collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        // No avatars
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        msgTyping = Message(idSender: senderId, idReceiver: idReceiver!, message: "", type: TypeMessage.TYPING, time: 0)
        loadData(time: Date().millisecondsSince1970)
        self.collectionView.addInfiniteScrolling(actionHandler: { 
            if self.messages.count > 0 {
                let oldBottomOffset = self.collectionView.contentSize.height - self.collectionView.contentOffset.y
                self.collectionView.collectionViewLayout.springinessEnabled = false
                self.collectionView.infiniteScrollingView.startAnimating()
                
                self.loadMessage(lastTime: self.messagesSub[0].time!.rounded()).subscribe(onNext: { (msgs) in
                    self.fetchData(msgs: msgs)
                    self.collectionView.reloadData()
                    self.collectionView.contentOffset = CGPoint(x: 0, y: self.collectionView.contentSize.height - oldBottomOffset)
                    
                    self.collectionView.infiniteScrollingView.stopAnimating()
                    self.collectionView.collectionViewLayout.springinessEnabled = true
                    
                }, onError: nil, onCompleted: {
                    
                }, onDisposed: nil).addDisposableTo(self.disposeBag)
            } else {
                self.loadData(time: Date().millisecondsSince1970)
            }

        }, direction: UInt(SVInfiniteScrollingDirectionTop))
        
    }
    
    func loadNewData(newId: String) {
        if idReceiver != newId {
            idReceiver = newId
            messages.removeAll()
            messagesSub.removeAll()
            photoMessageMap.removeAll()
            loadData(time: Date().millisecondsSince1970)
        }
    }
    
    func loadData(time: Double) {
        loadMessage(lastTime: time.rounded()).subscribe(onNext: { (msgs) in
            self.fetchData(msgs: msgs)
            self.collectionView.reloadData()
            self.scrollToBottom(animated: false)
        }, onError: nil, onCompleted: nil, onDisposed: nil).addDisposableTo(disposeBag)
    }
    
    func fetchData(msgs: [Message]) {
        for message in msgs {
            if message.type == 1 { // 1 normal message
                self.addMessageAtFirst(message)
            } else { // 2 image message
                if let mediaItem = JSQPhotoMediaItem(maskAsOutgoing: senderId == message.idSender) {
                    KingfisherManager.shared.downloader.downloadImage(with: URL(string: message.message!)!, options: [], progressBlock: nil, completionHandler: {(image, error, imageURL, originalData) -> () in
                        mediaItem.image = image
                        self.collectionView.reloadData()
                    })
                    self.addPhotoMessageAtFirst(message, key: "\(message.time!)", mediaItem: mediaItem)
                }
            }
            
        }
    }
    
    func addMessage(_ message: Message) {
        if let jsqMessage = JSQMessage(senderId: message.idSender, displayName: "", text: message.message) {
            messages.append(jsqMessage)
            messagesSub.append(message)
        }
    }
    
    func addMessageAtFirst(_ message: Message) {
        if let jsqMessage = JSQMessage(senderId: message.idSender, displayName: "", text: message.message) {
            messages.insert(jsqMessage, at: 0)
            messagesSub.insert(message, at: 0)
        }
    }
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        if message.senderId == senderId {
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let msg = Message(idSender: senderId, idReceiver: idReceiver!, message: text, type: TypeMessage.MESSAGE_NORMAL, time: date.millisecondsSince1970)
        SocketUtil.emitData(event: EmitEventConstant.getMessagingEvent(), jsonData: msg.toJSONString()!)
        
        addMessage(msg)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        finishSendingMessage()
    }
    
    override func didPressAccessoryButton(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        present(picker, animated: true, completion:nil)
    }
    
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        print(textView.text)
        if textView.text.isEmpty {
            msgTyping?.type = TypeMessage.UNTYPING
            SocketUtil.emitData(event: EmitEventConstant.getTypingEvent(), jsonData: (msgTyping?.toJSONString())!)
            return
        }
        
        if !textView.text.isEmpty {
            msgTyping?.type = TypeMessage.TYPING
            SocketUtil.emitData(event: EmitEventConstant.getTypingEvent(), jsonData: (msgTyping?.toJSONString())!)
            return
        }
    }
    
    func addPhotoMessage(_ message: Message, key: String, mediaItem: JSQPhotoMediaItem) {
        if let jsqMessage = JSQMessage(senderId: message.idSender, displayName: "", media: mediaItem) {
            messages.append(jsqMessage)
            messagesSub.append(message)
            
            if (mediaItem.image == nil) {
                mediaItem.image = UIImage.gif(name: "loading")
                photoMessageMap[key] = mediaItem
            }
        }
    }
    
    func addPhotoMessageAtFirst(_ message: Message, key: String, mediaItem: JSQPhotoMediaItem) {
        if let jsqMessage = JSQMessage(senderId: message.idSender, displayName: "", media: mediaItem) {
            messages.insert(jsqMessage, at: 0)
            messagesSub.insert(message, at: 0)
            
            if (mediaItem.image == nil) {
                mediaItem.image = UIImage.gif(name: "loading")
                photoMessageMap[key] = mediaItem
            }
        }
    }
    
    //remove avatar
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
}

extension ChatViewController: SocketHandleData {
    func onReceive<BaseResponse>(event: String, data: BaseResponse) {
        switch event {
        case OnEventConstant.getMessageEvent():
            handleMessage(message: (data as! MessageResponse).messages!)
            break
        case OnEventConstant.getOnlineEvent():
            handleOnline(id: (data as! StatusResponse).id!)
            break
        case OnEventConstant.getOfflineEvent():
            handleOnline(id: (data as! StatusResponse).id!)
            break
        case OnEventConstant.getTypingEvent():
            handleTyping(message: (data as! MessageResponse).messages!)
            break
        default:
            print(event)
        }
    }
    
    func handleMessage(message: Message) {
        if message.idSender == idReceiver {
            if message.type == 1 { // 1 normal message
                addMessage(message)
                if self.showTypingIndicator {
                    self.showTypingIndicator = false
                }
                
            } else { // 2 image message
                if let mediaItem = JSQPhotoMediaItem(maskAsOutgoing: senderId == message.idSender) {
                    KingfisherManager.shared.downloader.downloadImage(with: URL(string: message.message!)!, options: [], progressBlock: nil, completionHandler: {(image, error, imageURL, originalData) -> () in
                        mediaItem.image = image
                        self.collectionView.reloadData()
                    })
                    addPhotoMessage(message, key: "\(message.time!)", mediaItem: mediaItem)
                }
            }
            
            finishReceivingMessage()
        }
    }
    
    func handleOnline(id: String) {
        if id == idReceiver {
            
        }
    }
    
    func handleOffline(id: String) {
        if id == idReceiver {
            
        }
    }
    
    func handleTyping(message: Message) {
        if message.idSender == idReceiver {
            if message.type == TypeMessage.TYPING {
                if !self.showTypingIndicator {
                    self.showTypingIndicator = true
                }
            } else {
                if self.showTypingIndicator {
                    self.showTypingIndicator = false
                }
            }
        }
    }
    
    func loadMessage(lastTime: Double) -> Observable<[Message]> {
        return Observable<[Message]>.concat([MessageRealm.getMessage(idSender: self.senderId, idReceiver: idReceiver!, lastTime: lastTime), loadFromAPI(idSender: self.senderId, idReceiver: idReceiver!, lastTime: lastTime.rounded())])
            .filter({ (msgs) -> Bool in
                if(msgs.count == 0) {
                    self.collectionView.infiniteScrollingView.stopAnimating()
                    self.collectionView.collectionViewLayout.springinessEnabled = true
                }
                return msgs.count > 0
            }).single().observeOn(MainScheduler.instance)
    }
    
    
}

extension ChatViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let message = Message(idSender: self.senderId, idReceiver: self.idReceiver!, message: "", type: TypeMessage.MESSAGE_PHOTO, time: Date().millisecondsSince1970)
        if let mediaItem = JSQPhotoMediaItem(maskAsOutgoing: true) {
            addPhotoMessage(message, key: "\(message.time!)", mediaItem: mediaItem)
            finishSendingMessage()
        }
        
        picker.dismiss(animated: true, completion: nil)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if let imageData = UIImageJPEGRepresentation(chosenImage, 0.2) {
                multipartFormData.append(imageData, withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
            }
            
        }, to: ApiConstant.getApiUploadImage(), method: .post, headers: nil, encodingCompletion: {
            endcodingResult in
            switch endcodingResult {
            case .success(let upload, _, _):
                upload.responseObject {
                    (response: DataResponse<ImageUploadResponse>) in
                    self.photoMessageMap["\(message.time!)"]?.image = chosenImage
                    self.collectionView.reloadData()
                    
                    message.message = (response.value?.imageUrl)!
                    SocketUtil.emitData(event: EmitEventConstant.getMessagingEvent(), jsonData: message.toJSONString()!)
                }
            case .failure(let encodingError):
                print("error:\(encodingError)")
            }
        })

    }
}

extension ChatViewController: LoadingMessage {
    internal func loadFromAPI(idSender: String, idReceiver: String, lastTime: Double) -> Observable<[Message]> {
        return Observable<[Message]>.create({ (observer) -> Disposable in
            
            let req = MessageHistoryRequest(idSender: idSender, idReceiver: idReceiver, lastTime: lastTime.rounded())
            let request = Alamofire.request(ApiConstant.getApiMessageHistory(), method: .post, parameters: req.toJSON(), encoding: JSONEncoding.default).responseObject {
                (res: DataResponse<MessageHistoryResponse>) in
                if let msgRes = res.value, msgRes.status == 1 {
                    let msgs = (msgRes.messages)!
                    observer.onNext(msgs)
                } else {
                    observer.onNext([])
                }
                
                observer.onCompleted()
            }
            
            return Disposables.create {
                request.cancel()
            }
        })
        
    }
}


protocol LoadingMessage: class {
    func loadFromAPI(idSender: String, idReceiver: String, lastTime: Double) -> Observable<[Message]>
}
