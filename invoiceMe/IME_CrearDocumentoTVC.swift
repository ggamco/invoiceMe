//
//  IME_CrearDocumentoTVC.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 2/7/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit
import CoreData
import InteractiveSideMenu

class IME_CrearDocumentoNAV: UINavigationController, SideMenuItemContent {
    
}

class IME_CrearDocumentoTVC: UITableViewController {

    // MARK: - Objetos propios COREDATA
    let contexto = CoreDataStack.shared.persistentContainer.viewContext
    var servicioDocumento: ServicioDocumento?
    var servicioEmisor: ServicioEmisor?
    
    //MARK: - Elementos visuales Personalizados
    let font = UIFont(name: "HelveticaNeue", size: 16.0)
    let datapicker = UIDatePicker()
    let format = DateFormatter()
    
    //MARK: - Variables Locales
    var today: Date?
    var tomorrow: Date?
    var empresaSeleccionada = 0
    var seccionSeleccionada = 0
    var documentoNuevo: Documento?
    var emisor: Emisor?
    var receptor: Empresa?
    var productos: [Producto]?
    
    // MARK: - IBOutlets
    @IBOutlet weak var myNombreEmisor: UITextField!
    @IBOutlet weak var myNombreReceptor: UITextField!
    @IBOutlet weak var myTipoDocumento: UISegmentedControl!
    @IBOutlet weak var myNumeroDocumento: UITextField!
    @IBOutlet weak var mySufijoDocumento: UITextField!
    @IBOutlet weak var myFechaEmision: UITextField!
    @IBOutlet weak var myFechaValidez: UITextField!
    @IBOutlet weak var mySwFechaEmision: UISwitch!
    @IBOutlet weak var mySwFechaValidez: UISwitch!

    //MARK: - IBActions
    @IBAction func openMenu(_ sender: Any) {
        if let navigationViewController = self.navigationController as? SideMenuItemContent {
            navigationViewController.showSideMenu()
        }
    }
    
    @IBAction func activarFechasSW(_ sw: UISwitch) {
        if sw.isOn {
            if sw.tag == 0 {
                myFechaEmision.isEnabled = true
                myFechaEmision.textColor = UIColor.darkText
                today = datapicker.date
                myFechaEmision.text = format.string(from: today!)
            } else {
                myFechaValidez.isEnabled = true
                myFechaValidez.textColor = UIColor.darkText
                tomorrow = datapicker.date
                myFechaValidez.text = format.string(from: tomorrow!)
            }
        } else {
            if sw.tag == 0 {
                myFechaEmision.isEnabled = false
                myFechaEmision.textColor = UIColor.gray
                //myFechaEmision.text = ""
            } else {
                myFechaValidez.isEnabled = false
                myFechaValidez.textColor = UIColor.gray
                //myFechaValidez.text = ""
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //INICIAMOS SERVICIO COREDATA
        servicioDocumento = ServicioDocumento(contexto: contexto)
        servicioEmisor = ServicioEmisor(contexto: contexto)
        
        //CONFIGURACIONES ESTETICAS VARIAS
        myNumeroDocumento.layer.cornerRadius = 5
        mySufijoDocumento.layer.cornerRadius = 5
        myFechaEmision.layer.cornerRadius = 5
        myFechaValidez.layer.cornerRadius = 5
        
        //CONFIGURACIONES VARIAS
        format.dateFormat = "dd/MM/yyyy"
        myFechaEmision.delegate = self
        myFechaValidez.delegate = self
        
        //CONFIGURAMOS LA CARGA DEL DATAPICKER
        datapicker.datePickerMode = UIDatePickerMode.date
        myFechaEmision.inputView = datapicker
        myFechaValidez.inputView = datapicker
        datapicker.addTarget(self, action: #selector(setFechaLabel), for: UIControlEvents.valueChanged)
        
        setFechasIniciales()
        
        //Recuperamos contador
        myNumeroDocumento.text = String(UserDefaults.standard.integer(forKey: "contador"))
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return 3
        default:
            return 1
        }
    }

    
    // MARK: - FUNCIONES PROPIAS
    func crearDocumento() -> Documento? {
        
        let doc = servicioDocumento?.crearDocumento(tipoDocumento: myTipoDocumento.selectedSegmentIndex,
                                                    numeroDocumento: Int(myNumeroDocumento.text!)!,
                                                    sujijo: mySufijoDocumento.text!,
                                                    fechaEmison: mySwFechaEmision.isOn ? myFechaEmision.text! : "",
                                                    fechaValidez: mySwFechaValidez.isOn ? myFechaValidez.text! : "",
                                                    logo: "")
        doc?.emisor = emisor
        doc?.receptor = receptor
        
        do {
            try contexto.save()
        } catch let error {
            print(error.localizedDescription)
        }
        
        return servicioDocumento?.recuperarDocumentos().last
    }
    
    func setFechasIniciales() {
        today = datapicker.date
        myFechaEmision.text = format.string(from: today!)
        myFechaEmision.textColor = UIColor.gray
        myFechaValidez.text = format.string(from: today!)
        myFechaValidez.textColor = UIColor.gray
    }
    
    func setFechaLabel(_ dp: UIDatePicker){
        
        if dp.tag == 0 {
            today = datapicker.date
            myFechaEmision.text = format.string(from: today!)
        } else {
            tomorrow = datapicker.date
            if today! > tomorrow! {
                tomorrow = today
                datapicker.date = tomorrow!
            }
            myFechaValidez.text = format.string(from: tomorrow!)
            
        }
        
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "gotoEmisor" {
            
            let destinationVC = segue.destination as? IME_EmisorTVC
            destinationVC?.fechaEmision = myFechaEmision.text!
            destinationVC?.emisor = emisor
            
            if servicioEmisor?.recuperarEmisores().count != 0 {
                destinationVC?.esActualizacion = true
            } else {
                destinationVC?.esActualizacion = false
            }
            
        } else if segue.identifier == "servicioPDF" {

            //Creamos el Documento con los datos obtenidos
            documentoNuevo = crearDocumento()
            
        } else {
            
            let destinationVC = segue.destination as? IME_ListaClientesTVC
            
            destinationVC?.empresaSeleccionada = empresaSeleccionada
            destinationVC?.seccionSeleccionada = seccionSeleccionada
            
            if let nombre = myNombreReceptor.text, myNombreReceptor.text != "" {
                destinationVC?.nombreCliente = nombre
            } else {
                destinationVC?.nombreCliente = receptor?.nombre
            }
        }
    }

}

//MARK: - Extensión de UITextFieldDelegate
extension IME_CrearDocumentoTVC: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            datapicker.tag = 0
        default:
            datapicker.tag = 1
        }
        
        return true
    }
}
