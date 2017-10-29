//
//  IME_ProyectosTVC.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 5/1/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON
import Alamofire
import WebKit

class IME_ProyectosTVC: UITableViewController {

    //MARK: - Objetos propios COREDATA
    let contexto = CoreDataStack.shared.persistentContainer.viewContext
    
    var servicioProyecto: API_ServicioProyecto?
    var servicioEmpresa: API_ServicioEmpresa?
    
    //MARK: - Variables Locales
    
    var proyectos: [Proyecto] = []
    var empresas: [String] = []
    var diccionario: [String : [Proyecto]] = [:]
    
    @IBAction func crearProyecto(_ sender: UIBarButtonItem) {
        let destinoVC = storyboard?.instantiateViewController(withIdentifier: "CrearProyectoNuevoTVC") as! IME_CrearProyectoNuevoTVC
        
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
        
        servicioProyecto = API_ServicioProyecto(contexto: contexto)
        servicioEmpresa = API_ServicioEmpresa(contexto: contexto)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        proyectos = (servicioProyecto?.recuperarProyectos())!
        ordenarProyectosPorEmpresa()
        tableView.reloadData()
        
        
    }

    //MARK: - Recupera empresas
    func recuperarEmpresasDeProyectos() -> [String]{
        var listaEmpresas: [String] = []
        
        for proyecto in proyectos {
            let empresa = proyecto.empresa
            if !listaEmpresas.contains(empresa!){
                listaEmpresas.append(empresa!)
            }
        }
        
        listaEmpresas.sort{$0.localizedCompare($1) == .orderedAscending}
        return listaEmpresas
    }
    
    func ordenarProyectosPorEmpresa() {
        
        diccionario.removeAll(keepingCapacity: false)
        empresas = recuperarEmpresasDeProyectos()
        
        for empresa in empresas {
            var listaProyectos: [Proyecto] = []
            for proyecto in proyectos where proyecto.empresa == empresa {
                listaProyectos.append(proyecto)
            }
            diccionario[empresa] = listaProyectos
            
        }
    }
    
    //MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        if proyectos.count == 0 {
            emptyTable(tableView)
        } else {
            resetTableUI(tableView)
        }
        return diccionario.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (diccionario[empresas[section]]?.count)!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = diccionario[empresas[indexPath.section]]?[indexPath.row]
        
        if (data?.facturadoHoras)! {
            //creo la celda
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellBudge", for: indexPath) as! IME_ProjectBudgeCell
            
            //modifico la celda
            cell.myLogoProject.image = cell.myLogoProject.image?.withRenderingMode(.alwaysTemplate)
            cell.myLogoProject.tintColor = UIColor.white
            cell.myLogoProject.backgroundColor = CONSTANTES.COLORES.ARRAY_COLORES[Int((data?.cliente?.color)!)]
            cell.myLogoProject.layer.cornerRadius = cell.myLogoProject.frame.size.width / 2
            cell.myProjectName.text = data?.nombre
            if let _ = data?.horasEstimadas {
                let calculo = calcularProgreso(data!)
                cell.myProgressLabel.text = String(format: "%.0f", calculo * 100 ) + "%"
                cell.myProgressBar.progress = Float(calculo)
            } else {
                cell.myProgressLabel.text = "0%"
                cell.myProgressBar.progress = 0.0
            }
            
            
            //devuelvo la celda
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellBasic", for: indexPath) as! IME_ProjectBasicCell
            
            cell.myLogoProject.image = cell.myLogoProject.image?.withRenderingMode(.alwaysTemplate)
            cell.myLogoProject.tintColor = UIColor.white
            let color = dimeInt(data?.cliente?.color)
            if color != -1{
                cell.myLogoProject.backgroundColor = CONSTANTES.COLORES.ARRAY_COLORES[color]
            } else {
                cell.myLogoProject.backgroundColor = CONSTANTES.COLORES.DESCONOCIDO
            }
            
            cell.myLogoProject.layer.cornerRadius = cell.myLogoProject.frame.size.width / 2
            cell.myProjectName.text = data?.nombre
            
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return empresas[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let data = diccionario[empresas[indexPath.section]]?[indexPath.row]
        
        if (data?.facturadoHoras)! {
            return 72.0
        } else {
            return 62.0
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let title = UILabel()
        title.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        title.textColor = UIColor.darkGray
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = title.font
        header.textLabel?.textColor = title.textColor
        header.tintColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        header.backgroundView?.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)

    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
                
        let borrarAction = UITableViewRowAction(style: .destructive, title: "Borrar") { (action, indexPath) in
            
            let proyecto = self.diccionario[self.empresas[indexPath.section]]?[indexPath.row]
            self.diccionario[self.empresas[indexPath.section]]?.remove(at: indexPath.row)
            
            if self.diccionario[self.empresas[indexPath.section]]?.count == 0 {
                self.diccionario.removeValue(forKey: self.empresas[indexPath.section])
                self.empresas.remove(at: indexPath.section)
                if let index = self.proyectos.enumerated().filter( { $0.element === proyecto }).map({ $0.offset }).first {
                    self.proyectos.remove(at: index)
                }
            }
            
            self.servicioProyecto?.eliminarProyecto(by: (proyecto?.objectID)!)
            do {
                try self.contexto.save()
            } catch let error {
                print(error.localizedDescription)
            }
            
            self.tableView.reloadData()
        }
        
        return [borrarAction]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let destinoVC = storyboard?.instantiateViewController(withIdentifier: "DetalleProyectoVC") as! IME_DetalleProyectoVC
        
        destinoVC.proyecto = diccionario[empresas[indexPath.section]]?[indexPath.row]
        destinoVC.title = "Detalle Proyecto"
        
        // IMPORTANT!
        // Este es el que funciona para ocultar el titulo del back buttom item
        self.navigationItem.backBarButtonItem?.title = ""
        
        self.navigationController?.pushViewController(destinoVC, animated: true)

    }
    // MARK: - Utiles
    @objc func cerrarVentana() {
        dismiss(animated: true, completion: nil)
    }
    
    func calcularProgreso(_ proyecto: Proyecto) -> Double{
        let documentos = proyecto.documentos?.allObjects as! [Documento]
        var sumatorioHoras: Double = 0.0
        var sumatorioProductos: Double = 0.0
        for doc in documentos {
            if Int(doc.tipoDocumento) == 1 {
                
                let productos = doc.productos?.allObjects as! [Producto]
                for pro in productos {
                    let tipoMedida = Int((pro.productoBase?.tipoMedida)!)
                    if tipoMedida == 1 {
                        sumatorioHoras = sumatorioHoras + pro.cantidad
                        sumatorioProductos = sumatorioProductos + 1.0
                    }
                }
                
            }
        }
        let resultado = Double(sumatorioHoras) / proyecto.horasEstimadas
        print("Resultado: \(resultado)")
        return resultado
    }
}
