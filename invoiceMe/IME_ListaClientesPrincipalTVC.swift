//
//  IME_ListaClientesPrincipalTVC.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 16/6/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit

class IME_ListaClientesPrincipalTVC: UITableViewController {
    
    //MARK: - Objetos propios COREDATA
    let contexto = CoreDataStack.shared.persistentContainer.viewContext
    
    //MARK: - Variables Locales
    var empresas: [Empresa]?
    var empresaSeleccionada = 0
    var indexOfNumbers = [String]()
    var diccionario: [String : [Empresa]] = [:]
    
    @IBAction func crearCliente(_ sender: UIBarButtonItem) {
        let destinoVC = storyboard?.instantiateViewController(withIdentifier: "CrearClienteNuevoTVC") as! IME_CrearClienteNuevoTVC
        
        destinoVC.esActualizacion = false
        
        let navigationController = UINavigationController(rootViewController: destinoVC)
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cerrarVentana))
        
        self.navigationController?.modalPresentationStyle = .currentContext
        self.present(navigationController, animated: true, completion: nil)
    }
    
    //MARK: - Utils
    @objc func cerrarVentana() {
        dismiss(animated: true, completion: nil)
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
        
        if empresas?.count == 0 {
            emptyTable(self.tableView)
        } else {
            resetTableUI(self.tableView)
        }
    }
    
    //MARK: - FUNCIONES PROPIAS
    func cargarEmpresasCD() {
        do {
            //Sentencia de busqueda en CoreData
            empresas = try contexto.fetch(Empresa.fetchRequest())
            
            //Orden alfabético del listado de Empresas
            empresas?.sort{$0.nombre! < $1.nombre!}
            
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

    // MARK: - Table view data source

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

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return indexOfNumbers
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClienteCustomCell", for: indexPath)
        
        cell.textLabel?.text = diccionario[indexOfNumbers[indexPath.section]]?[indexPath.row].nombre
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let borrarAction = UITableViewRowAction(style: .default, title: "Borrar") { (action, indexPath) in
            
            let empresa = self.diccionario[self.indexOfNumbers[indexPath.section]]?[indexPath.row]
            self.contexto.delete(empresa!)
            
            do {
                try self.contexto.save()
            } catch let error {
                print(error.localizedDescription)
            }
            
            
            //self.empresas?.remove(at: indexPath.row)
            self.diccionario[self.indexOfNumbers[indexPath.section]]!.remove(at: indexPath.row)
            
            if self.empresaSeleccionada != 0 {
                self.empresaSeleccionada = self.empresaSeleccionada - 1
            } else {
                self.empresaSeleccionada = 0
            }
            
            self.tableView.reloadData()
            
        }
        
        return [borrarAction]
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let destinoVC = storyboard?.instantiateViewController(withIdentifier: "CrearClienteNuevoTVC") as! IME_CrearClienteNuevoTVC
        
        destinoVC.cliente = diccionario[indexOfNumbers[indexPath.section]]?[indexPath.row]
        destinoVC.esActualizacion = true
        destinoVC.title = "Editar Cliente"
        
        self.navigationController?.pushViewController(destinoVC, animated: true)
        
    }

}
