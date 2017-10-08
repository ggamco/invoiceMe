//
//  IME_DetalleProyectoVC.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 8/10/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit
import CoreData

class IME_DetalleProyectoVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Variables locales
    var proyecto: Proyecto? = nil
    var documentos: [Documento] = []
    var hayFacturas = false
    
    // MARK: - CoreData
    let contexto = CoreDataStack.shared.persistentContainer.viewContext
    var servicioDocumento: ServicioDocumento?
    
    // MARK: - IBOutlets
    @IBOutlet weak var myTituloProyecto: UILabel!
    @IBOutlet weak var myEmpresaNombre: UILabel!
    @IBOutlet weak var myDocumentosLabel: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    
    // MARK: - IBActions
    @IBAction func editarProyecto(_ sender: UIBarButtonItem) {
        let destinoVC = storyboard?.instantiateViewController(withIdentifier: "CrearProyectoNuevoTVC") as! IME_CrearProyectoNuevoTVC
        
        destinoVC.proyecto = proyecto
        destinoVC.esActualizacion = true
        destinoVC.title = "Editar Proyecto"
        
        // IMPORTANT!
        // Este es el que funciona para ocultar el titulo del back buttom item
        self.navigationItem.backBarButtonItem?.title = ""
        
        let navigationController = UINavigationController(rootViewController: destinoVC)
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cerrarVentana))
        
        self.navigationController?.modalPresentationStyle = .currentContext
        self.present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - LIFE VC
    override func viewDidLoad() {
        super.viewDidLoad()
        if let documentosDes = proyecto?.documentos?.allObjects as? [Documento]{
            documentos = documentosDes
        }
        myTableView.delegate = self
        myTableView.dataSource = self
        myTituloProyecto.text = proyecto?.nombre
        myEmpresaNombre.text = proyecto?.cliente?.nombre
        servicioDocumento = ServicioDocumento(contexto: contexto)
    }
    
    // MARK: - Utils
    @objc func cerrarVentana() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rows = proyecto?.documentos?.count{
            if rows > 0 {
                hayFacturas = true
                self.myTableView.separatorStyle = .singleLine
                myDocumentosLabel.text = "LISTADO DE DOCUMENTOS"
                return rows
            } else {
                self.myTableView.separatorStyle = .none
                myDocumentosLabel.text = "NO HAY DOCUMENTOS"
                return 0
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "facturaCell", for: indexPath) as! IME_MasterFacturasCustomCell
        if documentos.count > 0{
            let tipoDocumento = documentos[indexPath.row].tipoDocumento
            let numero = String(format: "%04d", documentos[indexPath.row].numeroDocumento)
            let sufijo = dimeString(documentos[indexPath.row].sufijoDocumento)
            cell.myTituloFactura.text = numero + " - " + sufijo
            cell.myBotonEstado.layer.cornerRadius = 5
            switch tipoDocumento{
            case 0:
                cell.myBotonEstado.setTitle("PRESUPUESTO", for: .normal)
                cell.myBotonEstado.backgroundColor = CONSTANTES.COLORES.PRESUPUESTO
            default:
                cell.myBotonEstado.setTitle("FACTURA", for: .normal)
                cell.myBotonEstado.backgroundColor = CONSTANTES.COLORES.FACTURA
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let borrarAction = UITableViewRowAction(style: .destructive, title: "Borrar") { (action, indexPath) in
            self.servicioDocumento?.eliminarDocumento(by: self.documentos[indexPath.row].objectID)
            self.documentos.remove(at: indexPath.row)
            do {
                try self.contexto.save()
            } catch let error {
                print(error.localizedDescription)
            }
            self.myTableView.reloadData()
        }
        return [borrarAction]
    }

}
