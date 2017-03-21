//
//  FriendOnlineResponse.swift
//  Brain Challenge
//
//  Created by Hado on 3/18/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import ObjectMapper

class FriendOnlineResponse: BaseResponse {
    var friendStatusModel: FriendStatusModel?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        friendStatusModel <- map["data"]
    }
}

class FriendStatusModel: Mappable {
    var friendsOnline: [User]?
    var friendsOffline: [User]?
    var messageOffline: [Message]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        friendsOnline <- map["friend_online"]
        friendsOffline <- map["friend_offline"]
        messageOffline <- map["message_offline"]
    }
}
