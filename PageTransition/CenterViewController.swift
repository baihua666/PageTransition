
import UIKit

class CenterViewController: UIViewController {
    
    @IBOutlet var leftBtn: UIButton!
    @IBOutlet var rightBtn: UIButton!
    
    var leftBtnStartFrame: CGRect!
    var leftBtnEndFrame: CGRect!
    
    var rightBtnStartFrame: CGRect!
    var rightBtnEndFrame: CGRect!
    
    
    deinit {
        print("CenterViewController deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("CenterViewController viewDidLoad")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("CenterViewController viewWillAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("CenterViewController viewWillDisappear")
        
        if self.leftBtnStartFrame == nil {
            self.leftBtnStartFrame = self.leftBtn.frame
            let targetLeft = (SCREEN_WIDTH - self.leftBtnStartFrame.size.width)/2
            self.leftBtnEndFrame = self.leftBtnStartFrame.offsetBy(dx: targetLeft - self.leftBtnStartFrame.origin.x, dy: 0)
        }
        
    }
    

    @IBAction func onLeftBtnClick(_ sender: Any) {
        if let navigationDelegate = self.navigationController?.delegate as? NavigationControllerDelegate {
            navigationDelegate.transition(to: .left, animated: true)
        }
    }
    
    @IBAction func onRightBtnClick(_ sender: Any) {
        if let navigationDelegate = self.navigationController?.delegate as? NavigationControllerDelegate {
            navigationDelegate.transition(to: .right, animated: true)
        }
    }

    @IBAction func onBottomBtnClick(_ sender: Any) {
        if let navigationDelegate = self.navigationController?.delegate as? NavigationControllerDelegate {
            navigationDelegate.transition(to: .bottom, animated: true)
        }
    }
    

    @IBAction func onPushBtnClick(_ sender: Any) {
        let controller: Right1ViewController = ControllerHelper.default.instantiateViewController(withIdentifier: "right1ViewController") as! Right1ViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}

extension CenterViewController: PageTransitionDelegate {
    func onTransitionStart(forKey key: UITransitionContextViewControllerKey, direction: PanDirection) {
        if direction != .verticalUp && direction != .verticalDown {
            return
        }
        
        if key == UITransitionContextViewControllerKey.from {
            self.leftBtn.frame = self.leftBtnStartFrame
        }
        else {
            self.leftBtn.frame = self.leftBtnEndFrame
        }
    }
    
    func onTransitionEnd(forKey key: UITransitionContextViewControllerKey, direction: PanDirection) {
        if direction != .verticalUp && direction != .verticalDown {
            return
        }
        
        if key == UITransitionContextViewControllerKey.from {
            self.leftBtn.frame = self.leftBtnEndFrame
        }
        else {
            self.leftBtn.frame = self.leftBtnStartFrame
        }
    }
}
