//
//  MainViewController.swift
//  Brain Challenge
//
//  Created by Hado on 2/14/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import UIKit
import SocketIO

class MainViewController: UIViewController {
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var tab1: UIButton!
    @IBOutlet weak var tab2: UIButton!
    @IBOutlet weak var tab3: UIButton!
    @IBOutlet weak var tab4: UIButton!
    @IBOutlet weak var ivDotTab3: UIImageView!
    @IBOutlet weak var ivDotTab4: UIImageView!
    
    var currentTab: UIViewController?
    
    var drawerViewController: DrawerViewController?
    
    var viewControllerMenuRight: [UIViewController] = []
    
    var roomViewController: RoomViewController?
    var searchViewController: FindUserViewController?
    var chatViewController: ChatViewController?
    var mainChatViewController: MainChatViewController?
    
    static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    static let idMe = UserRealm.getUserInfo()?._id
    

    override func viewDidLoad() {
        super.viewDidLoad()
        drawerViewController?.drawerProtocol = self
        SocketUtil.setMessageProtocol(listener: self)
        SocketUtil.haveOfflineMsgProtocol = self
        SocketUtil.receiveInvitationProtocol = self
        
        automaticallyAdjustsScrollViewInsets = false
        
        initViewControllerMenuRight()
        initViewControllerTab()
        
        currentTab = roomViewController
        fetchView()
        self.title = "Room"
        
        SocketUtil.connectChat()
    }
    
    func initViewControllerMenuRight() {
        viewControllerMenuRight.append(MainViewController.mainStoryboard.instantiateViewController(withIdentifier: EventViewController.getIdentifier()))
        viewControllerMenuRight.append(UIViewController())
        viewControllerMenuRight.append(MainViewController.mainStoryboard.instantiateViewController(withIdentifier: FriendsViewController.getIdentifier()))
        viewControllerMenuRight.append(MainViewController.mainStoryboard.instantiateViewController(withIdentifier: RankViewController.getIdentifier()))
        viewControllerMenuRight.append(UIViewController())
    }
    
    func initViewControllerTab() {
        roomViewController = MainViewController.mainStoryboard.instantiateViewController(withIdentifier: RoomViewController.getIdentifier()) as? RoomViewController
        
        searchViewController = MainViewController.mainStoryboard.instantiateViewController(withIdentifier: FindUserViewController.getIdentifier()) as? FindUserViewController
        
        mainChatViewController = MainViewController.mainStoryboard.instantiateViewController(withIdentifier: MainChatViewController.getIdentifier()) as? MainChatViewController
        
        chatViewController = ChatViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func menuClicked(_ sender: Any) {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
    
    @IBAction func tab1Clicked(_ sender: Any) {
        if (currentTab as? RoomViewController) != nil {
            return
        }
        currentTab = roomViewController
        fetchView()
        self.title = "Room"
    }
    
    @IBAction func tab2Clicked(_ sender: Any) {
        if (currentTab as? FindUserViewController) != nil {
            return
        }
        currentTab = searchViewController
        fetchView()
        self.title = "Search"
    }
    
    @IBAction func tab3Clicked(_ sender: Any) {
        ivDotTab3.isHidden = true
        if (currentTab as? MainChatViewController) != nil {
            return
        }
        currentTab = mainChatViewController
        fetchView()
        self.title = "Chat"
    }
    
    @IBAction func tab4Clicked(_ sender: Any) {
        if chatViewController?.idReceiver == nil {
            tab3Clicked(Any.self)
            return
        }
        
        if (currentTab as? ChatViewController) != nil {
            return
        }
        
        ivDotTab4.isHidden = true
        currentTab = chatViewController
        
        fetchView()
    }
    
    func fetchView() {
        addChildViewController(currentTab!)
        currentTab?.view.frame = container.bounds
        container.addSubview((currentTab?.view)!)
        currentTab?.didMove(toParentViewController: self)
    }

}

extension MainViewController: SocketHandleData {
    func onReceive<BaseResponse>(event: String, data: BaseResponse) {
        switch event {
        case OnEventConstant.getMessageEvent():
            let msg = (data as! MessageResponse).messages
            if let chatVC = currentTab as? ChatViewController {
                if msg?.idSender != chatVC.idReceiver {
                    ivDotTab3.isHidden = false
                    MainChatViewController.friendOnline[0].isRead = false
                }
            } else if (currentTab as? MainChatViewController) != nil {
                if msg?.idSender == chatViewController?.idReceiver {
                    ivDotTab4.isHidden = false
                } else {
                    
                    //TODO: xu ly tab 3 hien thi tin nhan moi den va reload lai list view
                }
            } else {
                if msg?.idSender == chatViewController?.idReceiver {
                    ivDotTab4.isHidden = false
                } else {
                    ivDotTab3.isHidden = false
                    //TODO: xu ly tab 3 hien thi tin nhan moi den va reload lai list view
                }
            }
            break
        case "Have message offline":
            ivDotTab3.isHidden = false
            break
        case EmitEventConstant.getReceiveInvitationEvent():
            let room = (data as! RoomActionResponse).room
            let title = "Onwer room \((room?.roomName)!) is \((room?.userHost?.name)!) inviting you"
            AlertHelper.showAlert(viewController: self, title: "Have invitation", message: title, titleButton1: "Reject", titleButton2: "Accept", callback1: { (alert) in
                SocketUtil.emitBattleData(event: EmitEventConstant.getResultInvitationEvent(), jsonData: (room?.toJSONString())!)
            }, callback2: { (alert) in
                room?.userMember = UserRealm.getUserInfo()
                SocketUtil.emitBattleData(event: EmitEventConstant.getResultInvitationEvent(), jsonData: (room?.toJSONString())!)
                WaitingRoomViewController.navigate(viewController: self, room: room!, cbUpdate: { 
                    //do nothing
                })
            })
            break
        default:
            print(event)
        }
    }
}

extension MainViewController: DrawerProtocol {
    func selectedItem(index: Int) {
        if index == -1 {
            let profileVC = MainViewController.mainStoryboard.instantiateViewController(withIdentifier: ProfileViewController.getIdentifier()) as! ProfileViewController
            profileVC.isPresent = true
            profileVC.idShow = (UserRealm.getUserInfo()?._id)!
            currentTab = profileVC
            self.title = "Profile"
        } else if index == 1 {
            AlertHelper.showDialogCreateRoom(viewController: self, cbCancelFriend: { (alert) in
                
            }, cbCreate: { (alert, roomName, password) in
                let userHost = UserRealm.getUserInfo()
                let roomCreated: Room = Room(userHost: userHost!, userMember: nil, roomName: roomName, password: password, time: Date().millisecondsSince1970)
                SocketUtil.emitBattleData(event: EmitEventConstant.getCreateRoomEvent(), jsonData: roomCreated.toJSONString()!)
                WaitingRoomViewController.navigate(viewController: self, room: roomCreated) {
                    
                }
            })
        } else {
            currentTab = viewControllerMenuRight[index]
            if index == 0 {
                self.title = "Event"
            } else if index == 2 {
                self.title = "Friend"
            } else if index == 3 {
                self.title = "Rank"
            }
        }
        
        fetchView()
    }
    
    
    class func navigate(viewController: UIViewController) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyBoard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        let drawerViewController = storyBoard.instantiateViewController(withIdentifier: "DrawerViewController") as! DrawerViewController
        let drawerController = KYDrawerController(drawerDirection: .left, drawerWidth: 300)
        drawerController.mainViewController = UINavigationController(
            rootViewController: mainViewController
        )   
        
        drawerController.drawerViewController = drawerViewController
        
        mainViewController.drawerViewController = drawerViewController
        viewController.present(drawerController, animated: true, completion: nil)
    }
}
