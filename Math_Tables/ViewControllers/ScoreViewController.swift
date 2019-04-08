//
//  ScoreViewController.swift
//  Math_Tables
//
//  Created by Lê Trần Trọng Tín on 3/20/19.
//  Copyright © 2019 Lê Trần Trọng Tín. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var goldView: UIView!
    @IBOutlet weak var silverView: UIView!
    @IBOutlet weak var bronzeView: UIView!
    @IBOutlet weak var lbGold: UILabel!
    @IBOutlet weak var lbSilver: UILabel!
    @IBOutlet weak var lbBronze: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnHome: UIButton!
    
    
    let scoreSheet = UserDefaults.standard
    var scoreDict = [[String : Int]]()
    var dateStringList = [String]()
    var scoreList = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        goldView.layer.cornerRadius = 20
        silverView.layer.cornerRadius = 20
        bronzeView.layer.cornerRadius = 20
        
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: kNibName.ScoreTableViewCell, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: kCellId.scoreCell)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        self.configData()
    }
    
    private func configData() {
        
        let goldCount = scoreSheet.array(forKey: kUserDefaultKey.goldCount)
        let silverCount = scoreSheet.array(forKey: kUserDefaultKey.silverCount)
        let bronzeCount = scoreSheet.array(forKey: kUserDefaultKey.bronzeCount)
        
        self.lbGold.text = "\(goldCount?.count ?? 0)"
        self.lbSilver.text = "\(silverCount?.count ?? 0)"
        self.lbBronze.text = "\(bronzeCount?.count ?? 0)"
        
        self.scoreDict = scoreSheet.array(forKey: kUserDefaultKey.scoreData) as? [[String : Int]] ?? [[String : Int]]()
        
        scoreDict.sort(by: {
            let score1 = $0.first!.value;
            let score2 = $1.first!.value;
            
            return score1 > score2
        })
        
        for items in scoreDict {
            for (playedDate, score) in items {
                
                dateStringList.append(playedDate)
                scoreList.append(score)
            }
        }
        
        print(scoreDict)
    }

    @IBAction func btnHome(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dateStringList.count >= 5 {
            return 5
        } else {
            return dateStringList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellId.scoreCell, for: indexPath) as! ScoreTableViewCell
        cell.dateLabel.text = self.dateStringList[indexPath.row]
        cell.scoreLabel.text = "\(self.scoreList[indexPath.row])"
        return cell
    }
}
