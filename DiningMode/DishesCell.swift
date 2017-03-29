//
//  DishesCell.swift
//  DiningMode
//
//  Created by Ryley Herrington on 3/27/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//

import UIKit

/*
 Third card is the "best dishes" feature: an optional list of 1 to 3 dishes, along with a review snippet, where mentions of the dish are emphasized. Some ground rules about dishes:
 A dish has at least one photo, and exactly one snippet
 
 A snippet holds the full review, a range which indicates which part should be displayed, and a list of highlight ranges. All the ranges are relative to the full review (e.g. a highlight at (197, 8) means "8 characters starting from the 197th character in the full review", regardless of which range of the review should be displayed).
 
 if the restaurant has no dishes, the card should not be shown
 
 if the restaurant has more than 3 dishes, only the first 3 should be shown each dish is guaranteed to have at least one picture, and one review snippet
 for each displayed snippet, we want to display: the photo, the dish name and the snippet along with its highlight. You're free to pick whatever method for the highlight (bold, color, underline etc.)
 */

public let DishesCellReuseId = "dishesCell"

class DishesCell: UICollectionViewCell {
    
    var reservation:Reservation!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    var dishTap:((_ dish:Dish, _ sender:UITableViewCell)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x:0,
                              y: self.tableView.frame.origin.y))
        
        path.addLine(to: CGPoint(x:self.frame.size.width,
                                 y:self.tableView.frame.origin.y))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 0.5
        
        self.layer.addSublayer(shapeLayer)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func updateModel(){
        self.tableView.reloadData()
    }

}

extension DishesCell: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let bufferView =  UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 20))
        bufferView.backgroundColor = UIColor.white
        
        return bufferView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservation.restaurant.dishes.count > 3 ? 3 : reservation.restaurant.dishes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DishTableCell = (self.tableView.dequeueReusableCell(withIdentifier: DishTableReuseId) as? DishTableCell)!
        cell.dish = reservation.restaurant.dishes[indexPath.row]
        cell.setModel()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let dish = reservation.restaurant.dishes[indexPath.row]
       self.dishTap?(dish, tableView.cellForRow(at: indexPath)!)
    }
    
}
