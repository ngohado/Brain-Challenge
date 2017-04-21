//
//  RoomTableViewCell.swift
//  Brain Challenge
//
//  Created by Hado on 4/7/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import UIKit

class RoomTableViewCell: UITableViewCell {
    
    class func getIdentifier() -> String {
        return "RoomTableViewCell"
    }

    @IBOutlet weak var ivAvatar: UIImageView!
    @IBOutlet weak var ivLevel: UIImageView!
    @IBOutlet weak var tvRoomName: UILabel!
    @IBOutlet weak var tvHostName: UILabel!
    @IBOutlet weak var tvStatus: UILabel!
    @IBOutlet weak var ivLock: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ivAvatar.layer.cornerRadius = ivAvatar.frame.height / 2
        ivAvatar.layer.borderWidth = 1
        ivAvatar.layer.borderColor = UIColor.lightGray.cgColor
        ivAvatar.clipsToBounds = true
        
        ivLevel.layer.cornerRadius = ivLevel.frame.height / 2
        ivLevel.layer.borderWidth = 1
        ivLevel.layer.borderColor = UIColor.lightGray.cgColor
        ivLevel.clipsToBounds = true
    }

    func bindData(room: Room) {
        tvRoomName.text = room.roomName
        tvHostName.text = "Host: \((room.userHost?.name)!)"
        
        if room.userMember != nil {
            tvStatus.text = "Status: 2/2"
        } else {
            tvStatus.text = "Status: 1/2"
        }
        
        if let password = room.password, !password.isEmpty {
            ivLock.isHidden = false
        } else {
            ivLock.isHidden = true
        }
        
        if let score = room.userHost?.score, score > 1 {
            if score < 1000 {
                ivLevel.image = #imageLiteral(resourceName: "indicator1")
            } else if score < 2000 {
                ivLevel.image = #imageLiteral(resourceName: "indicator2")
            } else if score < 3000 {
                ivLevel.image = #imageLiteral(resourceName: "indicator3")
            } else if score < 4000 {
                ivLevel.image = #imageLiteral(resourceName: "indicator4")
            } else {
                ivLevel.image = #imageLiteral(resourceName: "indicator5")
            }
        } else {
            ivLevel.image = #imageLiteral(resourceName: "indicator1")
        }
        
        if let avatarUrl = room.userHost?.avatar, !avatarUrl.isEmpty {
            ivAvatar.kf.setImage(with: URL(string: avatarUrl))
        }
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
