//
//  DetalleProyectoTVC.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 7/10/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit

class IME_DetalleProyectoTVC: UITableViewController {

    // MARK: - Variables locales
    var proyecto: Proyecto? = nil
    var facturas: [Factura] = []
    var hayFacturas = false
    
    @IBAction func editarProyecto(_ sender: UIBarButtonItem) {
        let destinoVC = storyboard?.instantiateViewController(withIdentifier: "CrearProyectoNuevoTVC") as! IME_CrearProyectoNuevoTVC
        
        destinoVC.proyecto = proyecto
        destinoVC.esActualizacion = true
        destinoVC.title = "Editar Proyecto"
        
        // IMPORTANT!
        // Este es el que funciona para ocultar el titulo del back buttom item
        self.navigationItem.backBarButtonItem?.title = ""
        
        self.navigationController?.pushViewController(destinoVC, animated: true)
    }
    // MARK: - LIFE VC
    override func viewDidLoad() {
        super.viewDidLoad()
        if let facturasDes = proyecto?.facturas?.allObjects as? [Factura]{
            facturas = facturasDes
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rows = proyecto?.facturas?.count{
            if rows > 0 {
                hayFacturas = true
                return rows + 2
            }
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath) as! IME_TituloProyectoCustomCell
            cell.myNombreEmpresa.text = proyecto?.empresa?.uppercased()
            cell.myTituloProyecto.text = proyecto?.nombre?.uppercased()
            cell.backgroundColor = CONSTANTES.COLORES.ARRAY_COLORES[Int((proyecto?.cliente?.color)!)]
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "staticCell", for: indexPath)
            if !hayFacturas {
                cell.textLabel?.text = "NO HAY FACTURAS"
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "facturaCell", for: indexPath) as! IME_MasterFacturasCustomCell
            if facturas.count > 0{
                cell.myTituloFactura.text = facturas[indexPath.row - 2].nombre
                cell.myBotonEstado.layer.cornerRadius = 5
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 1:
            return 120
        default:
            return 44
        }
    }

}
