//
//  IME_CrearDocumentoDynamicTVC.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 21/10/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit
import CoreData

protocol CellInfoDelegate {
    var documentoAlmacenado: Documento? {get set}
    func informarDatos(_ campo: String)
}

class IME_CrearDocumentoDynamicTVC: UITableViewController, CellInfoDelegate {

    // MARK: - Objetos propios COREDATA
    let contexto = CoreDataStack.shared.persistentContainer.viewContext
    var servicioDocumento: ServicioDocumento?
    var servicioEmisor: ServicioEmisor?
    var servicioProducto: API_ServicioProducto?
    
    // MARK: - Variables locales
    //var documentoCoreData: Documento?
    var documentoAlmacenado: Documento?
    var productosSeleccionado: [Producto]?
    var tipoDocumentoDeseado: Int?
    var emisor: Emisor?
    var receptor: Empresa?
    var proyecto: Proyecto?
    var contador: Int!
    var esActualizacion = false
    
    @IBAction func guardarDocumento(_ sender: UIBarButtonItem) {
        //Creamos el Documento con los datos obtenidos
        if esActualizacion {
            guardarDocumento()
            _ = navigationController?.popViewController(animated: true)
        } else {
            if emisor != nil && receptor != nil {
                crearDocumento()
                dismiss(animated: true, completion: nil)
            } else {
                let alert = muestraAlertVC(titulo: "Atención", mensaje: "Completa todos los campos para continuar.")
                present(alert, animated: true, completion: nil)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //IMPORTANTE
        //ESTAS LINEAS ELIMINAN EL TITULO AL BACKBUTTON
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
        //INICIAMOS SERVICIO COREDATA
        servicioDocumento = ServicioDocumento(contexto: contexto)
        servicioEmisor = ServicioEmisor(contexto: contexto)
        servicioProducto = API_ServicioProducto(contexto: contexto)
        if documentoAlmacenado == nil {
            documentoAlmacenado = servicioDocumento?.crearDocumento()
        }
        if esActualizacion {
            contador = Int((documentoAlmacenado?.numeroDocumento)!)
            tipoDocumentoDeseado = Int((documentoAlmacenado?.tipoDocumento)!)
            cargarDatosPrevios()
        } else {
            contador = recuperarContador(tipoDocumentoDeseado!)
            emisor = servicioEmisor?.recuperarEmisores().last
            if let receptorAlmacenado = documentoAlmacenado?.receptor {
                receptor = receptorAlmacenado
            }
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    // MARK: - Funciones del delegado
    
    func informarDatos(_ campo: String) {
        print("informamos el campo \(campo)")
    }
    
    // MARK: - Funcciones propias
    
    func cargarDatosPrevios() {
        emisor = documentoAlmacenado?.emisor
        receptor = documentoAlmacenado?.receptor
        proyecto = documentoAlmacenado?.proyecto
        productosSeleccionado = documentoAlmacenado?.productos?.allObjects as? [Producto]
    }
    
    func guardarContador(){
        if let numero = documentoAlmacenado?.numeroDocumento {
            switch tipoDocumentoDeseado! {
            case 0:
                UserDefaults.standard.setValue(numero + 1, forKey: "contadorPresupuestos")
            default:
                UserDefaults.standard.setValue(numero + 1, forKey: "contadorFacturas")
            }
        }
    }
    
    func recuperarContador(_ tipoDocumento: Int) -> Int? {
        switch tipoDocumento {
        case 0:
            return UserDefaults.standard.integer(forKey: "contadorPresupuestos")
        default:
            return UserDefaults.standard.integer(forKey: "contadorFacturas")
        }
    }
    
    func guardarDocumento() {
        /*
        documentoCoreData?.emisor = emisor
        documentoCoreData?.receptor = receptor
        documentoCoreData?.numeroDocumento = (documentoAlmacenado?.numeroDocumento)!
        documentoCoreData?.sufijoDocumento = documentoAlmacenado?.sufijoDocumento
        documentoCoreData?.fechaEmision = documentoAlmacenado?.fechaEmision
        documentoCoreData?.fechaValidez = documentoAlmacenado?.fechaValidez
        documentoCoreData?.nota = documentoAlmacenado?.nota
        if let productosDes = productosSeleccionado {
            documentoCoreData?.productos = NSSet(array: productosDes)
        }
        documentoCoreData?.esActualizado = false
        */
        documentoAlmacenado?.emisor = emisor
        if let productos = productosSeleccionado {
            documentoAlmacenado?.productos = NSSet(array: productos)
        }
        documentoAlmacenado?.esActualizado = false
        do {
            try contexto.save()
            guardarContador()
        }catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func crearDocumento() {
        /*
        var fechaEmision = ""
        var fechaValidez = ""
        if let emision = documentoAlmacenado?.fechaEmision {
            fechaEmision = emision
        }
        if let validez = documentoAlmacenado?.fechaValidez {
            fechaValidez = validez
        }
        
        documentoCoreData = servicioDocumento?.crearDocumento(tipoDocumento: tipoDocumentoDeseado!,
                                                              numeroDocumento: (documentoAlmacenado?.numeroDocumento)!,
                                                              sujijo: (documentoAlmacenado?.sufijoDocumento)!,
                                                              fechaEmison: fechaEmision,
                                                              fechaValidez: fechaValidez,
                                                              nota: (documentoAlmacenado?.nota)!,
                                                              logo: "")
        documentoCoreData?.emisor = emisor
        documentoCoreData?.receptor = receptor
        documentoCoreData?.proyecto = proyecto
        documentoCoreData?.esActualizado = true
        if productosSeleccionado != nil{
            documentoCoreData?.productos = NSSet(array: productosSeleccionado!)
        }
        */
        documentoAlmacenado?.emisor = emisor
        documentoAlmacenado?.receptor = receptor
        documentoAlmacenado?.proyecto = proyecto
        documentoAlmacenado?.tipoDocumento = Int16(tipoDocumentoDeseado!)
        if let productos = productosSeleccionado {
            documentoAlmacenado?.productos = NSSet(array: productos)
        }
        documentoAlmacenado?.esActualizado = true
        do {
            try contexto.save()
            guardarContador()
        } catch let error {
            print(error.localizedDescription)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 4
        case 2:
            if let numeroProductos = productosSeleccionado?.count {
                return numeroProductos + 1
            } else {
                return 1
            }
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 52.0
        case 1, 2:
            switch indexPath.row {
            case 0, 1, 2:
                return 60.0
            default:
                return 120.0
            }
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
                cell.myNombreEmisorTF.placeholder = "Selecciona un Emisor"
                if emisor != nil {
                    cell.myNombreEmisorTF.text = emisor?.nombre
                } else {
                    cell.myNombreEmisorTF.text = ""
                }
                return cell
            } else {
                cell.myTitleLabel.text = "Receptor"
                cell.myNombreEmisorTF.placeholder = "Selecciona un Receptor"
                cell.accessoryType = .none
                if receptor != nil {
                    cell.myNombreEmisorTF.text = receptor?.nombre
                } else {
                    cell.myNombreEmisorTF.text = ""
                }
                return cell
            }
        case 1:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellNumero", for: indexPath) as! IME_NumeroCustomCell
                cell.delegate = self
                if let numero = contador {
                    cell.myNumeroDocumento.text = String(numero)
                    documentoAlmacenado?.numeroDocumento = Int32(numero)
                }
                if let sufijo = documentoAlmacenado?.sufijoDocumento {
                    cell.mySufijoDocumento.text = sufijo
                }
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellFechaEmision", for: indexPath) as! IME_FechaEmisionCustomCell
                cell.delegate = self
                if let documentoDes = documentoAlmacenado {
                    if let emision = documentoDes.fechaEmision {
                        cell.myFechaEmision.textColor = UIColor.darkGray
                        cell.myFechaEmision.text = emision
                        cell.myFechaEmisionSW.isOn = true
                    }
                }
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellFechaValidez", for: indexPath) as! IME_FechaValidezCustomCell
                cell.delegate = self
                if let documentoDes = documentoAlmacenado {
                    if let validez = documentoDes.fechaValidez {
                        cell.myFechaValidez.textColor = UIColor.darkGray
                        cell.myFechaValidez.text = validez
                        cell.myFechaValidezSW.isOn = true
                    }
                }
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellNota", for: indexPath) as! IME_NotaCustomCell
                cell.delegate = self
                if let documentoDes = documentoAlmacenado {
                    if let nota = documentoDes.nota {
                        cell.myNotaText.text = nota
                    }
                }
                return cell
            }
        default:
            if let productosDes = productosSeleccionado {
                let count = productosDes.count
                if count > indexPath.row {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cellProductoAdded", for: indexPath) as! IME_ProductoDocumentoCustomCell
                    cell.myCodigo.text = productosSeleccionado?[indexPath.row].productoBase?.codigo
                    cell.myTitulo.text = productosSeleccionado?[indexPath.row].productoBase?.titulo
                    cell.myPrecio.text = String(format: "%.2f", (productosSeleccionado?[indexPath.row].precio)!)
                    cell.myCantidad.text = String(format: "%.2f", (productosSeleccionado?[indexPath.row].cantidad)!)
                    cell.myExentoIVA.text = (productosSeleccionado?[indexPath.row].productoBase?.exentoIva)! ? "NO" : "SI"
                    cell.myExentoIRPF.text = (productosSeleccionado?[indexPath.row].productoBase?.exentoIrpf)! ? "NO" : "SI"
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cellBoton", for: indexPath) as! IME_BotonCustomCell
                    return cell
                }
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellBoton", for: indexPath) as! IME_BotonCustomCell
                return cell
            }
        }
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            let destinoVC = self.storyboard?.instantiateViewController(withIdentifier: "EmisorTVC") as! IME_EmisorTVC
            self.navigationController?.pushViewController(destinoVC, animated: true)
        } else if indexPath.section == 2 {
            if let productosDes = productosSeleccionado {
                let count = productosDes.count
                if count > indexPath.row {
                    let destinoVC = self.storyboard?.instantiateViewController(withIdentifier: "CrearProductoDocumentoTVC") as! IME_CrearProductoDocumentoTVC
                    destinoVC.producto = productosDes[indexPath.row]
                    destinoVC.esActualizacion = true
                    destinoVC.title = "Editar Producto"
                    self.navigationController?.pushViewController(destinoVC, animated: true)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let eliminar = UITableViewRowAction(style: .default, title: "Eliminar") { (action, indexPath) in
            let productoDoc = self.productosSeleccionado![indexPath.row]
            self.servicioProducto?.eliminarProducto(by: productoDoc.objectID)
            do {
                try self.contexto.save()
                self.productosSeleccionado?.remove(at: indexPath.row)
            } catch let error {
                print("Error: \(error.localizedDescription)")
            }
            self.tableView.reloadData()
        }
        
        if let productoDes = productosSeleccionado {
            let count = productoDes.count
            if indexPath.section == 2 && ( count > indexPath.row) {
                return [eliminar]
            } else {
                return []
            }
        } else {
            return []
        }
        
        
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoEmisor" {
            let destinationVC = segue.destination as? IME_EmisorTVC
            destinationVC?.emisor = emisor
            if servicioEmisor?.recuperarEmisores().count != 0 {
                destinationVC?.esActualizacion = true
            } else {
                destinationVC?.esActualizacion = false
            }
        }
    }
}
