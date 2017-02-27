//
//  MessageResponse.swift
//  Brain Challenge
//
//  Created by Hado on 2/25/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import Foundation
import ObjectMapper

class MessageHistoryResponse: BaseResponse {
    var messages: [Message]?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        messages <- map["data"]
    }
    
}


