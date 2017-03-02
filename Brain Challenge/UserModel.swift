//
//  UserModel.swift
//  Brain Challenge
//
//  Created by Hado on 2/2/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import ObjectMapper
import RealmSwift

class User: Mappable {
    var _id: String?
    var name: String?
    var username: String?
    var email: String?
    var phone: String?
    var avatar: String?
    var dateOfBirth: Double?
    var score: Int?
    var gender: Int?
    var type: Int?
    var firstLogin: Int?
    var items: [Item]?
    var token: String?
    
    required init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    init(user: UserRealm) {
        self._id = user.id
        self.name = user.name
        self.username = user.username
        self.email = user.email
        self.phone = user.phone
        self.token = user.token
        self.avatar = user.avatar
        
        self.dateOfBirth = user.dateOfBirth.value
        self.score = user.score.value
        self.gender = user.gender.value
        self.type = user.type.value
        self.firstLogin = user.firstLogin.value
    }
    
    func mapping(map: Map) {
        self._id <- map["_id"]
        self.name <- map["name"]
        self.username <- map["username"]
        self.email <- map["email"]
        self.phone <- map["phone"]
        self.avatar <- map["avatar"]
        self.dateOfBirth <- map["dob"]
        self.score <- map["score"]
        self.token <- map["token"]
        self.gender <- map["gender"]
        self.type <- map["type"]
        self.items <- map["item"]
        self.firstLogin <- map["firstLogin"]
    }
    
}

class UserRealm: Object {
    dynamic var id: String?
    dynamic var name: String?
    dynamic var username: String?
    dynamic var email: String?
    dynamic var phone: String?
    dynamic var avatar: String?
    dynamic var token: String?
    
    var dateOfBirth = RealmOptional<Double>()
    var score = RealmOptional<Int>()
    var gender = RealmOptional<Int>()
    var type = RealmOptional<Int>()
    var firstLogin = RealmOptional<Int>()
    
    func initData(user: User) {
        self.id = user._id
        self.name = user.name
        self.username = user.username
        self.email = user.email
        self.phone = user.phone
        self.token = user.token
        self.avatar = user.avatar
        
        self.dateOfBirth = RealmOptional<Double>(user.dateOfBirth)
        self.score = RealmOptional<Int>(user.score)
        self.gender = RealmOptional<Int>(user.gender)
        self.type = RealmOptional<Int>(user.type)
        self.firstLogin = RealmOptional<Int>(user.firstLogin)
    }

    func save() -> Bool {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(self)
            }
        } catch {
            return false
        }
        return true
    }
    
    class func getUserInfo() -> User? {
        do {
            let realm = try Realm()
            let users = realm.objects(UserRealm.self)
            if users.count > 0 {
                return User(user: users[users.count - 1])
            }
        } catch let error as NSError{
            print(error)
        }
        return nil
    }

}

class UserInfo: User {
    var typeFriend: Int?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        typeFriend <- map["type_friend"]
    }
}

class TwitterUser: Mappable {
    var name: String?
    var avatar: String?
    var email: String?
    var type: Int?
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.name <- map["name"]
        self.avatar <- map["profile_image_url"]
        self.email <- map["screen_name"]
    }
}
