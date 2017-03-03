//
//  FriendRequest.swift
//  Brain Challenge
//
//  Created by Hado on 3/3/17.
//  Copyright © 2017 Hado. All rights reserved.
//
import ObjectMapper

class FriendRequest: BaseRequest {
    var id: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        id <- map["id"]
    }
}
