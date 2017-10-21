//
//  IME_CrearDocumentoDynamicTVC.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 21/10/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit

class IME_CrearDocumentoDynamicTVC: UITableViewController {

    // MARK: - Variables locales
    var productosSeleccionado: [Producto] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numeroConceptos = productosSeleccionado.count
        switch section {
        case 0:
            return 2
        case 1:
            return 4
        case 2:
            return numeroConceptos + 1
        default:
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellEmisor", for: indexPath) as! IME_InfoCustomCell
            if indexPath.row == 0 {
                cell.myTitleLabel.text = "Emisor"
                cell.myNombreEmisorTF.text = ""
                return cell
            } else {
                cell.myTitleLabel.text = "Receptor"
                cell.myNombreEmisorTF.text = ""
                return cell
            }
        case 1:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellNumero", for: indexPath) as! IME_NumeroCustomCell
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellFechaEmision", for: indexPath) as! IME_FechaEmisionCustomCell
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellFechaValidez", for: indexPath) as! IME_FechaValidezCustomCell
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellNota", for: indexPath) as! IME_NotaCustomCell
                return cell
            }
        default:
            <#code#>
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellEmisor", for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "información"
        case 1:
            return "datos documento"
        case 2:
            return "conceptos"
        default:
            return "desconocido"
        }
    }

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
