//
//  RegistResponse.swift
//  Brain Challenge
//
//  Created by Hado on 2/4/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import ObjectMapper

class RegistResponse: BaseResponse {
    var userInfo: User?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        self.userInfo <- map["data"]
    }
}
