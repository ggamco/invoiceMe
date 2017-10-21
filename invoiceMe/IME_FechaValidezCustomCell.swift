//
//  IME_FechaValidezCustomCell.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 21/10/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit

class IME_FechaValidezCustomCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var myFechaValidez: UITextField!
    @IBOutlet weak var myFechaValidezSW: UISwitch!
    
    // MARK: - IBActions
    @IBAction func activarFechaValidez(_ sender: UISwitch) {
        if sender.isOn {
            myFechaValidez.isEnabled = true
            myFechaValidez.textColor = UIColor.darkText
        } else {
            myFechaValidez.isEnabled = false
            myFechaValidez.textColor = UIColor.lightText
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
