//
//  InviteTableViewCell.swift
//  Brain Challenge
//
//  Created by Hado on 4/20/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import UIKit

class InviteTableViewCell: UITableViewCell {

    @IBOutlet weak var ivAvatar: UIImageView!
    
    @IBOutlet weak var btnStatusFriend: UIButton!
    
    @IBOutlet weak var lbName: UILabel!
    
    var handleFriendClicked: (() -> Void)?
    
    class func getIdentifier() -> String {
        return "InviteTableViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ivAvatar.layer.cornerRadius = ivAvatar.frame.height / 2
        ivAvatar.layer.borderWidth = 1
        ivAvatar.layer.borderColor = UIColor.lightGray.cgColor
        ivAvatar.clipsToBounds = true
        
        btnStatusFriend.layer.cornerRadius = 5
        btnStatusFriend.layer.borderWidth = 1
        btnStatusFriend.layer.borderColor = UIColor.lightGray.cgColor
        btnStatusFriend.clipsToBounds = true
        
    }
    
    @IBAction func friendButtonClicked(_ sender: Any) {
        handleFriendClicked!()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func bindData(data: User) {
        lbName.text = data.name ?? data.username
        if let avatarUrl = data.avatar, !avatarUrl.isEmpty {
            ivAvatar.kf.setImage(with: URL(string: avatarUrl))
        }
    }


}
