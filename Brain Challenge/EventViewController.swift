//
//  EventViewController.swift
//  Brain Challenge
//
//  Created by Hado on 2/20/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class EventViewController: UIViewController {
    
    @IBOutlet weak var alertCongrat: UIVisualEffectView!
    @IBOutlet weak var lbTitleAlert: UILabel!
    @IBOutlet weak var lbMessageAlert: UILabel!
    @IBOutlet weak var ivItemAlert: UIImageView!
    
    class func getIdentifier() -> String {
        return "EventViewController"
    }
    
    var events: [Event] = []
    
    @IBOutlet weak var eventTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTableView.contentInset.top = getTopInsect()
        eventTableView.contentInset.bottom = 50
        
        alertCongrat.layer.cornerRadius = 5
        alertCongrat.clipsToBounds = true
        
        eventTableView.dataSource = self
        getEvents()
    }
    @IBAction func thankyouClicked(_ sender: Any) {
        alertCongrat.isHidden = true
    }
    
    func getEvents() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(ApiConstant.getApiEvent(), parameters: EventRequest().toJSON()).responseObject {
            (response: DataResponse<EventResponse>) in
            if let guideRes = response.value, guideRes.status == 1 {
                self.events.removeAll()
                self.events += (guideRes.events?.dynamicEvent)!
                self.events += (guideRes.events?.fixedEvent)!
                self.eventTableView.reloadData()
            } else {
                print("non status")
            }
            
            MBProgressHUD.hide(for: self.view, animated: true)
        }

    }
    
    func requestBonus(code: String) {
        let bonusRequest: BonusRequest = BonusRequest()
        bonusRequest.code = code
        Alamofire.request(ApiConstant.getApiBonus(), method: .post, parameters: bonusRequest.toJSON(), encoding: JSONEncoding.default).responseObject {
            (response: DataResponse<BonusResponse>) in
            if let result = response.value {
                print(result)
                if result.status == 1 {
                    let newItem = result.newItem!
                    self.lbMessageAlert.text = "You get \(newItem.quantity!) \(newItem.name!)"
                    self.ivItemAlert.kf.setImage(with: URL(string: newItem.image!))
                    self.alertCongrat.isHidden = false
                } else {
                    self.handleError(errorCode: result.errorCode!)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleError(errorCode: Int) {
        var title: String?
        var message: String?
        switch errorCode {
        case 102:
            title = "Request Failed"
            message = "Some error occur during request, please try again :)"
        case 108:
            title = "Wrong code"
            message = "Your code is incorrect, please check it again :)"
        case 107:
            title = "Used code"
            message = "You have already used this code :)"
        case 109:
            title = "Expired code"
            message = "Your code is expired, see you later :)"
        case 110:
            title = "User is unavailable"
            message = "You is not in event scope :("
            
        default:
            title = "Authenticate failed"
            message = "You must relogin to continue, sorry for inconvenient :("
        }
        
        AlertHelper.showAlert(viewController: self, title: title!, message: message!, titleButton: "Ok") {
            alert in
            alert.dismiss(animated: true, completion: nil)
        }
    }
    

}

extension EventViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "enter_code_cell", for: indexPath) as! EnterCodeViewCell
            (cell as! EnterCodeViewCell).handelApplyClicked = {
                code in
                if (code?.isEmpty)! {
                    AlertHelper.showAlert(viewController: self, title: "Empty data", message: "The code is empty", titleButton: "Ok") {
                        alert in
                        alert.dismiss(animated: true, completion: nil)
                    }
                } else {
                    self.requestBonus(code: code!)
                }
            }
            
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "event_cell", for: indexPath)
            (cell as! EventViewCell).bindData(event: events[indexPath.row - 1])
        }
        
        return cell!
    }
    
    
}

extension UIViewController {
    func getTopInsect() -> CGFloat {
        let height = UIApplication.shared.statusBarFrame.height +
            self.navigationController!.navigationBar.frame.height
        return CGFloat(height)
    }
}
