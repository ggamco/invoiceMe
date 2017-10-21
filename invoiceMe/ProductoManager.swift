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
            "codigo" : dimeString(self.productoBase?.codigo),
            "descripcion" : dimeString(self.productoBase?.descripcion),
            "cantidad" : self.cantidad,
            "precio" : self.precio,
            "IVA" : dimeDouble(self.productoBase?.iva),
            "IRPF" : dimeDouble(self.productoBase?.irpf),
            "exentoIVA" : dimeBool(self.productoBase?.exentoIva),
            "exentoIRPF" : dimeBool(self.productoBase?.exentoIrpf)
        ]
        
    }
    
}
