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
import PKHUD
import MessageUI

class IME_ServicioWebVC: UIViewController {

    // MARK: - Objetos propios COREDATA
    let contexto = CoreDataStack.shared.persistentContainer.viewContext
    var servicioDocumento: ServicioDocumento?
    
    // MARK: - Variables Locales
    var documento: Documento?
    
    // MARK: - IBOutlets
    @IBOutlet weak var webview: UIWebView!
    
    // MARK: - IBActions
    @IBAction func cerrarVentana(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func enviarEmail(_ sender: UIBarButtonItem) {
        envioEmailPreparado()
    }
    
    @IBAction func imprimir(_ sender: UIBarButtonItem) {
        let pdfLoc = NSURL(fileURLWithPath: (documento?.pathFichero)!)
        let printController = UIPrintInteractionController.shared
        let printInfo = UIPrintInfo(dictionary:nil)
        
        printInfo.outputType = UIPrintInfoOutputType.general
        printInfo.jobName = "Imprimir Documento"
        printController.printInfo = printInfo
        printController.printingItem = pdfLoc
        printController.present(from: sender, animated: true, completionHandler: nil)
    }
    
    // MARK: - LIFE VC
    override func viewDidLoad() {
        super.viewDidLoad()
        servicioDocumento = ServicioDocumento(contexto: contexto)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        HUD.show(.progress)
        if (documento?.esActualizado)! {
            if let path = documento?.pathFichero {
                cargarPDF(path)
                HUD.hide(afterDelay: 0)
            } else {
                llamadaServicio()
                HUD.hide(afterDelay: 3)
            }
        } else {
            llamadaServicio()
            HUD.hide(afterDelay: 3)
        }
        
    }
    
    func envioEmailPreparado(){
        let mailComposeVC = configuracionMailVC()
        if MFMailComposeViewController.canSendMail(){
            present(mailComposeVC, animated: true, completion: nil)
        }else{
            let alertMailVC = UIAlertController(title: "Estimado usuario", message: "No hemos podido enviar el mail", preferredStyle: .alert)
            alertMailVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alertMailVC, animated: true, completion: nil)
        }
    }
    
    func configuracionMailVC() -> MFMailComposeViewController  {
        let mailCompose = IME_MailComposeCustom()
        if let email = documento?.receptor?.email {
            mailCompose.setToRecipients([email])
        } else {
            mailCompose.setToRecipients([""])
        }
        if let sufijo = documento?.sufijoDocumento, let num = documento?.numeroDocumento, let path = documento?.pathFichero {
            mailCompose.setSubject("Factura \(num)\(sufijo)")
            mailCompose.addAttachmentData(adjuntarPDF(path)! as Data, mimeType: "application/pdf", fileName: "Factura \(num)\(sufijo).pdf")
            mailCompose.setMessageBody("Estimado cliente,\n\nRemito factura nº \(num)\(sufijo) para su abono según los terminos acordados.\n\nReciba un cordial saludo.", isHTML: false)
        } else {
            mailCompose.setMessageBody("Estimado cliente,\n\nRemito factura nº para su abono según los terminos acordados.\n\nReciba un cordial saludo.", isHTML: false)
            mailCompose.setSubject("Factura")
        }
        mailCompose.mailComposeDelegate = self
        mailCompose.navigationBar.tintColor = UIColor.white
        return mailCompose
    }
    
    func adjuntarPDF(_ path: String) -> NSData?{
        let url = URL(fileURLWithPath: path)
        let data = NSData(contentsOf: url)
        return data
    }
    
    func cargarPDF(_ path: String) {
        let url = URL(fileURLWithPath: path)
        do{
            let data = try Data(contentsOf: url)
            self.webview.load(data, mimeType: "application/pdf", textEncodingName:"", baseURL: url.deletingLastPathComponent())
        } catch let error {
            print("Error: \(error.localizedDescription)")
            llamadaServicio()
        }
    }
    
    func llamadaServicio() {
        eliminarArchivoTemp()
        let image = UIImagePNGRepresentation(UIImage(named: "placeHolderLogo")!)?.base64EncodedString()
        documento?.logo = image
        let parameter = documento?.toJSON()
        print("JSON: \(parameter!)")
        let url = URL(string: CONSTANTES.URLS.URL_PDF_CREATE)
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        Alamofire.download(
            url!,
            method: .post,
            parameters: parameter,
            encoding: JSONEncoding.default,
            headers: nil,
            to: destination).downloadProgress(closure: { (progress) in
                print("Progress: \(progress.fractionCompleted)")
            }).response { response in
                let path = response.destinationURL!
                self.webview.loadRequest(URLRequest(url: path))
                self.documento?.pathFichero = path.path
                self.documento?.esActualizado = true
                do {
                    try self.contexto.save()
                } catch let error {
                    print(error.localizedDescription)
                }
        }
    }
    
    func eliminarArchivoTemp(){
        if !(documento?.esActualizado)! {
            if let rutaFichero = documento?.pathFichero {
                let url = URL(fileURLWithPath: rutaFichero)
                if FileManager.default.fileExists(atPath: url.path) {
                    do{
                        try FileManager.default.removeItem(atPath: url.path)
                    }catch let error{
                        print("Error: \(error.localizedDescription)")
                    }
                } else {
                    print("No se ha encontrado fichero...")
                }
            }
        }
    }
    
}
extension IME_ServicioWebVC : MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
