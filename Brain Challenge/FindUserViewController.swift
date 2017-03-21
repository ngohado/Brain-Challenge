//
//  FindUserViewController.swift
//  Brain Challenge
//
//  Created by Hado on 3/6/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

class FindUserViewController: UIViewController {
    
    class func getIdentifier() -> String {
        return "FindUserViewController"
    }
    
    @IBOutlet weak var edtSearch: UISearchBar!
    @IBOutlet weak var usersTableView: UITableView!
    var dispose: Disposable?
    let id = (UserRealm.getUserInfo()?._id)!
    var users: [UserInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usersTableView.contentInset.top = getTopInsect() + edtSearch.frame.height
        usersTableView.contentInset.bottom = 50
        
        usersTableView.dataSource = self
        usersTableView.delegate = self
        
        dispose = edtSearch.rx.text.orEmpty
            .throttle(2.0, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMap({ (query: String) -> Observable<SearchUserResponse> in
                if query.isEmpty {
                    return .just(SearchUserResponse())
                }
                return self.requestSearch(textSearch: query)
            })
            .map {
                response -> [UserInfo] in
                if((response.status)! == 1) {
                    return (response.users)!
                }
                return []
            }
            .observeOn(MainScheduler.instance).subscribe(onNext: { (usersResponse) in
                self.users = usersResponse
                self.usersTableView.reloadData()
            }, onError: { (error) in
                
            }, onCompleted: nil, onDisposed: nil)
    }
    
    func requestSearch(textSearch: String) -> Observable<SearchUserResponse> {
        return Observable<SearchUserResponse>.create({ (observer) -> Disposable in
            let req = SearchUserRequest()
            req.id = self.id
            req.textSearch = textSearch
            let request = Alamofire.request(ApiConstant.getApiSearchUser(), method: .post, parameters: req.toJSON(), encoding: JSONEncoding.default).responseObject(completionHandler: { (response: DataResponse<SearchUserResponse>) in
                observer.onNext(response.value!)
                observer.onCompleted()
            })
            
            return Disposables.create {
                request.cancel()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        dispose?.dispose()
    }
    

}


extension FindUserViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ProfileViewController.navigate(viewConstroller: self, idShow: users[indexPath.row]._id!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        var cell: UITableViewCell?
        switch user.typeFriend! {
        case TypeFriend.FRIEND:
            cell = usersTableView.dequeueReusableCell(withIdentifier: FriendViewCell.getIdentifier(), for: indexPath)
            let friendCell = cell as! FriendViewCell
            friendCell.btnStatusFriend.isHidden = false
            friendCell.btnStatusFriend.setTitleChaneSize(title: "Friend")
            friendCell.bindData(data: user)
            friendCell.handleFriendClicked = {
                AlertHelper.showAlertFriendSheet(viewController: self, cbCancelFriend: { (alsert) in
                    self.requestUserAction(api: ApiConstant.getApiCancelFriend(), idSender: self.users[indexPath.row]._id!, idReceiver: self.id, callback: { (success) in
                        if success {
                            self.users[indexPath.row].typeFriend = TypeFriend.NOT_FRIEND
                        }
                    })
                })
            }
            
            break
        case TypeFriend.NOT_FRIEND:
            cell = usersTableView.dequeueReusableCell(withIdentifier: FriendViewCell.getIdentifier(), for: indexPath)
            let friendCell = cell as! FriendViewCell
            friendCell.btnStatusFriend.isHidden = false
            friendCell.btnStatusFriend.setTitleChaneSize(title: "Add friend")
            friendCell.bindData(data: user)
            friendCell.handleFriendClicked = {
                self.requestUserAction(api: ApiConstant.getApiAddFriend(), idSender: self.id, idReceiver: self.users[indexPath.row]._id!, callback: { (success) in
                    if success {
                        self.users[indexPath.row].typeFriend = TypeFriend.SEND_REQUEST
                    }
                })
            }
            break
        case TypeFriend.SEND_REQUEST:
            cell = usersTableView.dequeueReusableCell(withIdentifier: FriendViewCell.getIdentifier(), for: indexPath)
            let friendCell = cell as! FriendViewCell
            friendCell.btnStatusFriend.isHidden = false
            friendCell.btnStatusFriend.setTitleChaneSize(title: "Cancel request")
            friendCell.bindData(data: user)
            friendCell.handleFriendClicked = {
                self.requestUserAction(api: ApiConstant.getApiCancelRequestFriend(), idSender: self.id, idReceiver: self.users[indexPath.row]._id!, callback: { (success) in
                    if success {
                        self.users[indexPath.row].typeFriend = TypeFriend.NOT_FRIEND
                    }
                })
            }
            break
        case TypeFriend.RECEIVE_REQUEST:
            cell = usersTableView.dequeueReusableCell(withIdentifier: RequestFriendViewCell.getIdentifier(), for: indexPath)
            let friendCell = cell as! RequestFriendViewCell
            friendCell.bindData(data: user)
            friendCell.handelCancelClicked = {
                self.requestUserAction(api: ApiConstant.getApiCancelRequestFriend(), idSender: self.users[indexPath.row]._id!, idReceiver: self.id, callback: { (success) in
                    if success {
                        self.users[indexPath.row].typeFriend = TypeFriend.NOT_FRIEND
                    }
                })
            }
            
            friendCell.handelAcceptClicked = {
                self.requestUserAction(api: ApiConstant.getApiAcceptRequestFriend(), idSender: self.users[indexPath.row]._id!, idReceiver: self.id, callback: { (success) in
                    if success {
                        self.users[indexPath.row].typeFriend = TypeFriend.FRIEND
                    }
                })
            }
            break
        case TypeFriend.YOURSELF:
            cell = usersTableView.dequeueReusableCell(withIdentifier: FriendViewCell.getIdentifier(), for: indexPath)
            let friendCell = cell as! FriendViewCell
            friendCell.btnStatusFriend.isHidden = true
            friendCell.bindData(data: user)
            break
        default: break
            
        }
        
        return cell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func requestUserAction(api: String, idSender: String, idReceiver: String, callback: @escaping (Bool) -> Void) {
        let req = UserActionRequest()
        req.idSender = idSender
        req.idReceiver = idReceiver
        
        Alamofire.request(api, method: .post, parameters: req.toJSON(), encoding: JSONEncoding.default).responseObject {
            (resonpose: DataResponse<BaseResponse>) in
            if let dataRes = resonpose.value, dataRes.status == 1 {
                callback(true)
                self.usersTableView.reloadData()
            } else {
                callback(false)
            }
        }
    }

}
