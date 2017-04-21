//
//  RoomViewController.swift
//  Brain Challenge
//
//  Created by Hado on 4/7/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import UIKit

class RoomViewController: UIViewController {
    
    class func getIdentifier() -> String {
        return "RoomViewController"
    }
    
    static var rooms: [Room] = []

    @IBOutlet weak var tableviewRoom: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SocketUtil.roomsProtocol = self
        SocketUtil.createProtocol = self
        SocketUtil.cancelRoomProtocol.append(self)
        SocketUtil.connectBattle()
        
        tableviewRoom.contentInset.top = getTopInsect()
        tableviewRoom.contentInset.bottom = 50
        
        tableviewRoom.dataSource = self
        tableviewRoom.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
    }
}

extension RoomViewController: SocketHandleData {
    func onReceive<BaseResponse>(event: String, data: BaseResponse) {
        switch event {
        case EmitEventConstant.getRoomEvent():
            RoomViewController.rooms = (data as! RoomsResponse).rooms!;
            tableviewRoom.reloadData()
            break
        case EmitEventConstant.getCreateRoomEvent():
            RoomViewController.rooms.append((data as! RoomActionResponse).room!)
            tableviewRoom.reloadData()
            break
            
        case EmitEventConstant.getCancelRoomEvent():
            let roomCancel = (data as! RoomActionResponse).room
            for (index, value) in RoomViewController.rooms.enumerated().reversed() {
                if value.userHost?._id == roomCancel?.userHost?._id {
                    RoomViewController.rooms.remove(at: index)
                    break
                }
            }
            tableviewRoom.reloadData()
            break
        default:
            print(event)
        }
        
    }
}

extension RoomViewController: UITableViewDelegate, UITableViewDataSource {
    
    func joinRoom(room: Room) {
        room.userMember = UserRealm.getUserInfo()
        SocketUtil.emitBattleData(event: EmitEventConstant.getJoinRoomEvent(), jsonData: room.toJSONString()!)
        WaitingRoomViewController.navigate(viewController: self, room: room) {
            self.tableviewRoom.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let room = RoomViewController.rooms[indexPath.row]
        if room.userMember != nil {
            AlertHelper.showAlert(viewController: self, title: "Full room", message: "The room is full, please choose another room", titleButton: "Ok")
        } else if room.password != nil {
            AlertHelper.showDialogConfirmPassword(viewController: self, cbCancel: { (alert) in
                
            }, cbConfirm: { (alert, password) in
                if password != room.password {
                    AlertHelper.showAlert(viewController: self, title: "Wrong password", message: "Your password is wrong, please try again", titleButton: "OK")
                } else {
                    //join room
                    alert.dismiss(animated: true, completion: nil)
                    self.joinRoom(room: room)
                }
            })
        } else {
            //join room
            joinRoom(room: room)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RoomViewController.rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let room = RoomViewController.rooms[indexPath.row]
        let cell = tableviewRoom.dequeueReusableCell(withIdentifier: RoomTableViewCell.getIdentifier(), for: indexPath) as! RoomTableViewCell
        cell.bindData(room: room)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
