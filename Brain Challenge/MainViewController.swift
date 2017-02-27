//
//  MainViewController.swift
//  Brain Challenge
//
//  Created by Hado on 2/14/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import UIKit
import SocketIO

class MainViewController: UIViewController {
    @IBOutlet weak var container: UIView!
    
    var drawerViewController: DrawerViewController?
    
    var viewControllerMenuRight: [UIViewController] = []
    
    let socket = SocketIOClient(socketURL: URL(string: "http://127.0.0.1:3000")!, config: [.log(true), .forcePolling(true), .nsp("/chat")])
    
    
    static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        drawerViewController?.drawerProtocol = self
        
        initViewControllerMenuRight()
        
        socket.on(OnEventConstant.getConnectionEvent()) {data, ack in
            print("Connected")
            self.socket.emit(EmitEventConstant.getInitDataEvent(), with: [(UserRealm.getUserInfo()?.toJSONString())!])
        }
        
        socket.on(OnEventConstant.getFriendsOnlineEvent()) {data, ack in
            print("Hado receive: \(data[0])")
        }
        
//        socket.on(OnEventConstant.getOnlineOnEvent()) {data, ack in
//            print("Someone online: \(data[0])")
//        }
        
        socket.connect()
    }
    
    func initViewControllerMenuRight() {
        viewControllerMenuRight.append(MainViewController.mainStoryboard.instantiateViewController(withIdentifier: EventViewController.getIdentifier()))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menuClicked(_ sender: Any) {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
    
    

}

extension MainViewController: DrawerProtocol {
    func selectedItem(index: Int) {
        
        let currentTab = viewControllerMenuRight[index]
        addChildViewController(currentTab)
        currentTab.view.frame = container.bounds
        container.addSubview(currentTab.view)
        currentTab.didMove(toParentViewController: self)
        
    }
    
    
    class func navigate(viewController: UIViewController) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController   = storyBoard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        let drawerViewController = storyBoard.instantiateViewController(withIdentifier: "DrawerViewController") as! DrawerViewController
        let drawerController     = KYDrawerController(drawerDirection: .left, drawerWidth: 300)
        drawerController.mainViewController = UINavigationController(
            rootViewController: mainViewController
        )   
        
        drawerController.drawerViewController = drawerViewController
        
        mainViewController.drawerViewController = drawerViewController
        viewController.present(drawerController, animated: true, completion: nil)
    }
}
