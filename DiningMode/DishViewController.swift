//
//  DishViewController.swift
//  DiningMode
//
//  Created by Ryley Herrington on 3/27/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//

import UIKit

class DishViewController: UIViewController {

    var dish:Dish!
    @IBOutlet weak var dishImage: UIImageView!
    @IBOutlet weak var dishSnippet: UITextView!
    @IBOutlet weak var dishTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDish()
        self.view.layer.cornerRadius = 5
        self.view.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1.5, animations:{
            self.view.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        }, completion: nil)
    }
    
    func setupDish(){
        if let photo = dish.photos.first{
            let url = photo.urlForSize(desiredSize: CGSize(width: 175, height: 175))
            self.dishImage.setImageWith(URL(string: url)!)
        }
        
        self.dishTitle.text = dish.name
        
        let attributedString = NSMutableAttributedString(string: dish.snippet.content)
        for highlightRange in dish.snippet.highlights {
            let boldedTextAttribute = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 17.0)!]
            attributedString.addAttributes(boldedTextAttribute, range: highlightRange)
        }
        
        self.dishSnippet.attributedText = attributedString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.backgroundColor = UIColor.clear
        }) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
    }

}
