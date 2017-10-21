//
//  IME_FechaEmisionCustomCell.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 21/10/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit

class IME_FechaEmisionCustomCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var myFechaEmision: UITextField!
    @IBOutlet weak var myFechaEmisionSW: UISwitch!
    
    // MARK: - IBActions
    @IBAction func activarFechaEmision(_ sender: UISwitch) {
        if sender.isOn {
            myFechaEmision.isEnabled = true
            myFechaEmision.textColor = UIColor.darkText
        } else {
            myFechaEmision.isEnabled = false
            myFechaEmision.textColor = UIColor.lightText
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
