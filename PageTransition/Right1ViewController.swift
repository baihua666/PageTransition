

import UIKit

class Right1ViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onBackBtnClick(_ sender: Any) {
        if let rootController = self.navigationController?.viewControllers[0], rootController === self {
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            view.window!.layer.add(transition, forKey: kCATransition)
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }

   

}
