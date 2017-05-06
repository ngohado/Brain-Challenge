//
//  ItemModel.swift
//  Brain Challenge
//
//  Created by Hado on 2/21/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import ObjectMapper

class Item: Mappable {
    
    var id: Int?
    var name: String?
    var image: String?
    var description: String?
    var quantity: Int?
    
    required init?(map: Map) {
        
    }
    
    init(id: Int) {
        self.id = id
        quantity = 0
    }
    
    func mapping(map: Map) {
        id <- map["item_id"]
        name <- map["item_name"]
        image <- map["item_image"]
        description <- map["item_description"]
        quantity <- map["item_quantity"]
    }
    
}

class ItemUpdate: Mappable {
    
    var email: String?
    var items: [Item]?
    
    required init?(map: Map) {
        
    }
    
    init(email: String, items: [Item]) {
        self.email = email
        self.items = items
    }
    
    func mapping(map: Map) {
        email <- map["email_user"]
        items <- map["items"]
    }
    
}
