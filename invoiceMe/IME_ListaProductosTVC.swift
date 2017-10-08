//
//  IME_ListaProductosTVC.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 9/7/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit
import CoreData

class IME_ListaProductosTVC: UITableViewController {

    //MARK: - Objetos propios COREDATA
    let contexto = CoreDataStack.shared.persistentContainer.viewContext
    var servicioProducto: API_ServicioProducto?
    // MARK: - Variables Locales
    var productos: [Producto]?
    
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
        servicioProducto = API_ServicioProducto(contexto: contexto)
        cargarProductos()
    }
    
    //Usamos este metodo propio del ciclo de vida del VC para cargar datos siempre que vuelva a visualizarse
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        productos = servicioProducto?.recuperarProductos()
        tableView.reloadData()
        //Asignamos el delegate
        navigationController?.delegate = self
        
        if productos?.count == 0 {
            emptyTable(self.tableView)
        } else {
            resetTableUI(self.tableView)
        }
    }
    
    //MARK: - FUNCIONES PROPIAS
    func cargarProductos() {
        productos = servicioProducto?.recuperarProductos()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rows = productos?.count {
            return rows
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaProducto", for: indexPath) as! IME_ProductoCustomCell
        if let producto = productos?[indexPath.row] {
            cell.myCodigo.text = producto.codigo
            cell.myPrecio.text = String(format: "%.2f",producto.precio)
            cell.myTitulo.text = producto.titulo
            cell.myCantidad.text = String(format: "%.2f", producto.cantidad)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let destinoVC = storyboard?.instantiateViewController(withIdentifier: "VistaProductoTVC") as! IME_VistaProductoTVC
        
        destinoVC.producto = productos?[indexPath.row]
        destinoVC.esActualizacion = true
        destinoVC.title = "Editar Producto"
        
        // IMPORTANT!
        // Este es el que funciona para ocultar el titulo del back buttom item
        self.navigationItem.backBarButtonItem?.title = ""
        
        self.navigationController?.pushViewController(destinoVC, animated: true)
        
    }
}

//MARK: - Extensión de UINavigationControllerDelegate
//USADO PARA DEVOLVER DATOS AL VIEWCONTROLLER ANTERIOR

extension IME_ListaProductosTVC: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        
    }
    
}
