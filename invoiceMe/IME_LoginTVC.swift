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
    
    // MARK: - IBOutlets
    @IBOutlet weak var myCorreo: UITextField!
    @IBOutlet weak var myBarraCorreo: UIView!
    @IBOutlet weak var myPassword: UITextField!
    @IBOutlet weak var myBarraPassword: UIView!
    @IBOutlet weak var myBotonLogin: UIButton!
    @IBOutlet weak var myTopCons: NSLayoutConstraint!
    @IBOutlet weak var myBottomCons: NSLayoutConstraint!
    @IBOutlet weak var myImagenPerfil: UIImageView!
    
    // MARK: - IBActions
    @IBAction func loginUsuario(_ sender: UIButton) {
        HUD.show(.progress)
        let sign = APISignIn(p_username: myCorreo.text!, p_password: myPassword.text!)
        do {
            try sign.signUser()
            UserDefaults.standard.setValue("REGISTERED", forKey: CONSTANTES.PREFS.REGISTERED)
            self.performSegue(withIdentifier: "fromLoginTVC", sender: self)
        } catch let error{
            present(muestraAlertVC(titulo: "Lo sentimos", mensaje: "\(error.localizedDescription)"),
                    animated: true,
                    completion: nil)
        }
        HUD.hide(afterDelay: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deviceSize = self.view.frame.height
        self.navigationController?.navigationBar.topItem?.title = ""
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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


