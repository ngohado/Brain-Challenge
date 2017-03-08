//
//  SearchResponse.swift
//  Brain Challenge
//
//  Created by Hado on 3/6/17.
//  Copyright © 2017 Hado. All rights reserved.
//
import ObjectMapper

class SearchUserResponse: BaseResponse {
    var users: [UserInfo]?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        self.users <- map["data"]
    }
}
