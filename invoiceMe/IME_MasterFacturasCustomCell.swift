//
//  IME_MasterFacturasCustomCell.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 7/10/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit

class IME_MasterFacturasCustomCell: UITableViewCell {

    //Variables
    var documentos: [Documento] = []
    var parentViewController: UIViewController? = nil
    
    //IBOutlets
    @IBOutlet weak var myTituloFactura: UILabel!
    @IBOutlet weak var myBotonEstado: UIButton!
    @IBOutlet weak var myTipoView: UIView!
    @IBOutlet weak var myTipoDocumentoLabel: UILabel!
    
    //IBAction
    @IBAction func verDocumento(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let servicioVC = storyboard.instantiateViewController(withIdentifier: "ServicioWebVC") as! IME_ServicioWebVC
        servicioVC.documento = documentos[sender.tag]
        let navigation = UINavigationController(rootViewController: servicioVC)
        parentViewController?.present(navigation, animated: true, completion: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        myTipoView.layer.cornerRadius = myTipoView.frame.width / 2
        myBotonEstado.backgroundColor = CONSTANTES.COLORES.DIVIDER_COLOR
        myBotonEstado.setTitleColor(CONSTANTES.COLORES.NAV_ITEMS, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
