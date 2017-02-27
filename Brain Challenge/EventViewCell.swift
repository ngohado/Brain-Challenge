//
//  EventViewCell.swift
//  Brain Challenge
//
//  Created by Hado on 2/20/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import UIKit

class EventViewCell: UITableViewCell {
    
    @IBOutlet weak var ivBanner: UIImageView!

    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var lbExpiredDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
