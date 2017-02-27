//
//  BonusResponse.swift
//  Brain Challenge
//
//  Created by Hado on 2/21/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import ObjectMapper

class BonusResponse: BaseResponse {
    
    var newItem: Item?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        newItem <- map["data"]
    }
}
