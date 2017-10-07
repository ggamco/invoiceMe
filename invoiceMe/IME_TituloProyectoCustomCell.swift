//
//  IME_TituloProyectoCustomCell.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 7/10/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit

class IME_TituloProyectoCustomCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var myImagenView: UIImageView!
    @IBOutlet weak var myTituloProyecto: UILabel!
    @IBOutlet weak var myNombreEmpresa: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
