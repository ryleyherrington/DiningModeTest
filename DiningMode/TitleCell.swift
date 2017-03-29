//
//  FirstResCell.swift
//  DiningMode
//
//  Created by Ryley Herrington on 3/26/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//

import UIKit

//First card displays:
//restaurant name
//the reservation time
//the party size
//picture of the restaurant

public let TitleCellReuseId = "titleCell"

class TitleCell: UICollectionViewCell {
    
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var resNumberLabel: UILabel!
    
    var reservation:Reservation!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        
        self.restaurantImage.layer.cornerRadius = self.restaurantImage.frame.size.width/2
        self.restaurantImage.clipsToBounds = true
    }
    
    func updateModel(){
        self.titleLabel.text = reservation.restaurant.name
        
        self.restaurantImage!.image = nil
        if let url = reservation.restaurant.profilePhoto?.urlForSize(desiredSize: CGSize(width: 133.0, height: 133.0)) {
            self.restaurantImage.setImageWith(URL(string: url)!)
        }
        
        let dateString = DateTransformer().transformToString(date:reservation.localDate)
        self.dateLabel.text = "📅\n\(dateString)"
        
        self.resNumberLabel.text = "👥\n\(reservation.partySize)"
    }
    
    
}
