//
//  SocketIO.swift
//  Brain Challenge
//
//  Created by Hado on 2/23/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import SocketIO
import ObjectMapper

extension SocketIOClient {
    func onJson<T: BaseMappable>(event: String, callback: @escaping (_ response: T) -> Void) {
        on(event) {data, ack in
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data[0], options: .prettyPrinted)
                let res = Mapper<T>().map(JSONString: String(data: jsonData, encoding: String.Encoding.utf8)!)
                
                callback(res!)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    

}

class SocketUtil {
    private static var isConnect: Bool = false
    
    //socket chat
    static let socketChat = SocketIOClient(socketURL: URL(string: "\(ApiConstant.BASE_URL):3000")!,
                                           config: [.log(false), .forcePolling(true), .nsp("/chat")])
    
    //socket battle
    static let socketBattle = SocketIOClient(socketURL: URL(string: "\(ApiConstant.BASE_URL):3000")!,
                                             config: [.log(false), .forcePolling(true), .nsp("/battle")])
    
    static var msgHistoryProtocol: [SocketHandleData] = []
    static var messageProtocol: [SocketHandleData] = []
    static var onlineProtocol: [SocketHandleData] = []
    static var offlineProtocol: [SocketHandleData] = []
    static var typingProtocol: SocketHandleData?
    static var haveOfflineMsgProtocol: SocketHandleData?
    
    static var roomsProtocol: SocketHandleData?
    static var createProtocol: SocketHandleData?
    static var joinRoomProtocol: SocketHandleData?
    static var exitRoomProtocol: SocketHandleData?
    static var readyProtocol: SocketHandleData?
    static var kickProtocol: SocketHandleData?
    static var questionProtocol: SocketHandleData?
    static var battleStartProtocol: SocketHandleData?
    static var rivalAnswerProtocol: SocketHandleData?
    static var nextQuestionProtocol: SocketHandleData?
    static var freezeProtocol: SocketHandleData?
    static var resultQuestionProtocol: SocketHandleData?
    static var sentInvitationProtocol: SocketHandleData?
    static var resultInvitationProtocol: SocketHandleData?
    static var receiveInvitationProtocol: SocketHandleData?
    static var cancelRoomProtocol: [SocketHandleData] = []
    
    class func setMsgHistoryProtocol(listener: SocketHandleData) {
        msgHistoryProtocol.append(listener)
    }
    
    class func setMessageProtocol(listener: SocketHandleData) {
        messageProtocol.append(listener)
    }
    
    class func setOnlineProtocol(listener: SocketHandleData) {
        onlineProtocol.append(listener)
    }
    
    class func setOfflineProtocol(listener: SocketHandleData) {
        offlineProtocol.append(listener)
    }
    
    class func setTypingProtocol(listener: SocketHandleData) {
        typingProtocol = listener
    }
    
    class func emitData(event: String, jsonData: String) {
        socketChat.emit(event, jsonData)
    }
    
    class func connectChat() {
        if isConnect {
            return
        }
        
        socketChat.on(OnEventConstant.getConnectionEvent()) {
            data, ack in
            isConnect = true
            //TODO: emit id to sever
            socketChat.emit(EmitEventConstant.getInitDataEvent(), (UserRealm.getUserInfo()?.toJSONString())!)
        }
        
        socketChat.onJson(event: OnEventConstant.getMessageHistoryEvent()) { (messages: MessageHistoryResponse) in
            for listener in msgHistoryProtocol {
                listener.onReceive(event: OnEventConstant.getMessageHistoryEvent(), data: messages)
            }
        }
        
        socketChat.onJson(event: OnEventConstant.getMessageEvent()) { (messages: MessageResponse) in
            MainChatViewController.friendOnline.sort(by: { (u1, u2) -> Bool in
                let idSender = (messages.messages?.idSender)
                return u2._id == idSender
            })
            
            for listener in messageProtocol {
                listener.onReceive(event: OnEventConstant.getMessageEvent(), data: messages)
            }
        }
        
        socketChat.onJson(event: OnEventConstant.getOnlineEvent()) { (status: StatusResponse) in
            for (index, value) in MainChatViewController.friendOffline.enumerated().reversed() {
                if value._id == status.id {
                    MainChatViewController.friendOnline.append(value)
                    MainChatViewController.friendOffline.remove(at: index)
                    break
                }
            }
            
            for listener in onlineProtocol {
                listener.onReceive(event: OnEventConstant.getOnlineEvent(), data: status)
            }
        }
        
        socketChat.onJson(event: OnEventConstant.getOfflineEvent()) { (status: StatusResponse) in
            for (index, value) in MainChatViewController.friendOnline.enumerated().reversed() {
                if value._id == status.id {
                    MainChatViewController.friendOffline.append(value)
                    MainChatViewController.friendOnline.remove(at: index)
                    break
                }
            }
            
            for listener in offlineProtocol {
                listener.onReceive(event: OnEventConstant.getOfflineEvent(), data: status)
            }
        }
        
        socketChat.onJson(event: OnEventConstant.getTypingEvent()) { (messages: MessageResponse) in
            typingProtocol?.onReceive(event: OnEventConstant.getTypingEvent(), data: messages)
        }
        
        socketChat.onJson(event: OnEventConstant.getFriendsOnlineEvent()) { (response: FriendOnlineResponse) in
            MainChatViewController.friendOnline = response.friendStatusModel!.friendsOnline!
            MainChatViewController.friendOffline = response.friendStatusModel!.friendsOffline!
            
            for listener in onlineProtocol {
                listener.onReceive(event: OnEventConstant.getOnlineEvent(), data: response)
            }
            
            for friend in MainChatViewController.friendOnline {
                if !friend.isRead {
                    haveOfflineMsgProtocol?.onReceive(event: "Have message offline", data: response)
                    return
                }
            }
            
            for friend in MainChatViewController.friendOffline {
                if !friend.isRead {
                    haveOfflineMsgProtocol?.onReceive(event: "Have message offline", data: response)
                    return
                }
            }
        }
        
        socketChat.connect()
    }
    
    
    class func connectBattle() {
        socketBattle.on(OnEventConstant.getConnectionEvent()) {
            data, ack in
            isConnect = true
            //TODO: emit id to sever
            socketBattle.emit(EmitEventConstant.getInitDataEvent(), (UserRealm.getUserInfo()?.toJSONString())!)
        }
        
        socketBattle.onJson(event: EmitEventConstant.getRoomEvent()) { (rooms: RoomsResponse) in
            roomsProtocol?.onReceive(event: EmitEventConstant.getRoomEvent(), data: rooms)
        }
        
        socketBattle.onJson(event: EmitEventConstant.getJoinRoomEvent()) { (room: RoomActionResponse) in
            joinRoomProtocol?.onReceive(event: EmitEventConstant.getJoinRoomEvent(), data: room)
        }
        
        socketBattle.onJson(event: EmitEventConstant.getExitRoomEvent()) { (room: RoomActionResponse) in
            exitRoomProtocol?.onReceive(event: EmitEventConstant.getExitRoomEvent(), data: room)
        }
        
        socketBattle.onJson(event: EmitEventConstant.getCreateRoomEvent()) { (room: RoomActionResponse) in
            createProtocol?.onReceive(event: EmitEventConstant.getCreateRoomEvent(), data: room)
        }
        
        socketBattle.onJson(event: EmitEventConstant.getCancelRoomEvent()) { (room: RoomActionResponse) in
            for cb in cancelRoomProtocol {
                cb.onReceive(event: EmitEventConstant.getCancelRoomEvent(), data: room)
            }
        }
        
        socketBattle.onJson(event: EmitEventConstant.getReadyEvent()) { (readyModel: ReadyResponse) in
            readyProtocol?.onReceive(event: EmitEventConstant.getReadyEvent(), data: readyModel)
        }
        
        socketBattle.onJson(event: EmitEventConstant.getQuestionEvent()) { (questionRes: QuestionResponse) in
            questionProtocol?.onReceive(event: EmitEventConstant.getQuestionEvent(), data: questionRes)
        }
        
        socketBattle.onJson(event: EmitEventConstant.getBattleStartEvent()) { (room: RoomActionResponse) in
            battleStartProtocol?.onReceive(event: EmitEventConstant.getBattleStartEvent(), data: room)
        }
        
        socketBattle.onJson(event: EmitEventConstant.getKickEvent()) { (room: RoomActionResponse) in
            kickProtocol?.onReceive(event: EmitEventConstant.getKickEvent(), data: room)
        }
        
        socketBattle.onJson(event: EmitEventConstant.getRivalAnswerEvent()) { (answerRes: AnswerResponse) in
            rivalAnswerProtocol?.onReceive(event: EmitEventConstant.getRivalAnswerEvent(), data: answerRes)
        }
        
        socketBattle.onJson(event: EmitEventConstant.getNextQuestionEvent()) { (res: BaseResponse) in
            nextQuestionProtocol?.onReceive(event: EmitEventConstant.getNextQuestionEvent(), data: res)
        }
        
        socketBattle.onJson(event: EmitEventConstant.getResultQuestionEvent()) { (res: AnswerResponse) in
            resultQuestionProtocol?.onReceive(event: EmitEventConstant.getResultQuestionEvent(), data: res)
        }
        
        socketBattle.onJson(event: EmitEventConstant.getFreezeEvent()) { (res: BaseResponse) in
            freezeProtocol?.onReceive(event: EmitEventConstant.getFreezeEvent(), data: res)
        }
        
        socketBattle.onJson(event: EmitEventConstant.getResultInvitationEvent()) { (room: RoomActionResponse) in
            resultInvitationProtocol?.onReceive(event: EmitEventConstant.getResultInvitationEvent(), data: room)
        }
        
        socketBattle.onJson(event: EmitEventConstant.getSentInvitationEvent()) { (res: BaseResponse) in
            sentInvitationProtocol?.onReceive(event: EmitEventConstant.getSentInvitationEvent(), data: res)
        }
        
        socketBattle.onJson(event: EmitEventConstant.getReceiveInvitationEvent()) { (room: RoomActionResponse) in
            receiveInvitationProtocol?.onReceive(event: EmitEventConstant.getReceiveInvitationEvent(), data: room)
        }
        
        socketBattle.connect()
    }
    
    class func emitBattleData(event: String, jsonData: String) {
        socketBattle.emit(event, jsonData)
    }
}

protocol SocketHandleData: class {
    func onReceive<T: BaseMappable> (event: String, data: T)
}

extension Date {
    var millisecondsSince1970:Double {
        return (self.timeIntervalSince1970 * 1000.0).rounded()
    }
}
