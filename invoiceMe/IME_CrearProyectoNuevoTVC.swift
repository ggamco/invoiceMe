//
//  IME_CrearProyectoNuevoTVC.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 26/2/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit
import CoreData

class IME_CrearProyectoNuevoTVC: UITableViewController {

    //MARK: - Elementos visuales Personalizados
    let font = UIFont(name: "HelveticaNeue", size: 16.0)
    let datapicker = UIDatePicker()
    let format = DateFormatter()
    
    //MARK: - Objetos propios COREDATA
    let appDel = UIApplication.shared.delegate as! AppDelegate
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - Variables Locales
    var celdasOcultas = true
    var today: Date?
    var tomorrow: Date?
    
    //Modelos
    var proyecto: Proyecto?
    var empresa: Empresa?
    
    //Servicios
    var servicioProyecto: API_ServicioProyecto?
    var servicioEmpresa: API_ServicioEmpresa?
    
    var empresas: [Empresa] = []
    var empresaSelecionada = 0
    var esActualizacion = false
    
    //MARK: - IBOutlets
    @IBOutlet weak var myCancelarBTN: UIBarButtonItem!
    @IBOutlet weak var mySalvarBTN: UIBarButtonItem!
    @IBOutlet weak var myNombreCliente: UILabel!
    @IBOutlet weak var myNombreProyecto: UITextField!
    @IBOutlet weak var myFechaInicio: UITextField!
    @IBOutlet weak var myFechaFin: UITextField!
    @IBOutlet weak var myInicioSW: UISwitch!
    @IBOutlet weak var myFinSW: UISwitch!
    @IBOutlet weak var myFacturarHoras: UISwitch!
    @IBOutlet weak var myTipoFacturacion: UISegmentedControl!
    @IBOutlet weak var myHorasEstimadas: UITextField!
    @IBOutlet weak var myPrecioHora: UITextField!
    
    //MARK: - IBActions
    @IBAction func cancelarAction(_ sender: Any) {
        self.dismiss(animated: true, completion:nil)
    }
    
    @IBAction func salvarDatosAction(_ sender: Any) {
        
        if esActualizacion {
            
            proyecto?.nombre = myNombreProyecto.text
            proyecto?.empresa = myNombreCliente.text
            proyecto?.tipoFacturacion = Int16(myTipoFacturacion.selectedSegmentIndex)
            proyecto?.facturadoHoras = myFacturarHoras.isOn
            proyecto?.horasEstimadas = Double(myHorasEstimadas.text!)!
            proyecto?.precioHora = Double(myPrecioHora.text!)!
            proyecto?.cliente = empresa
            
            servicioProyecto?.actualizarProyecto(proyectoActualizado: proyecto!)
            
        } else {
            
            if myNombreProyecto.text!.characters.count > 0 && myNombreCliente.text!.characters.count > 0{
                
                proyecto = servicioProyecto?.crearProyecto(nombre: myNombreProyecto.text!,
                                                           empresa: myNombreCliente.text!,
                                                           tipoFacturacion: Int16(myTipoFacturacion.selectedSegmentIndex),
                                                           facturadoHoras: myFacturarHoras.isOn,
                                                           horasEstimadas: myHorasEstimadas.text!,
                                                           precioHora: myPrecioHora.text!,
                                                           fechaInicio: myFechaInicio.text!,
                                                           fechaFinal: myFechaFin.text!)
                
                //Relación entre proyecto y cliente
                proyecto?.cliente = empresa
            }
        }
        
        appDel.saveContext()
        esActualizacion = false
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //cargamos los servicios
        servicioProyecto = API_ServicioProyecto(contexto: contexto)
        servicioEmpresa = API_ServicioEmpresa(contexto: contexto)
        
        //CONFIGURACIONES VARIAS
        format.dateStyle = DateFormatter.Style.long
        myFechaInicio.delegate = self
        myFechaFin.delegate = self
        
        //Mejoras estéticas del navigation controller
        myCancelarBTN.setTitleTextAttributes([NSFontAttributeName: font!], for:UIControlState.normal)
        mySalvarBTN.setTitleTextAttributes([NSFontAttributeName: font!], for:UIControlState.normal)
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: font!, NSForegroundColorAttributeName: CONSTANTES.COLORES.PRIMARY_COLOR_LIGHT]
        
        //CONFIGURAMOS LA CARGA DEL DATAPICKER
        datapicker.datePickerMode = UIDatePickerMode.date
        myFechaInicio.inputView = datapicker
        myFechaFin.inputView = datapicker
        datapicker.addTarget(self, action: #selector(setFechaLabel), for: UIControlEvents.valueChanged)
        
        //PREPARAMOS EL SWITCH PARA ENTRAR LA FECHA
        myInicioSW.addTarget(self, action: #selector(enableFecha(_:)), for: UIControlEvents.valueChanged)
        myFinSW.addTarget(self, action: #selector(enableFecha(_:)), for: UIControlEvents.valueChanged)
        myFacturarHoras.addTarget(self, action: #selector(mostrarFilasHoras), for: UIControlEvents.valueChanged)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        empresas = (servicioEmpresa?.recuperarEmpresas())!
        empresas.sort{$0.nombre! < $1.nombre!}
        
        if empresas.count > 0 {
            empresa = empresas[0]
            myNombreCliente.text = empresas[0].nombre
            myNombreCliente.textColor = CONSTANTES.COLORES.FIRST_TEXT_COLOR
        } else {
            myNombreCliente.text = "Nuevo Cliente"
            myNombreCliente.textColor = CONSTANTES.COLORES.SECOND_TEXT_COLOR
        }
        
        if proyecto != nil {
            myNombreProyecto.text = proyecto?.nombre
            myNombreCliente.text = proyecto?.cliente?.nombre
            myTipoFacturacion.selectedSegmentIndex = Int((proyecto?.tipoFacturacion)!)
            
            if (proyecto?.facturadoHoras)! {
                myFacturarHoras.isOn = true
                mostrarFilasHoras()
            }
            
            if let horas = proyecto?.horasEstimadas {
                myHorasEstimadas.text = String(horas)
            }
            
            if let precio = proyecto?.precioHora {
                myPrecioHora.text = String(precio)
            }
            
            if (proyecto?.fechaInicio?.characters.count)! > 0 {
                myInicioSW.isOn = true
                myFechaInicio.text = proyecto?.fechaInicio
            }
            
            if (proyecto?.fechaFinal?.characters.count)! > 0 {
                myFinSW.isOn = true
                myFechaFin.text = proyecto?.fechaFinal
            }
            
            
        } else {
            print("vacio")
        }
        
    }
    
    //MARK: - Funciones Propias
    
    func ocultarTeclado(){
        self.tableView.endEditing(true)
    }
    
    func enableFecha(_ sw: UISwitch){
        if sw.isOn {
            if sw.tag == 0 {
                myFechaInicio.isEnabled = true
                today = datapicker.date
                myFechaInicio.text = format.string(from: today!)
            } else {
                myFechaFin.isEnabled = true
                tomorrow = datapicker.date
                myFechaFin.text = format.string(from: tomorrow!)
            }
        } else {
            if sw.tag == 0 {
                myFechaInicio.isEnabled = false
                myFechaInicio.text = ""
            } else {
                myFechaFin.isEnabled = false
                myFechaFin.text = ""
            }
        }
    }
    
    func setFechaLabel(_ dp: UIDatePicker){
        
        if dp.tag == 0 {
            today = datapicker.date
            myFechaInicio.text = format.string(from: today!)
        } else {
            tomorrow = datapicker.date
            if today! > tomorrow! {
                tomorrow = today
                datapicker.date = tomorrow!
            }
            myFechaFin.text = format.string(from: tomorrow!)
            
        }
        
    }
    
    func mostrarFilasHoras(){
        celdasOcultas = !celdasOcultas
        tableView.reloadData()
    }

    // MARK: - TableView DATASOURCE
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 3
        case 1:
            return 1
        default:
            return 5
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 2 && celdasOcultas {
            switch indexPath.row {
                case 1, 2:
                    return 0
                default:
                    return 44
            }
        } else if indexPath.section == 0 && indexPath.row == 2{
            return 120
        }else {
            return 44
        }
        
        
    }
    
    // MARK: - Navegación SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backButton = UIBarButtonItem()
        backButton.title = self.navigationController?.navigationItem.title
        backButton.setTitleTextAttributes([NSFontAttributeName: font!], for:UIControlState.normal)
        navigationController?.navigationBar.tintColor = CONSTANTES.COLORES.PRIMARY_COLOR_LIGHT
        navigationItem.backBarButtonItem = backButton
        
        let destinationVC = segue.destination as? IME_ListaClientesTVC
        destinationVC?.empresaSeleccionada = empresaSelecionada
    }
    

}

//MARK: - Extensión de UITextFieldDelegate
extension IME_CrearProyectoNuevoTVC: UITextFieldDelegate{
    
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
