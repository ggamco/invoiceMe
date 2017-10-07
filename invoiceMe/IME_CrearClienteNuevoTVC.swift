//
//  IME_CrearClienteNuevoTVC.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 26/2/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit
import CoreData
import PhoneNumberKit

class IME_CrearClienteNuevoTVC: UITableViewController {

    //MARK: - Elementos visuales Personalizados
    let font = UIFont(name: "HelveticaNeue", size: 16.0)
    
    //MARK: - Objetos propios COREDATA
    let contexto = CoreDataStack.shared.persistentContainer.viewContext
    
    //MARK: - Variables Locales
    let phoneNumberKit = PhoneNumberKit()
    var servicioEmpresa: API_ServicioEmpresa?
    var selectedColor = 0
    var cliente: Empresa? = nil
    var esActualizacion = false
    
    //MARK: - IBOutlets
    @IBOutlet weak var mySalvarCambiosBTN: UIBarButtonItem!
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var myNombreCliente: UITextField!
    @IBOutlet weak var myDireccionCliente: UITextField!
    @IBOutlet weak var myCpostalCliente: UITextField!
    @IBOutlet weak var myCiudadCliente: UITextField!
    @IBOutlet weak var myCifCliente: UITextField!
    @IBOutlet weak var myEmailCliente: UITextField!
    @IBOutlet weak var myTelefonoCliente: PhoneNumberTextField!
    @IBOutlet var myGuardarBTN: UIBarButtonItem!
    
    //MARK: - IBActions
    @IBAction func guardarCliente(_ sender: Any) {
        if myNombreCliente.text!.characters.count != 0 {
                
            cliente = servicioEmpresa?.crearEmpresa(nombre: myNombreCliente.text!,
                                                    color: Int16(selectedColor),
                                                    direccion: myDireccionCliente.text!,
                                                    cpostal: myCpostalCliente.text!,
                                                    ciudad: myCiudadCliente.text!,
                                                    cif: myCifCliente.text!,
                                                    email: myEmailCliente.text!,
                                                    telefono: myTelefonoCliente.text!)
        }
        
        do {
            try contexto.save()
        } catch let error {
            print(error.localizedDescription)
        }
        
        esActualizacion = false
        
        let _ = navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - LIFE VC
    override func viewDidLoad() {
        super.viewDidLoad()
        
        servicioEmpresa = API_ServicioEmpresa(contexto: contexto)
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        myTelefonoCliente.addTarget(self, action: #selector(formatearTelefono), for: UIControlEvents.editingDidBegin)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let clienteDes = cliente {
            myNombreCliente.text = clienteDes.nombre
            myDireccionCliente.text = clienteDes.direccion
            myCpostalCliente.text = clienteDes.cpostal
            myCiudadCliente.text = clienteDes.ciudad
            myCifCliente.text = clienteDes.cif
            myEmailCliente.text = clienteDes.email
            myTelefonoCliente.text = clienteDes.telefono
            selectedColor = Int(clienteDes.color)
            myCollectionView.reloadData()
            
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
    @objc func formatearTelefono() {
        myTelefonoCliente.text?.append("+34")
    }
    
    func guardarCambios(){
        cliente?.nombre = myNombreCliente.text
        cliente?.color = Int16(selectedColor)
        cliente?.direccion = myDireccionCliente.text
        cliente?.cpostal = myCpostalCliente.text
        cliente?.ciudad = myCiudadCliente.text
        cliente?.cif = myCifCliente.text
        cliente?.email = myEmailCliente.text
        cliente?.telefono = myTelefonoCliente.text
        
        servicioEmpresa?.actualizarEmpresa(empresaActualizada: cliente!)
        
        do {
            try contexto.save()
        } catch let error {
            print(error.localizedDescription)
        }
        
        esActualizacion = false
    }
    
    // MARK: - TableView DATASOURCE
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {
        case 0, 1:
            return 1
        case 2:
            return 4
        default:
            return 2
        }
    }
    

}

//MARK: - Extensión de UICollectionViewDelegate y UICollectionViewDataSource

extension IME_CrearClienteNuevoTVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! IME_ColorCorporativoCCCell
        cell.layer.backgroundColor = CONSTANTES.COLORES.ARRAY_COLORES[indexPath.row].cgColor
        cell.layer.cornerRadius = cell.frame.width / 2
        cell.layer.borderColor = UIColor.white.cgColor
        
        if selectedColor == indexPath.row {
            cell.myImagenProyecto.image = cell.myImagenProyecto.image?.withRenderingMode(.alwaysTemplate)
            cell.myImagenProyecto.tintColor = UIColor.white
            cell.myImagenProyecto.isHidden = false
            cell.layer.borderWidth = 2
            
        } else {
            cell.myImagenProyecto.isHidden = true
            cell.layer.borderWidth = 0
        }
        
        
        if indexPath.row == 0 {
            
        }
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedColor = indexPath.row
        collectionView.reloadData()
        
    }
    
    
    
}
