//
//  ApiConstant.swift
//  Brain Challenge
//
//  Created by Hado on 2/2/17.
//  Copyright © 2017 Hado. All rights reserved.
//

class ApiConstant {
    static let BASE_URL = "http://127.0.0.1"
    static let BASE_API = "\(BASE_URL):8080"
    
    class func getApiLogin() -> String {
        return BASE_API + "/login"
    }
    
    class func getApiLoginSN() -> String {
        return BASE_API + "/loginsn"
    }
    
    class func getApiRegist() -> String {
        return BASE_API + "/regist"
    }
    
    class func getApiGuide() -> String {
        return BASE_API + "/guide"
    }
    
    class func getApiEvent() -> String {
        return BASE_API + "/event"
    }
    
    class func getApiBonus() -> String {
        return BASE_API + "/bonus"
    }
    
    class func getApiUserInfo() -> String {
        return BASE_API + "/user"
    }
    
    class func getApiAddFriend() -> String {
        return BASE_API + "/requestfriend"
    }
    
    class func getApiCancelRequestFriend() -> String {
        return BASE_API + "/cancelrequestfriend"
    }
    
    class func getApiAcceptRequestFriend() -> String {
        return BASE_API + "/acceptrequestfriend"
    }
    
    class func getApiCancelFriend() -> String {
        return BASE_API + "/cancelfriend"
    }
    
    
}

class OnEventConstant {
    
    class func getMessageHistoryEvent() -> String {
        return "message_history"
    }
    
    class func getMessageEvent() -> String {
        return "message"
    }
    
    class func getConnectionEvent() -> String {
        return "connect"
    }
    
    class func getDisconnectEvent() -> String {
        return "disconnect"
    }
    
    class func getOnlineOnEvent() -> String {
        return "informOnline"
    }
    
    class func getOfflineEvent() -> String {
        return "informOffline"
    }
    
    class func getFriendsOnlineEvent() -> String {
        return "friendsOnlineList"
    }
}

class EmitEventConstant {
    class func getInitDataEvent() -> String {
        return "initdata"
    }
}

