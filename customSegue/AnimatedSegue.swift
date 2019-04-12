//
//  AnimatedSegue.swift
//  customSegue
//
//  Created by Benjamin on 2019-04-12.
//  Copyright © 2019 Benjamin. All rights reserved.
//

import UIKit

enum transition: Int {
    case circle = 1
    case scale = 2
    case verticalPaging = 3
//   private case unwind = 4
//   private case zoom = 5
//   private case zoomUnwind = 6
    case rotate = 7
    case fade = 8
    case expand = 9
}

class AnimatedSegue: UIStoryboardSegue, CAAnimationDelegate {
    
    

    var animationType: transition?
    
    var defaultTransiction :transition = .rotate
    
    let firstVCView : UIView = UIView()
    let secondVCView : UIView = UIView()
    
    let toViewController: UIViewController
    let fromViewController: UIViewController
    
    //@IBInspectable var type : Int = 1
    
    override func perform() {
        
        if AnimatedSegue.isAnimating {
            return
        }
        
        if AnimatedSegue.stack.peek() !== destination {
            AnimatedSegue.stack.push(vc: source)
        } else {
            AnimatedSegue.stack.pop()
            shouldUnwind = true
        }
        
        guard let firstVCView = self.source.view else {fatalError()}
        guard let secondVCView = self.destination.view else {fatalError()}
        
        
        
        let type = animationType ?? defaultTransiction
        
        switch type {
        case .circle:
            circleSegue()
        case .scale:
            scaleSegue()
        case .verticalPaging:
            verticalPagingSegue()
//        case .unwind:
//            UnwindSegue()
//        case .zoom:
//            zoomSegue()
//        case .zoomUnwind:
//            zoomUnwindSegue()
        case .rotate:
            rotateSegue()
        case .fade:
            fadeSegue()
        case .expand:
            expandingSegue()
        }
    }
    
    //MARK: - rotate segue
    func rotateSegue() {
        
        let containerView = fromViewController.view.superview
        let originalCenter = fromViewController.view.center
        
        //toViewController.view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        toViewController.view.alpha = 0
        self.toViewController.view.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        toViewController.view.center = originalCenter
        containerView?.addSubview(toViewController.view)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.toViewController.view.transform = CGAffineTransform.identity
            self.toViewController.view.alpha = 1
            self.fromViewController.view.alpha = 0
            self.fromViewController.view.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }, completion: {completted in
            self.fromViewController.present(self.toViewController, animated: false, completion: nil)
        })
    }
    
    //MARK: - expanding segue
    func expandingSegue() {
        
        let containerView = fromViewController.view.superview
        let originalCenter = fromViewController.view.center
        
        fromViewController.view.alpha = 0
        toViewController.view.alpha = 1
        self.toViewController.view.transform = CGAffineTransform(scaleX: 0, y: 0.2)
        toViewController.view.center = originalCenter
        containerView?.addSubview(toViewController.view)
        
        
        UIView.animate(withDuration: 0.5, animations: {
            self.toViewController.view.transform = CGAffineTransform(scaleX: 1, y: 0.2)
        }, completion: {completted in
            UIView.animate(withDuration: 0.5, animations: {
                 self.toViewController.view.transform = CGAffineTransform.identity
            }, completion: { (completted) in
                self.fromViewController.present(self.toViewController, animated: false, completion: nil)
            })
        })
    }
    
    //MARK: - fade segue
    func fadeSegue() {
        
        let containerView = fromViewController.view.superview
        let originalCenter = fromViewController.view.center
        
        
        toViewController.view.alpha = 0
        toViewController.view.center = originalCenter
        containerView?.addSubview(toViewController.view)
        
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseIn, animations: {
            self.toViewController.view.alpha = 1
            self.fromViewController.view.alpha = 0
        }, completion: {completted in
            self.fromViewController.present(self.toViewController, animated: false, completion: nil)
        })
        
    }
    
    
    //MARK: - zoom seque
    
    func zoomSegue() {
        
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(secondVCView, belowSubview: firstVCView)
        
        secondVCView.transform = secondVCView.transform.scaledBy(x: 0.001, y: 0.001)
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            
            self.firstVCView.transform = self.secondVCView.transform.scaledBy(x: 0.001, y: 0.001)
            
        }) { (Finished) -> Void in
            
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.secondVCView.transform = CGAffineTransform.identity
                
            }, completion: { (Finished) -> Void in
                
                self.firstVCView.transform = CGAffineTransform.identity
                self.source.present(self.destination, animated: false, completion: nil)
            })
        }
    }
    
    func zoomUnwindSegue() {

        let screenHeight = UIScreen.main.bounds.size.height
        
        firstVCView.frame = firstVCView.frame.offsetBy( dx: 0.0, dy: screenHeight)
        firstVCView.transform = firstVCView.transform.scaledBy( x: 0.001, y: 0.001)

        let window = UIApplication.shared.keyWindow
        window?.insertSubview(secondVCView, aboveSubview: firstVCView)

        UIView.animate(withDuration: 0.5, animations: { () -> Void in

            self.secondVCView.transform = self.secondVCView.transform.scaledBy(x: 0.001, y: 0.001)
            self.secondVCView.frame = self.secondVCView.frame.offsetBy( dx: 0.0, dy: -screenHeight)

            self.firstVCView.transform = CGAffineTransform.identity
            self.firstVCView.frame = self.firstVCView.frame.offsetBy( dx: 0.0, dy: -screenHeight)

        }) { (Finished) -> Void in

            self.source.dismiss(animated: false, completion: nil)
        }
    }
    
    
    
    //MARK: - unwind segue - verticalpaging back
    func UnwindSegue() {
        // Assign the source and destination views to local variables.
        
        
        let screenHeight = UIScreen.main.bounds.size.height
        
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(secondVCView, aboveSubview: secondVCView)
        
        // Animate the transition.
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.firstVCView.frame = self.firstVCView.frame.offsetBy( dx: 0.0, dy: screenHeight)
            self.secondVCView.frame = self.secondVCView.frame.offsetBy( dx: 0.0, dy: screenHeight)
            
        }) { (Finished) -> Void in
            
            self.source.dismiss(animated: false, completion: nil)
        }
        
    }
    
    //MARK: - vertical paging segue
    func verticalPagingSegue() {
        
        // Get the screen width and height.
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        // Specify the initial position of the destination view.
        secondVCView.frame = CGRect(x: 0.0, y: screenHeight, width: screenWidth, height: screenHeight)
        
        // Access the app's key window and insert the destination view above the current (source) one.
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(secondVCView, aboveSubview: firstVCView)
        
        // Animate the transition.
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
           
            
            self.firstVCView.frame = self.firstVCView.frame.offsetBy(dx: 0.0, dy: -screenHeight)
            self.secondVCView.frame = self.secondVCView.frame.offsetBy(dx: 0.0, dy: -screenHeight)
            
        }) { (Finished) -> Void in
            self.source.present(self.destination, animated: false, completion: nil)
        }
    }
    
    //MARK: - scale segue
    
    func scaleSegue() {
        
        let containerView = fromViewController.view.superview
        let originalCenter = fromViewController.view.center
        
        toViewController.view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        toViewController.view.center = originalCenter
        containerView?.addSubview(toViewController.view)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.toViewController.view.transform = CGAffineTransform.identity
        }, completion: {completted in
            self.fromViewController.present(self.toViewController, animated: false, completion: nil)
        })
    }
    
    
    
    
    
    
    
    
    //MARK: - circle segue
    
    private static let expandDur: CFTimeInterval = 0.35 // Change to make transition faster/slower
    private static let contractDur: CFTimeInterval = 0.15 // Change to make transition faster/slower
    private static let stack = Stack()
    private static var isAnimating = false
    
    var circleOrigin: CGPoint
    private var shouldUnwind: Bool
    
    override init(identifier: String?, source: UIViewController, destination: UIViewController) {
        
        // By default, transition starts from the center of the screen,
        // so let's find the center when segue is first initialized
        let centerX = UIScreen.main.bounds.width*0.5
        let centerY = UIScreen.main.bounds.height*0.5
        let centerOfScreen = CGPoint(x:centerX, y:centerY)
        
        toViewController = destination
        fromViewController = source
        
        // Initialize properties
        circleOrigin = centerOfScreen
        shouldUnwind = false
        
        super.init(identifier: identifier, source: source, destination: destination)
    }
    
    func circleSegue() {
    
    let sourceView = source.view as UIView?
    let destView = destination.view as UIView?
    
    // Add source (or destination) controller's view to the main application
    // window depending of if this is a normal or unwind segue
    let window = UIApplication.shared.keyWindow
    if !shouldUnwind {
    window?.insertSubview(destView!, aboveSubview: sourceView!)
    } else {
    window?.insertSubview(destView!, at:0)
    }
    
    let paths = startAndEndPaths(shouldUnwind: !shouldUnwind)
    
    // Create circle mask and apply it to the view of the destination controller
    let mask = CAShapeLayer()
    mask.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    mask.position = circleOrigin
    mask.path = paths.start
    (shouldUnwind ? sourceView : destView)?.layer.mask = mask
    
    // Call method for creating animation and add it to the view's mask
    (shouldUnwind ? sourceView : destView)?.layer.mask?.add(scalingAnimation(destinationPath: paths.end), forKey: nil)
    }
    
    // MARK: Animation delegate
    
    func animationDidStart(_ anim: CAAnimation) {
        AnimatedSegue.isAnimating = true
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool)  {
        AnimatedSegue.isAnimating = false
        if !shouldUnwind {
            source.present(destination, animated: false, completion: nil)
        } else {
            source.dismiss(animated: false, completion: nil)
        }
    }
    
    // MARK: Helper methods
    
    private func scalingAnimation(destinationPath: CGPath) -> CABasicAnimation {
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.toValue = destinationPath
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.both
        animation.duration = shouldUnwind ? AnimatedSegue.contractDur : AnimatedSegue.expandDur
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.delegate = self as CAAnimationDelegate
        return animation
    }
    
    private func startAndEndPaths(shouldUnwind: Bool) -> (start: CGPath, end: CGPath) {
        
        // The hypothenuse is the diagonal of the screen. Further, we use this diagonal as
        // the diameter of the big circle. This way we are always certain that the big circle
        // will cover the whole screen.
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        let rw = width + abs(width/2 - circleOrigin.x)
        let rh = height + abs(height/2 - circleOrigin.y)
        let h1 = hypot(width/2 - circleOrigin.x, height/2 - circleOrigin.y)
        let hyp = CGFloat(sqrtf(powf(Float(rw), 2) + powf(Float(rh), 2)))
        let dia = h1 + hyp
        
        // The two circle sizes we will animate to/from
        let path1 = UIBezierPath(ovalIn: CGRect.zero).cgPath
        let path2 = UIBezierPath(ovalIn: CGRect(x:-dia/2, y:-dia/2, width:dia, height:dia)).cgPath
        
        // If shouldUnwind flag is true, we should go from big to small circle, or else go from small to big
        return shouldUnwind ? (path1, path2) : (path2, path1)
    }
    
    // MARK: Stack implementation
    
    // Simple stack implementation for keeping track of our view controllers
    private class Stack {
        
        private var stackArray = Array<UIViewController>()
        private var size: Int {
            get {
                return stackArray.count
            }
        }
        
        func push(vc: UIViewController) {
            stackArray.append(vc)
        }
        
        func pop() -> UIViewController? {
            if let last = stackArray.last {
                stackArray.removeLast()
                return last
            }
            return nil
        }
        
        func peek() -> UIViewController? {
            return stackArray.last
        }
    }
}



    

