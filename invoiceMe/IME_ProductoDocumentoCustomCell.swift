//
//  IME_ProductoDocumentoCustomCell.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 21/10/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit

class IME_ProductoDocumentoCustomCell: UITableViewCell {

    // MARK: - Delegado
    var delegate: CellInfoDelegate?
    
    // MARK: - IBOutlets
    @IBOutlet weak var myCodigo: UILabel!
    @IBOutlet weak var myTitulo: UILabel!
    @IBOutlet weak var myPrecio: UILabel!
    @IBOutlet weak var myCantidad: UILabel!
    @IBOutlet weak var myExentoIVA: UILabel!
    @IBOutlet weak var myExentoIRPF: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
