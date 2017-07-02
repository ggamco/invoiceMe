//
//  IME_ServicioWebVC.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 3/7/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class IME_ServicioWebVC: UIViewController {

    // MARK: - Objetos propios COREDATA
    let appDel = UIApplication.shared.delegate as! AppDelegate
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var servicioDocumento: ServicioDocumento?
    
    // MARK: - Variables Locales
    var tipoDocumento: Int?
    var numeroDocumento: Int?
    var emisor: Emisor?
    var receptor: Empresa?
    var documento: Documento?
    var destino: String?
    
    // MARK: - IBOutlets
    @IBOutlet weak var webview: UIWebView!
    
    // MARK: - IBActions
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        servicioDocumento = ServicioDocumento(contexto: contexto)
        print(tipoDocumento)
        print(numeroDocumento)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        documento = crearDoc()
        
        let image = UIImagePNGRepresentation(UIImage(named: "placeHolderLogo")!)?.base64EncodedString()
        documento?.logo = image
        
        let parameter = documento?.toJSON()
        
        print("el json: \(parameter!)")

        let url = URL(string: "http://192.168.1.109:8080/PDFCreator/PDF")
        
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
    
    // MARK: - Funciones propias
    func crearDoc() -> Documento? {
        let doc = servicioDocumento?.crearDocumento(tipoDocumento: tipoDocumento!,
                                                    numeroDocumento: numeroDocumento!,
                                                    logo: "")
        doc?.emisor = emisor
        doc?.receptor = receptor
        
        appDel.saveContext()
        
        return servicioDocumento?.recuperarDocumentos().last
    }

}
