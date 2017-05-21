//
//  UpdateModel.swift
//  Brain Challenge
//
//  Created by Hado on 5/21/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import Foundation
import ObjectMapper

class UpdateModel: Mappable {
    var id: String?
    var newValue: String?
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        newValue <- map["new_value"]
    }
}


class UpdateGenderModel: Mappable {
    var id: String?
    var gender: Int?
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        gender <- map["gender"]
    }
}
