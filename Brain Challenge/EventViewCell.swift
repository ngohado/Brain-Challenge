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
    
    @IBOutlet weak var lbCode: UILabel!
    
    @IBOutlet weak var viewCode: UIVisualEffectView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        viewCode.layer.cornerRadius = 5
        viewCode.clipsToBounds = true
        // Configure the view for the selected state
    }
    
    func bindData(event: Event) {
        ivBanner.kf.setImage(with: URL(string: event.bannerUrl!))
        lbTitle.text = event.title
        lbExpiredDate.text = event.content
        lbCode.text = event.code
    }

}
