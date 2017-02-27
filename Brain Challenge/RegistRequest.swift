//
//  RegistRequest.swift
//  Brain Challenge
//
//  Created by Hado on 2/4/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import ObjectMapper

class RegistRequest: Mappable {
    
    var name: String?
    var username: String?
    var password: String?
    var email: String?
    var gender: String?
    
    required init?(map: Map) {
        
    }
    
    init(username: String?, password: String?, name: String?, email: String?, gender: String?) {
        self.username = username
        self.password = password
        self.email = email
        self.name = name
        self.gender = gender
    }
    
    func mapping(map: Map) {
        self.username <- map["username"]
        self.password <- map["password"]
        self.name <- map["name"]
        self.email <- map["email"]
        self.gender <- map["gender"]
    }
}
