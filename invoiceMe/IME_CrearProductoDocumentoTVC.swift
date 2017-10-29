//
//  IME_CrearProductoDocumentoTVC.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 21/10/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit
import CoreData

class IME_CrearProductoDocumentoTVC: UITableViewController {

    //MARK: - Objetos propios COREDATA
    let contexto = CoreDataStack.shared.persistentContainer.viewContext
    var servicioProducto: API_ServicioProducto?
    
    var delegate: CellInfoDelegate?
    var productoBase: ProductoBase?
    var producto: Producto?
    var esAgregacion = false
    var esActualizacion = false
    
    // MARK: - IBOutlets
    @IBOutlet weak var myCodigoProducto: CustomTextField!
    @IBOutlet weak var myTituloProducto: CustomTextField!
    @IBOutlet weak var myDescripcionProducto: UITextView!
    @IBOutlet weak var mySelectorMedida: UISegmentedControl!
    @IBOutlet weak var myMedidaCustom: CustomTextField!
    @IBOutlet weak var myPrecio: CustomTextField!
    @IBOutlet weak var myIVA: CustomTextField!
    @IBOutlet weak var myExentoIVA: UISwitch!
    @IBOutlet weak var myIRPF: CustomTextField!
    @IBOutlet weak var myExentoIRPF: UISwitch!
    @IBOutlet weak var myCantidad: CustomTextField!
    @IBOutlet weak var myStepper: UIStepper!
    @IBOutlet weak var myTipoMedidaLabel: UILabel!
    
    // MARK: - IBActions
    @IBAction func cambiarCantidad(_ sender: UIStepper) {
        myCantidad.text = String(format: "%.2f", sender.value)
    }
    
    @IBAction func permitirUnidadCustom(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0, 1:
            myTipoMedidaLabel.text = sender.titleForSegment(at: sender.selectedSegmentIndex)! + ":"
            myMedidaCustom.isEnabled = false
            myMedidaCustom.textColor = UIColor.gray
        default:
            myMedidaCustom.isEnabled = true
            myMedidaCustom.textColor = UIColor.darkGray
            myTipoMedidaLabel.text = sender.titleForSegment(at: sender.selectedSegmentIndex)! + ":"
        }
    }
    
    @IBAction func activarExentos(_ sender: UISwitch) {
        if sender.isOn {
            if sender.tag == 0 {
                myIVA.isEnabled = false
                myIVA.textColor = UIColor.gray
            } else {
                myIRPF.isEnabled = false
                myIRPF.textColor = UIColor.gray
            }
        } else {
            if sender.tag == 0 {
                myIVA.isEnabled = true
                myIVA.textColor = UIColor.darkText
            } else {
                myIRPF.isEnabled = true
                myIRPF.textColor = UIColor.darkText
            }
        }
    }
    
    @IBAction func guardarCambiosAction(_ sender: UIBarButtonItem) {
        if esActualizacion {
            productoBase = producto?.productoBase
        }
        if esAgregacion {
            producto = servicioProducto?.crearProducto()
        }
        producto?.cantidad = convertirToDouble(myCantidad.text)
        producto?.precio = convertirToDouble(myPrecio.text)
        productoBase?.codigo = myCodigoProducto.text
        productoBase?.titulo = myTituloProducto.text
        productoBase?.descripcion = myDescripcionProducto.text
        productoBase?.tipoMedida = Int16(mySelectorMedida.selectedSegmentIndex)
        productoBase?.medidaCustom = myMedidaCustom.text
        productoBase?.iva = convertirToDouble(myIVA.text)
        productoBase?.irpf = convertirToDouble(myIRPF.text)
        productoBase?.exentoIva = myExentoIVA.isOn
        productoBase?.exentoIrpf = myExentoIRPF.isOn
        producto?.productoBase = productoBase
        do {
            try contexto.save()
        }catch let error {
            print("Error: \(error.localizedDescription)")
        }
        if esAgregacion {
            goToDocumento()
        } else if esActualizacion {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - LIFE VC
    override func viewDidLoad() {
        super.viewDidLoad()
        servicioProducto = API_ServicioProducto(contexto: contexto)
        cargarDatosPrevios()
        myMedidaCustom.delegate = self
        myPrecio.delegate = self
        myCantidad.delegate = self
    }
    
    // MARK: - Funciones propias
    func cargarDatosPrevios() {
        if esActualizacion {
            if let productoDes = producto {
                myCodigoProducto.text = productoDes.productoBase?.codigo
                myTituloProducto.text = productoDes.productoBase?.titulo
                myDescripcionProducto.text = productoDes.productoBase?.descripcion
                mySelectorMedida.selectedSegmentIndex = Int((productoDes.productoBase?.tipoMedida)!)
                myMedidaCustom.text = productoDes.productoBase?.medidaCustom
                myIVA.text = String(format: "%.2f", (productoDes.productoBase?.iva)!)
                myIRPF.text = String(format: "%.2f", (productoDes.productoBase?.irpf)!)
                myExentoIVA.isOn = (productoDes.productoBase?.exentoIva)!
                myExentoIRPF.isOn = (productoDes.productoBase?.exentoIrpf)!
                cargarUnidad(productoDes.productoBase!)
                myCantidad.text = String(format: "%.2f", productoDes.cantidad)
                myPrecio.text = String(format: "%.2f", productoDes.precio)
                myStepper.value = productoDes.cantidad
            }
        } else {
            if let productoBaseDes = productoBase {
                myCodigoProducto.text = productoBaseDes.codigo
                myTituloProducto.text = productoBaseDes.titulo
                myDescripcionProducto.text = productoBaseDes.descripcion
                mySelectorMedida.selectedSegmentIndex = Int(productoBaseDes.tipoMedida)
                myMedidaCustom.text = productoBaseDes.medidaCustom
                myIVA.text = String(format: "%.2f", productoBaseDes.iva)
                myIRPF.text = String(format: "%.2f", productoBaseDes.irpf)
                myExentoIVA.isOn = productoBaseDes.exentoIva
                myExentoIRPF.isOn = productoBaseDes.exentoIrpf
                cargarUnidad(productoBaseDes)
            }
        }
        
    }
    
    func cargarUnidad(_ producto: ProductoBase) {
        if producto.medidaCustom != "" {
            myMedidaCustom.text = producto.medidaCustom
            myTipoMedidaLabel.text = "\(producto.medidaCustom!):"
        } else {
            switch producto.tipoMedida {
            case 0:
                myTipoMedidaLabel.text = "UNIDADES:"
            case 1:
                myTipoMedidaLabel.text = "HORAS:"
            default:
                myTipoMedidaLabel.text = "OTRO:"
            }
        }
    }
    
    func goToDocumento() {
        let vcIndex = self.navigationController?.viewControllers.index(where: { (viewController) -> Bool in
            
            if let _ = viewController as? IME_CrearDocumentoDynamicTVC {
                return true
            }
            return false
        })
        
        let vc = self.navigationController?.viewControllers[vcIndex!] as! IME_CrearDocumentoDynamicTVC
        if vc.productosSeleccionado != nil {
            vc.productosSeleccionado?.append(producto!)
        } else {
            vc.productosSeleccionado = []
            vc.productosSeleccionado?.append(producto!)
        }
        self.navigationController?.popToViewController(vc, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 2:
            return 3
        case 1:
            return 2
        default:
            return 1
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}// FIN DE LA CLASE

extension IME_CrearProductoDocumentoTVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 10:
            if textField.text != "" {
                myTipoMedidaLabel.text = textField.text! + ":"
            }
        case 20:
            if textField.text != "" {
                let double = Double(textField.text!)
                myCantidad.text = String(format: "%.2f", double!)
            }
        case 30:
            if textField.text != "" {
                let double = Double(textField.text!)
                myPrecio.text = String(format: "%.2f", double!)
            }
        case 40:
            if textField.text != "" {
                let double = Double(textField.text!)
                myIVA.text = String(format: "%.2f", double!)
            }
        case 50:
            if textField.text != "" {
                let double = Double(textField.text!)
                myIRPF.text = String(format: "%.2f", double!)
            }
        default:
            print()
        }
    }
}
