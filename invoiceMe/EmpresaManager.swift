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
            "nombre" : dimeString(self.nombre),
            "direccion" : dimeString(self.direccion),
            "zipCode" : convertirToEntero(self.cpostal),
            "ciudad" : dimeString(self.ciudad),
            "cif" : dimeString(self.cif),
            "email" : dimeString(self.email)
        ]
    }
    
}
