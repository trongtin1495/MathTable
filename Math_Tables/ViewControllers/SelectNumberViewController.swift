//
//  SelectNumberViewController.swift
//  Math_Tables
//
//  Created by Lê Trần Trọng Tín on 2/22/19.
//  Copyright © 2019 Lê Trần Trọng Tín. All rights reserved.
//

import UIKit

class SelectNumberViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var items = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        let nib = UINib(nibName: kNibName.ResultCollectionViewCell, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: kCellId.resultCell)
        
        items += 1...20
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellId.resultCell, for: indexPath) as! ResultCollectionViewCell
        cell.lbResult.text = String(items[indexPath.item])
        cell.lbResult.layer.cornerRadius = 5
        cell.lbResult.backgroundColor = UIColor.randomFlat
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let view = LearnViewController(nibName: kNibName.LearnViewController, bundle: nil)
        view.number = indexPath.item + 1

        self.present(view, animated: true, completion: nil)
    }
    
    let spacing = 10
    let itemPerRow = 5
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = collectionView.contentInset.left + collectionView.contentInset.right
        let cgSpacing = CGFloat(spacing)
        let cgItemPerRow = CGFloat(itemPerRow)
        
        let totalCellWidth = collectionView.bounds.width - padding - cgSpacing * (cgItemPerRow - 1)
        let cellWidth = totalCellWidth / cgItemPerRow
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(spacing)
    }
}
