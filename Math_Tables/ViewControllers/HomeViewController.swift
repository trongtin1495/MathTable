//
//  HomeViewController.swift
//  Math_Tables
//
//  Created by Lê Trần Trọng Tín on 2/22/19.
//  Copyright © 2019 Lê Trần Trọng Tín. All rights reserved.
//

import UIKit
import SCLAlertView

class HomeViewController: UIViewController {
    @IBOutlet weak var btnLearn: UIButton!
    @IBOutlet weak var btnMake: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnScore: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnLearn(_ sender: Any) {
        let view = SelectNumberViewController(nibName: kNibName.SelectNumberViewController, bundle: nil)
        present(view, animated: true, completion: nil)
    }
    
    @IBAction func btnMake(_ sender: Any) {
        let view = MakeTableViewController(nibName: kNibName.MakeTableViewController, bundle: nil)
        present(view, animated: true, completion: nil)
    }
    
    @IBAction func btnPlay(_ sender: Any) {
        let view = PlayViewController(nibName: kNibName.PlayViewController, bundle: nil)
        present(view, animated: true, completion: nil)
    }
    
    @IBAction func btnScore(_ sender: Any) {
        let view = ScoreViewController(nibName: kNibName.ScoreViewController, bundle: nil)
        present(view, animated: true, completion: nil)
    }
}
