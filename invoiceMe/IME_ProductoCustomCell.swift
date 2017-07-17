//
//  IME_ProductoCustomCell.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 9/7/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit

class IME_ProductoCustomCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var myCodigo: UILabel!
    @IBOutlet weak var myTitulo: UILabel!
    @IBOutlet weak var myPrecio: UILabel!
    @IBOutlet weak var myCantidad: UILabel!
    @IBOutlet weak var myStepper: UIStepper!
    
    @IBAction func aumentarCantidad(_ sender: UIStepper) {
        myCantidad.text = String(sender.value)
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
