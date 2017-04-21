//
//  InviteViewController.swift
//  Brain Challenge
//
//  Created by Hado on 4/20/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import UIKit
import Alamofire

class InviteViewController: UIViewController {
    
    class func navigate(viewConstroller: UIViewController, room: Room, cb: @escaping (_ success: Bool) -> Void) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: InviteViewController.getIdentifier()) as! InviteViewController
        vc.cbInvite = cb
        vc.room = room
        viewConstroller.navigationController?.pushViewController(vc, animated: true)
    }
    
    class func getIdentifier() -> String {
        return "InviteViewController"
    }
    
    var cbInvite: ((_ success: Bool) -> Void)?
    
    @IBOutlet weak var friendsTableView: UITableView!

    let id = (UserRealm.getUserInfo()?._id)!
    
    var room: Room?
    
    var friends: [User] = []
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SocketUtil.sentInvitationProtocol = self
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        
        friendsTableView.dataSource = self
        friendsTableView.delegate = self
        loadFriend()
        
    }
    
    func loadFriend() {
        let req = FriendRequest()
        req.id = id
        Alamofire.request(ApiConstant.getApiFriend(), method: .post, parameters: req.toJSON(), encoding: JSONEncoding.default).responseObject {
            (dataResponse: DataResponse<FriendResponse>) in
            if let response = dataResponse.value, response.status == 1 {
                self.friends = (response.friends?.friends)!
            } else {
                self.friends = []
            }
            
            self.friendsTableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension InviteViewController: SocketHandleData {
    func onReceive<BaseMappable>(event: String, data: BaseMappable) {
        let res = data as! BaseResponse
        if res.status == 1 {
            cbInvite!(true)
        } else {
            AlertHelper.showAlert(viewController: self, title: "Friend offline", message: "Your friend is offline now!", titleButton: "OK")
        }
    }
}

extension InviteViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ProfileViewController.navigate(viewConstroller: self, idShow: friends[indexPath.row]._id!)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        cell = friendsTableView.dequeueReusableCell(withIdentifier: InviteTableViewCell.getIdentifier(), for: indexPath)
        let friendCell = (cell as! InviteTableViewCell)
        friendCell.bindData(data: friends[indexPath.row])
        friendCell.handleFriendClicked = {
            let req: InvitationModel = InvitationModel(idRecipient: self.friends[indexPath.row]._id, room: self.room)
            SocketUtil.emitBattleData(event: EmitEventConstant.getSentInvitationEvent(), jsonData: req.toJSONString()!)
        }
        
        return cell!
    }
    
}

