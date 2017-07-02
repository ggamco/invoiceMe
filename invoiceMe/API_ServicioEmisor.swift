//
//  API_ServicioEmisor.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 1/7/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import CoreData

class ServicioEmisor {
    
    //Contexto de la aplicación necesario para almacenar datos en CoreData
    var contexto: NSManagedObjectContext
    
    //Constructor, inicializa con el contexto de la app
    init(contexto: NSManagedObjectContext){
        self.contexto = contexto
    }
    
    //MARK: - Crear Emisor
    func crearEmisor(nombre: String,
                     fecha: String,
                     direccion: String,
                     zipCode: Int,
                     ciudad: String,
                     cif: String,
                     iban: String) -> Emisor {
        
        let nuevoEmisor = NSEntityDescription.insertNewObject(forEntityName: "Emisor", into: contexto) as! Emisor
        
        nuevoEmisor.nombre = nombre
        nuevoEmisor.fecha = fecha
        nuevoEmisor.direccion = direccion
        nuevoEmisor.zipCode = Int16(zipCode)
        nuevoEmisor.ciudad = ciudad
        nuevoEmisor.cif = cif
        nuevoEmisor.iban = iban
        
        return nuevoEmisor
        
    }
    
    //MARK: - Buscar Emisor
    
    //Buscar Emisor por ObjectID
    func buscarEmisor(by id: NSManagedObjectID) -> Emisor? {
        
        return contexto.object(with: id) as? Emisor
        
    }
    
    //Buscar Emisor usando sentencias propias
    //Ejemplos de sentencias validas:
    // - NSPredicate(format: "nombre == %@", "NombreBuscado")
    // - NSPredicate(format: "nombre contains %@", "NombreBuscado")
    func buscarEmisor(byQuery query: NSPredicate) -> [Emisor] {
        
        var resultadoBusqueda: [Emisor] = []
        
        let peticion: NSFetchRequest = Emisor.fetchRequest()
        peticion.predicate = query
        
        do{
            resultadoBusqueda = try contexto.fetch(peticion)
        }catch let error as NSError {
            print(error)
        }
        
        return resultadoBusqueda
        
    }
    
    //MARK: - Recuperar todos los emisores
    func recuperarEmisores() -> [Emisor] {
        var resultadoBusqueda: [Emisor] = []
        
        resultadoBusqueda = buscarEmisor(byQuery: NSPredicate(value: true))
        
        return resultadoBusqueda
    }
    
    //MARK: - Actualizar Emisor
    func actualizarEmisor(emisorActualizado: Emisor) {
        
        if let emisor = buscarEmisor(by: emisorActualizado.objectID) {
            emisor.nombre = emisorActualizado.nombre
            emisor.fecha = emisorActualizado.fecha
            emisor.direccion = emisorActualizado.direccion
            emisor.zipCode = Int16(emisorActualizado.zipCode)
            emisor.ciudad = emisorActualizado.ciudad
            emisor.cif = emisorActualizado.cif
            emisor.iban = emisorActualizado.iban
        }
        
    }
    
    //MARK: - Eliminar Emisor
    func eliminarProyecto(by id: NSManagedObjectID){
        if let emisorEliminado = buscarEmisor(by: id){
            contexto.delete(emisorEliminado)
        }
    }
}
