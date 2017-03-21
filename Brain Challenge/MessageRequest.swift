//
//  MessageRequest.swift
//  Brain Challenge
//
//  Created by Hado on 3/11/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import ObjectMapper

class MessageHistoryRequest: BaseRequest {
    var idSender: String?
    var idReceiver: String?
    var lastTime: Double?
    
    init(idSender idS: String, idReceiver idR: String, lastTime lt: Double) {
        super.init()
        idSender  = idS
        idReceiver = idR
        lastTime = lt
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        idSender <- map["id_sender"]
        idReceiver <- map["id_receiver"]
        lastTime <- map["last_time"]
    }
}
