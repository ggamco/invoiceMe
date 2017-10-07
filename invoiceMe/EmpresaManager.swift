//
//  EmpresaManager.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 30/6/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import Foundation

extension Empresa {
    
    func toJSON() -> [String : Any] {
        return [
            "nombre" : self.nombre!,
            "direccion" : self.direccion!,
            "zipCode" : Int(self.cpostal!)!,
            "ciudad" : self.ciudad!,
            "cif" : self.cif!,
            "email" : self.email!
        ]
    }
    
}
