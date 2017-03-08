//
//  RankTableViewCell.swift
//  Brain Challenge
//
//  Created by Hado on 3/7/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import UIKit

class RankTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbIndex: UILabel!
    @IBOutlet weak var ivAvatar: UIImageView!
    @IBOutlet weak var ivRankIndicator: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbScore: UILabel!
    
    class func getIdentifier() -> String {
        return "RankTableViewCell"
    }

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

        // Configure the view for the selected state
    }
    
    func bindData(data: User, index: Int) {
        lbName.text = data.name ?? data.username
        
        if let score = data.score, score > 1 {
            lbScore.text = "\(score) points"
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
            lbScore.text = "0 point"
            ivRankIndicator.image = #imageLiteral(resourceName: "indicator1")
        }
        
        lbIndex.text = "\(index + 1)."
        
        if let avatarUrl = data.avatar, !avatarUrl.isEmpty {
            ivAvatar.kf.setImage(with: URL(string: avatarUrl))
        }
    }

}
