//
//  AlertHelper.swift
//  Brain Challenge
//
//  Created by Hado on 2/2/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import UIKit

class AlertHelper {
    class func showAlert(viewController: UIViewController, title: String, message: String, titleButton1: String, titleButton2: String, callback1: @escaping (_ alert: UIAlertController) -> Void, callback2: @escaping (_ alert: UIAlertController) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let button1 = UIAlertAction(title: titleButton1, style: UIAlertActionStyle.default, handler: {
            (UIAlertAction) in
            callback1(alert)
        })
        
        let button2 = UIAlertAction(title: titleButton2, style: UIAlertActionStyle.default, handler: {
            (UIAlertAction) in
            callback2(alert)
        })
        
        alert.addAction(button1)
        alert.addAction(button2)
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    class func showAlert(viewController: UIViewController, title: String, message: String, titleButton: String, callback: ((_ alert: UIAlertController) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let button1 = UIAlertAction(title: titleButton, style: UIAlertActionStyle.default, handler: {
            (UIAlertAction) in
            if(callback == nil) {
                alert.dismiss(animated: true, completion: nil)
            } else {
                callback!(alert)
            }
        })
        
        alert.addAction(button1)
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    class func showAlertGift(viewController: UIViewController, title: String, message: String, titleButton: String, callback: ((_ alert: UIAlertController) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let button1 = UIAlertAction(title: titleButton, style: UIAlertActionStyle.default, handler: {
            (UIAlertAction) in
            if(callback == nil) {
                alert.dismiss(animated: true, completion: nil)
            } else {
                callback!(alert)
            }
        })
        
        alert.addAction(button1)
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        image.kf.setImage(with: URL(string: "http://res.cloudinary.com/dv1czewz7/image/upload/v1487672348/2X_Servant_EXP_icon_ecilm0.png"))
        alert.view.addSubview(image)
        
        viewController.present(alert, animated: true, completion: nil)
    }

    
    class func showAlertPickImageSheet(viewController: UIViewController, cbCamera: @escaping (_ alert: UIAlertController) -> Void, cbGallery: @escaping (_ alert: UIAlertController) -> Void) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (UIAlertAction) in
            cbCamera(alert)
        }))
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (UIAlertAction) in
            cbGallery(alert)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    class func showAlertSigninSheet(viewController: UIViewController, cbFacebook: @escaping (_ alert: UIAlertController) -> Void, cbTwitter: @escaping (_ alert: UIAlertController) -> Void) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(UIAlertAction(title: "Facebook", style: .default, handler: { (UIAlertAction) in
            cbFacebook(alert)
        }))
        
        alert.addAction(UIAlertAction(title: "Twitter", style: .default, handler: { (UIAlertAction) in
            cbTwitter(alert)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        viewController.present(alert, animated: true, completion: nil)
    }

}
