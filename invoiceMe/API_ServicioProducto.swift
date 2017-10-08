//
//  API_ServicioProducto.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 1/7/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import CoreData

class API_ServicioProducto {
    
    //Contexto de la aplicación necesario para almacenar datos en CoreData
    var contexto: NSManagedObjectContext
    
    //Constructor, inicializa con el contexto de la app
    init(contexto: NSManagedObjectContext){
        self.contexto = contexto
    }
    
    //MARK: - Crear Producto
    func crearProducto(codigo: String,
                       titulo: String,
                       descripcion: String,
                       cantidad: Float,
                       precio: Float,
                       iva: Float,
                       irpf: Float,
                       exentoIva: Bool,
                       exentoIrpf: Bool) -> Producto {
        
        let nuevoProducto = NSEntityDescription.insertNewObject(forEntityName: "Producto", into: contexto) as! Producto
        
        nuevoProducto.codigo = codigo
        nuevoProducto.titulo = titulo
        nuevoProducto.descripcion = descripcion
        nuevoProducto.cantidad = cantidad
        nuevoProducto.precio = precio
        nuevoProducto.iva = iva
        nuevoProducto.irpf = irpf
        nuevoProducto.exentoIva = exentoIva
        nuevoProducto.exentoIrpf = exentoIrpf
        
        return nuevoProducto
        
    }
    
    //MARK: - Buscar Producto
    
    //Buscar Producto por ObjectID
    func buscarProducto(by id: NSManagedObjectID) -> Producto? {
        
        return contexto.object(with: id) as? Producto
        
    }
    
    //Buscar Producto usando sentencias propias
    //Ejemplos de sentencias validas:
    // - NSPredicate(format: "nombre == %@", "NombreBuscado")
    // - NSPredicate(format: "nombre contains %@", "NombreBuscado")
    func buscarProducto(byQuery query: NSPredicate) -> [Producto] {
        
        var resultadoBusqueda: [Producto] = []
        
        let peticion: NSFetchRequest = Producto.fetchRequest()
        peticion.predicate = query
        
        do{
            resultadoBusqueda = try contexto.fetch(peticion)
        }catch let error as NSError {
            print(error)
        }
        
        return resultadoBusqueda
        
    }
    
    //MARK: - Recuperar todas los Productos
    func recuperarProductos() -> [Producto] {
        var resultadoBusqueda: [Producto] = []
        
        resultadoBusqueda = buscarProducto(byQuery: NSPredicate(value: true))
        
        return resultadoBusqueda
    }
    
    //MARK: - Actualizar Producto
    func actualizarProducto(productoActualizado: Producto) {
        
        if let producto = buscarProducto(by: productoActualizado.objectID) {
            producto.codigo = productoActualizado.codigo
            producto.titulo = productoActualizado.titulo
            producto.descripcion = productoActualizado.descripcion
            producto.cantidad = productoActualizado.cantidad
            producto.precio = productoActualizado.precio
            producto.iva = productoActualizado.iva
            producto.irpf = productoActualizado.irpf
            producto.exentoIva = productoActualizado.exentoIva
            producto.exentoIrpf = productoActualizado.exentoIrpf
        }
        
    }
    
    //MARK: - Eliminar Producto
    func eliminarProducto(by id: NSManagedObjectID){
        if let documentoEliminado = buscarProducto(by: id){
            contexto.delete(documentoEliminado)
        }
    }
}
