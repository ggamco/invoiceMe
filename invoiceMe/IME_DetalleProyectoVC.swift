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
    @IBOutlet weak var botonAddDocumento: UIButton!
    
    // MARK: - IBActions
    @IBAction func editarProyecto(_ sender: UIBarButtonItem) {
        let destinoVC = storyboard?.instantiateViewController(withIdentifier: "CrearProyectoNuevoTVC") as! IME_CrearProyectoNuevoTVC
        
        destinoVC.proyecto = proyecto
        destinoVC.esActualizacion = true
        destinoVC.title = "Editar Proyecto"
        
        let navigationController = UINavigationController(rootViewController: destinoVC)
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cerrarVentana))
        
        self.navigationController?.modalPresentationStyle = .currentContext
        self.present(navigationController, animated: true, completion: nil)
    }
    @IBAction func addDocumento(_ sender: UIButton) {
        let actionVC = self.muestraActionSheet(titulo: "Elija una opción:",
                                               mensaje: "¿Qué tipo de documento quiere crear?",
                                               proyecto: proyecto!)
        self.present(actionVC, animated: true, completion: nil)
    }
    
    // MARK: - LIFE VC
    override func viewDidLoad() {
        super.viewDidLoad()
        insertarIconoBTN()
        myTableView.delegate = self
        myTableView.dataSource = self
        myTituloProyecto.text = proyecto?.nombre
        myEmpresaNombre.text = proyecto?.cliente?.nombre
        servicioDocumento = ServicioDocumento(contexto: contexto)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let documentosDes = proyecto?.documentos?.allObjects as? [Documento]{
            documentos = documentosDes
        }
        self.myTableView.reloadData()
    }
    
    // MARK: - Utils
    @objc func cerrarVentana() {
        dismiss(animated: true, completion: nil)
    }
    
    func insertarIconoBTN() {
        let origImage = UIImage(named: "plus")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        botonAddDocumento.setImage(tintedImage, for: .normal)
        botonAddDocumento.tintColor = CONSTANTES.COLORES.PRIMARY_COLOR
    }
    
    func muestraActionSheet (titulo: String, mensaje: String, proyecto: Proyecto) -> UIAlertController {
        let destinoVC = storyboard?.instantiateViewController(withIdentifier: "CrearDocumentoDynamicTVC") as! IME_CrearDocumentoDynamicTVC
        destinoVC.receptor = proyecto.cliente
        destinoVC.proyecto = proyecto
        
        let navigationController = UINavigationController(rootViewController: destinoVC)
        navigationController.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cerrarVentana))
        
        
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
        let alertActionCancelar = UIAlertAction(title: "Cancelar", style: .cancel) { (action) in
        }
        alertVC.addAction(alertActionPresupuesto)
        alertVC.addAction(alertActionFactura)
        alertVC.addAction(alertActionCancelar)
        return alertVC
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
                cell.myTipoDocumentoLabel.text = "P"
                cell.myTipoView.backgroundColor = CONSTANTES.COLORES.PRESUPUESTO
            default:
                cell.myTipoDocumentoLabel.text = "F"
                cell.myTipoView.backgroundColor = CONSTANTES.COLORES.FACTURA
            }
            cell.myBotonEstado.tag = indexPath.row
            cell.documentos = documentos
            cell.parentViewController = self
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinoVC = self.storyboard?.instantiateViewController(withIdentifier: "CrearDocumentoDynamicTVC") as! IME_CrearDocumentoDynamicTVC
        destinoVC.navigationItem.title = "Editar Documento"
        destinoVC.documentoAlmacenado = documentos[indexPath.row]
        destinoVC.esActualizacion = true
        //ESTAS LINEAS ELIMINAN EL TITULO AL BACKBUTTON
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
        //COLOCARLAS SIEMPRE EN EL PADRE
        self.navigationController?.pushViewController(destinoVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    @objc func verDocumento(_ index: IndexPath) {
        let servicioPDF = self.storyboard?.instantiateViewController(withIdentifier: "ServicioWebVC") as! IME_ServicioWebVC
        servicioPDF.documento = documentos[index.row]
        servicioPDF.modalTransitionStyle = .coverVertical
        self.present(servicioPDF, animated: true, completion: nil)
    }
}
