

import UIKit

var SCREEN_WIDTH: CGFloat = {
    return UIScreen.main.bounds.size.width
}()
var SCREEN_HEIGHT = {
    return UIScreen.main.bounds.size.height
}()

class PageTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    weak var transitionContext: UIViewControllerContextTransitioning?
    
    
    public var panDirection = PanDirection.undefined
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        
        let containerView = transitionContext.containerView
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)! //as! ViewController
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)! //as! ViewController
        //let button = fromViewController.button
        
        containerView.addSubview(fromViewController.view)
        containerView.addSubview(toViewController.view)
        
        var toFrame: CGRect!
        var fromFrame: CGRect!
        var toFrameEnd: CGRect!
        var fromFrameEnd: CGRect!
        if self.panDirection == .horizontalRight {
            toFrame = CGRect(x: -SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
            fromFrame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
            
            toFrameEnd = toFrame.offsetBy(dx: SCREEN_WIDTH, dy: 0)
            fromFrameEnd = fromFrame.offsetBy(dx: SCREEN_WIDTH, dy: 0)
        }
        else if self.panDirection == .horizontalLeft {
            toFrame = CGRect(x: SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
            fromFrame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
            
            toFrameEnd = toFrame.offsetBy(dx: -SCREEN_WIDTH, dy: 0)
            fromFrameEnd = fromFrame.offsetBy(dx: -SCREEN_WIDTH, dy: 0)
        }
        else if self.panDirection == .verticalDown {
            toFrame = CGRect(x: 0, y: -SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
            fromFrame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
            
            toFrameEnd = toFrame.offsetBy(dx: 0, dy: SCREEN_HEIGHT)
            fromFrameEnd = fromFrame.offsetBy(dx: 0, dy: SCREEN_HEIGHT)
        }
        else if self.panDirection == .verticalUp {
            toFrame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
            fromFrame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
            
            toFrameEnd = toFrame.offsetBy(dx: 0, dy: -SCREEN_HEIGHT)
            fromFrameEnd = fromFrame.offsetBy(dx: 0, dy: -SCREEN_HEIGHT)
        }
        else {
            assert(false)
            //不是上下左右的界面切换，进入或者退出二级页面
//            let index = toViewController.navigationController!.viewControllers.index(of: toViewController)!
//            let isCenter = toViewController.navigationController!.viewControllers[0] === toViewController
//            || fromViewController.navigationController!.viewControllers[0] === fromViewController
//            let minIndex = isCenter ? 0 : 1
//            if index > minIndex {
//                toFrame = CGRect(x: SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
//                fromFrame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
//                
//                toFrameEnd = toFrame.offsetBy(dx: -SCREEN_WIDTH, dy: 0)
//                fromFrameEnd = fromFrame.offsetBy(dx: -SCREEN_WIDTH, dy: 0)
//            }
//            else {
//                toFrame = CGRect(x: -SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
//                fromFrame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
//                
//                toFrameEnd = toFrame.offsetBy(dx: SCREEN_WIDTH, dy: 0)
//                fromFrameEnd = fromFrame.offsetBy(dx: SCREEN_WIDTH, dy: 0)
//
//            }
        }
        
        
        toViewController.view.frame = toFrame
        fromViewController.view.frame = fromFrame
        
        //let finalFrame = transitionContext.finalFrame(for: toViewController)
        let fromDelegate = fromViewController as? PageTransitionDelegate
        fromDelegate?.onTransitionStart(forKey: UITransitionContextViewControllerKey.from, direction: self.panDirection)
        
        let toDelegate = toViewController as? PageTransitionDelegate
        toDelegate?.onTransitionStart(forKey: UITransitionContextViewControllerKey.to, direction: self.panDirection)
        

        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: .transitionCurlDown, animations: { 
            fromViewController.view.frame = fromFrameEnd
            toViewController.view.frame  = toFrameEnd
            
            fromDelegate?.onTransitionEnd(forKey: UITransitionContextViewControllerKey.from, direction: self.panDirection)
            toDelegate?.onTransitionEnd(forKey: UITransitionContextViewControllerKey.to, direction: self.panDirection)
        }) { (isCompleted) in
            if transitionContext.transitionWasCancelled {
                transitionContext.cancelInteractiveTransition()
            }
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    

}
