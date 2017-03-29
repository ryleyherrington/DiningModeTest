//
//  DishTableCell.swift
//  DiningMode
//
//  Created by Ryley Herrington on 3/27/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//

import UIKit

public let DishTableReuseId = "dishTableCell"

class DishTableCell: UITableViewCell {
    
    var dish:Dish!

    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dishImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dishImage.layer.cornerRadius = 5
        self.dishImage.clipsToBounds = true
    }
    
    func setModel(){
        if let photo = dish.photos.first{
            let url = photo.urlForSize(desiredSize: CGSize(width: 130, height: 130))
            self.dishImage.setImageWith(URL(string: url)!)
        }
        
        self.titleLabel.text = dish.name
        
        let attributedString = NSMutableAttributedString(string: dish.snippet.content)
        for highlightRange in dish.snippet.highlights {
            let boldedTextAttribute = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 12.0)!]
            attributedString.addAttributes(boldedTextAttribute, range: highlightRange)
        }
        
        self.descriptionTextView.attributedText = attributedString
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
