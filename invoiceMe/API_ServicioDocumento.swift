//
//  API_ServicioDocumento.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 1/7/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import CoreData

class ServicioDocumento {
    
    //Contexto de la aplicación necesario para almacenar datos en CoreData
    var contexto: NSManagedObjectContext
    
    //Constructor, inicializa con el contexto de la app
    init(contexto: NSManagedObjectContext){
        self.contexto = contexto
    }
    
    //MARK: - Crear Documento
    func crearDocumento() -> Documento {
        let nuevoDocumento = NSEntityDescription.insertNewObject(forEntityName: "Documento", into: contexto) as! Documento
        return nuevoDocumento
    }
    
    func crearDocumento(tipoDocumento: Int,
                        numeroDocumento: Int32,
                        sujijo: String,
                        fechaEmison: String,
                        fechaValidez: String,
                        nota: String,
                        logo: String) -> Documento {
        
        let nuevoDocumento = NSEntityDescription.insertNewObject(forEntityName: "Documento", into: contexto) as! Documento
        
        nuevoDocumento.tipoDocumento = Int16(tipoDocumento)
        nuevoDocumento.numeroDocumento = numeroDocumento
        nuevoDocumento.sufijoDocumento = sujijo
        nuevoDocumento.logo = logo
        nuevoDocumento.fechaEmision = fechaEmison
        nuevoDocumento.fechaValidez = fechaValidez
        nuevoDocumento.nota = nota
        
        return nuevoDocumento
    }
    
    //MARK: - Buscar Documento
    
    //Buscar Documento por ObjectID
    func buscarDocumento(by id: NSManagedObjectID) -> Documento? {
        
        return contexto.object(with: id) as? Documento
        
    }
    
    //Buscar Documento usando sentencias propias
    //Ejemplos de sentencias validas:
    // - NSPredicate(format: "nombre == %@", "NombreBuscado")
    // - NSPredicate(format: "nombre contains %@", "NombreBuscado")
    func buscarDocumento(byQuery query: NSPredicate) -> [Documento] {
        
        var resultadoBusqueda: [Documento] = []
        
        let peticion: NSFetchRequest = Documento.fetchRequest()
        peticion.predicate = query
        
        do{
            resultadoBusqueda = try contexto.fetch(peticion)
        }catch let error as NSError {
            print(error)
        }
        
        return resultadoBusqueda
        
    }
    
    //MARK: - Recuperar todos los documentos
    func recuperarDocumentos() -> [Documento] {
        var resultadoBusqueda: [Documento] = []
        
        resultadoBusqueda = buscarDocumento(byQuery: NSPredicate(value: true))
        //resultadoBusqueda.sort{ $0.numeroDocumento > $1.numeroDocumento}
        
        return resultadoBusqueda
    }
    
    //MARK: - Actualizar Documento
    func actualizarDocumento(documentoActualizado: Documento) {
        
        if let documento = buscarDocumento(by: documentoActualizado.objectID) {
            documento.tipoDocumento = Int16(documentoActualizado.tipoDocumento)
            documento.numeroDocumento = Int32(documentoActualizado.numeroDocumento)
            documento.sufijoDocumento = documentoActualizado.sufijoDocumento
            documento.logo = documentoActualizado.logo
            documento.emisor = documentoActualizado.emisor
            documento.receptor = documentoActualizado.receptor
            documento.productos = documentoActualizado.productos
            documento.fechaEmision = documentoActualizado.fechaEmision
            documento.fechaValidez = documentoActualizado.fechaValidez
            documento.nota = documentoActualizado.nota
        }
        
    }
    
    //MARK: - Eliminar Documento
    func eliminarDocumento(by id: NSManagedObjectID){
        if let documentoEliminado = buscarDocumento(by: id){
            contexto.delete(documentoEliminado)
        }
    }
}
