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
            "numeroDocumento" : Int(self.numeroDocumento),
            "logo" : self.logo!,
            "emisor" : self.emisor.map({$0.toJSON()})!,
            "receptor" : self.receptor.map({$0.toJSON()})!,
            "listaProductos" : (self.productos?.allObjects as! [Producto]).map({ (model) -> [String : Any] in
                return model.toJSON()
            })
        ]
    }
    
}
