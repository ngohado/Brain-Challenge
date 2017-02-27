//
//  EventModel.swift
//  Brain Challenge
//
//  Created by Hado on 2/20/17.
//  Copyright © 2017 Hado. All rights reserved.
//
import ObjectMapper

class Event: Mappable {
    var id: Int?
    var bannerUrl: String?
    var title: String?
    var content: String?
    var expiredDate: Double?
    var code: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        bannerUrl <- map["banner"]
        title <- map["title"]
        content <- map["content"]
        expiredDate <- map["expired_date"]
        code <- map["code"]
    }
    
}
