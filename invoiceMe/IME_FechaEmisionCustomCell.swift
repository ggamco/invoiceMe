//
//  IME_FechaEmisionCustomCell.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 21/10/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit

class IME_FechaEmisionCustomCell: UITableViewCell {

    // MARK: - Delegado
    var delegate: CellInfoDelegate?
    
    // MARK: - Elementos visuales Personalizados
    let datapicker = UIDatePicker()
    let format = DateFormatter()
    
    // MARK: - Variables Locales
    var fecha: Date?
    
    // MARK: - IBOutlets
    @IBOutlet weak var myFechaEmision: UITextField!
    @IBOutlet weak var myFechaEmisionSW: UISwitch!
    
    // MARK: - IBActions
    @IBAction func activarFechaEmision(_ sender: UISwitch) {
        if sender.isOn {
            myFechaEmision.isEnabled = true
            myFechaEmision.textColor = UIColor.darkGray
        } else {
            myFechaEmision.isEnabled = false
            myFechaEmision.textColor = UIColor.lightGray
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configuracionesVarias()
        setFechasIniciales()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Funciones Propias
    
    func configuracionesVarias() {
        //CONFIGURACIONES ESTETICAS VARIAS
        myFechaEmision.layer.cornerRadius = 5
        myFechaEmisionSW.onTintColor = CONSTANTES.COLORES.PRIMARY_COLOR
        //CONFIGURACIONES VARIAS
        format.dateFormat = "dd/MM/yyyy"
        myFechaEmision.delegate = self
        //CONFIGURAMOS LA CARGA DEL DATAPICKER
        datapicker.datePickerMode = UIDatePickerMode.date
        datapicker.locale = Locale(identifier: "es_ES")
        myFechaEmision.inputView = datapicker
        datapicker.addTarget(self, action: #selector(setFechaLabel), for: UIControlEvents.valueChanged)
    }
    
    func setFechasIniciales() {
        fecha = datapicker.date
        myFechaEmision.text = format.string(from: fecha!)
        if myFechaEmisionSW.isOn {
            myFechaEmision.textColor = UIColor.darkGray
        } else {
            myFechaEmision.textColor = UIColor.lightGray
        }
    }
    
    @objc func setFechaLabel(_ dp: UIDatePicker){
        fecha = datapicker.date
        myFechaEmision.text = format.string(from: fecha!)
    }

}

// MARK: - Extensión de UITextFieldDelegate
extension IME_FechaEmisionCustomCell: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if myFechaEmisionSW.isOn {
            if let fecha = textField.text {
                delegate?.documentoAlmacenado?.fechaEmision = fecha
                delegate?.informarDatos("FECHA EMISION")
            }
        }
    }
}
