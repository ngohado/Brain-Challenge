//
//  BonusRequest.swift
//  Brain Challenge
//
//  Created by Hado on 2/21/17.
//  Copyright © 2017 Hado. All rights reserved.
//
import ObjectMapper

class BonusRequest: BaseRequest {
    
    var emailUser: String?
    var code: String?
    
    override init() {
        super.init()
        if let e = UserRealm.getUserInfo()?.email {
            emailUser = e
        }
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        emailUser <- map["email"]
        code <- map["code"]
    }
}
