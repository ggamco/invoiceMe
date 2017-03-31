//
//  Empresa+CoreDataProperties.swift
//  
//
//  Created by Gustavo Gamboa on 14/3/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Empresa {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Empresa> {
        return NSFetchRequest<Empresa>(entityName: "Empresa");
    }

    @NSManaged public var cif: String?
    @NSManaged public var ciudad: String?
    @NSManaged public var color: Int16
    @NSManaged public var cpostal: String?
    @NSManaged public var direccion: String?
    @NSManaged public var email: String?
    @NSManaged public var nombre: String?
    @NSManaged public var telefono: String?
    @NSManaged public var proyectos: NSSet?

}

// MARK: Generated accessors for proyectos
extension Empresa {

    @objc(addProyectosObject:)
    @NSManaged public func addToProyectos(_ value: Proyecto)

    @objc(removeProyectosObject:)
    @NSManaged public func removeFromProyectos(_ value: Proyecto)

    @objc(addProyectos:)
    @NSManaged public func addToProyectos(_ values: NSSet)

    @objc(removeProyectos:)
    @NSManaged public func removeFromProyectos(_ values: NSSet)

}
