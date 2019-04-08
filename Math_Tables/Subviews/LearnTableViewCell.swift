//
//  LearnTableViewCell.swift
//  Math_Tables
//
//  Created by Lê Trần Trọng Tín on 2/22/19.
//  Copyright © 2019 Lê Trần Trọng Tín. All rights reserved.
//

import UIKit
import AVFoundation
import ChameleonFramework

class LearnTableViewCell: UITableViewCell {
    @IBOutlet weak var lbMultiplication: UILabel!
    @IBOutlet weak var lbResult: UILabel!
    @IBOutlet weak var viewCalculation: UIView!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var lbEqual: UILabel!
    
    var isAnswered = false {
        didSet { checkAnswer() }
    }
    
    var isPressed = false {
        didSet {
            if isPressed {
                selection()
            } else {
                notSelect()
            }
        }
    }
    
    var tempResult: String?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // Initialization code
        
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        viewCalculation.layer.cornerRadius = viewCalculation.frame.height / 2
        viewCalculation.clipsToBounds = true
        lbMultiplication.layer.cornerRadius = lbMultiplication.frame.height / 2
        lbMultiplication.clipsToBounds = true
        lbResult.layer.cornerRadius = lbResult.frame.height / 2
        lbResult.clipsToBounds = true
        cellView.layer.cornerRadius = cellView.frame.height / 2
        cellView.clipsToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateAnswer(answer: String) {
        lbResult.text = answer
        isAnswered = true
    }
    
    func swapAnswer(cell: LearnTableViewCell) {
        if !cell.isAnswered {
            cell.isAnswered = true
            isAnswered = false
        } else {
            isAnswered = true
            cell.isAnswered = true
        }
        lbResult.text = nil
        let snap = lbResult.makeSnapshot();
        let snapFrame = viewCalculation.convert(lbResult.frame, to: contentView)
        contentView.addSubview(snap)
        contentView.sendSubviewToBack(snap)
        snap.frame = snapFrame

        let orginalY = lbResult.frame.origin.y
        let originalBackground = lbResult.backgroundColor
        lbResult.frame.origin.y = -lbResult.frame.height
        lbResult.backgroundColor = .clear

        UIView.animate(withDuration: 0.5, animations: {
            self.lbResult.frame.origin.y = orginalY
        }) { (_) in
            self.lbResult.backgroundColor = originalBackground
            snap.removeFromSuperview()
        }

        guard let tempResult = tempResult else { return }
        lbResult.text = cell.lbResult.text
        cell.lbResult.text = tempResult
    }
    
    func setupView() {
        lbMultiplication.backgroundColor = UIColor.flatSkyBlue
        lbResult.backgroundColor = UIColor.flatMint
        lbEqual.textColor = UIColor.flatYellowDark
    }
    
    func setupViewLearn() {
        lbMultiplication.backgroundColor = UIColor.flatLimeDark
        lbResult.backgroundColor = UIColor.flatLimeDark
        lbEqual.textColor = UIColor.flatLimeDark
    }
    
    func didGetDragged() {
        tempResult = lbResult.text
        lbResult.text = ""
        isAnswered = false
    }
    
    func cancelSwap() {
        lbResult.text = tempResult
        isAnswered = true
    }
    
    func selection() {
        cellView.layer.borderColor = UIColor.lightGray.cgColor
        cellView.layer.borderWidth = 2
    }
    
    func notSelect() {
        cellView.layer.borderColor = UIColor.clear.cgColor
    }
    
    func wrongAnswer() {
        lbMultiplication.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        lbEqual.textColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        lbResult.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
    }
    
    func trueAnswer() {
        lbMultiplication.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        lbEqual.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        lbResult.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
    }
    
    func checkAnswer() {
        lbResult.backgroundColor = isAnswered ? UIColor.flatSkyBlue : UIColor.flatMint
    }
}
