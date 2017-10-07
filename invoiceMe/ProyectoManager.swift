//
//  ProyectoManager.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 30/6/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import Foundation

extension Proyecto {
    
    func toJSON() -> [String : Any] {
        return [
            "nombre" : self.nombre!,
            "empresa" : self.empresa!,
            "descripcion" : self.descripcionCorta!,
            "facturadoHoras" : self.facturadoHoras,
            "estimadasHoras" : self.horasEstimadas,
            "precioHoras" : self.precioHora,
            "tipoFacturacion" : Int(self.tipoFacturacion),
            "fechaInicio" : self.fechaInicio!,
            "fechaFinal" : self.fechaFinal!,
            "receptor" : self.cliente.map({$0.toJSON()})!
        ]
    }
    
}
