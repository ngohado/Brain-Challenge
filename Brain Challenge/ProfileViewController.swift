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

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    @IBOutlet weak var lbPhoneTitle: UILabel!
    var idShow: String = ""
    var isPresent: Bool?
    let imagePicker = UIImagePickerController()

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
        
        imagePicker.delegate = self
        
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
        
        let idMe = UserRealm.getUserInfo()?._id
        let enableUpdate = idMe == idShow ? true : false
        
        lbName.isUserInteractionEnabled = enableUpdate
        lbName.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editName(tapGestureRecognizer:))))
        
        lbPhone.isUserInteractionEnabled = enableUpdate
        lbPhone.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editPhone(tapGestureRecognizer:))))
        
        lbPhoneTitle.isUserInteractionEnabled = enableUpdate
        lbPhoneTitle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editPhone(tapGestureRecognizer:))))
        
        lbGender.isUserInteractionEnabled = enableUpdate
        lbGender.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editGender(tapGestureRecognizer:))))
        
        ivAvatar.isUserInteractionEnabled = enableUpdate
        ivAvatar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editAvatar(tapGestureRecognizer:))))
        
    }
    
    func editName(tapGestureRecognizer: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Change name", message: "Enter new name", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField { (tfRoom) in
            tfRoom.placeholder = self.lbName.text
        }
        
        let btnCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
        })
        
        let btnSet = UIAlertAction(title: "Set", style: UIAlertActionStyle.default, handler: {
            (UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
            let newName = alert.textFields?.first?.text
            if (newName?.isEmpty)! {
                AlertHelper.showAlert(viewController: self, title: "New name is invalid", message: "New name is empty", titleButton: "Ok")
                return
            }
            //request api change name
            
            let updateNameModel: UpdateModel = UpdateModel()
            updateNameModel.id = self.idShow
            updateNameModel.newValue = newName
            
            Alamofire.request(ApiConstant.getApiUpdateName(), method: .post, parameters: updateNameModel.toJSON(), encoding: JSONEncoding.default).responseObject {
                (response: DataResponse<UserInfoResponse>) in
                if response.value?.status == 1 {
                    self.lbName.text = newName
                } else {
                    AlertHelper.showAlert(viewController: self, title: "Update failed", message: "An error occurs during update name", titleButton: "Ok")
                }
            }
            
        })
        
        alert.addAction(btnCancel)
        alert.addAction(btnSet)
        self.present(alert, animated: true, completion: nil)
    }
    
    func editPhone(tapGestureRecognizer: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Change phone", message: "Enter new phone", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField { (tfRoom) in
            tfRoom.placeholder = self.lbPhone.text
        }
        
        let btnCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
        })
        
        let btnSet = UIAlertAction(title: "Set", style: UIAlertActionStyle.default, handler: {
            (UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
            let newPhone = alert.textFields?.first?.text
            if (newPhone?.isEmpty)! {
                AlertHelper.showAlert(viewController: self, title: "New phone is invalid", message: "New phone is empty", titleButton: "Ok")
                return
            }
            //request api change phone
            
            let updatePhoneModel: UpdateModel = UpdateModel()
            updatePhoneModel.id = self.idShow
            updatePhoneModel.newValue = newPhone
            
            Alamofire.request(ApiConstant.getApiUpdatePhone(), method: .post, parameters: updatePhoneModel.toJSON(), encoding: JSONEncoding.default).responseObject {
                (response: DataResponse<UserInfoResponse>) in
                if response.value?.status == 1 {
                    self.lbPhone.text = newPhone
                } else {
                    AlertHelper.showAlert(viewController: self, title: "Update failed", message: "An error occurs during update phone", titleButton: "Ok")
                }
            }
            
        })
        
        alert.addAction(btnCancel)
        alert.addAction(btnSet)
        self.present(alert, animated: true, completion: nil)
    }
    
    func editGender(tapGestureRecognizer: UITapGestureRecognizer) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        alert.addAction(UIAlertAction(title: "Male", style: .default, handler: { (UIAlertAction) in
            self.updateGender(gender: 1)
        }))
        
        alert.addAction(UIAlertAction(title: "Female", style: .default, handler: { (UIAlertAction) in
            self.updateGender(gender: 0)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateGender(gender: Int) {
        let updateGenderModel: UpdateGenderModel = UpdateGenderModel()
        updateGenderModel.id = self.idShow
        updateGenderModel.gender = gender
        
        Alamofire.request(ApiConstant.getApiUpdateGender(), method: .post, parameters: updateGenderModel.toJSON(), encoding: JSONEncoding.default).responseObject {
            (response: DataResponse<UserInfoResponse>) in
            if response.value?.status == 1 {
                self.lbGender.text = gender == 1 ? "Male" : "Female"
            } else {
                AlertHelper.showAlert(viewController: self, title: "Update failed", message: "An error occurs during update gender", titleButton: "Ok")
            }
        }
    }
    
    func editAvatar(tapGestureRecognizer: UITapGestureRecognizer) {
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        ivAvatar.image = chosenImage
        imagePicker.dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
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
