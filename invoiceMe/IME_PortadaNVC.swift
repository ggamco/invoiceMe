//
//  IME_PortadaNVC.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 25/6/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit
import InteractiveSideMenu

class IME_PortadaNVC: UINavigationController, SideMenuItemContent {
    
}

class InnerViewController: UIViewController {
    
    @IBAction func openMenu(_ sender: Any) {
        if let navigationViewController = self.navigationController as? SideMenuItemContent {
            navigationViewController.showSideMenu()
        }
    }
}
