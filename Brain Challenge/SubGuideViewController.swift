//
//  SubGuideViewController.swift
//  Brain Challenge
//
//  Created by Hado on 2/9/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import UIKit
import Kingfisher

class SubGuideViewController: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var lbDescription: UILabel!
    
    @IBOutlet weak var ivBackground: UIImageView!
    
    @IBOutlet weak var btnGetStart: UIButton!
    
    var data: Guide?
    
    var titleString: String? {
        didSet {
            lbTitle.text = titleString
        }
    }
    
    var descriptionString: String? {
        didSet {
            lbDescription.text = descriptionString
        }
    }
    
    var backgroundURL: String? {
        didSet {
            let url = URL(string: backgroundURL!)!
            ivBackground.kf.setImage(with: url)
        }
    }
    
    class func getIdentifier() -> String {
        return "SubGuideViewController"
    }
    
    var index: Int?
    var total: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.pageControl.numberOfPages = total ?? 0
        self.pageControl.currentPage = index ?? 0
        
        if data != nil {
            titleString = data?.title
            descriptionString = data?.description
            backgroundURL = data?.image
            if let isLastest = data?.isLastest, isLastest == 1 {
                btnGetStart.isHidden = false
            } else {
                btnGetStart.isHidden = true
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func getStartClicked(_ sender: Any) {
        MainViewController.navigate(viewController: self)
    }

}
