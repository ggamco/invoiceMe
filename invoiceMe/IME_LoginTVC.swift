//
//  IME_LoginTVC.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 16/9/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit
import Parse
import PKHUD
import Alamofire

class IME_LoginTVC: UITableViewController {
    
    // Variable local
    var deviceSize: CGFloat!
    var fromLogOut = false
    
    // MARK: - IBOutlets
    @IBOutlet weak var myCorreo: UITextField!
    @IBOutlet weak var myBarraCorreo: UIView!
    @IBOutlet weak var myPassword: UITextField!
    @IBOutlet weak var myBarraPassword: UIView!
    @IBOutlet weak var myBotonLogin: UIButton!
    @IBOutlet weak var myTopCons: NSLayoutConstraint!
    @IBOutlet weak var myBottomCons: NSLayoutConstraint!
    @IBOutlet weak var myImagenPerfil: UIImageView!
    @IBOutlet weak var myBotonReset: UIButton!
    @IBOutlet weak var registrateView: UIView!
    
    // MARK: - IBActions
    @IBAction func resetPassword(_ sender: UIButton) {
        if !(myCorreo.text?.isEmpty)! {
            myBotonReset.isEnabled = false
            PFUser.requestPasswordResetForEmail(inBackground: myCorreo.text!)
            present(muestraAlertVC(titulo: "Comprueba tu cuenta de correo", mensaje: "Hemos enviado un mensaje a tu correo con las instrucciones para cambiar la contraseña de tu cuenta InvoiceMe"), animated: true, completion: {
                self.myBotonReset.isEnabled = true
            })
        } else {
            present(muestraAlertVC(titulo: "¡Atención!", mensaje: "Introduce tu correo electrónico"), animated: true, completion: nil)
        }
    }
    
    @IBAction func loginUsuario(_ sender: UIButton) {
        
        if (myCorreo.text?.isEmpty)! || (myCorreo.text?.isEmpty)! {
            present(muestraAlertVC(titulo: "¡Atención!", mensaje: "Rellena todos los campos para continuar"), animated: true, completion: nil)
        } else {
            HUD.show(.progress)
            PFUser.logInWithUsername(inBackground: myCorreo.text!, password: myPassword.text!, block: { (user, error) in
                HUD.hide(afterDelay: 0)
                if user != nil {
                    //Login ok
                    DispatchQueue.main.async {
                        if UserDefaults.standard.string(forKey: CONSTANTES.PREFS.REGISTERED) == nil {
                            UserDefaults.standard.setValue("REGISTERED", forKey: CONSTANTES.PREFS.REGISTERED)
                        }
                        self.performSegue(withIdentifier: "fromLoginTVC", sender: self)
                    }
                } else {
                    self.present(muestraAlertVC(titulo: "Lo sentimos...", mensaje: "\(error?.localizedDescription ?? "Error desconocido. Inténtalo denuevo más tarde")"), animated: true, completion: nil)
                }
            })
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if fromLogOut {
            registrateView.isHidden = false
            //IMPORTANTE
            //ESTAS LINEAS ELIMINAN EL TITULO AL BACKBUTTON
            let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backBarButtonItem
            //COLOCARLAS SIEMPRE EN EL PADRE
        } else {
            registrateView.isHidden = true
        }
        deviceSize = self.view.frame.height
        self.navigationController?.navigationBar.tintColor = CONSTANTES.COLORES.NAV_ITEMS
        //Personaliza boton
        myBotonLogin.layer.cornerRadius = 5
        
        //Delegado de UITextfield
        myCorreo.delegate = self
        myPassword.delegate = self
        
    }
    
    // MARK: - Utils
    func loginDeviceOnAPI() -> Error? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var errorServicio: Error?
        
        let url = URL(string: CONSTANTES.URLS.URL_REGISTER_DEVICE)
        let paremeters: [String : String] = [
            "deviceToken" : appDelegate.TOKEN_DEVICE,
            "user" : myCorreo.text!
        ]
        let headers: [String : String] = [
            "Autorization" : CONSTANTES.URLS.AUTH_CODE,
            "content-type": "application/json"
        ]
        Alamofire.request(
            url!,
            method: .post,
            parameters: paremeters,
            encoding: JSONEncoding.default,
            headers: headers).response { (response) in
                if let error = response.error {
                    print("Se ha producido un error en la autentificación y registro del dispositivo. \(error.localizedDescription)")
                    errorServicio = error
                } else {
                    print("Registrado correctamente")
                }
        }
        return errorServicio
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return getHeightRow(by: deviceSize)
        case 1:
            return 72.0
        case 2:
            return 72.0
        default:
            return 124.0
        }
    }
    
    // MARK: - Funciones de Utilidades
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func getHeightRow(by deviceSize: CGFloat) -> CGFloat{
        switch deviceSize {
        case CONSTANTES.DEVICE.SMALL:
            myTopCons.constant = 4.0
            myBottomCons.constant = 4.0
            return 148.0
        case CONSTANTES.DEVICE.MEDIUM:
            myTopCons.constant = 16.0
            myBottomCons.constant = 16.0
            return 236.0
        case CONSTANTES.DEVICE.STANDARD:
            myTopCons.constant = 52.0
            myBottomCons.constant = 52.0
            return 335.0
        case CONSTANTES.DEVICE.PLUS:
            myTopCons.constant = 96.0
            myBottomCons.constant = 96.0
            return 424.0
        default:
            myTopCons.constant = 96.0
            myBottomCons.constant = 96.0
            return 424.0
        }
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToRegister" {
            let destinoVC = segue.destination as! IME_RegistroTVC
            destinoVC.fromLoginVC = true
        }
    }

}// MARK: - Fin de la clase

// MARK: - Extension del delegado UITextField
extension IME_LoginTVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            myBarraCorreo.backgroundColor = CONSTANTES.COLORES.PRIMARY_COLOR
        } else {
            myBarraPassword.backgroundColor = CONSTANTES.COLORES.PRIMARY_COLOR
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            myBarraCorreo.backgroundColor = CONSTANTES.COLORES.PRIMARY_COLOR_LIGHT
        } else {
            myBarraPassword.backgroundColor = CONSTANTES.COLORES.PRIMARY_COLOR_LIGHT
        }
    }
}


