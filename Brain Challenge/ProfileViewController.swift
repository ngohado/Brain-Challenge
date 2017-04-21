//
//  ProfileViewController.swift
//  Brain Challenge
//
//  Created by Hado on 2/28/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class ProfileViewController: UIViewController {
    
    class func navigate(viewConstroller: UIViewController, idShow: String) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: ProfileViewController.getIdentifier()) as! ProfileViewController
        vc.idShow = idShow
        vc.isPresent = false
        viewConstroller.navigationController?.pushViewController(vc, animated: true)
    }
    
    class func getIdentifier() -> String {
        return "ProfileViewController"
    }
    
    @IBOutlet weak var scrollVIew: UIScrollView!
    @IBOutlet weak var ivAvatar: UIImageView!
    @IBOutlet weak var ivFriendStatus: UIButton!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbScore: UILabel!
    @IBOutlet weak var ivRank: UIImageView!
    @IBOutlet weak var lbUsername: UILabel!
    @IBOutlet weak var lbEmail: UILabel!
    @IBOutlet weak var lbPhone: UILabel!
    @IBOutlet weak var lbGender: UILabel!
    @IBOutlet weak var lbAccount: UILabel!
    @IBOutlet weak var btnStatusFriend: UIButton!
    
    @IBOutlet weak var item1Quantity: UILabel!
    @IBOutlet weak var item2Quantity: UILabel!
    @IBOutlet weak var item3Quantity: UILabel!
    @IBOutlet weak var item4Quantity: UILabel!
    
    var idShow: String = ""
    var isPresent: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isPresent! {
            scrollVIew.contentInset.top = getTopInsect()
        } else {
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
        }
        
        
        if idShow.isEmpty {
            dismiss(animated: true, completion: nil)
            return
        }
        
        setupView()
        
        loadInfo()
    }

    func setupView() {
        //image avatar
        ivAvatar.layer.cornerRadius = ivAvatar.frame.height / 2
        ivAvatar.layer.borderWidth = 2
        ivAvatar.layer.borderColor = UIColor.lightGray.cgColor
        ivAvatar.clipsToBounds = true
        
        //button friend status
        btnStatusFriend.layer.cornerRadius = btnStatusFriend.frame.height / 2
        btnStatusFriend.layer.borderWidth = 1
        btnStatusFriend.layer.borderColor = UIColor.init(hexString: "#B574F5").cgColor
        btnStatusFriend.clipsToBounds = true
        
    }
    
    func loadInfo() {
        let req = UserInfoRequest()
        req.id = UserRealm.getUserInfo()?._id
        req.idShow = idShow
        Alamofire.request(ApiConstant.getApiUserInfo(), method: .post, parameters: req.toJSON(), encoding: JSONEncoding.default).responseObject {
            (resonpose: DataResponse<UserInfoResponse>) in
            if let dataRes = resonpose.value {
                if dataRes.status == 1 {
                    self.handleData(user: dataRes.userInfo!)
                } else {
                    //handle error
                }
            }
        }
    }
    
    func handleData(user: UserInfo) {
        if let userName = user.username {
            lbUsername.text = userName
            lbName.text = userName
        }
        
        if let email = user.email {
            lbEmail.text = email
        } else {
            lbEmail.text = ""
        }
        
        if let phone = user.phone {
            lbPhone.text = phone
        } else {
            lbPhone.text = ""
        }
        
        if let gender = user.gender {
            lbGender.text = gender == 1 ? "Male" : "Female"
        } else {
            lbGender.text = ""
        }
        
        if let typeAcc = user.type {
            var stringType: String?
            switch typeAcc {
            case 1:
                stringType = "Facebook"
            case 2:
                stringType = "Twitter"
            default:
                stringType = "Nomal"
            }
            
            lbAccount.text = stringType
        } else {
            lbAccount.text = "Nomal"
        }
        
        if let name = user.name {
            lbName.text = name
        }
        
        if let score = user.score {
            lbScore.text = "\(score) points"
            if score < 1000 {
                ivRank.image = #imageLiteral(resourceName: "level1")
            } else if score < 2000 {
                ivRank.image = #imageLiteral(resourceName: "level2")
            } else if score < 3000 {
                ivRank.image = #imageLiteral(resourceName: "level3")
            } else if score < 4000 {
                ivRank.image = #imageLiteral(resourceName: "level4")
            } else {
                ivRank.image = #imageLiteral(resourceName: "level5")
            }
        } else {
            lbScore.text = "0 points"
            ivRank.image = #imageLiteral(resourceName: "level1")
        }
        
        if let avatar = user.avatar, !avatar.isEmpty {
            ivAvatar.kf.setImage(with: URL(string: avatar))
        } else {
            ivAvatar.image = #imageLiteral(resourceName: "avatar")
        }
        
        if let typeFriend = user.typeFriend {
            switch typeFriend {
            case 0:
                btnStatusFriend.isHidden = true
                break
            case 1:
                btnStatusFriend.setTitleChaneSize(title: "Cancel request")
                break
            case 2:
                btnStatusFriend.setTitleChaneSize(title: "Answer request")
                break
            case 3:
                btnStatusFriend.setTitleChaneSize(title: "Friend")
                break
            case 4:
                btnStatusFriend.setTitleChaneSize(title: "Add friend")
                break
            default:
                btnStatusFriend.isHidden = true
            }
        }
        
        if let items = user.items, items.count > 0 {
            for item in items {
                if item.id == 1 {
                    item1Quantity.text = "+\(item.quantity!)"
                } else if item.id == 2 {
                    item2Quantity.text = "+\(item.quantity!)"
                } else if item.id == 3 {
                    item3Quantity.text = "+\(item.quantity!)"
                } else {
                    item4Quantity.text = "+\(item.quantity!)"
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func messageClicked(_ sender: Any) {
        
    }

    @IBAction func statusFriendClicked(_ sender: Any) {
        switch btnStatusFriend.currentTitle! {
        case "Cancel request":
            requestUserAction(api: ApiConstant.getApiCancelRequestFriend())
            break
        case "Answer request":
            AlertHelper.showAlertAnswerSheet(viewController: self, cbAccept: { (alert) in
                self.requestUserAction(api: ApiConstant.getApiAcceptRequestFriend())
            }, cbReject: { (alert) in
                self.requestUserAction(api: ApiConstant.getApiCancelRequestFriend())
            })
            break
        case "Friend":
            AlertHelper.showAlertFriendSheet(viewController: self, cbCancelFriend: { (alert) in
                self.requestUserAction(api: ApiConstant.getApiCancelFriend())
            })
            break
        case "Add friend":
            requestUserAction(api: ApiConstant.getApiAddFriend())
            break
            
        default:
            print(btnStatusFriend.currentTitle ?? "Non title")
        }
    }
    
    
    func requestUserAction(api: String) {
        let req = UserActionRequest()
        req.idSender = UserRealm.getUserInfo()?._id
        req.idReceiver = idShow
        
        if btnStatusFriend.currentTitle! == "Answer request" {
            let tmp = req.idSender
            req.idSender = req.idReceiver
            req.idReceiver = tmp
        }
        
        Alamofire.request(api, method: .post, parameters: req.toJSON(), encoding: JSONEncoding.default).responseObject {
                (resonpose: DataResponse<BaseResponse>) in
                    if let dataRes = resonpose.value, dataRes.status == 1 {
                        switch api {
                            case ApiConstant.getApiCancelRequestFriend():
                                self.btnStatusFriend.setTitleChaneSize(title: "Add friend")
                                break;
                            case ApiConstant.getApiAcceptRequestFriend():
                                self.btnStatusFriend.setTitleChaneSize(title: "Friend")
                                break;
                            case ApiConstant.getApiCancelFriend():
                                self.btnStatusFriend.setTitleChaneSize(title: "Add friend")
                                break;
                            case ApiConstant.getApiAddFriend():
                                self.btnStatusFriend.setTitleChaneSize(title: "Cancel request")
                                break;
                        default:
                            print(api)
                            
                        }
                    }
                }
    }

}
