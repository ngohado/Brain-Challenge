//
//  BattleViewController.swift
//  Brain Challenge
//
//  Created by Hado on 4/14/17.
//  Copyright © 2017 Hado. All rights reserved.
//

import UIKit

class BattleViewController: UIViewController {
    
    @IBOutlet weak var ivMeAvatar: UIImageView!
    
    @IBOutlet weak var ivMeIndicator: UIImageView!
    
    @IBOutlet weak var lbMeCorrectAnswers: UILabel!

    @IBOutlet weak var lbMyName: UILabel!
    
    @IBOutlet weak var ivRivalAvatar: UIImageView!
    
    @IBOutlet weak var ivRivalIndicator: UIImageView!
    
    @IBOutlet weak var lbRivalCorrectAnswer: UILabel!
    
    @IBOutlet weak var lbRivalName: UILabel!
    
    @IBOutlet weak var lbTimeCount: UILabel!
    
    @IBOutlet weak var lbCurrentQuestion: UILabel!
    
    @IBOutlet weak var lbQuestion: UILabel!
    
    @IBOutlet weak var lbAnswerA: AnswerLabel!
    
    @IBOutlet weak var lbAnswerB: AnswerLabel!
    
    @IBOutlet weak var lbAnswerC: AnswerLabel!
    
    @IBOutlet weak var lbAnswerD: AnswerLabel!
    
    @IBOutlet weak var viewContainerItem: UIView!
    
    @IBOutlet weak var containerA: UIView!
    
    @IBOutlet weak var containerB: UIView!
    
    @IBOutlet weak var containterC: UIView!
    
    @IBOutlet weak var containerD: UIView!
    
    @IBOutlet weak var lbItem1: UILabel!
    
    @IBOutlet weak var lbItem2: UILabel!
    
    @IBOutlet weak var lbItem3: UILabel!
    
    @IBOutlet weak var lbItem4: UILabel!
    
    let WIN = 1
    let LOSE = 2
    let DRAW_CORRECT = 3
    let DRAW_INCORRECT = 4
    
    let CORRECT_COLOR = UIColor.green
    let INCORRECT_COLOR = UIColor.red
    
    let TIME_WAIT = 3
    let TIME_ANSWER = 20
    
    var room: Room?
    var me = UserRealm.getUserInfo()
    var questions: [QuestionModel] = []
    var myCorrectAnswers: [AnswerResultModel] = []
    
    var timer: Timer!
    
    var freezeImage: UIImageView?
    let window = UIApplication.shared.keyWindow!
    
    var stateItem3On: Bool = false
    
    var currentTime = 0
    var currentQuestion = -1
    
    var myCorrectNumber: Int = 0 {
        didSet {
            setCorrectAnswer(lbAnswer: lbMeCorrectAnswers, correctNumber: myCorrectNumber)
        }
    }
    var rivalCorrectNumber: Int = 0 {
        didSet {
            setCorrectAnswer(lbAnswer: lbRivalCorrectAnswer, correctNumber: rivalCorrectNumber)
        }
    }
    
    var finishCallback: ((_ result: Int, _ score: Int) -> Void)?
    
    class func navigate(viewController: UIViewController, room: Room, questions: [QuestionModel], cb: @escaping (_ result: Int, _ score: Int) -> Void) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let battleViewController = storyBoard.instantiateViewController(withIdentifier: "BattleViewController") as! BattleViewController
        battleViewController.questions = questions
        battleViewController.room = room
        battleViewController.finishCallback = cb
        viewController.present(battleViewController, animated: true, completion: nil)
    }
    
    func waitingBeforeStart() {
        if currentTime > 0 {
            currentTime -= 1
            lbTimeCount.text = "\(currentTime)"
        } else {
            lbTimeCount.text = "Start..."
            timer.invalidate()
            SocketUtil.emitBattleData(event: EmitEventConstant.getBattleReadyEvent(), jsonData: (room?.toJSONString())!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initData()
        initListener()
        currentTime = TIME_WAIT
        lbTimeCount.text = "\(TIME_WAIT)"
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(BattleViewController.waitingBeforeStart), userInfo: nil, repeats: true)
    }
    
    func initListener() {
        SocketUtil.battleStartProtocol = self
        SocketUtil.nextQuestionProtocol = self
        SocketUtil.rivalAnswerProtocol = self
        SocketUtil.resultQuestionProtocol = self
        SocketUtil.freezeProtocol = self
        
        containerA.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(answerAClicked(tapGestureRecognizer:))))
        containerB.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(answerBClicked(tapGestureRecognizer:))))
        containterC.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(answerCClicked(tapGestureRecognizer:))))
        containerD.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(answerDClicked(tapGestureRecognizer:))))
    }
    
    
    
    func initView() {
        borderCircleView(view: ivMeAvatar)
        borderCircleView(view: ivMeIndicator)
        
        borderCircleView(view: ivRivalAvatar)
        borderCircleView(view: ivRivalIndicator)
        
        borderView(view: containerA, radius: 5, borderWidth: 1, borderColor: UIColor.lightGray.cgColor, clipsToBounds: true)
        borderView(view: containerB, radius: 5, borderWidth: 1, borderColor: UIColor.lightGray.cgColor, clipsToBounds: true)
        borderView(view: containterC, radius: 5, borderWidth: 1, borderColor: UIColor.lightGray.cgColor, clipsToBounds: true)
        borderView(view: containerD, radius: 5, borderWidth: 1, borderColor: UIColor.lightGray.cgColor, clipsToBounds: true)
        
        let lbH = lbItem1.frame.height / 2;
        borderView(view: lbItem1, radius: lbH, borderWidth: 0, borderColor: UIColor.white.cgColor, clipsToBounds: true)
        borderView(view: lbItem2, radius: lbH, borderWidth: 0, borderColor: UIColor.white.cgColor, clipsToBounds: true)
        borderView(view: lbItem3, radius: lbH, borderWidth: 0, borderColor: UIColor.white.cgColor, clipsToBounds: true)
        borderView(view: lbItem4, radius: lbH, borderWidth: 0, borderColor: UIColor.white.cgColor, clipsToBounds: true)
        
        borderView(view: viewContainerItem, radius: viewContainerItem.frame.height / 2, borderWidth: 1, borderColor: UIColor.darkGray.cgColor, clipsToBounds: false)
        
        
        freezeImage = UIImageView(frame: CGRect(x: window.frame.origin.x, y: window.frame.origin.y, width: window.frame.width, height: window.frame.height))
        freezeImage?.image = #imageLiteral(resourceName: "freeze-wallpapers")
        freezeImage?.contentMode = UIViewContentMode.scaleAspectFit
        reloadItemLabel()
        
    }
    
    func reloadItemLabel() {
        if let items = me?.items, items.count > 0 {
            for item in items {
                if item.id == 1 {
                    lbItem1.text = item.quantity! <= 9 ? "\(item.quantity!)" : "9+"
                } else if item.id == 2 {
                    lbItem2.text = item.quantity! <= 9 ? "\(item.quantity!)" : "9+"
                } else if item.id == 3 {
                    lbItem3.text = item.quantity! <= 9 ? "\(item.quantity!)" : "9+"
                } else {
                    lbItem4.text = item.quantity! <= 9 ? "\(item.quantity!)" : "9+"
                }
            }
        }
    }
    
    func initData() {
        feedDataUser(ivAvatar: ivMeAvatar, ivIndicator: ivMeIndicator, lbName: lbMyName, user: me!)
        if me?._id == room?.userHost?._id {
            feedDataUser(ivAvatar: ivRivalAvatar, ivIndicator: ivRivalIndicator, lbName: lbRivalName, user: (room?.userMember)!)
        } else {
            feedDataUser(ivAvatar: ivRivalAvatar, ivIndicator: ivRivalIndicator, lbName: lbRivalName, user: (room?.userHost)!)
        }
        setCorrectAnswer(lbAnswer: lbMeCorrectAnswers, correctNumber: myCorrectNumber)
        setCorrectAnswer(lbAnswer: lbRivalCorrectAnswer, correctNumber: rivalCorrectNumber)
    }
    
    func setCorrectAnswer(lbAnswer: UILabel, correctNumber: Int) {
        var textColor: UIColor?
        switch correctNumber {
        case 0:
            textColor = UIColor.red
            break;
        case 1:
            textColor = UIColor.init(hexString: "#ff4000")
            break;
        case 2:
            textColor = UIColor.init(hexString: "#ff8d00")
            break;
        case 3:
            textColor = UIColor.init(hexString: "#ff9a00")
            break;
        case 4:
            textColor = UIColor.init(hexString: "#ffce00")
            break;
        case 5:
            textColor = UIColor.init(hexString: "#fff400")
            break;
        case 6:
            textColor = UIColor.init(hexString: "#00ff2b")
            break;
        case 7...11:
            textColor = UIColor.init(hexString: "#2fff00")
            break;
            
        default:
            //do nothing
            break
        }
        
        lbAnswer.textColor = textColor
        lbAnswer.text = "\(correctNumber) correct answers"
    }
    
    func feedDataUser(ivAvatar: UIImageView, ivIndicator: UIImageView, lbName: UILabel, user: User) {
        lbName.text = user.name ?? user.username
        
        if let score = user.score, score > 1 {
            if score < 1000 {
                ivIndicator.image = #imageLiteral(resourceName: "indicator1")
            } else if score < 2000 {
                ivIndicator.image = #imageLiteral(resourceName: "indicator2")
            } else if score < 3000 {
                ivIndicator.image = #imageLiteral(resourceName: "indicator3")
            } else if score < 4000 {
                ivIndicator.image = #imageLiteral(resourceName: "indicator4")
            } else {
                ivIndicator.image = #imageLiteral(resourceName: "indicator5")
            }
        } else {
            ivIndicator.image = #imageLiteral(resourceName: "indicator1")
        }
        
        if let avatarUrl = user.avatar, !avatarUrl.isEmpty {
            ivAvatar.kf.setImage(with: URL(string: avatarUrl))
        }

    }
    
    func borderView(view: UIView, radius: CGFloat, borderWidth: CGFloat, borderColor: CGColor?, clipsToBounds: Bool) {
        view.layer.cornerRadius = radius
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderColor
        view.clipsToBounds = clipsToBounds
    }
    
    func borderCircleView(view: UIImageView) {
        view.layer.cornerRadius = view.frame.height / 2
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func item2Clicked(_ sender: Any) {
        if isItemAvailable(idItem: 2) { // 50 | 50
            var numbers: [Int] = []
            let question = questions[currentQuestion]
            for i in 1...4 {
                if i != question.trueCase {
                    numbers.append(i)
                }
            }
            let case1 = Utils.random(max: numbers.count)
            setButtonColorAnswer(number: numbers[case1], correct: false)
            numbers.remove(at: case1)
            let case2 = Utils.random(max: numbers.count)
            setButtonColorAnswer(number: numbers[case2], correct: false)
            numbers.remove(at: case2)
            
        }
    }
    
    @IBAction func item3Clicked(_ sender: Any) {
        if isItemAvailable(idItem: 3) {
            stateItem3On = true
        }
    }

    @IBAction func item1Clicked(_ sender: Any) {
        if isItemAvailable(idItem: 1) {
            let reqModel = AnswerResultModel()
            reqModel.id_rival = me?._id == room?.userHost?._id ? room?.userMember?._id : room?.userHost?._id
            SocketUtil.emitBattleData(event: EmitEventConstant.getFreezeEvent(), jsonData: reqModel.toJSONString()!)
        }
    }
    
    var idQuestionWithItem4: [Int] = []
    
    @IBAction func item4Clicked(_ sender: Any) {
        if isItemAvailable(idItem: 4) {
            idQuestionWithItem4.append(questions[currentQuestion]._id!)
        }
    }
    
    func isItemAvailable(idItem: Int) -> Bool {
        if (me?.items![idItem - 1].quantity)! > 0 {
            me?.items![idItem - 1].quantity = (me?.items![idItem - 1].quantity)! - 1
            UserRealm.updateScore(items: (me?.items)!)
            reloadItemLabel()
            return true
        }
        
        return false
    }
    
    func answerAClicked(tapGestureRecognizer: UITapGestureRecognizer) {
        emitAnswer(chooseCase: 1)
        containerA.backgroundColor = UIColor.lightGray
    }
    
    func answerBClicked(tapGestureRecognizer: UITapGestureRecognizer) {
        emitAnswer(chooseCase: 2)
        containerB.backgroundColor = UIColor.lightGray
    }
    
    func answerCClicked(tapGestureRecognizer: UITapGestureRecognizer) {
        emitAnswer(chooseCase: 3)
        containterC.backgroundColor = UIColor.lightGray
    }
    
    func answerDClicked(tapGestureRecognizer: UITapGestureRecognizer) {
        emitAnswer(chooseCase: 4)
        containerD.backgroundColor = UIColor.lightGray
    }
    
    func emitAnswer(chooseCase: Int) {
        if stateItem3On {
            stateItem3On = false
            if !checkAnswer(chooseCase: chooseCase) {
                setButtonColorAnswer(number: chooseCase, correct: false)
                return
            }
        }
        
        timer.invalidate()
        setEnableAnswerButton(enable: false)
        let answerModel: AnswerResultModel = AnswerResultModel()
        answerModel.room = room
        answerModel.id_question = questions[currentQuestion]._id
        answerModel.id_sender = me?._id
        answerModel.id_rival = me?._id == room?.userHost?._id ? room?.userMember?._id : room?.userHost?._id
        answerModel.answer = chooseCase
        answerModel.time = Float.init(currentTime)
        answerModel.correct = checkAnswer(chooseCase: chooseCase)
        SocketUtil.emitBattleData(event: EmitEventConstant.getAnswerEvent(), jsonData: answerModel.toJSONString()!)
    }
    
    func checkAnswer(chooseCase: Int) -> Bool {
        let question = questions[currentQuestion]
        return question.trueCase == chooseCase
    }
    
}

extension BattleViewController: SocketHandleData {
    func onReceive<BaseMappable>(event: String, data: BaseMappable) {
        switch event {
        case EmitEventConstant.getFreezeEvent():
            freezeImage?.isHidden = false
            window.addSubview(freezeImage!);
            Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(BattleViewController.hideFreeze), userInfo: nil, repeats: false)
            break
        case EmitEventConstant.getBattleStartEvent():
            nextQuestion()
            break
        case EmitEventConstant.getRivalAnswerEvent():
            let rivalAnswer = (data as! AnswerResponse).answer
            
            if (rivalAnswer?.correct)! && containerA.isUserInteractionEnabled {
                setEnableAnswerButton(enable: false)
                emitAnswer(chooseCase: 0)
            }
            
            break
        case EmitEventConstant.getResultQuestionEvent():
            let result = (data as! AnswerResponse).answer
            if result?.result == WIN {
                myCorrectAnswers.append(result!)
                myCorrectNumber += 1
                setButtonColorAnswer(number: (result?.answer)!, correct: true)
            } else if result?.result == LOSE {
                rivalCorrectNumber += 1
                if (result?.correct)! {
                    setButtonColorAnswer(number: (result?.answer)!, correct: true)
                } else {
                    setButtonColorAnswer(number: (result?.answer)!, correct: false)
                }
            } else if result?.result == DRAW_CORRECT {
                myCorrectAnswers.append(result!)
                myCorrectNumber += 1
                rivalCorrectNumber += 1
                setButtonColorAnswer(number: (result?.answer)!, correct: true)
            } else { //DRAW_INCORRECT
                setButtonColorAnswer(number: (result?.answer)!, correct: false)
            }
            Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(BattleViewController.nextQuestion), userInfo: nil, repeats: false)
            break
        case EmitEventConstant.getNextQuestionEvent():
            nextQuestion()
            break
            
        default:
            print(event)
        }
    }
    
    func hideFreeze() {
        window.willRemoveSubview(freezeImage!)
        freezeImage?.isHidden = true
    }
    
    func setButtonColorAnswer(number: Int, correct: Bool) {
        switch number {
        case 1:
            containerA.backgroundColor = correct ? CORRECT_COLOR : INCORRECT_COLOR
            break
        case 2:
            containerB.backgroundColor = correct ? CORRECT_COLOR : INCORRECT_COLOR
            break
        case 3:
            containterC.backgroundColor = correct ? CORRECT_COLOR : INCORRECT_COLOR
            break
        case 4:
            containerD.backgroundColor = correct ? CORRECT_COLOR : INCORRECT_COLOR
            break
        default:
            let qst = questions[currentQuestion]
            setButtonColorAnswer(number: qst.trueCase!, correct: true)
        }
    }
    
    func setTimeCountColor() {
        lbTimeCount.text = "\(currentTime)"
    }
    
    func countDown() {
        if currentTime > 0 {
            currentTime -= 1
            setTimeCountColor()
        } else {
            timer.invalidate()
            print("Time out")
            emitAnswer(chooseCase: 0)
        }
    }
    
    func nextQuestion() {
        setEnableAnswerButton(enable: true)
        clearColorAnswer()
        currentQuestion += 1
        if currentQuestion < 10 {
            lbCurrentQuestion.text = "Question \(currentQuestion + 1)"
            let question = questions[currentQuestion]
            lbQuestion.text = question.question
            lbAnswerA.text = question.caseA
            lbAnswerB.text = question.caseB
            lbAnswerC.text = question.caseC
            lbAnswerD.text = question.caseD
            
            currentTime = TIME_ANSWER
            setTimeCountColor()
            
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(BattleViewController.countDown), userInfo: nil, repeats: true)
        } else {
            caculateResult()
        }
    }
    
    func caculateResult() {
        var result: Int?
        var score: Int = 0
        
        if myCorrectNumber > rivalCorrectNumber {
            result = WIN
        } else if myCorrectNumber < rivalCorrectNumber {
            result = LOSE
        } else {
            result = DRAW_CORRECT
        }
        
        for answer in myCorrectAnswers {
            let question = getQuestionById(id: answer.id_question!)
            if question != nil {
                var tempScore = Int.init((question?.level)!)! * 100
                tempScore = Int(Float.init(tempScore) * ((answer.time! * 1) / Float.init(TIME_ANSWER)))
                for idQstLucky in idQuestionWithItem4 {
                    if idQstLucky == question?._id {
                        tempScore = tempScore * 2
                        break
                    }
                }
                score += tempScore
            }
        }
        dismiss(animated: true, completion: nil)
        finishCallback!(result!, score)
    }
    
    func getQuestionById(id: Int) -> QuestionModel? {
        for question in questions {
            if question._id == id {
                return question
            }
        }
        return nil
    }
    
    func setEnableAnswerButton(enable: Bool) {
        containerA.isUserInteractionEnabled = enable
        containerB.isUserInteractionEnabled = enable
        containterC.isUserInteractionEnabled = enable
        containerD.isUserInteractionEnabled = enable
    }
    
    func clearColorAnswer() {
        containerA.backgroundColor = UIColor.clear
        containerB.backgroundColor = UIColor.clear
        containterC.backgroundColor = UIColor.clear
        containerD.backgroundColor = UIColor.clear
    }
}
