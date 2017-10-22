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
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        if textField.tag == 10 {
            if textField.text != "" {
                myTipoMedidaLabel.text = textField.text! + ":"
            }
        } else if textField.tag == 20 {
            myCantidad.text = String(format: "%.2f", textField.text!)
        }
    }
    
}
