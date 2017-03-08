//
//  SearchRequest.swift
//  Brain Challenge
//
//  Created by Hado on 3/6/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import ObjectMapper

class SearchUserRequest: BaseRequest {
    var id: String?
    var textSearch: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        id <- map["id"]
        textSearch <- map["text_search"]
    }
}
