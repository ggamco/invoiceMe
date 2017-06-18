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
    var nombreCliente: String?
    var empresas: [Empresa]?
    var seccionSeleccionada = 0
    var empresaSeleccionada = 0
    var indexOfNumbers = [String]()
    var diccionario: [String : [Empresa]] = [:]
    
    //MARK: - IBActions
    @IBAction func crearCliente(_ sender: UIBarButtonItem) {
        let destinoVC = storyboard?.instantiateViewController(withIdentifier: "CrearClienteNuevoTVC") as! IME_CrearClienteNuevoTVC
        
        destinoVC.esActualizacion = false
        
        let navigationController = UINavigationController(rootViewController: destinoVC)
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cerrarVentana))
        
        self.navigationController?.modalPresentationStyle = .currentContext
        self.present(navigationController, animated: true, completion: nil)
    }
    
    
    //MARK: - LIFE VC
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let indexNumbers = "A B C D E F G H I J K L M N Ñ O P Q R S T U V W X Y Z #"
        indexOfNumbers = indexNumbers.components(separatedBy: " ")
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
            empresas?.sort{$0.nombre!.localizedCompare($1.nombre!) == .orderedAscending}
            
            for index in indexOfNumbers {
                if let empresasDes = empresas {
                    var empresasPorSeccion = [Empresa]()
                    for emp in empresasDes {
                        
                        let first = emp.nombre?.uppercased().characters.first
                        if Character(index) == first!{
                            empresasPorSeccion.append(emp)
                        }
                    }
                    if empresasPorSeccion.count > 0 {
                        diccionario[index] = empresasPorSeccion
                    }
                }
            }
            
        } catch {
            print("Error en la busqueda de objetos")
        }
    }
    
    func cerrarVentana() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - TableView DATASOURCE

    override func numberOfSections(in tableView: UITableView) -> Int {
        return indexOfNumbers.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let data = diccionario[indexOfNumbers[section]]{
            return data.count
        } else {
            return 0
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "clienteCell", for: indexPath)

        let empresaNombre = diccionario[indexOfNumbers[indexPath.section]]?[indexPath.row].nombre
        
        cell.textLabel?.text = empresaNombre
        
        if nombreCliente == empresaNombre {
            cell.accessoryType = .checkmark
            cell.tintColor = CONSTANTES.COLORES.PRIMARY_COLOR_DARK
            
        } else {
            
            cell.accessoryType = .none
            
        }

        return cell
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return indexOfNumbers
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
        
        seccionSeleccionada = indexPath.section
        empresaSeleccionada = indexPath.row
        nombreCliente = diccionario[indexOfNumbers[seccionSeleccionada]]?[empresaSeleccionada].nombre
        tableView.reloadData()
        
    }

}

//MARK: - Extensión de UINavigationControllerDelegate
//USADO PARA DEVOLVER DATOS AL VIEWCONTROLLER ANTERIOR

extension IME_ListaClientesTVC: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        if let destinationVC = viewController as? IME_CrearProyectoNuevoTVC {
            if empresas?.count != 0 {
                destinationVC.myNombreCliente.text = diccionario[indexOfNumbers[seccionSeleccionada]]?[empresaSeleccionada].nombre
                destinationVC.empresa = diccionario[indexOfNumbers[seccionSeleccionada]]?[empresaSeleccionada]
                destinationVC.empresaSelecionada = empresaSeleccionada
            }
        }
    }
    
}
