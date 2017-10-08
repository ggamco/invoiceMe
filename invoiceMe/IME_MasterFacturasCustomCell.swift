//
//  IME_MasterFacturasCustomCell.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 7/10/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit

class IME_MasterFacturasCustomCell: UITableViewCell {

    @IBOutlet weak var myTituloFactura: UILabel!
    @IBOutlet weak var myBotonEstado: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
