//
//  GuideResponse.swift
//  Brain Challenge
//
//  Created by Hado on 2/10/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import ObjectMapper

class GuideResponse: BaseResponse {
    
    var guides: [Guide]?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        self.guides <- map["data"]
    }
}
