//
//  ApiConstant.swift
//  Brain Challenge
//
//  Created by Hado on 2/2/17.
//  Copyright © 2017 Hado. All rights reserved.
//

class ApiConstant {
    static let BASE_URL = "http://192.168.0.102"
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
    
    class func getApiUpdateName() -> String {
        return BASE_API + "/updatename"
    }
    
    class func getApiUpdateGender() -> String {
        return BASE_API + "/updategender"
    }
    
    class func getApiUpdatePhone() -> String {
        return BASE_API + "/updatephone"
    }
    
    class func getApiUpdateAvatar() -> String {
        return BASE_API + "/updateavatar"
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
    
    class func getApiFriend() -> String {
        return BASE_API + "/friends"
    }
    
    class func getApiSearchUser() -> String {
        return BASE_API + "/searchuser"
    }
    
    class func getApiRank() -> String {
        return BASE_API + "/ranks"
    }
    
    class func getApiUploadImage() -> String {
        return BASE_API + "/upimage"
    }
    
    class func getApiMessageHistory() -> String {
        return BASE_API + "/messagehistory"
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
    
    class func getOnlineEvent() -> String {
        return "informOnline"
    }
    
    class func getOfflineEvent() -> String {
        return "informOffline"
    }
    
    class func getTypingEvent() -> String {
        return "typing"
    }
    
    class func getFriendsOnlineEvent() -> String {
        return "friendsOnlineList"
    }
}

/*
 0: yourself
 1: send request
 2: receive request
 3: friend
 4: not friend
 */
class TypeFriend {
    static let YOURSELF = 0
    static let SEND_REQUEST = 1
    static let RECEIVE_REQUEST = 2
    static let FRIEND = 3
    static let NOT_FRIEND = 4
}

class TypeMessage {
    static let MESSAGE_NORMAL = 1
    static let MESSAGE_PHOTO = 2
    static let TYPING = 3
    static let UNTYPING = 4
}

class EmitEventConstant {
    class func getInitDataEvent() -> String {
        return "initdata"
    }
    
    class func getMessagingEvent() -> String {
        return "message"
    }
    
    class func getOnlineEvent() -> String {
        return "online"
    }
    
    class func getOffilineEvent() -> String {
        return "offline"
    }
    
    class func getTypingEvent() -> String {
        return OnEventConstant.getTypingEvent()
    }
    
    //battle
    
    class func getRoomEvent() -> String {
        return "rooms"
    }
    
    class func getCreateRoomEvent() -> String {
        return "create_room"
    }
    
    class func getCancelRoomEvent() -> String {
        return "cancel_room"
    }
    
    class func getExitRoomEvent() -> String {
        return "exit_room"
    }
    
    class func getJoinRoomEvent() -> String {
        return "join_room"
    }
    
    class func getReadyEvent() -> String {
        return "ready"
    }
    
    class func getStartEvent() -> String {
        return "start"
    }
    
    class func getKickEvent() -> String {
        return "kick"
    }
    
    class func getQuestionEvent() -> String {
        return "question"
    }
    
    class func getFailJoinRoomEvent() -> String {
        return "fail_join_room"
    }
    
    class func getBattleReadyEvent() -> String {
        return "battle_ready"
    }
    
    class func getBattleStartEvent() -> String {
        return "battle_start"
    }
    
    class func getTimeoutOrAnsweredEvent() -> String {
        return "timeout_or_answered"
    }
    
    class func getNextQuestionEvent() -> String {
        return "next_question"
    }
    
    class func getRivalAnswerEvent() -> String {
        return "rival_answer"
    }
    
    class func getAnswerEvent() -> String {
        return "answer"
    }
    
    class func getResultQuestionEvent() -> String {
        return "result_question"
    }
    
    class func getFreezeEvent() -> String {
        return "freeze"
    }
    
    class func getSentInvitationEvent() -> String {
        return "sent_invitation"
    }
    
    class func getResultInvitationEvent() -> String {
        return "result_invitation"
    }
    
    class func getReceiveInvitationEvent() -> String {
        return "receive_invitation"
    }
    
}

