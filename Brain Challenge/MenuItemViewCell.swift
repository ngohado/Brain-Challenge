//
//  MenuItemViewCell.swift
//  Brain Challenge
//
//  Created by Hado on 2/15/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import UIKit

class MenuItemViewCell: UITableViewCell {

    @IBOutlet weak var ivIcon: UIImageView!
    
    @IBOutlet weak var lbTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bindData(item: MenuItem) {
        ivIcon.image = item.icon
        lbTitle.text = item.label
    }

}
