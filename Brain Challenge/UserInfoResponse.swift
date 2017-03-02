//
//  UserInfoResponse.swift
//  Brain Challenge
//
//  Created by Hado on 3/1/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import ObjectMapper

class UserInfoResponse: BaseResponse {
    var userInfo: UserInfo?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        self.userInfo <- map["data"]
    }
}
