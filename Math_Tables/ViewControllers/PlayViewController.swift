//
//  PlayViewController.swift
//  Math_Tables
//
//  Created by Lê Trần Trọng Tín on 2/26/19.
//  Copyright © 2019 Lê Trần Trọng Tín. All rights reserved.
//

import UIKit
import AVFoundation
import SCLAlertView

class PlayViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var lbQuestion: UILabel!
    @IBOutlet weak var lbScore: UILabel!
    @IBOutlet weak var lbWrong: UILabel!
    @IBOutlet weak var lbTrueResult: UILabel!
    @IBOutlet weak var lbMessage: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lbMultiplier: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var questionView: UIView!
    fileprivate var panGestureForCV: UIPanGestureRecognizer!
    
    var bombSoundEffect: AVAudioPlayer!
    var number: Int!
    var randomNum =  Array(1...20)
    var multiplierArray = Array(1...10)
    var multi: Int!
    var resultList = [Int]()
    var rs: Int!
    var rightNumber = 0
    var wrongNumber = 0
    var numQues = 1
    let spacing = 15
    
    var snapShotView: UIView?
    var selectingResult: String!
    var selectingCell: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.clipsToBounds = false
        let nib = UINib(nibName: kNibName.ResultCollectionViewCell, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: kCellId.resultCell)
        
        panGestureForCV = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        collectionView.addGestureRecognizer(panGestureForCV)
        collectionView.dragInteractionEnabled = true
        
        getData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            onTouchBegan(gesture: gesture)
        case .changed:
            onTouchChanged(gesture: gesture)
        case .ended:
            onTouchEnded(gesture: gesture)
        default:
            break
        }
    }
    
    func onTouchBegan(gesture: UIPanGestureRecognizer) {
        let panLocation = gesture.location(in: collectionView)
        guard
            let indexPath = collectionView.indexPathForItem(at: panLocation),
            let attr = collectionView.layoutAttributesForItem(at: indexPath),
            let cell = collectionView.cellForItem(at: indexPath) as? ResultCollectionViewCell
            else { return }
        
        let cellSnapShot = cell.makeSnapshot()
        cellSnapShot.frame = collectionView.convert(attr.frame, to: view)
        self.snapShotView = cellSnapShot
        view.addSubview(cellSnapShot)
        
        
        self.selectingResult = cell.lbResult.text
        self.selectingCell = cell
        cell.isHidden = true
    }
    
    func onTouchChanged(gesture: UIPanGestureRecognizer) {
        let panLocation = gesture.location(in: collectionView)
        let panLocationInQuestionView = gesture.location(in: questionView)
        guard
            let snapShotView = snapShotView
            else { return }
        
        let locationInSuperView = collectionView.convert(panLocation, to: view)
        let isInView = questionView.bounds.contains(panLocationInQuestionView)
        snapShotView.center = locationInSuperView
        if isInView {
            questionView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
            questionView.layer.borderWidth = 2
            questionView.layer.borderColor = UIColor.lightGray.cgColor
        } else {
            questionView.backgroundColor = .clear
            questionView.layer.borderWidth = 0
        }
    }
    
    func onTouchEnded(gesture: UIPanGestureRecognizer) {
        let panLocationInQuestionView = gesture.location(in: questionView)
        let isInView = questionView.bounds.contains(panLocationInQuestionView)
        
        guard let snapShotView = self.snapShotView else { return }
        
        if isInView {
            lbTrueResult.text = self.selectingResult
            checkAnswer()
        } else {
            selectingCell?.isHidden = false
        }
        snapShotView.removeFromSuperview()
        self.snapShotView = nil
        self.selectingResult = nil
    }
    
    func getData() {
        questionView.backgroundColor = .clear
        questionView.layer.borderWidth = 0
        
        questionView.layer.cornerRadius = 15
        lbMultiplier.layer.cornerRadius = 15
        lbTrueResult.layer.cornerRadius = 15
        
        lbMessage.layer.cornerRadius = 10
        lbMessage.isHidden = true
        
        btnNext.isHidden = true
        lbTrueResult.text = "???"
        lbQuestion.text = "Q.\(numQues) Guess value"
        lbScore.text = "Score: \(rightNumber)"
        lbWrong.text = "Wrong: \(wrongNumber)"
        
        resultList.removeAll()
        
        let randomIndex = Int.random(in: 0 ..< randomNum.count)
        number = randomNum[randomIndex]
        randomNum.remove(at: randomIndex)
        
        let multiIndex = Int.random(in: 0 ..< multiplierArray.count)
        multi = multiplierArray[multiIndex]
        
        lbMultiplier.text = "\(number!)  x  \(multi!)"
        
        rs = number * multi
        
        resultList = [rs, rs + 1, rs + 2, rs + 3, rs + 4, rs + 5 ]
        
        resultList.shuffle()
        
        let cells = collectionView.visibleCells as! [ResultCollectionViewCell]
        for cell in cells {
            if cell.isHidden {
                cell.isHidden = false
            }
        }
        collectionView.reloadData()
        collectionView.isUserInteractionEnabled = true
    }
    
    
    
    @IBAction func btnNext(_ sender: Any) {
        numQues += 1
        getData()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func checkAnswer() {
        if selectingResult == String(rs) {
            rightNumber += 1
            
            
            lbMessage.text = "Correct"
            lbMessage.textColor = #colorLiteral(red: 0, green: 0.9666637778, blue: 0, alpha: 1)
            
            lbScore.text = "Score: \(rightNumber)"
            
            let utterance = AVSpeechUtterance(string: lbTrueResult.text!)
            utterance.voice = AVSpeechSynthesisVoice(language: kLanguage.speakLanguage)
            
            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speak(utterance)
        } else {
            playSound(soundName: kSound.soundName, type: kSound.type)
            
            wrongNumber += 1
        
            lbMessage.text = "Wrong"
            lbMessage.textColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
            
            lbWrong.text = "Wrong: \(wrongNumber)"
        }
        collectionView.isUserInteractionEnabled = false
        btnNext.isHidden = false
        lbMessage.isHidden = false
        checkEndOfQues()
    }
    
    func checkEndOfQues() {
        if numQues == 10 {
            customAlert(score: self.rightNumber)
            saveScoreData(score: self.rightNumber)
        }
    }
    
    func playSound(soundName: String, type: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: type) else { return }
        bombSoundEffect = try! AVAudioPlayer(contentsOf: url)
        bombSoundEffect.play()
    }
    
    func customAlert(score: Int) {
        var status: String!
        let imgMedal: UIImage!
        
        switch score {
        case 9...10:
            status = "Great"
            imgMedal = kImageName.imgGold
        case 6...8:
            status = "Good"
            imgMedal = kImageName.imgSilver
        case 3...5:
            status = "Cool"
            imgMedal = kImageName.imgBronze
        default:
            status = "Fail"
            imgMedal = kImageName.imgFail
        }

        var alertView = SCLAlertView()
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false,
            showCircularIcon: true
        )
        alertView = SCLAlertView(appearance: appearance)
        
        let subInfo = "Your completed 10 question." + "\nCorrect answer \(score)"
        
        alertView.addButton("Continue", target:self, selector:#selector(handleContinue))
        alertView.addButton("Quit", target:self, selector:#selector(handleQuit))
        alertView.showWarning(status, subTitle: subInfo, circleIconImage: imgMedal)
    }
    
    @objc func handleContinue() {
        numQues = 1
        wrongNumber = 0
        rightNumber = 0
        getData()
    }
    
    @objc func handleQuit() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func saveScoreData(score: Int) {
        let scoreSheet = UserDefaults.standard
        switch score {
        case 9...10:
            var goldList = (scoreSheet.array(forKey: kUserDefaultKey.goldCount) as? [Int]) ?? [Int]()
            goldList.append(score)
            scoreSheet.set(goldList, forKey: kUserDefaultKey.goldCount)
            break
            
        case 6...8:
            var silverList = (scoreSheet.array(forKey: kUserDefaultKey.silverCount) as? [Int]) ?? [Int]()
            silverList.append(score)
            scoreSheet.set(silverList, forKey: kUserDefaultKey.silverCount)
            break
        case 3...5:
            var bronzeList = (scoreSheet.array(forKey: kUserDefaultKey.bronzeCount) as? [Int]) ?? [Int]()
            bronzeList.append(score)
            scoreSheet.set(bronzeList, forKey: kUserDefaultKey.bronzeCount)
            break
        default:
            return
        }
        
        var array = scoreSheet.array(forKey: kUserDefaultKey.scoreData) as? [([String : Int])] ?? [[String : Int]]()
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let playedDate = formatter.string(from: date)
        
        
        let saveScoreData = [playedDate : score]
        array.append(saveScoreData)
        
        scoreSheet.set(array, forKey: kUserDefaultKey.scoreData)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellId.resultCell, for: indexPath) as! ResultCollectionViewCell
        let result = String(resultList[indexPath.item])
        cell.setupPlayView(result: result)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: lbTrueResult.frame.width, height: lbTrueResult.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(spacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(spacing)
    }
}
