//
//  FriendsViewController.swift
//  Brain Challenge
//
//  Created by Hado on 3/3/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import UIKit
import Alamofire

class FriendsViewController: UIViewController {
    
    @IBOutlet weak var friendsTableView: UITableView!
    
    let id = (UserRealm.getUserInfo()?._id)!
//    let id = "58984d5efefb94049767d36b"
    
    var friends: [User] = []
    var friendsRequest: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                self.friendsRequest = (response.friends?.friendsRequest)!
            } else {
                self.friends = []
                self.friendsRequest = []
            }
            
            self.friendsTableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension FriendsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var idShow:String?
        if indexPath.section == 0 {
            idShow = friendsRequest[indexPath.row]._id
        } else {
            idShow = friends[indexPath.row]._id
        }
        
        ProfileViewController.navigate(viewConstroller: self, idShow: idShow!)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Request friends"
        } else {
            return "Friends"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return friendsRequest.count
        } else {
            return friends.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        if indexPath.section == 0 {
            cell = friendsTableView.dequeueReusableCell(withIdentifier: RequestFriendViewCell.getIdentifier(), for: indexPath)
            let reqFriendCell = (cell as! RequestFriendViewCell)
            reqFriendCell.bindData(data: friendsRequest[indexPath.row])
            reqFriendCell.handelCancelClicked = {
                self.requestUserAction(api: ApiConstant.getApiCancelRequestFriend(), idSender: self.friendsRequest[indexPath.row]._id!, idReceiver: self.id)
            }
            
            reqFriendCell.handelAcceptClicked = {
                self.requestUserAction(api: ApiConstant.getApiAcceptRequestFriend(), idSender: self.friendsRequest[indexPath.row]._id!, idReceiver: self.id)
            }
        } else {
            cell = friendsTableView.dequeueReusableCell(withIdentifier: FriendViewCell.getIdentifier(), for: indexPath)
            let friendCell = (cell as! FriendViewCell)
            friendCell.bindData(data: friends[indexPath.row])
            friendCell.handleFriendClicked = {
                AlertHelper.showAlertFriendSheet(viewController: self, cbCancelFriend: { (alert) in
                    self.requestUserAction(api: ApiConstant.getApiCancelFriend(), idSender: self.friends[indexPath.row]._id!, idReceiver: self.id)
                })
            }
        }
        
        return cell!
    }
    
    func requestUserAction(api: String, idSender: String, idReceiver: String) {
        let req = UserActionRequest()
        req.idSender = idSender
        req.idReceiver = idReceiver
        
        Alamofire.request(api, method: .post, parameters: req.toJSON(), encoding: JSONEncoding.default).responseObject {
            (resonpose: DataResponse<BaseResponse>) in
            if let dataRes = resonpose.value, dataRes.status == 1 {
                self.loadFriend()
            }
        }
    }

}
