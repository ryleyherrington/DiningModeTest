//
//  BannerView.swift
//  DiningMode
//
//  Created by Ryley Herrington on 3/26/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//

import UIKit

class BannerView: UIView {
    
    static let bannerHeight: CGFloat = 49
    
    var button: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init coder hasn't been implemented yet.")
    }
    
    func setupSubview() {
        self.backgroundColor = UIColor.lightGray
     
        button = UIButton()
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        
        button.setTitle("Next Reservation", for: .normal)
        button.backgroundColor = UIColor(red: 128/255, green: 23/255, blue: 71/255, alpha: 1.0)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(button)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[button]-|",
                                                           options: [], metrics: nil,
                                                           views: ["button": button]))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[button]-|",
                                                           options: [], metrics: nil,
                                                           views: ["button": button]))
 
    }
    
}
