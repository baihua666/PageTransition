//
//  ControllerHelper.swift
//  PageTransition
//
//  Created by yyf on 2017/5/24.
//  Copyright © 2017年 leo. All rights reserved.
//

import UIKit

class ControllerHelper: NSObject {
    lazy var mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
    
    public static let `default`: ControllerHelper = {
        return ControllerHelper()
    }()
    
    public func makeTestViewController(positon: Position) -> UIViewController {
        switch positon {
        case .left:
            return self.mainStoryBoard.instantiateViewController(withIdentifier: "leftViewController")
            
        case .right:
            return self.mainStoryBoard.instantiateViewController(withIdentifier: "rightViewController")
            
        case .top:
            return self.mainStoryBoard.instantiateViewController(withIdentifier: "topViewController")
            
        case .bottom:
            return self.mainStoryBoard.instantiateViewController(withIdentifier: "bottomViewController")
            
        default:
            return UIViewController()
        }
    }
    
    public func instantiateViewController(withIdentifier: String) -> UIViewController {
        return self.mainStoryBoard.instantiateViewController(withIdentifier: withIdentifier)
    }
}
