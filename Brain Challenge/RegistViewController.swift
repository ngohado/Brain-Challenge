//
//  RegistViewController.swift
//  Brain Challenge
//
//  Created by Hado on 2/3/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import UIKit
import IBAnimatable
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class RegistViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var ivAvatar: UIImageView!
    @IBOutlet weak var edtName: AnimatableTextField!
    @IBOutlet weak var edtUsername: AnimatableTextField!
    @IBOutlet weak var edtEmail: AnimatableTextField!
    @IBOutlet weak var edtPassword: AnimatableTextField!
    @IBOutlet weak var edtConfirmPassword: AnimatableTextField!
    
    let imagePicker = UIImagePickerController()
    let segmentGender = DGRunkeeperSwitch(titles: ["Female", "Male"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initImagePicker()
    }
    
    override func viewDidLayoutSubviews() {
        initView()
    }
    
    func initImagePicker() {
        imagePicker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        ivAvatar.image = chosenImage
        imagePicker.dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func initView() {
        ivAvatar.layer.cornerRadius = 15
        ivAvatar.layer.borderWidth = 5
        ivAvatar.layer.borderColor = UIColor.white.cgColor
        ivAvatar.clipsToBounds = true
        
        //handle click image event
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(ivAvatarClicked(img:)))
        ivAvatar.isUserInteractionEnabled = true
        ivAvatar.addGestureRecognizer(tapGestureRecognizer)
        
        //init segment
        segmentGender.backgroundColor = UIColor(red: 190.0/255.0, green: 97.0/255.0, blue: 208.0/255.0, alpha: 0.7)
        segmentGender.selectedBackgroundColor = .white
        segmentGender.titleColor = .white
        segmentGender.selectedTitleColor = UIColor(red: 190.0/255.0, green: 97.0/255.0, blue: 208.0/255.0, alpha: 1.0)
        segmentGender.titleFont = UIFont(name: "HelveticaNeue-Medium", size: 13.0)
        segmentGender.frame = CGRect(x: edtName.frame.origin.x, y: edtName.frame.origin.y + edtName.frame.height + 10, width: edtName.frame.width, height: edtName.frame.height)
        view.addSubview(segmentGender)
    }
    
    func ivAvatarClicked(img: AnyObject) {
        AlertHelper.showAlertPickImageSheet(viewController: self, cbCamera: { (alert) in
            //camera
            print("camera")
        }) { (alert) in
            //gallery
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }

    @IBAction func signupOnClicked(_ sender: Any) {
        if validateInfo() {
            let registRequest = RegistRequest(username: edtUsername.text!, password: edtPassword.text!, name: edtName.text!, email: edtEmail.text!, gender: "\(segmentGender.selectedIndex)")
            
            if ivAvatar.image == #imageLiteral(resourceName: "add_avatar-1") {
                Alamofire.request(ApiConstant.getApiRegist(), method: .post, parameters: registRequest.toJSON(), encoding: JSONEncoding.default).responseObject {
                    (response: DataResponse<RegistResponse>) in
                    self.handleReigstResponse(registResponse: (response.value)!)
                }
            } else {
                Alamofire.upload(multipartFormData: { (multipartFormData) in
                    if let imageData = UIImageJPEGRepresentation(self.ivAvatar.image!, 0.2) {
                        multipartFormData.append(imageData, withName: "avatar", fileName: "avatar.jpeg", mimeType: "image/jpeg")
                    }
                    
                    multipartFormData.append((registRequest.name?.data(using: .utf8))!, withName: "name")
                    multipartFormData.append((registRequest.username?.data(using: .utf8))!, withName: "username")
                    multipartFormData.append((registRequest.password?.data(using: .utf8))!, withName: "password")
                    multipartFormData.append((registRequest.email?.data(using: .utf8))!, withName: "email")
                    multipartFormData.append((registRequest.gender?.data(using: .utf8))!, withName: "gender")
                    
                }, to: ApiConstant.getApiRegist(), method: .post, headers: nil, encodingCompletion: {
                    endcodingResult in
                    switch endcodingResult {
                    case .success(let upload, _, _):
                        upload.responseObject {
                            (response: DataResponse<RegistResponse>) in
                            self.handleReigstResponse(registResponse: (response.value)!)
                        }
                    case .failure(let encodingError):
                        print("error:\(encodingError)")
                    }
                })
            }
        }
    }
    
    func handleReigstResponse(registResponse: RegistResponse?) {
        if (registResponse != nil) {
            if registResponse?.status! == 1 { //success
                saveUserInfo(user: (registResponse?.userInfo)!)
                GuideViewController.navigate(viewConstroller: self)
            } else {
                let errorCode = (registResponse?.errorCode)!
                var title: String?
                
                switch errorCode {
                case 99:
                    title = "Username, password or email is invalid"
                    break
                case 100:
                    title = "Username is invalid"
                    break
                case 101:
                    title = "Password is invalid"
                    break
                case 103:
                    title = "Username and password is invalid"
                    break
                    
                default:
                    title = "Regist failed"
                }
                
                AlertHelper.showAlert(viewController: self, title: title!, message: (registResponse?.errorMessage)!, titleButton1: "Cancel", titleButton2: "OK", callback1: {(alert) in
                    alert.dismiss(animated: true, completion: nil)
                }, callback2: { (alert) in
                    alert.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
    
    func saveUserInfo(user: User) {
        let userRealm = UserRealm()
        userRealm.initData(user: user)
        if userRealm.save() {
            print("Save success")
        } else {
            print("Save error")
        }
    }

    
    func validateInfo() -> Bool {
        if (edtName.text?.isEmpty)! {
            edtName.shake(repeatCount: 1)
            return false
        }
        
        if (edtUsername.text?.isEmpty)! {
            edtUsername.shake(repeatCount: 1)
            return false
        }
        
        if (edtEmail.text?.isEmpty)! {
            edtEmail.shake(repeatCount: 1)
            return false
        }
        
        if (edtPassword.text?.isEmpty)! {
            edtPassword.shake(repeatCount: 1)
            return false
        }
        
        if (edtConfirmPassword.text?.isEmpty)! {
            edtConfirmPassword.shake(repeatCount: 1)
            return false
        }
        
        if edtPassword.text! != edtConfirmPassword.text! {
            edtPassword.shake(repeatCount: 1)
            edtConfirmPassword.shake(repeatCount: 1)
            return false
        }
        
        return true
    }
    
    
    @IBAction func loginOnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
