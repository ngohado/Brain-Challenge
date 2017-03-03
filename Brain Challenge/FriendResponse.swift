//
//  FriendResponse.swift
//  Brain Challenge
//
//  Created by Hado on 3/3/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import ObjectMapper

class FriendResponse: BaseResponse {
    var friends: FriendResponseModel?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        self.friends <- map["data"]
    }
}
