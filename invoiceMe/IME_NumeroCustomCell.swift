//
//  IME_NumeroCustomCell.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 21/10/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit

class IME_NumeroCustomCell: UITableViewCell {

    // MARK: - Delegado
    var delegate: CellInfoDelegate?
    
    // MARK: - IBOutlets
    @IBOutlet weak var myNumeroDocumento: UITextField!
    @IBOutlet weak var mySufijoDocumento: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        myNumeroDocumento.layer.cornerRadius = 5
        mySufijoDocumento.layer.cornerRadius = 5
        myNumeroDocumento.delegate = self
        mySufijoDocumento.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}//FIN DE LA CLASE

extension IME_NumeroCustomCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            if let numero = textField.text {
                delegate?.documentoAlmacenado?.numeroDocumento = Int32(numero)!
                delegate?.informarDatos("NUMERO")
            }
        default:
            if let sufijo = textField.text {
                delegate?.documentoAlmacenado?.sufijoDocumento = sufijo
                delegate?.informarDatos("SUFIJO")
            }
        }
    }
}
