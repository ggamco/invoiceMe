//
//  IME_VistaProductoTVC.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 9/7/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit

class IME_VistaProductoTVC: UITableViewController {

    //MARK: - Objetos propios COREDATA
    let contexto = CoreDataStack.shared.persistentContainer.viewContext
    var servicioProducto: API_ServicioProducto?
    
    var esActualizacion = false
    var producto: Producto?
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var myCodigo: UITextField!
    @IBOutlet weak var myTitulo: UITextField!
    @IBOutlet weak var myDescripccion: UITextView!
    @IBOutlet weak var mySelectorMedida: UISegmentedControl!
    @IBOutlet weak var myMedidaCustom: UITextField!
    @IBOutlet weak var myPrecio: UITextField!
    @IBOutlet weak var mySelectorMoneda: UIButton!
    @IBOutlet weak var myDescuento: UITextField!
    @IBOutlet weak var mySelectorTipoDescuento: UIButton!
    @IBOutlet weak var myIVA: UITextField!
    @IBOutlet weak var myExentoIVA: UISwitch!
    @IBOutlet weak var myIRPF: UITextField!
    @IBOutlet weak var myExentoIRPF: UISwitch!
    @IBOutlet weak var myCantidad: UITextField!
    @IBOutlet weak var myStepperCantidad: UIStepper!
    
    @IBAction func guardarCambiosAction(_ sender: UIBarButtonItem) {
        if esActualizacion {
            guardarCambios()
        } else {
            if myTitulo.text!.characters.count > 0 {
                if myCodigo.text!.characters.count > 0 {
                    
                    producto = servicioProducto?.crearProducto(codigo: myCodigo.text!,
                                                               titulo: myTitulo.text!,
                                                               descripcion: myDescripccion.text!,
                                                               cantidad: (myCantidad.text! as NSString).floatValue,
                                                               precio: (myPrecio.text! as NSString).floatValue,
                                                               iva: (myIVA.text! as NSString).floatValue,
                                                               irpf: (myIRPF.text! as NSString).floatValue,
                                                               exentoIva: myExentoIVA.isOn,
                                                               exentoIrpf: myExentoIRPF.isOn)
                    
                    do {
                        try contexto.save()
                    } catch let error {
                        print(error.localizedDescription)
                    }
                    
                    esActualizacion = false
                    
                    let _ = navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                } else {
                    let alert = muestraAlertVC(titulo: "Atención!", mensaje: "No has añadido ningun código de producto.")
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                let alert = muestraAlertVC(titulo: "Atención!", mensaje: "No has introducido un nombre válido al producto.")
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - LIFE VC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        servicioProducto = API_ServicioProducto(contexto: contexto)
        mySelectorMoneda.layer.cornerRadius = 5
        mySelectorMoneda.layer.borderWidth = 0.5
        mySelectorMoneda.layer.borderColor = CONSTANTES.COLORES.FIRST_TEXT_COLOR.cgColor
        mySelectorTipoDescuento.layer.cornerRadius = 5
        mySelectorTipoDescuento.layer.borderWidth = 0.5
        mySelectorTipoDescuento.layer.borderColor = CONSTANTES.COLORES.FIRST_TEXT_COLOR.cgColor
        
        if esActualizacion {
            cargarProducto()
        }
    }

    // MARK: - Utils
    func cargarProducto() {
        if let productoDes = producto {
            myCodigo.text = productoDes.codigo
            myTitulo.text = productoDes.titulo
            myDescripccion.text = productoDes.descripcion
            myPrecio.text = String(format: "%.2f", productoDes.precio)
            myIVA.text = String(format: "%.2f", productoDes.iva)
            myIRPF.text = String(format: "%.2f", productoDes.irpf)
            myExentoIVA.isOn = productoDes.exentoIva
            myExentoIRPF.isOn = productoDes.exentoIrpf
            myCantidad.text = String(format: "%.2f", productoDes.cantidad)
        }
    }
    
    func guardarCambios(){
        
        producto?.titulo = myTitulo.text
        producto?.codigo = myCodigo.text
        producto?.descripcion = myDescripccion.text
        producto?.precio = (myPrecio.text! as NSString).floatValue
        producto?.iva = (myIVA.text! as NSString).floatValue
        producto?.exentoIva = myExentoIVA.isOn
        producto?.exentoIrpf = myExentoIRPF.isOn
        producto?.irpf = (myIRPF.text! as NSString).floatValue
        producto?.cantidad = (myCantidad.text! as NSString).floatValue
        servicioProducto?.actualizarProducto(productoActualizado: producto!)
        
        do {
            try contexto.save()
        } catch let error {
            print(error.localizedDescription)
        }
        
        esActualizacion = false
        
        let _ = navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 2
        default:
            return 5
        }
    }
}
