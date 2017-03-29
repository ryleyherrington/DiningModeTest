//
//  BannerAnimator.swift
//  DiningMode
//
//  Created by Ryley Herrington on 3/26/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//

import UIKit

enum TransitionType {
    case show
    case hide
}

class BannerAnimator: NSObject {
    
    var initialY: CGFloat = 0
    var transitionType: TransitionType = .show
    
    func presentWithAnimation(_ transitionContext: UIViewControllerContextTransitioning, fromVC: UIViewController, toVC: UIViewController) {
        
        let fromRect = transitionContext.initialFrame(for: fromVC)
        var toRect = fromRect
        toRect.origin.y = toRect.size.height - initialY
        
        toVC.view.frame = toRect
        let container = transitionContext.containerView
        let imageView = fakeMiniView()
        
        toVC.view.addSubview(imageView)
        container.addSubview(fromVC.view)
        container.addSubview(toVC.view)
        
        let animOptions: UIViewAnimationOptions = transitionContext.isInteractive ? [UIViewAnimationOptions.curveLinear] : []
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: animOptions, animations: {
            toVC.view.frame = fromRect
            imageView.alpha = 0
        }) { (finished) in
            imageView.removeFromSuperview()
            if transitionContext.transitionWasCancelled {
                transitionContext.completeTransition(false)
            } else {
                transitionContext.completeTransition(true)
            }
        }
    }
    
    func dismissWithAnimation(_ transitionContext: UIViewControllerContextTransitioning, fromVC: UIViewController, toVC: UIViewController) {
        
        var fromRect = transitionContext.initialFrame(for: fromVC)
        fromRect.origin.y = fromRect.size.height - initialY
        
        let imageView = fakeMiniView()
        imageView.alpha = 0
        fromVC.view.addSubview(imageView)
        
        let container = transitionContext.containerView
        container.addSubview(toVC.view)
        container.addSubview(fromVC.view)
        
        let animOptions: UIViewAnimationOptions = transitionContext.isInteractive ? [UIViewAnimationOptions.curveLinear] : []
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: animOptions, animations: {
            fromVC.view.frame = fromRect
            imageView.alpha = 1
        }) { (finished) in
            imageView.removeFromSuperview()
            if transitionContext.transitionWasCancelled {
                transitionContext.completeTransition(false)
            } else {
                transitionContext.completeTransition(true)
            }
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionContext!.isInteractive ? 0.4 : 0.3
    }
    
    func fakeMiniView() -> UIView {
        return BannerView(frame: CGRect(x: 0, y: -(BannerView.bannerHeight), width: UIScreen.main.bounds.size.width, height: BannerView.bannerHeight))
    }
}

extension BannerAnimator: UIViewControllerAnimatedTransitioning {
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let from = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let to = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        
        if transitionType == .show {
            presentWithAnimation(transitionContext, fromVC: from!, toVC: to!)
        } else  if transitionType == .hide {
            dismissWithAnimation(transitionContext, fromVC: from!, toVC: to!)
        }
        
    }
    
}
