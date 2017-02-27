//
//  GuideModel.swift
//  Brain Challenge
//
//  Created by Hado on 2/10/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import ObjectMapper

class Guide: Mappable {
    var stt: Int?
    var title: String?
    var image: String?
    var description: String?
    var isLastest: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.stt <- map["stt"]
        self.title <- map["title"]
        self.image <- map["image"]
        self.description <- map["description"]
        self.isLastest <- map["show_avatar"]
    }
}
