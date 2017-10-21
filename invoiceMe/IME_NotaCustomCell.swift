//
//  IME_NotaCustomCell.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 21/10/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit

class IME_NotaCustomCell: UITableViewCell {

    // MARK: - Delegado
    var delegate: CellInfoDelegate?
    
    // MARK: - IBOutlets
    @IBOutlet weak var myNotaText: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        myNotaText.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

// MARK: - Extension del delegado UITExtViewDelegate
extension IME_NotaCustomCell: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if let nota = textView.text {
            delegate?.documentoAlmacenado?.nota = nota
            delegate?.informarDatos("NOTA")
        }
    }
}
