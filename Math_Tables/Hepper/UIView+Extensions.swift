//
//  UIView+Extensions.swift
//  Math_Tables
//
//  Created by Lê Trần Trọng Tín on 3/6/19.
//  Copyright © 2019 Lê Trần Trọng Tín. All rights reserved.
//

import UIKit

extension UIView {
    
    func makeSnapshot(backgroundColor: UIColor? = nil) -> UIView {
        let temp = self.backgroundColor
        
        if let backgroundColor = backgroundColor {
            self.backgroundColor = backgroundColor
        }
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return UIView()
        }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let snapshot = UIImageView(image: image)
        // Tạo style cho snapshot view nổi bật hơn
        snapshot.layer.masksToBounds = false
        snapshot.layer.cornerRadius = 0.0
        snapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        snapshot.layer.shadowRadius = 5.0
        snapshot.layer.shadowOpacity = 0.4
        
        self.backgroundColor = temp
        
        return snapshot
    }
}
