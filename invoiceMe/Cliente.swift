//
//  Clientes.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 28/2/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit

class Clientes: NSObject {

    var nombreEmpresa: String?
    var colorCorporativo: UIColor?
    var direccionFiscal: String?
    var codigoPostal: String?
    var ciudad: String?
    var cif: String?
    var email: String?
    var telefono: String?
    
    init(nombre: String, color: UIColor, direccion: String, cp: String, ciudad: String, cif: String, email: String, telefono: String){
        
        self.nombreEmpresa = nombre
        self.colorCorporativo = color
        self.direccionFiscal = direccion
        self.codigoPostal = cp
        self.ciudad = ciudad
        self.cif = cif
        self.email = email
        self.telefono = telefono
        
    }
    
}
