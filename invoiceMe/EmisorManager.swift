//
//  EmisorManager.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 30/6/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import Foundation

extension Emisor {
    
    func toJSON() -> [String : Any] {
        return [
            "nombre" : dimeString(self.nombre),
            "direccion" : dimeString(self.direccion),
            "zipCode" : dimeInt(self.zipCode),
            "ciudad" : dimeString(self.ciudad),
            "cif" : dimeString(self.cif),
            "iban" : dimeString(self.iban),
            "email": dimeString(self.email),
            "telefono": dimeString(self.telefono)
        ]
    }
    
}
