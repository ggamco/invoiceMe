//
//  IME_MenuTVC.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 25/6/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit
import InteractiveSideMenu

class IME_MenuTVC: MenuViewController {

    //var listado : [Int : [String]] = [:]
    var listado : [String] = []
    var lastSectionSelected = 0
    var lastRowSelected = 0
    var contadorTag: Int!
    var fotoSeleccionada = false
    
    // MARK: - IBOutlets
    @IBOutlet weak var myImagenPerfil: UIImageView!
    @IBOutlet weak var myNombrePerfil: UILabel!
    @IBOutlet weak var myCorreoPerfil: UILabel!
    @IBOutlet weak var myCerrarSesionBTN: UIButton!
    @IBOutlet weak var myTableView: UITableView!
    
    
    // MARK: - LIFE VC
    override func viewDidLoad() {
        super.viewDidLoad()
        listado = cargarListado()
        myTableView.delegate = self
        myTableView.dataSource = self
        myCerrarSesionBTN.layer.cornerRadius = 5
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(pickerPhoto))
        myImagenPerfil.addGestureRecognizer(tapGR)
        myImagenPerfil.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Funciones privadas
    private func cargarListado() -> [String] {
        /*
        var list : [Int : [String]] = [:]
        list[0] = ["Inicio"]
        list[1] = ["Proyectos", "Facturas", "Presupuestos"]
        list[2] = ["Clientes", "Productos", "Gastos"]
        list[3] = ["Informes"]
        list[4] = ["Opciones", "Ayuda", "Enviar Comentarios"]
        return list
         */
        let list : [String] = ["Inicio", "Proyectos",
                               "Facturas", "Presupuestos",
                               "Clientes", "Productos",
                               "Gastos", "Informes",
                               "Opciones", "Ayuda",
                               "Enviar Comentarios"]
        return list
    }

}// MARK: - FIN DE LA CLASE

// MARK: - Extensión de TableViewDelegate y Datasource
extension IME_MenuTVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //return listado.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return (listado[section]?.count)!
        return listado.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! IME_MenuItemCell
        //cell.myMenuItem.text = listado[indexPath.section]?[indexPath.row]
        cell.myMenuItem.text = listado[indexPath.row]
        
        if(lastSectionSelected == indexPath.section && lastRowSelected == indexPath.row){
            cell.mySelectedItem.isHidden = false
        }
        else {
            cell.mySelectedItem.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let menuContainerViewController = self.menuContainerViewController else {
            return
        }
        // TODO: - Conseguir llamar al controlador correcto usando seccion y fila selecionada
        menuContainerViewController.selectContentViewController(menuContainerViewController.contentViewControllers[indexPath.row])
        
        lastSectionSelected = indexPath.section
        lastRowSelected = indexPath.row
        
        tableView.reloadData()
        
        menuContainerViewController.hideSideMenu()
    }
}

// MARK: - Extension de ImagePicker para tomar fotografias
extension IME_MenuTVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func pickerPhoto(){
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            muestraMenu()
        } else {
            muestraLibreriaFotos()
        }
        
    }
    
    func muestraMenu(){
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        let tomaFoto = UIAlertAction(title: "Toma foto", style: .default) { _ in
            
            self.muestraCamaraDispositivo()
            
        }
        let seleccionaFoto = UIAlertAction(title: "Selecciona desde Fotos", style: .default) { _ in
            
            self.muestraLibreriaFotos()
            
        }
        
        alertVC.addAction(cancelAction)
        alertVC.addAction(tomaFoto)
        alertVC.addAction(seleccionaFoto)
        present(alertVC, animated: true, completion: nil)
    }
    
    func muestraLibreriaFotos(){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func muestraCamaraDispositivo(){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //TODO: - Cambiar el nombre de la variable donde se cargará la imagen.
        //TODO: - Crear variable fotoselectionada: Bool = false
        if let imageData = info[UIImagePickerControllerOriginalImage] as? UIImage{
            myImagenPerfil.image = imageData
            if myImagenPerfil != nil {
                fotoSeleccionada = true
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
}
