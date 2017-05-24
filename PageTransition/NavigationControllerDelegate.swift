

import UIKit

enum Position {
    case center
    case top
    case bottom
    case left
    case right
    case undefined
}


enum PanDirection {
    case undefined
    case horizontalRight
    case horizontalLeft
    case verticalUp
    case verticalDown
}


class NavigationControllerDelegate: NSObject {
    @IBOutlet weak var navigationController: UINavigationController?
    
    var interactionController: UIPercentDrivenInteractiveTransition?
    
    var leftViewController: UIViewController!
    
    var rightViewController: UIViewController!
    
    var topViewController: UIViewController!
    
    var bottomViewController: UIViewController!
    
    var centerViewController: UIViewController!
    
    fileprivate var panDirection = PanDirection.undefined
    fileprivate var targetPosition = Position.undefined
    fileprivate var currPosition = Position.center
    
    //被禁用的视图位置
    var invaliadatePositionArray: [Position] = [.top]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panned(_:)))
        self.navigationController!.view.addGestureRecognizer(panGesture)
        
        
    }
    
    func isTransitionController() -> Bool {
        let topController = self.navigationController!.viewControllers.last!
        
        let isTransitionController = topController === self.leftViewController
            || topController === self.topViewController
            || topController === self.rightViewController
            || topController === self.bottomViewController
            || topController === self.centerViewController
        return isTransitionController
    }
    
    func panned(_ gestureRecognizer: UIPanGestureRecognizer) {
        let canTransition = self.isTransitionController()
        
        
        if self.panDirection == .undefined && !canTransition {
            return
        }
        
        switch gestureRecognizer.state {
        case .began:
            
            break
            
        case .changed:
            let translationInMainView = gestureRecognizer.translation(in: self.navigationController!.view)
            
            var newDirection: PanDirection!
            if self.panDirection == .undefined {
                if fabs(translationInMainView.x) > fabs(translationInMainView.y) {
                    newDirection = translationInMainView.x > 0 ? .horizontalRight : .horizontalLeft
                    
                }
                else {
                    newDirection = translationInMainView.y > 0 ? .verticalDown : .verticalUp
                    
                }
                let shouldPanResult = self.shouldPanDirectionUpdate(from: self.panDirection, to: newDirection)
                let isValiadateDirection = shouldPanResult.0
                if isValiadateDirection {
                    self.panDirection = newDirection
                    self.onTargetPositionUpdate(from: self.targetPosition, to: shouldPanResult.1, animated: true)
                    
                }
            }
            
            
            if self.panDirection == .horizontalLeft || self.panDirection == .horizontalRight {
                let completionProgress = fabs(translationInMainView.x/self.navigationController!.view.bounds.width)
                self.interactionController?.update(completionProgress)
            }
            else if self.panDirection == .verticalDown || self.panDirection == .verticalUp {
                let completionProgress = fabs(translationInMainView.y/self.navigationController!.view.bounds.height)
                self.interactionController?.update(completionProgress)
            }
            
            
        case .ended:
            let velocity = gestureRecognizer.velocity(in: self.navigationController!.view)
            var needFinish = false
            if (self.panDirection == .horizontalRight && velocity.x > 0)
                || (self.panDirection == .horizontalLeft && velocity.x < 0)
                || (self.panDirection == .verticalDown && velocity.y > 0)
                || (self.panDirection == .verticalUp && velocity.y < 0) {
                needFinish = true
            }
            
            self.onPanEnded(needFinish: needFinish)
            
        default:
            self.interactionController?.cancel()
            self.interactionController = nil
        }
        
        
        
    }
    
    fileprivate func onPanEnded(needFinish: Bool) {
        if needFinish {
            self.interactionController?.finish()
            self.currPosition = self.targetPosition
        } else {
            self.interactionController?.cancel()
        }
        self.interactionController = nil
        self.targetPosition = .undefined
        self.panDirection = .undefined
    }
    
    func shouldPanDirectionUpdate(from oldDirection: PanDirection, to newDirection: PanDirection) -> (Bool, Position) {
        if oldDirection == newDirection {
            return (false, .undefined)
        }
        
        var tarPosion: Position! = .undefined
        var isValiadateDirection = true
        switch newDirection {
        case .horizontalLeft:
            if self.currPosition == .right {
                isValiadateDirection = false
            }
            else if self.currPosition == .center {
                tarPosion = .right
            }
            else if self.currPosition == .left {
                tarPosion = .center
            }
            else {
                isValiadateDirection = false
            }
            
        case .horizontalRight:
            if self.currPosition == .left {
                isValiadateDirection = false
            }
            else if self.currPosition == .center {
                tarPosion = .left
            }
            else if self.currPosition == .right {
                tarPosion = .center
            }
            else {
                isValiadateDirection = false
            }
            
        case .verticalDown:
            if self.currPosition == .top {
                isValiadateDirection = false
            }
            else if self.currPosition == .center {
                tarPosion = .top
            }
            else if self.currPosition == .bottom {
                tarPosion = .center
            }
            else {
                isValiadateDirection = false
            }
            
        case .verticalUp:
            if self.currPosition == .bottom {
                isValiadateDirection = false
            }
            else if self.currPosition == .center {
                tarPosion = .bottom
            }
            else if self.currPosition == .top {
                tarPosion = .center
            }
            else {
                isValiadateDirection = false
            }
            
            
        default:
            break
        }
        
        if isValiadateDirection && self.invaliadatePositionArray.contains(tarPosion) {
            isValiadateDirection = false
        }
        
        return (isValiadateDirection, tarPosion)
    }
    
    func onTargetPositionUpdate(from oldPosition: Position, to newPosition: Position, animated: Bool) {
        if oldPosition == newPosition {
            return
        }
        guard let navigationController = self.navigationController else {
            return
        }
        
        self.interactionController = UIPercentDrivenInteractiveTransition()
        
        switch newPosition {
        case .undefined:
            assert(navigationController.viewControllers.count > 1)
            navigationController.popViewController(animated: animated)
            
        case .center:
            assert(navigationController.viewControllers.count > 1)
            navigationController.popViewController(animated: animated)
            
        case .left:
            assert(navigationController.viewControllers.count == 1)
            navigationController.pushViewController(self.leftViewController, animated: animated)
            
        case .right:
            assert(navigationController.viewControllers.count == 1)
            navigationController.pushViewController(self.rightViewController, animated: animated)
            
        case .bottom:
            assert(navigationController.viewControllers.count == 1)
            navigationController.pushViewController(self.bottomViewController, animated: animated)
            
        case .top:
            navigationController.pushViewController(self.topViewController, animated: animated)
        }
        
        self.targetPosition = newPosition
    }
    
    func transition(to position: Position, animated: Bool) {
        var newDirection: PanDirection!
        switch position {
        case .left:
            newDirection = .horizontalRight
        case .right:
            newDirection = .horizontalLeft
        case .bottom:
            newDirection = .verticalUp
        case .top:
            newDirection = .verticalDown
        default:
            assert(false)
            break
        }
        
        let shouldPanResult = self.shouldPanDirectionUpdate(from: self.panDirection, to: newDirection)
        let isValiadateDirection = shouldPanResult.0
        
        if isValiadateDirection {
            self.panDirection = newDirection
            self.onTargetPositionUpdate(from: self.targetPosition, to: shouldPanResult.1, animated: animated)
            self.onPanEnded(needFinish: true)
        }
        
        //self.onTargetPositionUpdate(from: self.targetPosition, to: position)
    }
}


// MARK: - UINavigationControllerDelegate
extension NavigationControllerDelegate: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let isLiveCenter = (self.centerViewController === fromVC && (toVC === self.leftViewController || toVC === self.topViewController || toVC === self.rightViewController || toVC === self.bottomViewController))
        let isToCenter = (self.centerViewController === toVC && (fromVC === self.leftViewController || fromVC === self.topViewController || fromVC === self.rightViewController || fromVC === self.bottomViewController))
        if !isLiveCenter && !isToCenter {
            return nil
        }
        let pageAnimator = PageTransitionAnimator()
        pageAnimator.panDirection = self.panDirection
        return pageAnimator
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactionController
    }
}
