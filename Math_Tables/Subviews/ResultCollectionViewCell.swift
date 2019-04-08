//
//  ResultCollectionViewCell.swift
//  Math_Tables
//
//  Created by Lê Trần Trọng Tín on 2/25/19.
//  Copyright © 2019 Lê Trần Trọng Tín. All rights reserved.
//

import UIKit

class ResultCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lbResult: UILabel!
    @IBOutlet weak var view: UIView!
    
    var roundCorner = true
    var isAnimating = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lbResult.backgroundColor = UIColor.flatYellowDark
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutIfNeeded()
        
        if roundCorner {
            lbResult.layer.cornerRadius = lbResult.frame.height / 2
            lbResult.clipsToBounds = true
        }
    }
    
    func setupPlayView(result: String) {
        roundCorner = false
        lbResult.backgroundColor = #colorLiteral(red: 1, green: 0.4782996774, blue: 0, alpha: 1)
        lbResult.layer.cornerRadius = 15
        lbResult.text = result
        lbResult.font = UIFont(name: Constant.LabelFont.resultFont, size: 30.0)
    }
}
