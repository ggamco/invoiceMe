//
//  API_ServicioProyecto.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 13/3/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import CoreData

class API_ServicioProyecto {

    //Contexto de la aplicación necesario para almacenar datos en CoreData
    var contexto: NSManagedObjectContext
    
    //Constructor, inicializa con el contexto de la app
    init(contexto: NSManagedObjectContext){
        self.contexto = contexto
    }
    
    //MARK: - Crear Proyecto
    func crearProyecto(nombre: String, empresa: String, tipoFacturacion: Int16, facturadoHoras: Bool, horasEstimadas: String, precioHora: String, fechaInicio: String, fechaFinal: String, descripcionCorta: String) -> Proyecto {
        
        let nuevoProyecto = NSEntityDescription.insertNewObject(forEntityName: "Proyecto", into: contexto) as! Proyecto
        
        nuevoProyecto.nombre = nombre
        nuevoProyecto.empresa = empresa
        nuevoProyecto.descripcionCorta = descripcionCorta
        nuevoProyecto.tipoFacturacion = Int16(tipoFacturacion)
        nuevoProyecto.facturadoHoras = facturadoHoras
        
        if facturadoHoras {
            if let estimadas = Double(horasEstimadas) {
                nuevoProyecto.horasEstimadas = estimadas
            }
            if let precio = Double(precioHora) {
                nuevoProyecto.precioHora = precio
            }
        }
        
        nuevoProyecto.fechaInicio = fechaInicio
        nuevoProyecto.fechaFinal = fechaFinal
        
        return nuevoProyecto
        
    }
    
    //MARK: - Buscar Proyecto
    
    //Buscar Proyecto por ObjectID
    func buscarProyecto(by id: NSManagedObjectID) -> Proyecto? {
        
        return contexto.object(with: id) as? Proyecto
        
    }
    
    //Buscar Proyecto usando sentencias propias
    //Ejemplos de sentencias validas:
    // - NSPredicate(format: "nombre == %@", "NombreBuscado")
    // - NSPredicate(format: "nombre contains %@", "NombreBuscado")
    func buscarProyecto(byQuery query: NSPredicate) -> [Proyecto] {
        
        var resultadoBusqueda: [Proyecto] = []
        
        let peticion: NSFetchRequest = Proyecto.fetchRequest()
        peticion.predicate = query
        
        do{
            resultadoBusqueda = try contexto.fetch(peticion)
        }catch let error as NSError {
            print(error)
        }
        
        return resultadoBusqueda
        
    }
    
    //MARK: - Recuperar todas las proyectos
    func recuperarProyectos() -> [Proyecto] {
        var resultadoBusqueda: [Proyecto] = []
        
        resultadoBusqueda = buscarProyecto(byQuery: NSPredicate(value: true))
        resultadoBusqueda.sort{ $0.empresa! > $1.empresa!}
        
        return resultadoBusqueda
    }
    
    //MARK: - Actualizar proyecto
    func actualizarProyecto(proyectoActualizado: Proyecto) {
        
        if let proyecto = buscarProyecto(by: proyectoActualizado.objectID) {
            proyecto.nombre = proyectoActualizado.nombre
            proyecto.empresa = proyectoActualizado.empresa
            proyecto.descripcionCorta = proyectoActualizado.descripcionCorta
            proyecto.tipoFacturacion = proyectoActualizado.tipoFacturacion
            proyecto.facturadoHoras = proyectoActualizado.facturadoHoras
            proyecto.horasEstimadas = proyectoActualizado.horasEstimadas
            proyecto.fechaInicio = proyectoActualizado.fechaInicio
            proyecto.fechaFinal = proyectoActualizado.fechaFinal
        }
        
    }
    
    //MARK: - Eliminar proyecto
    func eliminarProyecto(by id: NSManagedObjectID){
        if let proyectoEliminado = buscarProyecto(by: id){
            contexto.delete(proyectoEliminado)
        }
    }
    
}
