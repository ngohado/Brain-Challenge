//
//  DrawerViewController.swift
//  Brain Challenge
//
//  Created by Hado on 2/14/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import UIKit
import Kingfisher

struct MenuItem {
    var icon: UIImage?
    var label: String?
}

class DrawerViewController: UIViewController {
    
    @IBOutlet weak var ivAvatar: UIImageView!
    @IBOutlet weak var tbMenuItem: UITableView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbEmail: UILabel!
    
    var drawerProtocol: DrawerProtocol?
    
    let items: Array<MenuItem> = [MenuItem(icon: #imageLiteral(resourceName: "ic_view_day"), label: "Battle rooms"),
                                  MenuItem(icon: #imageLiteral(resourceName: "ic_cancel"), label: "Create room"),
                                  MenuItem(icon: #imageLiteral(resourceName: "ic_people"), label: "Friends"),
                                  MenuItem(icon: #imageLiteral(resourceName: "ic_stars"), label: "Rank"),
                                  MenuItem(icon: #imageLiteral(resourceName: "ic_power_settings_new"), label: "Logout")]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbMenuItem.delegate = self
        tbMenuItem.dataSource = self
        
        ivAvatar.layer.cornerRadius = ivAvatar.frame.height / 2
        ivAvatar.layer.borderWidth = 2
        ivAvatar.layer.borderColor = UIColor.white.cgColor
        ivAvatar.clipsToBounds = true
        
        bindUser(user: UserRealm.getUserInfo())
    }
    
    func bindUser(user: User?) {
        if user != nil {
            if let name = user?.name {
                lbName.text = name
            } else {
                lbName.text = user?.username
            }
            
            lbEmail.text = user?.email
            if let avatarUrl = user?.avatar {
                let url = URL(string: avatarUrl)!
                ivAvatar.kf.setImage(with: url)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

protocol DrawerProtocol: class {
    func selectedItem(index: Int)
}

extension DrawerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = items[indexPath.row]

        let itemCell = tableView.dequeueReusableCell(withIdentifier: "menuItem", for: indexPath) as! MenuItemViewCell
        itemCell.bindData(item: item)
        
        return itemCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let drawController = parent as? KYDrawerController {
            drawController.setDrawerState(.closed, animated: true)
        }
        
        self.drawerProtocol?.selectedItem(index: indexPath.row)
    }
}
