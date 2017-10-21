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
    var servicioProductoBase: API_ServicioProductoBase?
    
    var esActualizacion = false
    var producto: ProductoBase?
    
    var esAgregacion = false
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var myCodigo: UITextField!
    @IBOutlet weak var myTitulo: UITextField!
    @IBOutlet weak var myDescripccion: UITextView!
    @IBOutlet weak var mySelectorMedida: UISegmentedControl!
    @IBOutlet weak var myMedidaCustom: UITextField!
    @IBOutlet weak var myIVA: UITextField!
    @IBOutlet weak var myExentoIVA: UISwitch!
    @IBOutlet weak var myIRPF: UITextField!
    @IBOutlet weak var myExentoIRPF: UISwitch!

    
    // MARK: - IBActions
    @IBAction func permitirUnidadCustom(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0, 1:
            myMedidaCustom.isEnabled = false
            myMedidaCustom.textColor = UIColor.gray
        default:
            myMedidaCustom.isEnabled = true
            myMedidaCustom.textColor = UIColor.darkGray
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
            guardarCambios()
        } else {
            if myTitulo.text!.characters.count > 0 {
                if myCodigo.text!.characters.count > 0 {
                    
                    producto = servicioProductoBase?.crearProducto(codigo: myCodigo.text!,
                                                               titulo: myTitulo.text!,
                                                               descripcion: myDescripccion.text!,
                                                               iva: (myIVA.text! as NSString).doubleValue,
                                                               irpf: (myIRPF.text! as NSString).doubleValue,
                                                               exentoIva: myExentoIVA.isOn,
                                                               exentoIrpf: myExentoIRPF.isOn)
                    producto?.tipoMedida = Int16(mySelectorMedida.selectedSegmentIndex)
                    producto?.medidaCustom = myMedidaCustom.text
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
        activarExentos(myExentoIVA)
        activarExentos(myExentoIRPF)
        servicioProductoBase = API_ServicioProductoBase(contexto: contexto)
        myDescripccion.layer.cornerRadius = 5
        if myExentoIVA.isOn {
            myIVA.textColor = UIColor.darkGray
        } else {
            myIVA.textColor = UIColor.gray
        }
        if myExentoIRPF.isOn {
            myIRPF.textColor = UIColor.darkGray
        } else {
            myIRPF.textColor = UIColor.gray
        }
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
            myIVA.text = String(format: "%.2f", productoDes.iva)
            myIRPF.text = String(format: "%.2f", productoDes.irpf)
            myExentoIVA.isOn = productoDes.exentoIva
            myExentoIRPF.isOn = productoDes.exentoIrpf
            mySelectorMedida.selectedSegmentIndex = Int(productoDes.tipoMedida)
            myMedidaCustom.text = productoDes.medidaCustom
        }
    }
    
    func guardarCambios(){
        
        producto?.titulo = myTitulo.text
        producto?.codigo = myCodigo.text
        producto?.descripcion = myDescripccion.text
        producto?.iva = (myIVA.text! as NSString).doubleValue
        producto?.exentoIva = myExentoIVA.isOn
        producto?.exentoIrpf = myExentoIRPF.isOn
        producto?.irpf = (myIRPF.text! as NSString).doubleValue
        producto?.tipoMedida = Int16(mySelectorMedida.selectedSegmentIndex)
        producto?.medidaCustom = myMedidaCustom.text
        servicioProductoBase?.actualizarProducto(productoActualizado: producto!)
        
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
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        default:
            return 2
        }
    }
}
