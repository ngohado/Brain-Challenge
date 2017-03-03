//
//  RequestFriendViewCell.swift
//  Brain Challenge
//
//  Created by Hado on 3/3/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import UIKit

class RequestFriendViewCell: UITableViewCell {
    
    class func getIdentifier() -> String {
        return "RequestFriendViewCell"
    }

    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var ivAvatar: UIImageView!
    
    var handelAcceptClicked: (() -> Void)?
    var handelCancelClicked: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ivAvatar.layer.cornerRadius = ivAvatar.frame.height / 2
        ivAvatar.layer.borderWidth = 1
        ivAvatar.layer.borderColor = UIColor.lightGray.cgColor
        ivAvatar.clipsToBounds = true
        
        btnReject.layer.cornerRadius = 5
        btnReject.layer.borderWidth = 1
        btnReject.layer.borderColor = UIColor.lightGray.cgColor
        btnReject.clipsToBounds = true
        
        btnAccept.layer.cornerRadius = 5
        btnAccept.layer.borderWidth = 1
        btnAccept.layer.borderColor = UIColor.init(hexString: "#4f8baf").cgColor
        btnAccept.clipsToBounds = true
   
    }
    
    @IBAction func acceptClicked(_ sender: Any) {
        handelAcceptClicked!()
    }
    @IBAction func rejectClicked(_ sender: Any) {
        handelCancelClicked!()
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
