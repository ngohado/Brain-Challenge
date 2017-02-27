//
//  LoginRequest.swift
//  Brain Challenge
//
//  Created by Hado on 2/2/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import ObjectMapper

class LoginRequest: Mappable {
    
    var username: String?
    var password: String?
    
    required init?(map: Map) {
        
    }
    
    init(username: String?, password: String?) {
        self.username = username
        self.password = password
    }
    
    func mapping(map: Map) {
        self.username <- map["username"]
        self.password <- map["password"]
    }
}
