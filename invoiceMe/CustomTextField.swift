//
//  CustomTextField.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 9/7/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 5
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 8, 0, 8))
    }
 
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 8, 0, 8))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 8, 0, 8))
    }
}
