//
//  LoginViewController.swift
//  Brain Challenge
//
//  Created by Hado on 1/23/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import UIKit
import IBAnimatable
import AlamofireObjectMapper
import Alamofire
import ObjectMapper
import MBProgressHUD
import FacebookCore
import FacebookLogin
import TwitterKit
import TwitterCore
import SocketIO
import RealmSwift
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    @IBOutlet weak var btnLogin: AnimatableButton!
    @IBOutlet weak var edtPassword: AnimatableTextField!
    @IBOutlet weak var edtUsername: AnimatableTextField!
    @IBOutlet weak var loginView: AnimatableStackView!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        print((Date().timeIntervalSince1970 * 1000).rounded())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func validateLogin() -> Bool {
        if (edtUsername.text?.isEmpty)! && (edtPassword.text?.isEmpty)! {
            loginView.shake(repeatCount: 1)
            return false
        } else if (edtUsername.text?.isEmpty)! {
            edtUsername.shake(repeatCount: 1)
            return false
        } else if (edtPassword.text?.isEmpty)! {
            edtPassword.shake(repeatCount: 1)
            return false
        }
        
        return true
    }
    
    @IBAction func loginOnClicked(_ sender: Any) {
        if validateLogin() {
            if !Utils.isConnectedToNetwork() {
                AlertHelper.showAlert(viewController: self, title: "No Internet Connection", message: "Make sure your device is connected to the internet", titleButton: "OK", callback: { (alert) in
                    alert.dismiss(animated: true, completion: nil)
                })
                
                return
            }
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            changeStateComponent(enable: false)
            let loginRequest = LoginRequest(username: edtUsername.text, password: edtPassword.text)
            Alamofire.request(ApiConstant.getApiLogin(), method: .post, parameters: loginRequest.toJSON(), encoding: JSONEncoding.default).responseObject { (response: DataResponse<LoginResponse>) in
                MBProgressHUD.hide(for: self.view, animated: true)
                self.changeStateComponent(enable: true)
                self.handleLoginResponse(loginResponse: response.value)
            }
        }
    }
    
    func changeStateComponent(enable: Bool) {
        edtUsername.isEnabled = enable
        edtPassword.isEnabled = enable
        btnLogin.isEnabled = enable
    }
    
    func handleLoginResponse(loginResponse: LoginResponse?) {
        if (loginResponse != nil) {
            if loginResponse?.status! == 1 {
                print(loginResponse?.userInfo?.toJSONString() ?? "Nothing to show")
                saveUserInfo(user: (loginResponse?.userInfo)!)
                if let stateLogin = loginResponse?.userInfo?.firstLogin, stateLogin == 0 {
                    handleNormalLoginSuccess()
                } else {
                    handleFirstLoginSuccess()
                }
            } else {
                AlertHelper.showAlert(viewController: self, title: "Login failed", message: (loginResponse?.errorMessage)!, titleButton: "OK", callback: nil)
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
    /*
     * Method handle data received after login with social network
     */
    func handleLoginSNResponse(loginResponse: LoginResponse?) {
        if loginResponse != nil {
            if loginResponse?.status == 1 {
                saveUserInfo(user: (loginResponse?.userInfo)!)
                if let stateLogin = loginResponse?.userInfo?.firstLogin, stateLogin == 0 {
                    handleNormalLoginSuccess()
                } else {
                    handleFirstLoginSuccess()
                }
            } else {
                AlertHelper.showAlert(viewController: self, title: "Login failed", message: (loginResponse?.errorMessage)!, titleButton: "OK", callback: nil)
            }
        }
    }
    
    @IBAction func loginSNOnClicked(_ sender: Any) {
        AlertHelper.showAlertSigninSheet(viewController: self, cbFacebook: { (alert) in
            self.loginFacebook()
        }) { (alert) in
            self.loginTwitter()
        }
    }
    
    func loginTwitter() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Twitter.sharedInstance().logIn { (session, error) in
            if(session != nil) {
                let client = TWTRAPIClient.withCurrentUser()
                let request = client.urlRequest(withMethod: "GET",
                                                url: "https://api.twitter.com/1.1/account/verify_credentials.json",
                                                parameters: ["include_email": "true", "skip_status": "true"],
                                                error: nil)
                
                client.sendTwitterRequest(request, completion: { (response, data, error) in
                    do {
                        let userInfo = Mapper<TwitterUser>().map(JSON: try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! [String : Any] )
                        let user = User()
                        user.email = userInfo?.email
                        user.name = userInfo?.name
                        user.avatar = userInfo?.avatar
                        user.type = 2
                        self.changeStateComponent(enable: false)
                        Alamofire.request(ApiConstant.getApiLoginSN(), method: .post, parameters: user.toJSON(), encoding: JSONEncoding.default).responseObject {
                            (response: DataResponse<LoginResponse>) in
                            MBProgressHUD.hide(for: self.view, animated: true)
                            self.changeStateComponent(enable: true)
                            self.handleLoginSNResponse(loginResponse: response.value)
                        }
                    } catch {
                        AlertHelper.showAlert(viewController: self, title: "Login Twitter failed", message: "One error occur during signing in", titleButton: "OK", callback: nil)
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                })
            } else {
                AlertHelper.showAlert(viewController: self, title: "Login Twitter failed", message: "One error occur during signing in", titleButton: "OK", callback: nil)
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
    
    func loginFacebook() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let loginManager = LoginManager()
        loginManager.logIn([.publicProfile, .email, .userFriends], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
                MBProgressHUD.hide(for: self.view, animated: true)
            case .cancelled:
                print("User cancelled login.")
                MBProgressHUD.hide(for: self.view, animated: true)
            case .success( _, _, _):
                FacebookHelper.getUserInfo(){
                    (user: User?) in
                    if user != nil {
                        user?.type = 1
                        self.changeStateComponent(enable: false)
                        Alamofire.request(ApiConstant.getApiLoginSN(), method: .post, parameters: user?.toJSON(), encoding: JSONEncoding.default).responseObject { (response: DataResponse<LoginResponse>) in
                            MBProgressHUD.hide(for: self.view, animated: true)
                            self.changeStateComponent(enable: true)
                            self.handleLoginSNResponse(loginResponse: response.value)
                        }
                    }
                }
            }
        }
    }
    
    func handleNormalLoginSuccess() {
        MainViewController.navigate(viewController: self)
    }
    
    func handleFirstLoginSuccess() {
        GuideViewController.navigate(viewConstroller: self)
    }
    
    @IBAction func signupOnClicked(_ sender: Any) {
        
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

extension UIImageView {
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
}
