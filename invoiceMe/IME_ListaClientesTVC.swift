//
//  IME_ListaClientesTVC.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 26/2/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit
import CoreData

class IME_ListaClientesTVC: UITableViewController {

    //MARK: - Elementos visuales Personalizados
    let font = UIFont(name: "HelveticaNeue", size: 16.0)
    
    //MARK: - Objetos propios COREDATA
    let appDel = UIApplication.shared.delegate as! AppDelegate
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - Variables Locales
    var empresas: [Empresa]?
    var empresaSeleccionada = 0
    
    //MARK: - LIFE VC
    override func viewDidLoad() {
        super.viewDidLoad()  
    }
    
    //Usamos este metodo propio del ciclo de vida del VC para cargar datos siempre que vuelva a visualizarse
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Cargamos las empresas almacenadas en CoreData
        cargarEmpresasCD()
        //Recargamos la tabla con los últimos datos
        self.tableView.reloadData()
        
        //Asignamos el delegate
        navigationController?.delegate = self
    }

    //MARK: - FUNCIONES PROPIAS
    func cargarEmpresasCD() {
        do {
            //Sentencia de busqueda en CoreData
            empresas = try contexto.fetch(Empresa.fetchRequest())
            
            //Orden alfabético del listado de Empresas
            empresas?.sort{$0.nombre! < $1.nombre!}
        } catch {
            print("Error en la busqueda de objetos")
        }
    }

    // MARK: - TableView DATASOURCE

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (empresas?.count)!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "clienteCell", for: indexPath)

        cell.textLabel?.text = empresas?[indexPath.row].nombre
        
        if empresaSeleccionada == indexPath.row {
            
            cell.accessoryType = .checkmark
            cell.tintColor = CONSTANTES.COLORES.PRIMARY_COLOR_DARK
            
        } else {
            
            cell.accessoryType = .none
            
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let borrarAction = UITableViewRowAction(style: .default, title: "Borrar") { (action, indexPath) in
            
            let empresa = self.empresas?[indexPath.row]
            self.contexto.delete(empresa!)
            self.appDel.saveContext()
            
            self.empresas?.remove(at: indexPath.row)
            
            if self.empresaSeleccionada != 0 {
                self.empresaSeleccionada = self.empresaSeleccionada - 1
            } else {
                self.empresaSeleccionada = 0
            }
            
            self.tableView.reloadData()
            
        }
        
        let editarAction = UITableViewRowAction(style: .normal, title: "Editar") { (action, indexPath) in
            
            let destinationVC = self.storyboard?.instantiateViewController(withIdentifier: "CrearClienteNuevoTVC") as! IME_CrearClienteNuevoTVC
                
            destinationVC.cliente = self.empresas?[indexPath.row]
            destinationVC.esActualizacion = true
            destinationVC.title = "Editar Cliente"
                
            self.navigationController?.pushViewController(destinationVC, animated: true)
            
        }
        
        return [borrarAction, editarAction]
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        empresaSeleccionada = indexPath.row
        
        tableView.reloadData()
        
    }
    
    // MARK: - Navegación SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Personalizando el boton back
        let backButton = UIBarButtonItem()
        backButton.title = self.navigationController?.navigationItem.title
        backButton.setTitleTextAttributes([NSFontAttributeName: font!], for:UIControlState.normal)
        backButton.tintColor = CONSTANTES.COLORES.PRIMARY_COLOR_LIGHT
        navigationItem.backBarButtonItem = backButton
    }
    

}

//MARK: - Extensión de UINavigationControllerDelegate
//USADO PARA DEVOLVER DATOS AL VIEWCONTROLLER ANTERIOR

extension IME_ListaClientesTVC: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        if let destinationVC = viewController as? IME_CrearProyectoNuevoTVC {
            if empresas?.count != 0 {
                destinationVC.myNombreCliente.text = empresas?[empresaSeleccionada].nombre
                destinationVC.empresa = empresas?[empresaSeleccionada]
                destinationVC.empresaSelecionada = empresaSeleccionada
            }
        }
    }
    
}
