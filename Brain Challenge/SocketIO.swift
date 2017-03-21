//
//  SocketIO.swift
//  Brain Challenge
//
//  Created by Hado on 2/23/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import SocketIO
import ObjectMapper

extension SocketIOClient {
    func onJson<T: BaseMappable>(event: String, callback: @escaping (_ response: T) -> Void) {
        on(event) {data, ack in
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data[0], options: .prettyPrinted)
                let res = Mapper<T>().map(JSONString: String(data: jsonData, encoding: String.Encoding.utf8)!)
                
                callback(res!)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    

}

class SocketUtil {
    private static var isConnect: Bool = false
    
    static let socketChat = SocketIOClient(socketURL: URL(string: "\(ApiConstant.BASE_URL):3000")!, config: [.log(true), .forcePolling(true), .nsp("/chat")])
    
    static let socketBattle = SocketIOClient(socketURL: URL(string: "\(ApiConstant.BASE_URL):3000")!, config: [.log(true), .forcePolling(true), .nsp("/battle")])
    
    static var msgHistoryProtocol: [SocketHandleData] = []
    static var messageProtocol: [SocketHandleData] = []
    static var onlineProtocol: [SocketHandleData] = []
    static var offlineProtocol: [SocketHandleData] = []
    static var typingProtocol: SocketHandleData?
    static var haveOfflineMsgProtocol: SocketHandleData?
    
    
    class func setMsgHistoryProtocol(listener: SocketHandleData) {
        msgHistoryProtocol.append(listener)
    }
    
    class func setMessageProtocol(listener: SocketHandleData) {
        messageProtocol.append(listener)
    }
    
    class func setOnlineProtocol(listener: SocketHandleData) {
        onlineProtocol.append(listener)
    }
    
    class func setOfflineProtocol(listener: SocketHandleData) {
        offlineProtocol.append(listener)
    }
    
    class func setTypingProtocol(listener: SocketHandleData) {
        typingProtocol = listener
    }
    
    class func emitData(event: String, jsonData: String) {
        socketChat.emit(event, jsonData)
    }
    
    class func connectChat() {
        if isConnect {
            return
        }
        
        socketChat.on(OnEventConstant.getConnectionEvent()) {
            data, ack in
            isConnect = true
            //TODO: emit id to sever
            socketChat.emit(EmitEventConstant.getInitDataEvent(), (UserRealm.getUserInfo()?.toJSONString())!)
        }
        
        socketChat.onJson(event: OnEventConstant.getMessageHistoryEvent()) { (messages: MessageHistoryResponse) in
            for listener in msgHistoryProtocol {
                listener.onReceive(event: OnEventConstant.getMessageHistoryEvent(), data: messages)
            }
        }
        
        socketChat.onJson(event: OnEventConstant.getMessageEvent()) { (messages: MessageResponse) in
            MainChatViewController.friendOnline.sort(by: { (u1, u2) -> Bool in
                let idSender = (messages.messages?.idSender)
                return u2._id == idSender
            })
            
            for listener in messageProtocol {
                listener.onReceive(event: OnEventConstant.getMessageEvent(), data: messages)
            }
        }
        
        socketChat.onJson(event: OnEventConstant.getOnlineEvent()) { (status: StatusResponse) in
            for (index, value) in MainChatViewController.friendOffline.enumerated().reversed() {
                if value._id == status.id {
                    MainChatViewController.friendOnline.append(value)
                    MainChatViewController.friendOffline.remove(at: index)
                    break
                }
            }
            
            for listener in onlineProtocol {
                listener.onReceive(event: OnEventConstant.getOnlineEvent(), data: status)
            }
        }
        
        socketChat.onJson(event: OnEventConstant.getOfflineEvent()) { (status: StatusResponse) in
            for (index, value) in MainChatViewController.friendOnline.enumerated().reversed() {
                if value._id == status.id {
                    MainChatViewController.friendOffline.append(value)
                    MainChatViewController.friendOnline.remove(at: index)
                    break
                }
            }
            
            for listener in offlineProtocol {
                listener.onReceive(event: OnEventConstant.getOfflineEvent(), data: status)
            }
        }
        
        socketChat.onJson(event: OnEventConstant.getTypingEvent()) { (messages: MessageResponse) in
            typingProtocol?.onReceive(event: OnEventConstant.getTypingEvent(), data: messages)
        }
        
        socketChat.onJson(event: OnEventConstant.getFriendsOnlineEvent()) { (response: FriendOnlineResponse) in
            MainChatViewController.friendOnline = response.friendStatusModel!.friendsOnline!
            MainChatViewController.friendOffline = response.friendStatusModel!.friendsOffline!
            
            for listener in onlineProtocol {
                listener.onReceive(event: OnEventConstant.getOnlineEvent(), data: response)
            }
            
            for friend in MainChatViewController.friendOnline {
                if !friend.isRead {
                    haveOfflineMsgProtocol?.onReceive(event: "Have message offline", data: response)
                    return
                }
            }
            
            for friend in MainChatViewController.friendOffline {
                if !friend.isRead {
                    haveOfflineMsgProtocol?.onReceive(event: "Have message offline", data: response)
                    return
                }
            }
        }
        
        socketChat.connect()
    }
}

protocol SocketHandleData: class {
    func onReceive<T: BaseMappable> (event: String, data: T)
}

extension Date {
    var millisecondsSince1970:Double {
        return (self.timeIntervalSince1970 * 1000.0).rounded()
    }
}
