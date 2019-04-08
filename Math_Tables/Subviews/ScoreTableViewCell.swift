//
//  ScoreTableViewCell.swift
//  Math_Tables
//
//  Created by Lê Trần Trọng Tín on 3/21/19.
//  Copyright © 2019 Lê Trần Trọng Tín. All rights reserved.
//

import UIKit

class ScoreTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
