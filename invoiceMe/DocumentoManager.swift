//
//  DocumentoManager.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 30/6/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import Foundation

extension Documento {
    
    func toJSON() -> [String : Any] {
        
        return [
            "tipoDocumento" : Int(self.tipoDocumento),
            "numeroDocumento" : String(self.numeroDocumento),
            "sufijoDocumento" : self.sufijoDocumento!,
            "fechaEmision": dimeString(self.fechaEmision),
            "fechaValidez": dimeString(self.fechaValidez),
            "logo" : self.logo!,
            "nota" : dimeString(self.nota),
            "emisor" : self.emisor.map({$0.toJSON()})!,
            "receptor" : self.receptor.map({$0.toJSON()})!,
            "listaProductos" : (self.productos?.allObjects as! [Producto]).map({ (model) -> [String : Any] in
                return model.toJSON()
            })
        ]
    }
    
}
