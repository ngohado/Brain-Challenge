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
        return BASE_URL + "/login"
    }
    
    class func getApiLoginSN() -> String {
        return BASE_URL + "/loginsn"
    }
    
    class func getApiRegist() -> String {
        return BASE_URL + "/regist"
    }
    
    class func getApiGuide() -> String {
        return BASE_URL + "/guide"
    }
    
    class func getApiEvent() -> String {
        return BASE_URL + "/event"
    }
    
    class func getApiBonus() -> String {
        return BASE_URL + "/bonus"
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

