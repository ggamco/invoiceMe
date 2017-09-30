//
//  IME_FacturasTVC.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 29/9/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit

class IME_FacturasTVC: UITableViewController {

    // MARK: - Variables locales
    var proyecto:Proyecto?
    var empresaSeleccionada = 0
    var seccionSeleccionada = 0
    
    @IBAction func CrearDocumentoAction(_ sender: Any) {
        let actionVC = muestraActionSheet(titulo: "Elija una opción:", mensaje: "¿Qué tipo de documento quiere crear?")
        present(actionVC, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let backTable = UIImageView(frame: self.tableView.bounds)
        backTable.contentMode = .scaleAspectFill
        backTable.image = #imageLiteral(resourceName: "placeHolderTable")
        self.tableView.backgroundView = backTable
        self.tableView.separatorStyle = .none
    }

    // MARK: - Utils
    func muestraActionSheet (titulo: String, mensaje: String) -> UIAlertController {
        let destinoVC = storyboard?.instantiateViewController(withIdentifier: "CrearDocumentoTVC") as! IME_CrearDocumentoTVC
        destinoVC.receptor = self.proyecto?.cliente
        
        let navigationController = UINavigationController(rootViewController: destinoVC)
        let alertVC = UIAlertController(title: titulo, message: mensaje, preferredStyle: .actionSheet)
        let alertActionPresupuesto = UIAlertAction(title: "Presupuesto", style: .default) { (action) in
            destinoVC.navigationController?.navigationBar.topItem?.title = "Crear Presupuesto"
            destinoVC.tipoDocumentoDeseado = 0
            self.navigationController?.modalPresentationStyle = .currentContext
            self.present(navigationController, animated: true, completion: nil)
        }
        let alertActionFactura = UIAlertAction(title: "Factura", style: .default) { (action) in
            destinoVC.navigationController?.navigationBar.topItem?.title = "Crear Factura"
            destinoVC.tipoDocumentoDeseado = 1
            self.navigationController?.modalPresentationStyle = .currentContext
            self.present(navigationController, animated: true, completion: nil)
        }
        alertVC.addAction(alertActionPresupuesto)
        alertVC.addAction(alertActionFactura)
        return alertVC
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
