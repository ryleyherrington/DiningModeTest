//
//  ReservationCollectionViewController.swift
//  DiningMode
//
//  Created by Ryley Herrington on 3/26/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//

import UIKit

class ReservationCollectionViewController: UICollectionViewController {
    
    var reservation:Reservation!
    var rootVC: ViewController?
    var parentVC: SecondViewController? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.collectionView?.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: UICollectionView Methods

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var numberOfItems = 2
        
        if self.reservation!.restaurant.dishes.count > 0 {
            numberOfItems = numberOfItems + 1
        }
        
        return numberOfItems
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let defaultCell = UICollectionViewCell()
        
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCellReuseId, for: indexPath) as! TitleCell
            cell.reservation = self.reservation
            cell.updateModel()
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapCellReuseId, for: indexPath) as! MapCell
            cell.reservation = self.reservation
            cell.updateModel()
            return cell
            
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DishesCellReuseId, for: indexPath) as! DishesCell
            cell.reservation = self.reservation
            cell.updateModel()
            cell.dishTap = self.dishTap
            return cell
            
        default:
            return defaultCell
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader{
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader,
                                                                             withReuseIdentifier:TopReuseId,
                                                                             for: indexPath) as! TopReusableView
            headerView.dismissButton.addTarget(self, action: #selector(dismissSwipe), for: .touchUpInside)
            return headerView
        }
        
        return UICollectionReusableView()
    }
    
    // MARK: Dismissal
    func dismissSwipe() {
        if self.rootVC != nil {
            rootVC!.disableInteractivePlayerTransitioning = true
            self.dismiss(animated: true) { [unowned self] in
                self.rootVC?.disableInteractivePlayerTransitioning = false
            }
        } else if self.parentVC != nil {
            parentVC!.disableInteractivePlayerTransitioning = true
            self.dismiss(animated: true) { [unowned self] in
                self.parentVC?.disableInteractivePlayerTransitioning = false
            }
        }
        
    }
    
    //MARK dish tap delegate
    func dishTap(dish:Dish, sender:UITableViewCell){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dishVC = storyboard.instantiateViewController(withIdentifier: "dishViewControllerId") as! DishViewController
        
        dishVC.dish = dish
        dishVC.modalPresentationStyle = .overCurrentContext
        self.present(dishVC, animated: true, completion: nil)
    }
    
}
