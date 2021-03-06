//
//  ViewController.swift
//  DiningMode
//
//  Created by Olivier Larivain on 12/2/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import UIKit

import AFNetworking

enum JSONFileType {
    case twoDishes
    case fullRes
    case partialRes
}

class ViewController: UIViewController {
    
    var disableInteractivePlayerTransitioning = false
    
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var fullButton: UIButton!
    @IBOutlet weak var partialButton: UIButton!
    
    var bannerView: BannerView!
    var reservationVC: ReservationCollectionViewController!
    var presentInteractor: BannerTransition!
    var dismissInteractor: BannerTransition!
    
    //for swipe up VC
    var currentReservation:Reservation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // just to make sure everything links fine
        AFHTTPSessionManager(baseURL: nil).get("", parameters: nil, progress: nil, success: nil, failure: nil)
        
        //choose default reservation
        chooseData(type: .fullRes)
        updateButtons(type: .fullRes)
        
        buildBanner()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        
        reservationVC.rootVC = self
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
        
        UserDefaults.standard.set(resource, forKey: "updatedRes")
        NotificationCenter.default.post(name: Notification.Name("updatedReservation"), object: nil)
        
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
    
    // MARK: Button Functions
    @IBAction func twoDishesTouched(_ sender: Any) {
        chooseData(type: .twoDishes)
        updateButtons(type: .twoDishes)
    }
    
    @IBAction func fullResTouched(_ sender: Any) {
        chooseData(type: .fullRes)
        updateButtons(type: .fullRes)
    }
    
    @IBAction func partialResTouched(_ sender: Any) {
        chooseData(type: .partialRes)
        updateButtons(type: .partialRes)
    }
    
    func updateButtons(type:JSONFileType){
        switch type {
        case .twoDishes:
            self.twoButton.setTitle("✅ 2 Dishes", for: .normal)
            self.fullButton.setTitle("Full Reservation", for: .normal)
            self.partialButton.setTitle("Partial Reservation", for: .normal)
            
        case .fullRes:
            self.twoButton.setTitle("2 Dishes", for: .normal)
            self.fullButton.setTitle("✅ Full Reservation", for: .normal)
            self.partialButton.setTitle("Partial Reservation", for: .normal)
            
        case .partialRes:
            self.twoButton.setTitle("2 Dishes", for: .normal)
            self.fullButton.setTitle("Full Reservation", for: .normal)
            self.partialButton.setTitle("✅ Partial Reservation", for: .normal)
        }
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    
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

