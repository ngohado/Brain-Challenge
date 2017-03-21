//
//  StatusViewCell.swift
//  Brain Challenge
//
//  Created by Hado on 3/18/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import UIKit

class StatusViewCell: UITableViewCell {
    
    class func getIdentifier() -> String {
        return "StatusViewCell"
    }

    @IBOutlet weak var ivOnline: UIImageView!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var ivRankIndicator: UIImageView!
    @IBOutlet weak var ivAvatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ivAvatar.layer.cornerRadius = ivAvatar.frame.height / 2
        ivAvatar.layer.borderWidth = 1
        ivAvatar.layer.borderColor = UIColor.lightGray.cgColor
        ivAvatar.clipsToBounds = true
        
        ivRankIndicator.layer.cornerRadius = ivRankIndicator.frame.height / 2
        ivRankIndicator.layer.borderWidth = 1
        ivRankIndicator.layer.borderColor = UIColor.lightGray.cgColor
        ivRankIndicator.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func bindData(user: User, isOnline: Bool) {
        ivOnline.image = isOnline ? #imageLiteral(resourceName: "green-dot.svg.med") : #imageLiteral(resourceName: "dot_gray")
        lbStatus.text = isOnline ? "Online" : "Offline"
        lbName.text = user.name
        
        if let score = user.score, score > 1 {
            if score < 1000 {
                ivRankIndicator.image = #imageLiteral(resourceName: "indicator1")
            } else if score < 2000 {
                ivRankIndicator.image = #imageLiteral(resourceName: "indicator2")
            } else if score < 3000 {
                ivRankIndicator.image = #imageLiteral(resourceName: "indicator3")
            } else if score < 4000 {
                ivRankIndicator.image = #imageLiteral(resourceName: "indicator4")
            } else {
                ivRankIndicator.image = #imageLiteral(resourceName: "indicator5")
            }
        } else {
            ivRankIndicator.image = #imageLiteral(resourceName: "indicator1")
        }
        
        if let avatarUrl = user.avatar, !avatarUrl.isEmpty {
            ivAvatar.kf.setImage(with: URL(string: avatarUrl))
        }
    }

}

class Status2ViewCell: UITableViewCell {
    
    class func getIdentifier() -> String {
        return "Status2ViewCell"
    }
    
    @IBOutlet weak var ivOnline: UIImageView!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var ivRankIndicator: UIImageView!
    @IBOutlet weak var ivAvatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ivAvatar.layer.cornerRadius = ivAvatar.frame.height / 2
        ivAvatar.layer.borderWidth = 1
        ivAvatar.layer.borderColor = UIColor.lightGray.cgColor
        ivAvatar.clipsToBounds = true
        
        ivRankIndicator.layer.cornerRadius = ivRankIndicator.frame.height / 2
        ivRankIndicator.layer.borderWidth = 1
        ivRankIndicator.layer.borderColor = UIColor.lightGray.cgColor
        ivRankIndicator.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func bindData(user: User, isOnline: Bool) {
        ivOnline.image = isOnline ? #imageLiteral(resourceName: "green-dot.svg.med") : #imageLiteral(resourceName: "dot_gray")
        lbStatus.text = isOnline ? "Online" : "Offline"
        lbName.text = user.name
        
        if let score = user.score, score > 1 {
            if score < 1000 {
                ivRankIndicator.image = #imageLiteral(resourceName: "indicator1")
            } else if score < 2000 {
                ivRankIndicator.image = #imageLiteral(resourceName: "indicator2")
            } else if score < 3000 {
                ivRankIndicator.image = #imageLiteral(resourceName: "indicator3")
            } else if score < 4000 {
                ivRankIndicator.image = #imageLiteral(resourceName: "indicator4")
            } else {
                ivRankIndicator.image = #imageLiteral(resourceName: "indicator5")
            }
        } else {
            ivRankIndicator.image = #imageLiteral(resourceName: "indicator1")
        }
        
        if let avatarUrl = user.avatar, !avatarUrl.isEmpty {
            ivAvatar.kf.setImage(with: URL(string: avatarUrl))
        }
    }
    
}


