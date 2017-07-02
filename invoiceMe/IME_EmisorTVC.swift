//
//  IME_EmisorTVC.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 2/7/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit
import CoreData
import PhoneNumberKit

class IME_EmisorTVC: UITableViewController {

    //MARK: - Elementos visuales Personalizados
    let font = UIFont(name: "HelveticaNeue", size: 16.0)
    
    //MARK: - Objetos propios COREDATA
    let appDel = UIApplication.shared.delegate as! AppDelegate
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - Variables Locales
    let phoneNumberKit = PhoneNumberKit()
    var servicioEmisor: ServicioEmisor?
    var selectedColor = 0
    var emisor: Emisor? = nil
    var esActualizacion = false
    var fechaEmision = ""
    
    //MARK: - IBOutlets
    @IBOutlet weak var mySalvarCambiosBTN: UIBarButtonItem!
    @IBOutlet weak var myNombreEmisor: UITextField!
    @IBOutlet weak var myDireccionEmisor: UITextField!
    @IBOutlet weak var myCpostalEmisor: UITextField!
    @IBOutlet weak var myCiudadEmisor: UITextField!
    @IBOutlet weak var myCifEmisor: UITextField!
    @IBOutlet weak var myIbanEmisor: UITextField!
    @IBOutlet weak var myEmailEmisor: UITextField!
    @IBOutlet weak var myTelefonoEmisor: PhoneNumberTextField!
    @IBOutlet var myGuardarBTN: UIBarButtonItem!
    
    //MARK: - IBActions
    @IBAction func guardarCliente(_ sender: Any) {
        if myNombreEmisor.text!.characters.count != 0 {
            
            emisor = servicioEmisor?.crearEmisor(nombre: myNombreEmisor.text!,
                                                 fecha: fechaEmision,
                                                 direccion: myDireccionEmisor.text!,
                                                 zipCode: Int(myCpostalEmisor.text!)!,
                                                 ciudad: myCiudadEmisor.text!,
                                                 cif: myCifEmisor.text!,
                                                 iban: myIbanEmisor.text!)
        }
        
        appDel.saveContext()
        esActualizacion = false
        
        let _ = navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Asignamos el delegate
        navigationController?.delegate = self
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        servicioEmisor = ServicioEmisor(contexto: contexto)
        emisor = servicioEmisor?.recuperarEmisores().first
        myTelefonoEmisor.addTarget(self, action: #selector(formatearTelefono), for: UIControlEvents.editingDidBegin)
        
        if let emisorDes = emisor {
            myNombreEmisor.text = emisorDes.nombre
            myDireccionEmisor.text = emisorDes.direccion
            myCpostalEmisor.text = String(emisorDes.zipCode)
            myCiudadEmisor.text = emisorDes.ciudad
            myCifEmisor.text = emisorDes.ciudad
            myIbanEmisor.text = emisorDes.iban
            
        }
        
        //si la vista nace de una actualización ocultamos el boton guardar
        if esActualizacion {
            self.navigationItem.rightBarButtonItem = nil
        } else {
            self.navigationItem.rightBarButtonItem = self.myGuardarBTN
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //si la vista nace de una edición, cuando volvamos atrás
        //almacenaremos los cambios
        if esActualizacion {
            guardarCambios()
        }
    }
    
    //MARK: - Funciones Propias
    func formatearTelefono() {
        myTelefonoEmisor.text?.append("+34")
    }
    
    func guardarCambios(){
        emisor?.nombre = myNombreEmisor.text
        emisor?.direccion = myDireccionEmisor.text
        emisor?.zipCode = Int16(myCpostalEmisor.text!)!
        emisor?.ciudad = myCiudadEmisor.text
        emisor?.cif = myCifEmisor.text
        emisor?.fecha = fechaEmision
        //emisor?.email = myEmailEmisor.text
        //emisor?.telefono = myTelefonoEmisor.text
        
        servicioEmisor?.actualizarEmisor(emisorActualizado: emisor!)
        
        appDel.saveContext()
        esActualizacion = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 2:
            return 1
        case 1:
            return 4
        default:
            return 2
        }
    }

}
//MARK: - Extensión de UINavigationControllerDelegate
//USADO PARA DEVOLVER DATOS AL VIEWCONTROLLER ANTERIOR

extension IME_EmisorTVC: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        if let destinationVC = viewController as? IME_CrearDocumentoTVC {
            if emisor != nil {
                destinationVC.myNombreEmisor.text = emisor?.nombre
                destinationVC.emisor = emisor
            }
        }
    }
    
}
