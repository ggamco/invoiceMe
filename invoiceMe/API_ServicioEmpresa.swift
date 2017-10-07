//
//  API_ServicioEmpresa.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 12/3/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import CoreData

class API_ServicioEmpresa {

    //Contexto de la aplicación necesario para almacenar datos en CoreData
    var contexto: NSManagedObjectContext
    
    //Constructor, inicializa con el contexto de la app
    init(contexto: NSManagedObjectContext){
        self.contexto = contexto
    }
    
    //MARK: - Crear Empresa
    func crearEmpresa(nombre: String, color: Int16, direccion: String, cpostal: String, ciudad: String, cif: String, email: String, telefono: String) -> Empresa {
        
        let nuevaEmpresa = NSEntityDescription.insertNewObject(forEntityName: "Empresa", into: contexto) as! Empresa
        
        nuevaEmpresa.nombre = nombre
        nuevaEmpresa.color = color
        nuevaEmpresa.direccion = direccion
        nuevaEmpresa.cpostal = cpostal
        nuevaEmpresa.ciudad = ciudad
        nuevaEmpresa.cif = cif
        nuevaEmpresa.email = email
        nuevaEmpresa.telefono = telefono
        
        
        return nuevaEmpresa
        
    }
    
    //MARK: - Buscar Empresas
    
    //Buscar Empresa por ObjectID
    func buscarEmpresa(by id: NSManagedObjectID) -> Empresa? {
        
        return contexto.object(with: id) as? Empresa
        
    }
    
    //Buscar Empresa usando sentencias propias
    //Ejemplos de sentencias validas:
    // - NSPredicate(format: "nombre == %@", "NombreBuscado")
    // - NSPredicate(format: "nombre contains %@", "NombreBuscado")
    func buscarEmpresa(byQuery query: NSPredicate) -> [Empresa] {
        
        var resultadoBusqueda: [Empresa] = []
        
        let peticion: NSFetchRequest = Empresa.fetchRequest()
        peticion.predicate = query
        
        do{
            resultadoBusqueda = try contexto.fetch(peticion)
        }catch let error as NSError {
            print(error)
        }
        
        return resultadoBusqueda
        
    }
    
    //MARK: - Recuperar todas las empresas
    func recuperarEmpresas() -> [Empresa] {
        var resultadoBusqueda: [Empresa] = []
        
        resultadoBusqueda = buscarEmpresa(byQuery: NSPredicate(value: true))
        
        return resultadoBusqueda
    }
    
    //MARK: - Actualizar empresa
    func actualizarEmpresa(empresaActualizada: Empresa) {
        
        if let empresa = buscarEmpresa(by: empresaActualizada.objectID) {
            empresa.nombre = empresaActualizada.nombre
            empresa.color = empresaActualizada.color
            empresa.direccion = empresaActualizada.direccion
            empresa.cpostal = empresaActualizada.cpostal
            empresa.ciudad = empresaActualizada.ciudad
            empresa.cif = empresaActualizada.cif
            empresa.email = empresaActualizada.email
            empresa.telefono = empresaActualizada.telefono
        }
        
    }
    
    //MARK: - Eliminar empresa
    func eliminarEmpresa(by id: NSManagedObjectID){
        if let empresaEliminada = buscarEmpresa(by: id){
            contexto.delete(empresaEliminada)
        }
    }
 
}
