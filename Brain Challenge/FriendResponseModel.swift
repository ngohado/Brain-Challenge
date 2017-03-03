//
//  FriendResponseModel.swift
//  Brain Challenge
//
//  Created by Hado on 3/3/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import ObjectMapper

class FriendResponseModel: Mappable {
    
    var friends: [User]?
    var friendsRequest: [User]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.friends <- map["friends"]
        self.friendsRequest <- map["friends_request"]
    }
}

