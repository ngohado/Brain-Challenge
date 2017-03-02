//
//  UserInfoRequest.swift
//  Brain Challenge
//
//  Created by Hado on 3/1/17.
//  Copyright © 2017 Hado. All rights reserved.
//
import ObjectMapper

class UserInfoRequest: BaseRequest {
    var id: String?
    var idShow: String?
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        id <- map["id"]
        idShow <- map["id_show"]
    }
}

class UserActionRequest: BaseRequest {
    var idSender: String?
    var idReceiver: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        idSender <- map["id_sender"]
        idReceiver <- map["id_receiver"]
    }
}

