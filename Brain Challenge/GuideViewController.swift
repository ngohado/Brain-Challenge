//
//  GuideViewController.swift
//  Brain Challenge
//
//  Created by Hado on 2/8/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import UIKit
import Alamofire

class GuideViewController: UIPageViewController {
    var data: [Guide] = []
    
    class func getIdentifier() -> String {
        return "GuideViewController"
    }
    
    
    class func navigate(viewConstroller: UIViewController) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let guideViewConstroller = storyBoard.instantiateViewController(withIdentifier: GuideViewController.getIdentifier()) as! GuideViewController
        
        viewConstroller.present(guideViewConstroller, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        loadGuide()
    }
    
    func loadGuide() {
        Alamofire.request(ApiConstant.getApiGuide(), parameters: GuideRequest().toJSON()).responseObject {
            (response: DataResponse<GuideResponse>) in
            if let guideRes = response.value, guideRes.status == 1 {
                self.data = guideRes.guides!
                self.setViewControllers([self.getSubGuide(index: 0)!], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
            } else {
                print("non status")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getSubGuide(index: Int) -> UIViewController? {
        if index < 0 || index >= data.count {
            return nil
        }
        
        let subGuide = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: SubGuideViewController.getIdentifier()) as! SubGuideViewController
        subGuide.total = data.count
        subGuide.index = index
        subGuide.data = data[index]
        return subGuide
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GuideViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! SubGuideViewController).index
        return getSubGuide(index: index! + 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! SubGuideViewController).index
        return getSubGuide(index: index! - 1)
    }
}
