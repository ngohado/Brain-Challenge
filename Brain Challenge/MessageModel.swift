//
//  MessageModel.swift
//  Brain Challenge
//
//  Created by Hado on 2/25/17.
//  Copyright © 2017 Hado. All rights reserved.
//


import ObjectMapper

class Message: Mappable {
    
    var idSender: String?
    var idReceiver: String?
    var message: String?
    var type: Int?
    var time: Double?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        idSender <- map["id_sender"]
        idReceiver <- map["id_receiver"]
        message <- map["message"]
        type <- map["type"]
        time <- map["time"]
    }
    
}
