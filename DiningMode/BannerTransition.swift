//
//  BannerTransition.swift
//  DiningMode
//
//  Created by Ryley Herrington on 3/26/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//

import UIKit

class BannerTransition: UIPercentDrivenInteractiveTransition {
    var viewController: UIViewController?
    var presentViewController: UIViewController?
    var pan: UIPanGestureRecognizer!
    
    var shouldComplete = false
    var lastProgress: CGFloat?
    
    func attachToViewController(_ viewController: UIViewController, withView view: UIView, presentViewController: UIViewController?) {
        self.viewController = viewController
        self.presentViewController = presentViewController
        pan = UIPanGestureRecognizer(target: self, action: #selector(self.onPan(_:)))
        view.addGestureRecognizer(pan)
    }
    
    func onPan(_ pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: pan.view?.superview)
        
        //Represents the percentage of the transition that must be completed before allowing to complete.
        let percentThreshold: CGFloat = 0.2
        //Represents the difference between progress that is required to trigger the completion of the transition.
        let automaticOverrideThreshold: CGFloat = 0.03
        
        let screenHeight: CGFloat = UIScreen.main.bounds.size.height - BannerView.bannerHeight
        let dragAmount: CGFloat = (presentViewController == nil) ? screenHeight : -screenHeight
        var progress: CGFloat = translation.y / dragAmount
        
        progress = fmax(progress, 0)
        progress = fmin(progress, 1)
        
        switch pan.state {
        case .began:
            if let presentViewController = presentViewController {
                viewController?.present(presentViewController, animated: true, completion: nil)
            } else {
                viewController?.dismiss(animated: true, completion: nil)
            }
            
        case .changed:
            guard let lastProgress = lastProgress else {return}
            
            // When swiping back
            if lastProgress > progress {
                shouldComplete = false
                // When swiping quick to the right
            } else if progress > lastProgress + automaticOverrideThreshold {
                shouldComplete = true
            } else {
                // Normal behavior
                shouldComplete = progress > percentThreshold
            }
            update(progress)
            
        case .ended, .cancelled:
            if pan.state == .cancelled || shouldComplete == false {
                cancel()
            } else {
                finish()
            }
            
        default:
            break
        }
        
        lastProgress = progress
    }

}
