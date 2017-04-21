//
//  BattleResponse.swift
//  Brain Challenge
//
//  Created by Hado on 4/7/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import ObjectMapper

class RoomsResponse: BaseResponse {
    var rooms: [Room]?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        rooms <- map["data"]
    }
    
}

class RoomActionResponse: BaseResponse {
    var room: Room?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        room <- map["data"]
    }
    
}

class ReadyResponse: BaseResponse {
    var readyModel: ReadyModel?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        readyModel <- map["data"]
    }
    
}

class QuestionResponse: BaseResponse {
    var questions: [QuestionModel]?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        questions <- map["data"]
    }
}

class AnswerResponse: BaseResponse {
    var answer: AnswerResultModel?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        answer <- map["data"]
    }
}


