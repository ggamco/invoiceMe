//
//  IME_FechaValidezCustomCell.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 21/10/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit

class IME_FechaValidezCustomCell: UITableViewCell {
    
    // MARK: - Delegado
    var delegate: CellInfoDelegate?
    
    //MARK: - Elementos visuales Personalizados
    let datapicker = UIDatePicker()
    let format = DateFormatter()
    
    //MARK: - Variables Locales
    var fecha: Date?
    
    // MARK: - IBOutlets
    @IBOutlet weak var myFechaValidez: UITextField!
    @IBOutlet weak var myFechaValidezSW: UISwitch!
    
    // MARK: - IBActions
    @IBAction func activarFechaValidez(_ sender: UISwitch) {
        if sender.isOn {
            myFechaValidez.isEnabled = true
            myFechaValidez.textColor = UIColor.darkGray
        } else {
            myFechaValidez.isEnabled = false
            myFechaValidez.textColor = UIColor.lightGray
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
        myFechaValidez.layer.cornerRadius = 5
        myFechaValidezSW.onTintColor = CONSTANTES.COLORES.PRIMARY_COLOR
        //CONFIGURACIONES VARIAS
        format.dateFormat = "dd/MM/yyyy"
        myFechaValidez.delegate = self
        //CONFIGURAMOS LA CARGA DEL DATAPICKER
        datapicker.datePickerMode = UIDatePickerMode.date
        datapicker.locale = Locale(identifier: "es_ES")
        myFechaValidez.inputView = datapicker
        datapicker.addTarget(self, action: #selector(setFechaLabel), for: UIControlEvents.valueChanged)
    }
    
    func setFechasIniciales() {
        fecha = datapicker.date
        myFechaValidez.text = format.string(from: fecha!)
        if myFechaValidezSW.isOn {
            myFechaValidez.textColor = UIColor.darkGray
        } else {
            myFechaValidez.textColor = UIColor.lightGray
        }
    }
    
    @objc func setFechaLabel(_ dp: UIDatePicker){
        fecha = datapicker.date
        myFechaValidez.text = format.string(from: fecha!)
    }

}

// MARK: - Extensión de UITextFieldDelegate
extension IME_FechaValidezCustomCell: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if myFechaValidezSW.isOn {
            if let fecha = textField.text {
                delegate?.documentoAlmacenado?.fechaValidez = fecha
                delegate?.informarDatos("FECHA VALIDEZ")
            }
        }
    }
}
