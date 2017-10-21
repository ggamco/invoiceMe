//
//  IME_SeleccionProductosTVC.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 20/10/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit
import CoreData

class IME_SeleccionProductosTVC: UITableViewController {

    // MARK: - Variables locales
    let contexto = CoreDataStack.shared.persistentContainer.viewContext
    var productosBase: [ProductoBase]?
    var productos: [Producto]?
    var servicioProductoBase: API_ServicioProductoBase?
    var servicioProducto: API_ServicioProducto?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //IMPORTANTE
        //ESTAS LINEAS ELIMINAN EL TITULO AL BACKBUTTON
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
        //COLOCARLAS SIEMPRE EN EL PADRE
        servicioProducto = API_ServicioProducto(contexto: contexto)
        servicioProductoBase = API_ServicioProductoBase(contexto: contexto)
        cargarProductos()
        //cargarArraySeleccionados()
    }
    
    //MARK: - FUNCIONES PROPIAS
    func cargarProductos() {
        productos = servicioProducto?.recuperarProductos()
        productosBase = servicioProductoBase?.recuperarProductos()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let productosBaseDes = productosBase {
            return productosBaseDes.count
        }
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
