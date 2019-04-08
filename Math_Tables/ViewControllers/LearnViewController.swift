//
//  LearnViewController.swift
//  Math_Tables
//
//  Created by Lê Trần Trọng Tín on 2/22/19.
//  Copyright © 2019 Lê Trần Trọng Tín. All rights reserved.
//

import UIKit
import AVFoundation

class LearnViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AVSpeechSynthesizerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbNumber: UILabel!
    @IBOutlet weak var btnSpeak: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var btnHome: UIButton!
    
    var number = 1
    var cellIndex = 0
    var utterance: AVSpeechUtterance!
    let synthesizer = AVSpeechSynthesizer()
    var speakIndex = 0
    var isSpeakAll = false
    var backToHomeCallback: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        synthesizer.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        let nib = UINib(nibName: kNibName.LearnTableViewCell, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: kCellId.multiCell)
        tableView.separatorStyle = .none
        
        btnSpeak.layer.borderWidth = 5
        btnSpeak.layer.borderColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        btnSpeak.layer.cornerRadius = btnSpeak.frame.height / 2
        
        btnNext.layer.cornerRadius = 10
        btnPrevious.layer.cornerRadius = 10
        buttonView.layer.cornerRadius = 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellId.multiCell) as! LearnTableViewCell
        let i = indexPath.row + 1
        cell.lbMultiplication.text = "\(number) x \(i)"
        cell.lbResult.text = "\(number * i)"
        lbNumber.text = String(number)
        cell.setupViewLearn()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if synthesizer.isSpeaking {
            stopSpeaking()
            btnSpeak.setImage(kImageName.imgPlay, for: .normal)
        }
        
        resetSelection()
        
        let selectingCell = tableView.cellForRow(at: indexPath) as! LearnTableViewCell
        selectingCell.isPressed = true
        speakSingle(cell: selectingCell)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 10
    }
    
    @IBAction func btnNext(_ sender: Any) {
        resetSelection()
        stopSpeaking()
        btnSpeak.setImage(kImageName.imgPlay, for: .normal)
        if number < 20 {
            number += 1
            tableView.reloadData()
        } else {
            number = 1
            tableView.reloadData()
        }
    }
    
    @IBAction func btnPrevious(_ sender: Any) {
        resetSelection()
        stopSpeaking()
        btnSpeak.setImage(kImageName.imgPlay, for: .normal)
        
        if number > 1 {
            number -= 1
            tableView.reloadData()
        } else {
            number = 20
            tableView.reloadData()
        }
    }
    
    @IBAction func btnClose(_ sender: Any) {
        stopSpeaking()

        dismiss(animated: true, completion: {
            if let callbaclk = self.backToHomeCallback {
                callbaclk()
            }
        })
    }
    
    @IBAction func btnSpeak(_ sender: Any) {
        resetSelection()
        if !synthesizer.isSpeaking {
            speakAllCell()
            btnSpeak.setImage(kImageName.imgPause, for: .normal)
        } else {
            stopSpeaking()
            btnSpeak.setImage(kImageName.imgPlay, for: .normal)
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if isSpeakAll {
            speakIndex += 1
            
            let cells = tableView.visibleCells as! [LearnTableViewCell]

            if speakIndex >= cells.count {
                btnSpeak.setImage(kImageName.imgPlay, for: .normal)
                return
            }
            
            let cell = cells[speakIndex]
            cell.isPressed = true
            speak(cell: cell)
        }
    }
    
    func speakAllCell() {
        isSpeakAll = true
        speakIndex = 0
        let cells = tableView.visibleCells as! [LearnTableViewCell]
        let cell = cells[speakIndex]
        cell.isPressed = true
        speak(cell: cell)
    }
    
    func speakSingle(cell: LearnTableViewCell) {
        isSpeakAll = false
        speak(cell: cell)
    }
    
    func stopSpeaking() {
        isSpeakAll = false
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    func resetSelection() {
        let cells = tableView.visibleCells as! [LearnTableViewCell]
        for cell in cells {
            if cell.isPressed {
                cell.isPressed = false
            }
        }
    }
    
    func speak(cell: LearnTableViewCell) {
        let textToSpeech = "\(cell.lbMultiplication.text!) equal \(cell.lbResult.text!)"
        
        utterance = AVSpeechUtterance(string: textToSpeech)
        utterance.voice = AVSpeechSynthesisVoice(language: kLanguage.speakLanguage)
        synthesizer.speak(utterance)
    }
}
