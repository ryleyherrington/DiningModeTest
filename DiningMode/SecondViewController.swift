//
//  SecondViewController.swift
//  DiningMode
//
//  Created by Ryley Herrington on 3/28/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    var disableInteractivePlayerTransitioning = false
    
    var bannerView: BannerView!
    var reservationVC: ReservationCollectionViewController!
    var presentInteractor: BannerTransition!
    var dismissInteractor: BannerTransition!
    
    //for swipe up VC
    var currentReservation:Reservation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //choose default reservation
        chooseData(type: .fullRes)
        
        buildBanner()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(SecondViewController.updateReservation),
                                               name: NSNotification.Name(rawValue: "updatedReservation"),
                                               object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateReservation(notification: NSNotification){
        let resource = UserDefaults.standard.object(forKey: "updatedRes")
        
        //So this full versus partial wouldn't happen and we would obviously
        //save the reservation and not continually create a reservation but
        //it works for a small sample on a time crunch
        do {
            if let file = Bundle.main.path(forResource: resource as! String?, ofType: "json") {
                let data = try NSData(contentsOfFile: file, options: .mappedIfSafe)
                let json = try JSONSerialization.jsonObject(with: data as Data, options: [])
                if let object = json as? [String: Any] {
                    self.currentReservation = ReservationAssembler().createReservation(object)!
                    if reservationVC != nil {
                        reservationVC.reservation = self.currentReservation
                    }
                } else {
                    debugPrint("JSON is invalid")
                }
            } else {
                debugPrint("No File Found")
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
        
    }
    
    func buildBanner() {
        bannerView = BannerView()
        bannerView.button.addTarget(self, action: #selector(self.bottomButtonTapped), for: .touchUpInside)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bannerView)
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[bannerView]-0-|", options: [], metrics: nil, views: ["bannerView": bannerView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[bannerView(\(BannerView.bannerHeight))]-\(BannerView.bannerHeight)-|", options: [], metrics: nil, views: ["bannerView": bannerView]))
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        reservationVC = storyboard.instantiateViewController(withIdentifier: "ReservationVCId") as! ReservationCollectionViewController
        
        reservationVC.parentVC = self
        reservationVC.reservation = self.currentReservation
        reservationVC.transitioningDelegate = self
        reservationVC.modalPresentationStyle = .fullScreen
        
        presentInteractor = BannerTransition()
        presentInteractor.attachToViewController(self, withView: bannerView, presentViewController: reservationVC)
        dismissInteractor = BannerTransition()
        dismissInteractor.attachToViewController(reservationVC, withView: reservationVC.view, presentViewController: nil)
    }
    
    func bottomButtonTapped() {
        disableInteractivePlayerTransitioning = true
        self.present(reservationVC, animated: true) { [unowned self] in
            self.disableInteractivePlayerTransitioning = false
        }
    }
    
    //Network call usually but I'll do the local JSON file as that instead
    func chooseData(type:JSONFileType){
        var resource = "FullReservation"
        switch type {
        case .twoDishes:
            resource = "2dishes"
            
        case .fullRes:
            resource = "FullReservation"
            
        case .partialRes:
            resource = "PartialReservation"
        }
        
        //So this full versus partial wouldn't happen and we would obviously
        //save the reservation and not continually create a reservation but
        //it works for a small sample on a time crunch
        do {
            if let file = Bundle.main.path(forResource: resource, ofType: "json") {
                let data = try NSData(contentsOfFile: file, options: .mappedIfSafe)
                let json = try JSONSerialization.jsonObject(with: data as Data, options: [])
                if let object = json as? [String: Any] {
                    self.currentReservation = ReservationAssembler().createReservation(object)!
                    if reservationVC != nil {
                        reservationVC.reservation = self.currentReservation
                    }
                } else {
                    debugPrint("JSON is invalid")
                }
            } else {
                debugPrint("No File Found")
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
        
    }
    
   
}

extension SecondViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = BannerAnimator()
        animator.transitionType = .show
        animator.initialY = BannerView.bannerHeight
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = BannerAnimator()
        animator.initialY = BannerView.bannerHeight*2
        animator.transitionType = .hide
        return animator
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard !disableInteractivePlayerTransitioning else { return nil }
        return presentInteractor
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard !disableInteractivePlayerTransitioning else {
            return nil
        }
        return dismissInteractor
    }
}


