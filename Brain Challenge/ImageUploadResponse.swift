//
//  ImageUploadResponse.swift
//  Brain Challenge
//
//  Created by Hado on 3/10/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import ObjectMapper

class ImageUploadResponse: BaseResponse {
    var imageUrl: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        imageUrl <- map["data"]
    }
}
