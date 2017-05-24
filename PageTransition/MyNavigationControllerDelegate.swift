//
//  MyNavigationControllerDelegate.swift
//  PageTransition
//
//  Created by yyf on 2017/5/24.
//  Copyright © 2017年 leo. All rights reserved.
//

import UIKit

class MyNavigationControllerDelegate: NavigationControllerDelegate {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.centerViewController = self.navigationController!.viewControllers[0]
        
        
        self.leftViewController = ControllerHelper.default.makeTestViewController(positon: .left)
        
        self.rightViewController = ControllerHelper.default.makeTestViewController(positon: .right)
        
        self.topViewController = ControllerHelper.default.makeTestViewController(positon: .top)
        
        self.bottomViewController = ControllerHelper.default.makeTestViewController(positon: .bottom)

    }
    
}
