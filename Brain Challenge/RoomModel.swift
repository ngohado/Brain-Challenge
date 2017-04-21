//
//  RoomModel.swift
//  Brain Challenge
//
//  Created by Hado on 4/6/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import ObjectMapper
import RealmSwift
import RxSwift
import RxCocoa
import JSQMessagesViewController

class Room: Mappable {
    
    var userHost: User?
    var userMember: User?
    var roomName: String?
    var password: String?
    var time: Double?
    
    init(userHost: User, userMember: User?, roomName: String, password: String?, time: Double) {
        self.userHost = userHost
        self.userMember = userMember
        self.roomName = roomName
        self.password = password
        self.time = time
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        userHost <- map["user_host"]
        userMember <- map["user_member"]
        roomName <- map["message"]
        password <- map["password"]
        time <- map["time"]
    }
    
}

class ReadyModel: Mappable {
    
    var idHost: String?
    var ready: Bool?
    
    init(idHost: String, ready: Bool) {
        self.idHost = idHost
        self.ready = ready
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        idHost <- map["id_host"]
        ready <- map["ready"]
    }
    
}

class QuestionModel: Mappable {
    
    var _id: Int?
    var question: String?
    var caseA: String?
    var caseB: String?
    var caseC: String?
    var caseD: String?
    var trueCase: Int?
    var level: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        _id <- map["_id"]
        question <- map["question"]
        caseA <- map["casea"]
        caseB <- map["caseb"]
        caseC <- map["casec"]
        caseD <- map["cased"]
        trueCase <- map["truecase"]
        level <- map["level"]
    }
}

class RivalAnswerModel: Mappable {
    
    var id_sender: String?
    var id_receiver: String?
    var answer: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id_sender <- map["id_sender"]
        id_receiver <- map["id_receiver"]
        answer <- map["answer"]
    }
}

class InvitationModel: Mappable {
    
    var id_recipient: String?
    var room: Room?
    
    init(idRecipient: String?, room: Room?) {
        self.id_recipient = idRecipient
        self.room = room
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id_recipient <- map["id_recipient"]
        room <- map["room"]
    }
}

class AnswerResultModel: Mappable {
    var room: Room?
    var id_question: Int?
    var id_sender: String?
    var id_rival: String?
    var answer: Int?
    var correct: Bool?
    var time: Float?
    var result: Int?
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        room <- map["room"]
        id_question <- map["id_question"]
        id_sender <- map["id_sender"]
        id_rival <- map["id_rival"]
        answer <- map["answer"]
        correct <- map["correct"]
        time <- map["time"]
        result <- map["result"]
    }
}

