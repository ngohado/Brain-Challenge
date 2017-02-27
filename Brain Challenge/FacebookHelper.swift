//
//  FacebookHelper.swift
//  Brain Challenge
//
//  Created by Hado on 2/4/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import FacebookCore
import ObjectMapper

struct MyProfileRequest: GraphRequestProtocol {
    struct Response: GraphResponseProtocol {
        var name: String?
        var email: String?
        var id: String?
        init(rawResponse: Any?) {
            if let resDict = rawResponse as? [String : String] {
                print(resDict)
                name = resDict["name"]
                email = resDict["email"]
                id = resDict["id"]
            }
        }
    }
    
    var graphPath = "/me"
    var parameters: [String : Any]? = ["fields": "name, email"]
    var accessToken = AccessToken.current
    var httpMethod: GraphRequestHTTPMethod = .GET
    var apiVersion: GraphAPIVersion = .defaultVersion
}

class FacebookHelper {
    class func getUserInfo(callback: @escaping (_ user: User?) -> Void) {
        let connection = GraphRequestConnection()
        connection.add(MyProfileRequest()) { res, result in
            switch result {
            case .success(let response):
                let user = User()
                user.name = response.name
                user.email = response.email
                if let id = response.id {
                    user.avatar = "http://graph.facebook.com/\(id)/picture?type=large"
                }
                callback(user)
            case .failed(let error):
                print("Get user fb info error: \(error)")
                callback(nil)
            }
        }
        connection.start()
    }
}
