//
//  RankRequest.swift
//  Brain Challenge
//
//  Created by Hado on 3/8/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import ObjectMapper

class RankRequest: BaseRequest {
    var fromScore: Int?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        fromScore <- map["from_score"]
    }
}
