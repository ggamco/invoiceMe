//
//  CustomOverlayView.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 24/9/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit

class CustomOverlayView: UIView {

    @IBOutlet weak var circleOverlay: UIView!
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        circleOverlay.layer.cornerRadius = circleOverlay.frame.width / 2
        circleOverlay.layer.borderWidth = 4
        circleOverlay.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    

}
