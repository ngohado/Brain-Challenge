//
//  BaseResponse.swift
//  Brain Challenge
//
//  Created by Hado on 2/2/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import ObjectMapper

class BaseResponse: Mappable {
    
    var status: Int?
    var errorCode: Int?
    var errorMessage: String?
    
    init() {
        status = 0
    }
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        self.status <- map["status"]
        self.errorCode <- map["errorCode"]
        self.errorMessage <- map["errorMessage"]
    }
}
