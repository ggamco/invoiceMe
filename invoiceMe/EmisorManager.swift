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
            "nombre" : self.nombre!,
            "direccion" : self.direccion!,
            "zipCode" : self.zipCode,
            "ciudad" : self.ciudad!,
            "cif" : self.cif!,
            "iban" : self.iban!,
            "email": self.email!,
            "telefono": self.telefono!
        ]
    }
    
}
