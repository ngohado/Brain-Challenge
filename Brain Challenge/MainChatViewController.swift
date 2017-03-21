//
//  MainChatViewController.swift
//  Brain Challenge
//
//  Created by Hado on 3/18/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import UIKit

class MainChatViewController: UIViewController {
    
    class func getIdentifier() -> String {
        return "MainChatViewController"
    }
    
    @IBOutlet weak var mainChatTableView: UITableView!
    
    static var friendOnline: [User] = []
    static var friendOffline: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        SocketUtil.setOnlineProtocol(listener: self)
        SocketUtil.setOfflineProtocol(listener: self)
        mainChatTableView.dataSource = self
        mainChatTableView.delegate = self
        mainChatTableView.contentInset.top = getTopInsect()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainChatTableView.reloadData()
    }
}

extension MainChatViewController: SocketHandleData {
    func onReceive<BaseResponse>(event: String, data: BaseResponse) {
        switch event {
        case OnEventConstant.getMessageEvent():
//            handleMessage(message: (data as! MessageResponse).messages!)
            break
        case OnEventConstant.getOnlineEvent():
            self.mainChatTableView.reloadData()
            break
        case OnEventConstant.getOfflineEvent():
            self.mainChatTableView.reloadData()
            break
        case OnEventConstant.getTypingEvent():
//            handleTyping(message: (data as! MessageResponse).messages!)
            break
        default:
            print(event)
        }
    }
}

extension MainChatViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var user: User?
        if indexPath.section == 0 {
            user = MainChatViewController.friendOnline[indexPath.row]
        } else {
            user = MainChatViewController.friendOffline[indexPath.row]
        }
        user?.isRead = true
        let mainVC = parent as! MainViewController
        if mainVC.chatViewController?.idReceiver != nil &&
                mainVC.chatViewController?.idReceiver != user?._id {
            mainVC.chatViewController?.loadNewData(newId: (user?._id)!)
        } else {
            mainVC.chatViewController?.idReceiver = user?._id
        }
        
        mainVC.tab4Clicked(Any.self)
        mainChatTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Friends Online"
        } else {
            return "Friends Offline"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return MainChatViewController.friendOnline.count
        } else {
            return MainChatViewController.friendOffline.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell?
        
        if indexPath.section == 0 {
            if MainChatViewController.friendOnline[indexPath.row].isRead {
                cell = mainChatTableView.dequeueReusableCell(withIdentifier: StatusViewCell.getIdentifier(), for: indexPath) as! StatusViewCell
                (cell as! StatusViewCell).bindData(user: MainChatViewController.friendOnline[indexPath.row], isOnline: true)
            } else {
                cell = mainChatTableView.dequeueReusableCell(withIdentifier: Status2ViewCell.getIdentifier(), for: indexPath) as! Status2ViewCell
                (cell as! Status2ViewCell).bindData(user: MainChatViewController.friendOnline[indexPath.row], isOnline: true)
            }
        } else {
            if MainChatViewController.friendOffline[indexPath.row].isRead {
                cell = mainChatTableView.dequeueReusableCell(withIdentifier: StatusViewCell.getIdentifier(), for: indexPath) as! StatusViewCell
                (cell as! StatusViewCell).bindData(user: MainChatViewController.friendOffline[indexPath.row], isOnline: false)
            } else {
                cell = mainChatTableView.dequeueReusableCell(withIdentifier: Status2ViewCell.getIdentifier(), for: indexPath) as! Status2ViewCell
                (cell as! Status2ViewCell).bindData(user: MainChatViewController.friendOffline[indexPath.row], isOnline: false)
            }
        }
        
        return cell!
    }
    
}

