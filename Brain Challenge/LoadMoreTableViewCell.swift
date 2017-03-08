//
//  LoadMoreTableViewCell.swift
//  Brain Challenge
//
//  Created by Hado on 3/8/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import UIKit

class LoadMoreTableViewCell: UITableViewCell {
    
    var handelLoadMoreClicked: (() -> Void)?
    
    class func getIdentifier() -> String {
        return "LoadMoreTableViewCell"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func loadMoreClicked(_ sender: Any) {
        handelLoadMoreClicked?()
    }
}
