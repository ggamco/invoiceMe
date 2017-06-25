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

    var listado : [Int : [String]] = [:]
    var lastSectionSelected = 0
    var lastRowSelected = 0
    
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
    }
    
    // MARK: - Funciones privadas
    private func cargarListado() -> [Int : [String]] {
        var list : [Int : [String]] = [:]
        list[0] = ["Inicio"]
        list[1] = ["Proyectos", "Facturas", "Presupuestos"]
        list[2] = ["Clientes", "Conceptos", "Gastos"]
        list[3] = ["Informes"]
        list[4] = ["Opciones", "Ayuda", "Enviar Comentarios"]
        return list
    }

}// MARK: - FIN DE LA CLASE

// MARK: - Extensión de TableViewDelegate y Datasource
extension IME_MenuTVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listado.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (listado[section]?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! IME_MenuItemCell
        cell.myMenuItem.text = listado[indexPath.section]?[indexPath.row]
        
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
        menuContainerViewController.selectContentViewController(menuContainerViewController.contentViewControllers[0])
        
        lastSectionSelected = indexPath.section
        lastRowSelected = indexPath.row
        
        tableView.reloadData()
        
        menuContainerViewController.hideSideMenu()
    }
}
