//
//  IME_BotonCustomCell.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 21/10/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit

class IME_BotonCustomCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var myBotonAddConcepto: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        insertarIconoBTN()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func insertarIconoBTN() {
        let origImage = UIImage(named: "plus")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        myBotonAddConcepto.setImage(tintedImage, for: .normal)
        myBotonAddConcepto.tintColor = CONSTANTES.COLORES.PRIMARY_COLOR
    }
}
