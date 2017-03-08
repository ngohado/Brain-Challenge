//
//  RankViewController.swift
//  Brain Challenge
//
//  Created by Hado on 3/7/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import UIKit
import Alamofire

class RankViewController: UIViewController {
    @IBOutlet weak var rankTableView: UITableView!
    var users: [UserInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        rankTableView.dataSource = self
        rankTableView.delegate = self
        
        loadData(fromScore: nil)
    }
    
    func loadData(fromScore: Int?) {
        let req = RankRequest()
        if let score = fromScore {
            req.fromScore = score
        }
        
        Alamofire.request(ApiConstant.getApiRank(), method: .post, parameters: req.toJSON(), encoding: JSONEncoding.default).responseObject { (response: DataResponse<SearchUserResponse>) in
            if let userRes = response.value, userRes.status == 1 {
                if fromScore != nil {
                    self.users.append(contentsOf: userRes.users!)
                } else {
                    self.users = userRes.users!
                }
                self.rankTableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


extension RankViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ProfileViewController.navigate(viewConstroller: self, idShow: users[indexPath.row]._id!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == users.count {
            let cell = rankTableView.dequeueReusableCell(withIdentifier: LoadMoreTableViewCell.getIdentifier(), for: indexPath) as! LoadMoreTableViewCell
            cell.handelLoadMoreClicked = {
                print("Load more")
            }
            return cell
        } else {
            let user = users[indexPath.row]
            let cell = rankTableView.dequeueReusableCell(withIdentifier: RankTableViewCell.getIdentifier(), for: indexPath) as! RankTableViewCell
            cell.bindData(data: user, index: indexPath.row)
            
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
