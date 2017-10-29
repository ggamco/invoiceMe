//
//  IME_ListaProductosDocumentoTVC.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 22/10/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit

class IME_ListaProductosDocumentoTVC: UITableViewController {

    //MARK: - Objetos propios COREDATA
    let contexto = CoreDataStack.shared.persistentContainer.viewContext
    var servicioProductoBase: API_ServicioProductoBase?
    var servicioProducto: API_ServicioProducto?
    
    // MARK: - Variables Locales
    var productosBase: [ProductoBase]?
    var productos: [Producto]?
    //var indexProductosSeleccionados : [Int] = []
    //var productosSeleccionados: [ProductoBase] = []
    
    @IBAction func crearProductoAction(_ sender: UIBarButtonItem) {
        let destinoVC = storyboard?.instantiateViewController(withIdentifier: "VistaProductoTVC") as! IME_VistaProductoTVC
        destinoVC.esActualizacion = false
        let navigationController = UINavigationController(rootViewController: destinoVC)
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cerrarVentana))
        self.navigationController?.modalPresentationStyle = .currentContext
        self.present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - Utils
    @objc func cerrarVentana() {
        dismiss(animated: true, completion: nil)
    }
    // MARK: - LIFE VC
    override func viewDidLoad() {
        super.viewDidLoad()
        //IMPORTANTE
        //ESTAS LINEAS ELIMINAN EL TITULO AL BACKBUTTON
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
        //COLOCARLAS SIEMPRE EN EL PADRE
        servicioProductoBase = API_ServicioProductoBase(contexto: contexto)
        servicioProducto = API_ServicioProducto(contexto: contexto)
        //cargarProductos()
        //cargarArraySeleccionados()
    }
    
    //Usamos este metodo propio del ciclo de vida del VC para cargar datos siempre que vuelva a visualizarse
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        productosBase = servicioProductoBase?.recuperarProductos()
        //productos = servicioProducto?.recuperarProductos()
        tableView.reloadData()
        //Asignamos el delegate
        //navigationController?.delegate = self
        
        if productosBase?.count == 0 {
            emptyTable(self.tableView)
        } else {
            resetTableUI(self.tableView)
        }
    }
    
    //MARK: - FUNCIONES PROPIAS
    /*
    func cargarProductos() {
        productosBase = servicioProductoBase?.recuperarProductos()
    }
    */

    /*
    func cargarArraySeleccionados() {
        if let productosDes = productosBase {
            for (index, producto) in productosDes.enumerated() {
                if productosSeleccionados.contains(producto){
                    indexProductosSeleccionados.append(index)
                }
            }
        }
    }
    */
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rows = productosBase?.count {
            return rows
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaProducto", for: indexPath) as! IME_ProductoCustomCell
        if let producto = productosBase?[indexPath.row] {
            cell.myCodigo.text = producto.codigo
            cell.myTitulo.text = producto.titulo
            cell.myIVA.text = String(format: "%.2f", producto.iva)
            cell.myIRPF.text = String(format: "%.2f", producto.irpf)
            /*
             if indexProductosSeleccionados.count > 0 {
             if indexProductosSeleccionados.contains(indexPath.row) {
             cell.tintColor = CONSTANTES.COLORES.PRIMARY_COLOR_DARK
             } else {
             cell.tintColor = UIColor.lightGray
             }
             } else {
             cell.tintColor = UIColor.lightGray
             }
             */
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let eliminar = UITableViewRowAction(style: .default, title: "Eliminar") { (action, indexPath) in
            let alertVC = UIAlertController(title: "Atención", message: "Si elimina este producto eliminará todos los productos relacionados en sus documentos. ¿Está seguro?", preferredStyle: .alert)
            let alertActionOK = UIAlertAction(title: "Si", style: .destructive) { (action) in
                let productoEliminado = self.productosBase![indexPath.row]
                let predicate = NSPredicate(format: "ANY productoBase == %@", productoEliminado)
                if let productosConBase = self.servicioProducto?.buscarProducto(byQuery: predicate) {
                    for pro in productosConBase {
                        self.servicioProducto?.eliminarProducto(by: pro.objectID)
                    }
                }
                self.servicioProductoBase?.eliminarProducto(by: productoEliminado.objectID)
                self.productosBase?.remove(at: indexPath.row)
                do {
                    try self.contexto.save()
                    self.tableView.reloadData()
                }catch let error {
                    print("Error: \(error.localizedDescription)")
                }
            }
            alertVC.addAction(alertActionOK)
            let alertActionKO = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alertVC.addAction(alertActionKO)
            self.present(alertVC, animated: true, completion: nil)
        }
        return [eliminar]
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinoVC = self.storyboard?.instantiateViewController(withIdentifier: "CrearProductoDocumentoTVC") as! IME_CrearProductoDocumentoTVC
        destinoVC.productoBase = self.productosBase?[indexPath.row]
        destinoVC.esAgregacion = true
        self.navigationController?.pushViewController(destinoVC, animated: true)
    }
}
