//
//  Constant.swift
//  Math_Tables
//
//  Created by Lê Trần Trọng Tín on 3/21/19.
//  Copyright © 2019 Lê Trần Trọng Tín. All rights reserved.
//

import UIKit

typealias kUserDefaultKey = Constant.UserDefaultKey
typealias kCellId = Constant.CellId
typealias kLabelFont = Constant.LabelFont
typealias kNibName = Constant.NibName
typealias kImageName = Constant.ImageName
typealias kLanguage = Constant.Language
typealias kSound = Constant.Sound

struct Constant {
    
    struct UserDefaultKey {
        static let silverCount = "silver"
        static let goldCount = "gold"
        static let bronzeCount = "bronze"
        static let scoreData = "scoreData"
    }
    
    struct CellId {
        static let multiCell = "multiCell"
        static let resultCell = "resultCell"
        static let scoreCell = "scoreCell"
    }
    
    struct LabelFont {
        static let resultFont = "ChangaOne"
    }
    
    struct NibName {
        static let HomeViewController = "HomeViewController"
        static let SelectNumberViewController = "SelectNumberViewController"
        static let LearnViewController = "LearnViewController"
        static let MakeTableViewController = "MakeTableViewController"
        static let PlayViewController = "PlayViewController"
        static let ScoreViewController = "ScoreViewController"
        static let ScoreTableViewCell = "ScoreTableViewCell"
        static let ResultCollectionViewCell = "ResultCollectionViewCell"
        static let LearnTableViewCell = "LearnTableViewCell"
    }
    
    struct ImageName {
        static let imgPause = UIImage(named: "speaker_off_ic")
        static let imgPlay = UIImage(named: "speaker_ic")
        static let imgGold = UIImage(named: "gold_ic")
        static let imgSilver = UIImage(named: "silver_ic")
        static let imgBronze = UIImage(named: "bronze_ic")
        static let imgFail = UIImage(named: "fail_ic")
    }
    
    struct Language {
        static let speakLanguage = "en-US"
    }
    
    struct Sound {
        static let soundName = "incorrect"
        static let type = "mp3"
    }
}
