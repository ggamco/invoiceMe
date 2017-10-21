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
    var servicioProducto: API_ServicioProductoBase?
    // MARK: - Variables Locales
    var productos: [ProductoBase]?
    var indexProductosSeleccionados : [Int] = []
    var productosSeleccionados: [ProductoBase] = []
    
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
        servicioProducto = API_ServicioProductoBase(contexto: contexto)
        cargarProductos()
        cargarArraySeleccionados()
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
    
    func cargarArraySeleccionados() {
        if let productosDes = productos {
            for (index, producto) in productosDes.enumerated() {
                if productosSeleccionados.contains(producto){
                    indexProductosSeleccionados.append(index)
                }
            }
        }
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
            cell.myTitulo.text = producto.titulo
            
            if indexProductosSeleccionados.count > 0 {
                if indexProductosSeleccionados.contains(indexPath.row) {
                    cell.accessoryType = .checkmark
                    cell.tintColor = CONSTANTES.COLORES.PRIMARY_COLOR_DARK
                } else {
                    cell.accessoryType = .checkmark
                    cell.tintColor = UIColor.lightGray
                }
            } else {
                cell.accessoryType = .checkmark
                cell.tintColor = UIColor.lightGray
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editar = UITableViewRowAction(style: .normal, title: "Editar") { (action, indexPath) in
            let destinoVC = self.storyboard?.instantiateViewController(withIdentifier: "VistaProductoTVC") as! IME_VistaProductoTVC
            destinoVC.producto = self.productos?[indexPath.row]
            destinoVC.esActualizacion = true
            destinoVC.esAgregacion = true
            destinoVC.title = "Editar Producto"
            
            // IMPORTANT!
            // Este es el que funciona para ocultar el titulo del back buttom item
            self.navigationItem.backBarButtonItem?.title = ""
            
            self.navigationController?.pushViewController(destinoVC, animated: true)
        }
        return [editar]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexProductosSeleccionados.contains(indexPath.row) {
            let index = indexProductosSeleccionados.index(of: indexPath.row)
            indexProductosSeleccionados.remove(at: index!)
        } else {
            indexProductosSeleccionados.append(indexPath.row)
        }
        print(indexProductosSeleccionados)
        self.tableView.reloadData()
    }
}

//MARK: - Extensión de UINavigationControllerDelegate
//USADO PARA DEVOLVER DATOS AL VIEWCONTROLLER ANTERIOR

extension IME_ListaProductosTVC: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        if let destinoVC = viewController as? IME_CrearDocumentoTVC {
            productosSeleccionados.removeAll()
            for index in indexProductosSeleccionados {
                //productosSeleccionados.append(productos![index])
            }
            //destinoVC.productos = productosSeleccionados
            destinoVC.arrayIndexProductos = indexProductosSeleccionados
        }
    }
    
}
