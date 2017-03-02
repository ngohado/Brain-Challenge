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
    static let socketChat = SocketIOClient(socketURL: URL(string: "\(ApiConstant.BASE_URL):3000")!, config: [.log(true), .forcePolling(true), .nsp("/chat")])
    static let socketBattle = SocketIOClient(socketURL: URL(string: "\(ApiConstant.BASE_URL):3000")!, config: [.log(true), .forcePolling(true), .nsp("/battle")])
    
    static var msgHistoryProtocol: [SocketHandleData] = []
    
    
    class func setMsgHistoryProtocol(listener: SocketHandleData) {
        msgHistoryProtocol.append(listener)
    }
    
    class func connectChat() {
        if isConnect {
            return
        }
        
        socketChat.on(OnEventConstant.getConnectionEvent()) {
            data, ack in
            isConnect = true
            //TODO: emit id to sever
            
        }
        
        socketChat.onJson(event: OnEventConstant.getMessageHistoryEvent()) { (messages: MessageHistoryResponse) in
            for listener in msgHistoryProtocol {
                listener.onReceive(event: OnEventConstant.getMessageHistoryEvent(), data: messages)
            }
        }
        
        socketChat.connect()
    }
}

protocol SocketHandleData {
    func onReceive<T: BaseMappable> (event: String, data: T)
}
