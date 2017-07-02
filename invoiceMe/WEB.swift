//
//  WEB.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 1/7/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class WEB: UIViewController {
    //MARK: - Objetos propios COREDATA
    let appDel = UIApplication.shared.delegate as! AppDelegate
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var servicioProyecto: API_ServicioProyecto?
    var servicioEmpresa: API_ServicioEmpresa?
    var servicioDocumento: ServicioDocumento?
    var servicioEmisor: ServicioEmisor?
    var servicioProducto: ServicioProducto?
    
    //MARK: - Variables Locales
    
    var proyectos: [Proyecto] = []
    var empresas: [String] = []
    var diccionario: [String : [Proyecto]] = [:]
    var contador = UserDefaults.standard.integer(forKey: "contador")
    
    var tipoDocumento: Int?
    var numeroDocumento: Int?
    var emisor: Emisor?
    var receptor: Empresa?
    var documento: Documento?
    var destino: String?
    
    @IBAction func imprimir(_ sender: UIBarButtonItem) {
        
        let pdfLoc = NSURL(fileURLWithPath: destino!)
        let printController = UIPrintInteractionController.shared
        let printInfo = UIPrintInfo(dictionary:nil)
        
        printInfo.outputType = UIPrintInfoOutputType.general
        printInfo.jobName = "print Job"
        printController.printInfo = printInfo
        printController.printingItem = pdfLoc
        printController.present(from: sender, animated: true, completionHandler: nil)
    }
    
    @IBOutlet weak var webview: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //documento = crearDoc()
        
        /*
        if contador != 0{
            contador += 1
            
            documento = crearDoc()
        } else {
            contador = 1
            UserDefaults.standard.set(contador, forKey: "contador")
            
            documento = crearDoc()
        }
        
        servicioProyecto = API_ServicioProyecto(contexto: contexto)
        servicioEmpresa = API_ServicioEmpresa(contexto: contexto)
        
        proyectos = (servicioProyecto?.recuperarProyectos())!
 
        
        let image = UIImagePNGRepresentation(UIImage(named: "placeHolderLogo")!)?.base64EncodedString()
        documento?.logo = image
        
        //var contador = Int((documento?.numeroDocumento)!)
        //contador = contador + 1
        //UserDefaults.standard.set(contador, forKey: "contador")
        //documento?.numeroDocumento = Int16(contador)
        
            let parameter = documento?.toJSON()
            
            print("el json: \(parameter!)")
            print("el valor de contador es: \(contador)")
            let url = URL(string: "http://localhost:8080/PDFCreator/PDF")
            
            let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        
            Alamofire.download(
                url!,
                method: .post,
                parameters: parameter,
                encoding: JSONEncoding.default,
                headers: nil,
                to: destination).downloadProgress(closure: { (progress) in
                    //progress closure
                    print("Progress: \(progress.fractionCompleted)")
                }).response { response in
                    print(response.destinationURL!)
                    let path = response.destinationURL!
                    self.destino = path.path
                    print(self.destino!)
                    self.webview.loadRequest(URLRequest(url: path))
            }
            
        

        */
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        documento = crearDoc()
        
        let image = UIImagePNGRepresentation(UIImage(named: "placeHolderLogo")!)?.base64EncodedString()
        documento?.logo = image
        
        //var contador = Int((documento?.numeroDocumento)!)
        //contador = contador + 1
        //UserDefaults.standard.set(contador, forKey: "contador")
        //documento?.numeroDocumento = Int16(contador)
        
        let parameter = documento?.toJSON()
        
        print("el json: \(parameter!)")
        print("el valor de contador es: \(contador)")
        let url = URL(string: "http://localhost:8080/PDFCreator/PDF")
        
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        
        Alamofire.download(
            url!,
            method: .post,
            parameters: parameter,
            encoding: JSONEncoding.default,
            headers: nil,
            to: destination).downloadProgress(closure: { (progress) in
                //progress closure
                print("Progress: \(progress.fractionCompleted)")
            }).response { response in
                print(response.destinationURL!)
                let path = response.destinationURL!
                self.destino = path.path
                print(self.destino!)
                self.webview.loadRequest(URLRequest(url: path))
        }
    }

    func crearDoc() -> Documento? {
        servicioDocumento = ServicioDocumento(contexto: contexto)
        /*
        var arrayProductos: [Producto] = []
        arrayProductos.append(crearPro(id: 3)!)
        arrayProductos.append(crearPro(id: 4)!)
        */
        let doc = servicioDocumento?.crearDocumento(tipoDocumento: tipoDocumento!,
                                                    numeroDocumento: numeroDocumento!,
                                                    logo: "")
        doc?.emisor = emisor
        doc?.receptor = receptor
        //doc?.productos = NSSet(array: arrayProductos)
        
        appDel.saveContext()
        
        return servicioDocumento?.recuperarDocumentos().last
    }
    
    func crearEmi() -> Emisor? {
        servicioEmisor = ServicioEmisor(contexto: contexto)
        
        let emi = servicioEmisor?.crearEmisor(nombre: "Gustavo Gamboa Cordero",
                                        fecha: "01/07/2017",
                                        direccion: "Calle Aurora 29",
                                        zipCode: 28760,
                                        ciudad: "Tres Cantos",
                                        cif: "75891423w",
                                        iban: "ES70 1234 5678 1234 0987 7654")
        
        appDel.saveContext()
        
        return emi
    }
    
    func crearPro(id: Int) -> Producto? {
        servicioProducto = ServicioProducto(contexto: contexto)
        
        let pro = servicioProducto?.crearProducto(codigo: "JAVA\(id)",
                                            descripcion: "Ejemplo de descripccion de un articulo id: \(id)",
                                            cantidad: 20,
                                            precio: 30,
                                            iva: 0,
                                            irpf: 7,
                                            exentoIva: true,
                                            exentoIrpf: false)
        
        appDel.saveContext()
        
        return pro
    }
    
    func crearRecep () -> Empresa? {
        
        servicioEmpresa = API_ServicioEmpresa(contexto: contexto)
        
        let emp = servicioEmpresa?.crearEmpresa(nombre: "CICE",
                                                color: Int16(1),
                                                direccion: "Calle Povedilla",
                                                cpostal: "28760",
                                                ciudad: "Madrid",
                                                cif: "A12345678",
                                                email: "cice@ciceonline.com",
                                                telefono: "91 376 65 65")
        
        appDel.saveContext()
        
        return emp
        
    }

}
