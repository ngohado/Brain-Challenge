//
//  WaitingRoomViewController.swift
//  Brain Challenge
//
//  Created by Hado on 4/8/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import UIKit


class WaitingRoomViewController: UIViewController {

    @IBOutlet weak var viewHostOutside: UIView!
    @IBOutlet weak var btnHostQuit: UIButton!
    @IBOutlet weak var ivHostAvatar: UIImageView!
    @IBOutlet weak var lbHostName: UILabel!
    @IBOutlet weak var lbHostLevel: UILabel!
    @IBOutlet weak var btnHostStart: UIButton!
    
    @IBOutlet weak var btnMemQuit: UIButton!
    @IBOutlet weak var ivMemAvatar: UIImageView!
    @IBOutlet weak var lbMemName: UILabel!
    @IBOutlet weak var lbMemLevel: UILabel!
    @IBOutlet weak var btnMemReady: UIButton!
    @IBOutlet weak var btnMemKick: UIButton!
    @IBOutlet weak var viewMemOutside: UIView!
    
    let WIN = 1
    let LOSE = 2
    let DRAW = 3
    
    var room: Room?
    var user: User = UserRealm.getUserInfo()!
    var updateData: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SocketUtil.cancelRoomProtocol.append(self)
        SocketUtil.exitRoomProtocol = self
        SocketUtil.readyProtocol = self
        SocketUtil.questionProtocol = self
        SocketUtil.kickProtocol = self
        SocketUtil.joinRoomProtocol = self
        SocketUtil.resultInvitationProtocol = self
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    func initView() {
        ivHostAvatar.layer.cornerRadius = ivHostAvatar.frame.height / 2
        ivHostAvatar.layer.borderWidth = 3
        ivHostAvatar.layer.borderColor = UIColor.lightGray.cgColor
        ivHostAvatar.clipsToBounds = true
        
        viewHostOutside.layer.cornerRadius = viewHostOutside.frame.height / 2
        viewHostOutside.clipsToBounds = true
        
        ivMemAvatar.layer.cornerRadius = ivMemAvatar.frame.height / 2
        ivMemAvatar.layer.borderWidth = 3
        ivMemAvatar.layer.borderColor = UIColor.lightGray.cgColor
        ivMemAvatar.clipsToBounds = true
        
        viewMemOutside.layer.cornerRadius = viewMemOutside.frame.height / 2
        viewMemOutside.clipsToBounds = true

        btnMemKick.layer.cornerRadius = 3
        btnMemQuit.layer.cornerRadius = 3
        btnHostQuit.layer.cornerRadius = 3
        btnHostStart.layer.cornerRadius = 3
        btnMemReady.layer.cornerRadius = 3
        
        if user._id == room?.userHost?._id {
            setupMemNonData()
            setupHostData()
        } else {
            btnMemKick.isHidden = true
            btnHostStart.isHidden = true
            btnHostQuit.isHidden = true
            setupHostData()
            setupMemData()
        }
    }
    
    func setupMemNonData() {
        btnMemKick.setTitle("Invite", for: UIControlState.normal)
        btnMemReady.isHidden = true
        btnMemQuit.isHidden = true
        lbMemName.text = "???"
        lbMemLevel.text = ""
        ivMemAvatar.image = #imageLiteral(resourceName: "question_mark")
    }
    
    func setupHostData() {
        var textLevel = ""
        lbHostName.text = room?.userHost?.name!
        if let avatarUrl = room?.userHost?.avatar, !avatarUrl.isEmpty {
            ivHostAvatar.kf.setImage(with: URL(string: avatarUrl))
        }
        if let score = room?.userHost?.score, score > 1 {
            if score < 1000 {
                textLevel = "beginner"
            } else if score < 2000 {
                textLevel = "beginner++"
            } else if score < 3000 {
                textLevel = "intermediate"
            } else if score < 4000 {
                textLevel = "intermediate"
            } else {
                textLevel = "expert"
            }
        } else {
            textLevel = "beginner"
        }
        
        lbHostLevel.text = textLevel
    }
    
    func setupMemData() {
        var textLevel = ""
        lbMemName.text = room?.userMember?.name
        if let avatarUrl = room?.userMember?.avatar, !avatarUrl.isEmpty {
            ivMemAvatar.kf.setImage(with: URL(string: avatarUrl))
        }
        if let score = room?.userMember?.score, score > 1 {
            if score < 1000 {
                textLevel = "beginner"
            } else if score < 2000 {
                textLevel = "beginner++"
            } else if score < 3000 {
                textLevel = "intermediate"
            } else if score < 4000 {
                textLevel = "intermediate"
            } else {
                textLevel = "expert"
            }
        } else {
            textLevel = "beginner"
        }
        
        lbMemLevel.text = textLevel
        
        btnMemKick.setTitle("Kick", for: UIControlState.normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func navigate(viewController: UIViewController, room: Room, cbUpdate: @escaping () -> Void) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let waitingViewController = storyBoard.instantiateViewController(withIdentifier: "WaitingRoomViewController") as! WaitingRoomViewController
        waitingViewController.room = room
        waitingViewController.updateData = cbUpdate
        viewController.navigationController?.pushViewController(waitingViewController, animated: true)
//        viewController.present(waitingViewController, animated: true, completion: nil)
    }

    
    
    @IBAction func buttonReadyClicked(_ sender: Any) {
        if user._id == room?.userHost?._id {
            return
        }
        if btnMemReady.currentTitle == "Ready" {
            SocketUtil.emitBattleData(event: EmitEventConstant.getReadyEvent(), jsonData: ReadyModel(idHost: (room?.userHost?._id)!, ready: true).toJSONString()!)
            btnMemReady.setTitle("Unready", for: UIControlState.normal)
        } else {
            SocketUtil.emitBattleData(event: EmitEventConstant.getReadyEvent(), jsonData: ReadyModel(idHost: (room?.userHost?._id)!, ready: false).toJSONString()!)
            btnMemReady.setTitle("Ready", for: UIControlState.normal)
        }
    }
    
    @IBAction func buttonMemQuitClicked(_ sender: Any) {
        SocketUtil.emitBattleData(event: EmitEventConstant.getExitRoomEvent(), jsonData: (room?.toJSONString())!)
        room?.userMember = nil
        updateData!()
        navigationController?.popViewController(animated: true)
    }

    @IBAction func buttonKickClicked(_ sender: Any) {
        if btnMemKick.currentTitle == "Kick" {
            SocketUtil.emitBattleData(event: EmitEventConstant.getKickEvent(), jsonData: (room?.toJSONString())!)
            setupMemNonData()
            room?.userMember = nil
            btnMemKick.setTitle("Invite", for: UIControlState.normal)
        } else if btnMemKick.currentTitle == "Invite" {
            InviteViewController.navigate(viewConstroller: self, room: room!, cb: { (isSuccess) in
                if isSuccess {
                    self.btnMemKick.setTitle("Waiting", for: UIControlState.normal)
                    AlertHelper.showAlert(viewController: self, title: "Sent", message: "Your invitation was sent", titleButton: "OK")
                }
            })
        }
        
        
    }

    @IBAction func buttonHostQuitClicked(_ sender: Any) {
        SocketUtil.emitBattleData(event: EmitEventConstant.getCancelRoomEvent(), jsonData: (room?.toJSONString())!)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonStartClicked(_ sender: Any) {
        if (room?.userMember) != nil {
            if !btnMemReady.isHidden {
                SocketUtil.emitBattleData(event: EmitEventConstant.getStartEvent(), jsonData: (room?.toJSONString())!)
            } else {
                AlertHelper.showAlert(viewController: self, title: "Cannot start", message: "The player is not ready yet", titleButton: "OK")
            }
        } else {
            AlertHelper.showAlert(viewController: self, title: "Cannot start", message: "Not enough player", titleButton: "OK")
        }
        
    }
    
}

extension WaitingRoomViewController: SocketHandleData {
    func onReceive<BaseMappable>(event: String, data: BaseMappable) {
        switch event {
        case EmitEventConstant.getCancelRoomEvent():
            let realData: RoomActionResponse = data as! RoomActionResponse
            if room?.userHost?._id != realData.room?.userHost?._id || user._id == realData.room?.userHost?._id {
                break
            } else if room?.userHost?._id == realData.room?.userHost?._id {
                navigationController?.popViewController(animated: true)
            }
            break
        case EmitEventConstant.getExitRoomEvent():
            setupMemNonData()
            room?.userMember = nil
            break
        case EmitEventConstant.getReadyEvent():
            let readyModel: ReadyModel = (data as! ReadyResponse).readyModel!
            if readyModel.ready! {
                btnMemReady.isHidden = false
            } else {
                btnMemReady.isHidden = true
            }
            break
        case EmitEventConstant.getQuestionEvent():
            let questions = (data as! QuestionResponse).questions!
            BattleViewController.navigate(viewController: self, room: room!, questions: questions) {
                (result: Int, score: Int) in
                var title: String?
                var prefixMsg = ""
                if result == self.WIN {
                    title = "You win!"
                    prefixMsg = "Congratulations! "
                } else if result == self.LOSE {
                    title = "You lose!"
                } else {
                    title = "Draw!"
                }
                AlertHelper.showAlert(viewController: self, title: title!, message: "\(prefixMsg)You got \(score) scores", titleButton: "OK")
            }
            break
        case EmitEventConstant.getKickEvent():
            room?.userMember = nil
            navigationController?.popViewController(animated: true)
            break
        case EmitEventConstant.getJoinRoomEvent():
            room?.userMember = (data as! RoomActionResponse).room?.userMember
            setupMemData()
            break
            
        case EmitEventConstant.getResultInvitationEvent():
            let res = data as! RoomActionResponse
            if res.status == 1 {
                let r = res.room!
                room?.userMember = r.userMember
                setupMemData()
            } else {
                btnMemKick.setTitle("Invite", for: UIControlState.normal)
                AlertHelper.showAlert(viewController: self, title: "Doesn't accept invitation", message: "Your friend doesn't accept your invitation!", titleButton: "OK")
            }
            
            break
        default:
            print(event)
        }
    }
}
