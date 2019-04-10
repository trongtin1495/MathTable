//
//  MakeTableViewController.swift
//  Math_Tables
//
//  Created by Lê Trần Trọng Tín on 2/22/19.
//  Copyright © 2019 Lê Trần Trọng Tín. All rights reserved.
//

import UIKit
import AVFoundation
import SCLAlertView
import ChameleonFramework

class MakeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lbQuestion: UILabel!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    fileprivate var panGestureForCV: UIPanGestureRecognizer!
    fileprivate var panGestureForTBV: UIPanGestureRecognizer!
    
    var number: Int!
    var randomNum = Array(1...20)
    var multiplier = Array(1...10)
    var resultList = [Int]()
    var resultArray = [Int]()
    var currentLine = 0
    var numberQues = 1
    var bombSoundEffect: AVAudioPlayer!
    
    var snapShotViewCV: UIView?
    var selectingResultCV: String!
    var selectingIndexPathCV: IndexPath!
    var selectingCellCV: UIView?
    var saveResultAndIndexPath = [String: IndexPath]()
    
    var snapShotViewTBV: UIView?
    var selectingIndexPathTBV: IndexPath!
    var selectingCellTBV: LearnTableViewCell?
    var selectingResultTBV: String!
    var lbResultSize: CGSize!
    
    var highLightCell: LearnTableViewCell? {
        willSet {
            highLightCell?.isPressed = false
            newValue?.isPressed = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //table view
        tableView.delegate = self
        tableView.dataSource = self
        let nib1 = UINib(nibName: kNibName.LearnTableViewCell, bundle: nil)
        tableView.register(nib1, forCellReuseIdentifier: kCellId.multiCell)
        tableView.separatorStyle = .none
        panGestureForTBV = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGestureForTBV(gesture:)))
        tableView.addGestureRecognizer(panGestureForTBV)
        
        
        //collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.clipsToBounds = false
        let nib2 = UINib(nibName: kNibName.ResultCollectionViewCell, bundle: nil)
        collectionView.register(nib2, forCellWithReuseIdentifier: kCellId.resultCell)
        panGestureForCV = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGestureForCV(gesture:)))
        collectionView.addGestureRecognizer(panGestureForCV)
        
        getData()
    }
    
    @objc func handlePanGestureForTBV(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            onTouchBeganTBV(gesture: gesture)
        case .changed:
            onTouchChangedTBV(gesture: gesture)
        case .ended:
            onTouchEndedTBV(gesture: gesture)
        default:
            break
        }
    }
    
    func onTouchBeganTBV(gesture: UIPanGestureRecognizer) {
        let panLocationInTBV = gesture.location(in: tableView)
        guard
            let indexPath = tableView.indexPathForRow(at: panLocationInTBV),
            let cell = tableView.cellForRow(at: indexPath) as? LearnTableViewCell,
            cell.isAnswered
            else { return }
        
        let labelSnapShot = cell.lbResult.makeSnapshotLabel()
        self.snapShotViewTBV = labelSnapShot
        self.selectingIndexPathTBV = indexPath
        self.selectingCellTBV = cell
        self.selectingResultTBV = cell.lbResult.text
        view.addSubview(labelSnapShot)
        
        cell.didGetDragged()
        
        let touchPoint = CGPoint(x: panLocationInTBV.x, y: panLocationInTBV.y)
        labelSnapShot.frame.origin = touchPoint
    }
    
    func onTouchChangedTBV(gesture: UIPanGestureRecognizer) {
        let panLocationInTBV = gesture.location(in: tableView)
        guard let snapShotLabel = snapShotViewTBV else { return }
        
        let locationInSuperView = tableView.convert(panLocationInTBV, to: view)
        snapShotLabel.center = locationInSuperView
        
        if let indexPath = tableView.indexPathForRow(at: panLocationInTBV) {
            highLightCell = tableView.cellForRow(at: indexPath) as? LearnTableViewCell
        }
    }
    
    func onTouchEndedTBV(gesture: UIPanGestureRecognizer) {
        
        let panLocationInTBV = gesture.location(in: tableView)
        let panLocationInCV = gesture.location(in: collectionView)
        
        guard
            let selectingIndexPath = self.selectingIndexPathTBV,
            let snapShotView = self.snapShotViewTBV
            else { return }
        
        if collectionView.bounds.contains(panLocationInCV) && saveResultAndIndexPath.count != 10 {
            self.highLightCell = nil
            
            if
                let indexPathCV = collectionView.indexPathForItem(at: panLocationInCV),
                let cellCV = collectionView.cellForItem(at: indexPathCV) as? ResultCollectionViewCell,
                let selectingResultTBV = self.selectingResultTBV,
                let resultNeedSwap = cellCV.lbResult.text {
                
                for (key, value) in self.saveResultAndIndexPath {
                    if value == indexPathCV {
                        self.selectingCellTBV?.cancelSwap()
                        snapShotView.removeFromSuperview()
                        self.snapShotViewTBV = nil
                        return
                    }
                    
                    if key == selectingResultTBV {
                        self.saveResultAndIndexPath.removeValue(forKey: key)
                        let cellHidden = collectionView.cellForItem(at: value) as? ResultCollectionViewCell
                        cellHidden?.isHidden = false
                    }
                }
                
                self.saveResultAndIndexPath.updateValue(indexPathCV, forKey: resultNeedSwap)
                self.selectingCellTBV?.isAnswered = true
                self.selectingCellTBV?.lbResult.text = cellCV.lbResult.text
                cellCV.isHidden = true
                
                snapShotView.removeFromSuperview()
                self.snapShotViewTBV = nil
            }
            
            return
        }
        
        guard
            let currentIndexPath = tableView.indexPathForRow(at: panLocationInTBV),
            let cell = tableView.cellForRow(at: currentIndexPath) as? LearnTableViewCell
            else {
                snapShotView.removeFromSuperview()
                self.snapShotViewTBV = nil
                self.highLightCell = nil
                self.selectingCellTBV?.cancelSwap()
                return
            }
        
        tableView.isUserInteractionEnabled = false
        collectionView.isUserInteractionEnabled = false
        let cellFrameInView = tableView.convert(cell.frame, to: view)
        
        UIView.animate(withDuration: 0.3, animations: {
            let x = cellFrameInView.maxX - cell.lbResult.frame.width - 5
            let y = cellFrameInView.midY - cell.lbResult.bounds.midY
            snapShotView.frame.origin = CGPoint(x: x, y: y)
            snapShotView.frame.size = cell.lbResult.frame.size
        }) { (_) in
            if currentIndexPath != selectingIndexPath {
                self.selectingCellTBV?.swapAnswer(cell: cell)
            } else {
                self.selectingCellTBV?.cancelSwap()
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                snapShotView.alpha = 0
            }, completion: { (_) in
                snapShotView.removeFromSuperview()
                self.snapShotViewTBV = nil
                self.selectingCellTBV = nil
                self.selectingIndexPathTBV = nil
                self.highLightCell = nil
                self.tableView.isUserInteractionEnabled = true
                self.collectionView.isUserInteractionEnabled = true
            })
        }
    }
    
    
    @objc func handlePanGestureForCV(gesture: UIPanGestureRecognizer) {
        switch(gesture.state) {
        case .began:
            onTouchBeganCV(gesture: gesture)
        case .changed:
            onTouchChangedCV(gesture: gesture)
        case .ended:
            onTouchEndedCV(gesture: gesture)
        default:
            break
        }
    }
    
    func onTouchBeganCV(gesture: UIPanGestureRecognizer) {
        let panLocationInCV = gesture.location(in: collectionView)
        
        guard
            let indexPathCV = collectionView.indexPathForItem(at: panLocationInCV),
            let cell = collectionView.cellForItem(at: indexPathCV) as? ResultCollectionViewCell,
            let attr = collectionView.layoutAttributesForItem(at: indexPathCV),
            !cell.isHidden
            else { return }
        
        let cellSnapshot = cell.lbResult.makeSnapshotLabel()
        cellSnapshot.frame.origin = collectionView.convert(attr.frame.origin, to: view)
        
        snapShotViewCV = cellSnapshot
        view.addSubview(cellSnapshot)
        
        selectingResultCV = cell.lbResult.text
        selectingIndexPathCV = indexPathCV
        saveResultAndIndexPath.updateValue(selectingIndexPathCV, forKey: selectingResultCV)
        self.selectingCellCV = cell
        cell.isHidden = true
    }
    
    func onTouchChangedCV(gesture: UIPanGestureRecognizer) {
        let panLocationInCV = gesture.location(in: collectionView)
        let panLocationInTBV = gesture.location(in: tableView)
        
        guard let snapShotView = snapShotViewCV else { return }
        
        let locationInSuperView = collectionView.convert(panLocationInCV, to: view)
        snapShotView.center = locationInSuperView
        
        if let indexPath = tableView.indexPathForRow(at: panLocationInTBV) {
            highLightCell = tableView.cellForRow(at: indexPath) as? LearnTableViewCell
        }
    }
    
    func onTouchEndedCV(gesture: UIPanGestureRecognizer) {
        let panLocationInTBV = gesture.location(in: tableView)
        
        guard
            let selectingResult = self.selectingResultCV,
            let snapShotView = self.snapShotViewCV,
            let selectingCell = self.selectingCellCV
            else { return }
        
        guard
            let indexPath = tableView.indexPathForRow(at: panLocationInTBV),
            let cell = tableView.cellForRow(at: indexPath) as? LearnTableViewCell
            else {
                snapShotView.removeFromSuperview()
                self.snapShotViewCV = nil
                selectingCell.isHidden = false
                highLightCell = nil
                return
            }
        
        for (key, value) in saveResultAndIndexPath {
            if cell.lbResult.text == key {
                saveResultAndIndexPath.removeValue(forKey: key)
                let cellHidden = collectionView.cellForItem(at: value) as? ResultCollectionViewCell
                cellHidden?.isHidden = false
            }
        }
        
        if saveResultAndIndexPath.count == resultList.count {
            btnSubmit.isHidden = false
        }
        
        let cellFrameInView = tableView.convert(cell.frame, to: view)
        collectionView.isUserInteractionEnabled = false
        tableView.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.3, animations: {
            snapShotView.frame.size = cell.lbResult.frame.size

            let x = cellFrameInView.maxX - snapShotView.frame.width - 5
            let y = cellFrameInView.midY - snapShotView.bounds.midY
            snapShotView.frame.origin = CGPoint(x: x, y: y)
        }) { (_) in
            UIView.animate(withDuration: 0.2, animations: {
                cell.updateAnswer(answer: selectingResult)
                snapShotView.alpha = 0
            }, completion: { (_) in
                snapShotView.removeFromSuperview()
                self.snapShotViewCV = nil
                self.selectingResultCV = nil
                self.highLightCell = nil
                self.collectionView.isUserInteractionEnabled = true
                self.tableView.isUserInteractionEnabled = true
            })
        }
    }

    func getData() {
        btnNext.isHidden = true
        btnSubmit.isHidden = true
        btnSubmit.clipsToBounds = true
        btnSubmit.layer.borderWidth = 3
        btnSubmit.layer.cornerRadius = 15
        btnSubmit.layer.borderColor = #colorLiteral(red: 0.9803921569, green: 0.7529411765, blue: 0.2980392157, alpha: 1)
        
        saveResultAndIndexPath.removeAll()
        resultList.removeAll()
        multiplier.shuffle()
        currentLine = 0
        
        let randomIndex = Int.random(in: 0 ..< randomNum.count)
        number = randomNum[randomIndex]
        randomNum.remove(at: randomIndex)
        
        for i in multiplier {
            let rs = number * i
            resultList.append(rs)
        }
        
        resultArray = resultList.shuffled()
        lbQuestion.text = "Q.\(numberQues)"
        
        let tbcells = tableView.visibleCells as! [LearnTableViewCell]
        for cell in tbcells {
            cell.setupView()
            cell.isAnswered = false
        }
        tableView.isUserInteractionEnabled = true
        tableView.reloadData()
        
        let cvcells = collectionView.visibleCells as! [ResultCollectionViewCell]
        for cell in cvcells {
            if cell.isHidden {
                cell.isHidden = false
            }
        }
        collectionView.reloadData()
    }
    
    func checkEndOfQuest() {
        if numberQues == 20 {
        
            var alert = SCLAlertView()
            
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            alert = SCLAlertView(appearance: appearance)
            alert.addButton("Ok", target: self, selector: #selector(handleOk))
            alert.showSuccess("Congratulation!", subTitle: "You have passed this test")
        }
    }
    
    @objc func handleOk() {
        let view = HomeViewController(nibName: kNibName.HomeViewController, bundle: nil)
        self.present(view, animated: true, completion: nil)
    }
    
    func playSound(soundName: String, type: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: type) else { return }
        bombSoundEffect = try! AVAudioPlayer(contentsOf: url)
        bombSoundEffect.play()
    }
    
    @IBAction func btnNext(_ sender: Any) {
        numberQues += 1
        getData()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        let cells = tableView.visibleCells as! [LearnTableViewCell]
        var allCorrect = true
        for cell in cells {
            guard let rs = Int(cell.lbResult.text!)
                else { return }
            if resultList[currentLine] == rs {
                cell.trueAnswer()
                currentLine += 1
            } else {
                cell.wrongAnswer()
                currentLine += 1
                allCorrect = false
            }
        }
        currentLine = 0
        
        if allCorrect {
            btnNext.isHidden = false
            btnSubmit.isHidden = true
            tableView.isUserInteractionEnabled = false
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellId.multiCell) as! LearnTableViewCell
        let i = multiplier[indexPath.row]
        
        cell.lbMultiplication.text = "\(number!)   x   \(i)"
        cell.lbResult.text = "??"
        cell.selectionStyle = .none
        self.lbResultSize = cell.lbResult.frame.size
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / CGFloat(multiplier.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellId.resultCell, for: indexPath) as! ResultCollectionViewCell
        cell.lbResult.text = String(resultArray[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.width / 6, height: (collectionView.frame.height / 2) - 5)
        return size
    }
}


