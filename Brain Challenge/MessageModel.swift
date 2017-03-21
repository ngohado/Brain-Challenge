//
//  MessageModel.swift
//  Brain Challenge
//
//  Created by Hado on 2/25/17.
//  Copyright © 2017 Hado. All rights reserved.
//


import ObjectMapper
import RealmSwift
import RxSwift
import RxCocoa
import JSQMessagesViewController

class Message: Mappable {
    
    var idSender: String?
    var idReceiver: String?
    var message: String?
    var type: Int?
    var time: Double?
    
    init(idSender: String, idReceiver: String, message: String, type: Int, time: Double) {
        self.idSender = idSender
        self.idReceiver = idReceiver
        self.message = message
        self.type = type
        self.time = time
    }
    
    init(msg: MessageRealm) {
        self.idSender = msg.idSender
        self.idReceiver = msg.idReceiver
        self.message = msg.message
        self.type = msg.type.value
        self.time = msg.time.value
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        idSender <- map["id_sender"]
        idReceiver <- map["id_receiver"]
        message <- map["message"]
        type <- map["type"]
        time <- map["time"]
    }
    
    func save() {
        let msgSave = MessageRealm()
        msgSave.initData(msg: self)
        msgSave.save()
    }
    
    class func saveMulti(messages: [Message]) {
        do {
            let realm = try Realm()
            for msg in messages {
                let msgSave = MessageRealm()
                msgSave.initData(msg: msg)
                msgSave.save(realm: realm)
            }
        } catch {
            print("Error write message")
        }
    }
    
}


class MessageRealm: Object {
    dynamic var idSender: String?
    dynamic var idReceiver: String?
    dynamic var message: String?
    var type = RealmOptional<Int>()
    var time = RealmOptional<Double>()
    
    func initData(msg: Message) {
        self.idSender = msg.idSender
        self.idReceiver = msg.idReceiver
        self.message = msg.message
        self.type = RealmOptional<Int>(msg.type)
        self.time = RealmOptional<Double>(msg.time)
        
    }
    
    class func getMessage(idSender: String, idReceiver: String, lastTime: Double) -> Observable<[Message]> {
        return Observable<MessageRealm>.deferred({ () -> Observable<MessageRealm> in
            Observable<MessageRealm>.from(getMsgFromRealmDB(idSender: idSender, idReceiver: idReceiver, lastTime: lastTime))
        }).map({ (msgRealm) -> Message in
            return Message(msg: msgRealm)
        }).toArray().take(10).subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
    private class func getMsgFromRealmDB(idSender: String, idReceiver: String, lastTime: Double) -> [MessageRealm] {
        do {
            let realm = try Realm()
            
            var msgs = realm.objects(MessageRealm.self).filter("idSender = '\(idSender)' AND idReceiver = '\(idReceiver)' AND time < \(lastTime.rounded())").sorted(by: { (msg1, msg2) -> Bool in
                let time1 = msg1.time.value!
                let time2 = msg2.time.value!
                return time1 > time2
            })
            
            return []
        } catch let error as NSError{
            print(error)
        }
        return []
    }
    
    func save() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(self)
            }
        } catch {
            print("Error write message")
        }
    }
    
    func save(realm: Realm) {
        do {
            try realm.write {
                realm.add(self)
            }
        } catch {
            print("Error write message")
        }
    }
}
