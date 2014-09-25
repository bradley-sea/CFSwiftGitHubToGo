//
//  UserAnimationController.swift
//  CFSwiftGitHubToGo
//
//  Created by Bradley Johnson on 9/25/14.
//  Copyright (c) 2014 Brad Johnson. All rights reserved.
//

import UIKit

class UserAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var selectedCell : UICollectionViewCell!
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        //getting both the view controller we are presenting from (fromVC) and the one we are presenting (toVC)
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as UsersViewController?
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as UserViewController?
        
        let containerView = transitionContext.containerView()
        //start the toVC offscreen to the right
        toVC?.view.frame = containerView.frame
        toVC?.view.backgroundColor = UIColor.redColor()
        toVC?.view.frame.origin = CGPoint(x: toVC!.view.frame.width, y:toVC!.view.frame.origin.y)
        containerView.addSubview(toVC!.view)
        
        //generate our moving image view
        let userCell = selectedCell as UserCell
        let startFrame = fromVC?.collectionView.convertPoint(userCell.frame.origin, toView: fromVC!.view)
        var temporaryMovingImage = UIImageView(frame:CGRect(x: startFrame!.x, y: startFrame!.y, width: userCell.frame.width, height: userCell.frame.height))
        temporaryMovingImage.clipsToBounds = true
        temporaryMovingImage.image = userCell.imageView.image
        containerView.addSubview(temporaryMovingImage)
        userCell.hidden = true
        let duration = self.transitionDuration(transitionContext)
        
        UIView.animateWithDuration(duration, animations: { () -> Void in
            
            toVC!.view.frame.origin = fromVC!.view.frame.origin
            
            println(containerView.frame)
            println(CGRectGetMidX(containerView.frame))
            
            var finalX = CGRectGetMidX(toVC!.view.bounds) - (toVC!.userImageView.frame.width * 0.5)
            println(containerView.frame)
            println(toVC!.view.frame)
            var finalY = toVC!.userImageView.frame.origin.y + 20
            
            var finalWidth = toVC!.userImageView.frame.width
            var finalHeight = toVC!.userImageView.frame.height
            
            temporaryMovingImage.frame = CGRect(x: finalX, y: finalY, width: finalWidth, height: finalHeight)
//            temporaryMovingImage.center = CGPoint(x: CGRectGetMidX(toVC!.view.frame), y: toVC!.userImageView.frame.origin.y + toVC!.userImageView.frame.height * 0.5)
//            
//            temporaryMovingImage.frame.size = CGSize(width: toVC!.userImageView.frame.width, height: toVC!.userImageView.frame.height)
            
        }) { (finished) -> Void in
            
            toVC!.userImageView.image = temporaryMovingImage.image
            temporaryMovingImage.removeFromSuperview()
            userCell.hidden = false
            transitionContext.completeTransition(true)

        }
        

    }
}
