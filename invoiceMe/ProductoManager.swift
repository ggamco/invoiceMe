//
//  ProductoManager.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 30/6/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import Foundation

extension Producto {
    
    func toJSON() -> [String : Any] {
        
        return [
            "codigo" : self.codigo!,
            "descripcion" : self.descripcion!,
            "cantidad" : self.cantidad,
            "precio" : self.precio,
            "IVA" : self.iva,
            "IRPF" : self.irpf,
            "exentoIVA" : self.exentoIva,
            "exentoIRPF" : self.exentoIrpf
        ]
        
    }
    
}
