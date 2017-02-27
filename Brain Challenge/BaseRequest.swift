//
//  BaseRequest.swift
//  Brain Challenge
//
//  Created by Hado on 2/10/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import ObjectMapper

class BaseRequest: Mappable {
    var token: String?
    
    init() {
        if let user = UserRealm.getUserInfo() {
            token = user.token
        }
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.token <- map["token"]
    }
}
