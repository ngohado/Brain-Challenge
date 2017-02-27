//
//  EnterCodeViewCell.swift
//  Brain Challenge
//
//  Created by Hado on 2/20/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import UIKit
import IBAnimatable

class EnterCodeViewCell: UITableViewCell {
    
    @IBOutlet weak var edtCode: AnimatableTextField!
    
    @IBOutlet weak var btnApply: UIButton!
    
    var handelApplyClicked: ((String?) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func applyClicked(_ sender: Any) {
        if handelApplyClicked != nil {
            handelApplyClicked!(edtCode.text)
        }
    }

}
