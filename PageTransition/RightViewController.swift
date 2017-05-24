

import UIKit

class RightViewController: UIViewController {
    
    
    deinit {
        print("RightViewController deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("RightViewController viewDidLoad")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("RightViewController viewWillAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("RightViewController viewWillDisappear")
    }
    
    
    @IBAction func onPushBtnClick(_ sender: Any) {
        let controller: Right1ViewController = ControllerHelper.default.instantiateViewController(withIdentifier: "right1ViewController") as! Right1ViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func onPush1BtnClick(_ sender: Any) {
        let controller: Right1ViewController = ControllerHelper.default.instantiateViewController(withIdentifier: "right1ViewController") as! Right1ViewController
        let naviController = UINavigationController(rootViewController: controller)
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        self.navigationController?.present(naviController, animated: false, completion: nil)
    }

}
