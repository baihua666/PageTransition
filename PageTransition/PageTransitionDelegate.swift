
import UIKit

protocol PageTransitionDelegate: class {
    func onTransitionStart(forKey key: UITransitionContextViewControllerKey, direction: PanDirection)
    func onTransitionEnd(forKey key: UITransitionContextViewControllerKey, direction: PanDirection)
}
