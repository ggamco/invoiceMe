//
//  API_ServicioProductoBase.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 1/7/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import CoreData

class API_ServicioProductoBase {
    
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
                       iva: Double,
                       irpf: Double,
                       exentoIva: Bool,
                       exentoIrpf: Bool) -> ProductoBase {
        
        let nuevoProducto = NSEntityDescription.insertNewObject(forEntityName: "ProductoBase", into: contexto) as! ProductoBase
        
        nuevoProducto.codigo = codigo
        nuevoProducto.titulo = titulo
        nuevoProducto.descripcion = descripcion
        nuevoProducto.iva = iva
        nuevoProducto.irpf = irpf
        nuevoProducto.exentoIva = exentoIva
        nuevoProducto.exentoIrpf = exentoIrpf
        
        return nuevoProducto
        
    }
    
    //MARK: - Buscar Producto
    
    //Buscar Producto por ObjectID
    func buscarProducto(by id: NSManagedObjectID) -> ProductoBase? {
        
        return contexto.object(with: id) as? ProductoBase
        
    }
    
    //Buscar Producto usando sentencias propias
    //Ejemplos de sentencias validas:
    // - NSPredicate(format: "nombre == %@", "NombreBuscado")
    // - NSPredicate(format: "nombre contains %@", "NombreBuscado")
    func buscarProducto(byQuery query: NSPredicate) -> [ProductoBase] {
        
        var resultadoBusqueda: [ProductoBase] = []
        
        let peticion: NSFetchRequest = ProductoBase.fetchRequest()
        peticion.predicate = query
        
        do{
            resultadoBusqueda = try contexto.fetch(peticion)
        }catch let error as NSError {
            print(error)
        }
        
        return resultadoBusqueda
        
    }
    
    //MARK: - Recuperar todas los Productos
    func recuperarProductos() -> [ProductoBase] {
        var resultadoBusqueda: [ProductoBase] = []
        
        resultadoBusqueda = buscarProducto(byQuery: NSPredicate(value: true))
        
        return resultadoBusqueda
    }
    
    //MARK: - Actualizar Producto
    func actualizarProducto(productoActualizado: ProductoBase) {
        
        if let producto = buscarProducto(by: productoActualizado.objectID) {
            producto.codigo = productoActualizado.codigo
            producto.titulo = productoActualizado.titulo
            producto.descripcion = productoActualizado.descripcion
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
