//
//  Proyecto+CoreDataProperties.swift
//  
//
//  Created by Gustavo Gamboa on 14/3/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Proyecto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Proyecto> {
        return NSFetchRequest<Proyecto>(entityName: "Proyecto");
    }

    @NSManaged public var nombre: String?
    @NSManaged public var empresa: String?
    @NSManaged public var tipoFacturacion: Int16
    @NSManaged public var facturadoHoras: Bool
    @NSManaged public var horasEstimadas: Double
    @NSManaged public var precioHora: Double
    @NSManaged public var fechaInicio: String?
    @NSManaged public var fechaFinal: String?
    @NSManaged public var cliente: Empresa?

}
