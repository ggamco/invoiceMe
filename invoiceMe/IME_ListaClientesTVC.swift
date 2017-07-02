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
        
        self.navigationController?.navigationBar.topItem?.title = ""
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
        self.navigationController?.navigationBar.topItem?.title = ""
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
        } else if seccionSeleccionada != 0 && empresaSeleccionada != 0{
            if indexPath.section == seccionSeleccionada && indexPath.row == empresaSeleccionada {
                cell.accessoryType = .checkmark
                cell.tintColor = CONSTANTES.COLORES.PRIMARY_COLOR_DARK
            }
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
            let empresa = self.diccionario[self.indexOfNumbers[indexPath.section]]?[indexPath.row]
            
            //TODO: - Al borrar una empresa avisar que se eliminaran todos los proyectos asociados

            let servicio = API_ServicioProyecto(contexto: self.contexto)
            let proyectos = servicio.buscarProyecto(byQuery: NSPredicate(format: "cliente == %@", empresa!))
            
            if proyectos.count > 0{
                //TODO: - avisar al usuario que se eliminaran los proyectos relacionados
            }
            
            self.contexto.delete(empresa!)
            self.appDel.saveContext()
            
            self.diccionario[self.indexOfNumbers[indexPath.section]]?.remove(at: indexPath.row)
            
            if indexPath.row != 0 {
                self.empresaSeleccionada = indexPath.row - 1
                self.seccionSeleccionada = indexPath.section
            } else if indexPath.row == 0 && indexPath.section != 0{
                if let rows = (self.diccionario[self.indexOfNumbers[indexPath.section - 1]]?.count){
                    if rows - 1 >= 0{
                        self.seccionSeleccionada = indexPath.section - 1
                        self.empresaSeleccionada = indexPath.row - 1
                    }
                } else {
                    self.seccionSeleccionada = 0
                    self.empresaSeleccionada = 0
                }
            } else {
                self.seccionSeleccionada = 0
                self.empresaSeleccionada = 0
            }
            
            self.tableView.reloadData()
            
        }
        
        let editarAction = UITableViewRowAction(style: .normal, title: "Editar") { (action, indexPath) in
            
            let destinationVC = self.storyboard?.instantiateViewController(withIdentifier: "CrearClienteNuevoTVC") as! IME_CrearClienteNuevoTVC
            
            //TODO: - corregir la edición pasando el dato del diccionario, no del array
            destinationVC.cliente = self.diccionario[self.indexOfNumbers[indexPath.section]]?[indexPath.row]
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
                destinationVC.empresaSeleccionada = empresaSeleccionada
                destinationVC.seccionSeleccionada = seccionSeleccionada
            }
        } else if let destinationVC = viewController as? IME_CrearDocumentoTVC {
            if empresas?.count != 0 {
                destinationVC.myNombreReceptor.text = diccionario[indexOfNumbers[seccionSeleccionada]]?[empresaSeleccionada].nombre
                destinationVC.receptor = diccionario[indexOfNumbers[seccionSeleccionada]]?[empresaSeleccionada]
                destinationVC.empresaSeleccionada = empresaSeleccionada
                destinationVC.seccionSeleccionada = seccionSeleccionada
            }
        }
    }
    
}
