//
//  EventResponse.swift
//  Brain Challenge
//
//  Created by Hado on 2/20/17.
//  Copyright © 2017 Hado. All rights reserved.
//
import ObjectMapper

class EventResponse: BaseResponse {
    var events: EventResponseModel?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        events <- map["data"]
    }
}

class EventResponseModel: Mappable {
    
    var fixedEvent: [Event]?
    var dynamicEvent: [Event]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        fixedEvent <- map["fixed_event"]
        dynamicEvent <- map["dynamic_event"]
    }
}
