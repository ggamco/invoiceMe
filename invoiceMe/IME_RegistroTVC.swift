//
//  IME_RegistroTVC.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 24/9/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit
import Parse

class IME_RegistroTVC: UITableViewController {

    // Variable local
    var deviceSize: CGFloat!
    var fotoSeleccionada = false
    
    // MARK: - IBOutlets
    @IBOutlet weak var myCorreo: UITextField!
    @IBOutlet weak var myBarraCorreo: UIView!
    @IBOutlet weak var myPassword: UITextField!
    @IBOutlet weak var myBarraPassword: UIView!
    @IBOutlet weak var myBotonRegistro: UIButton!
    @IBOutlet weak var myTopCons: NSLayoutConstraint!
    @IBOutlet weak var myBottomCons: NSLayoutConstraint!
    @IBOutlet weak var myImagenPerfil: UIImageView!
    @IBOutlet weak var myLabelPerfil: UILabel!
    
    // MARK: - IBActions
    @IBAction func registrarUsuario(_ sender: UIButton) {
        // TODO: - Funcion para registrar usuario en parse
        var errorInicial = ""
        
        if verificaTF(myCorreo.text) || verificaTF(myPassword.text)  {
            
            errorInicial = "Por favor, rellene los campos solicitados."
            
        } else {
            let newUser = PFUser()
            newUser.password = myPassword.text
            newUser.email = myCorreo.text
            
            newUser.signUpInBackground(block: { (exitoso, errorRegistro) in
                
                if errorRegistro != nil {
                    self.present(muestraAlertVC(titulo: "Atención", mensaje: "\((errorRegistro?.localizedDescription)!)"), animated: true, completion: nil)
                } else {
                    self.signUpWithPhoto()
                    self.registerDeviceOnAPI()
                    self.performSegue(withIdentifier: "jumpFromRegisterVC", sender: self)
                }
            })
            
            if errorInicial != "" {
                present(muestraAlertVC(titulo: "Atención", mensaje: errorInicial), animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //personaliza imagen perfil
        myImagenPerfil.layer.cornerRadius = myImagenPerfil.frame.width / 2
        myImagenPerfil.layer.borderWidth = 2
        myImagenPerfil.layer.borderColor = CONSTANTES.COLORES.PRIMARY_COLOR_LIGHT.cgColor
        
        //gesto sobre la imagen para que el usuario pueda interactuar
        myImagenPerfil.isUserInteractionEnabled = true
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(pickerPhoto))
        myImagenPerfil.addGestureRecognizer(tapGR)
        
        //Personaliza boton
        myBotonRegistro.layer.cornerRadius = 5
        
        //Delegado de UITextfield
        myCorreo.delegate = self
        myPassword.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

    //MARK: - Utiles
    
    func verificaTF(_ string: String?) -> Bool {
        return string?.trimmingCharacters(in: .whitespaces) == ""
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
    
    func signUpWithPhoto() {
        if !fotoSeleccionada {
            self.present(muestraAlertVC(titulo: "Atención", mensaje: "Foto no seleccionada"), animated: true, completion: nil)
        } else {
            let imageProfile = PFObject(className: "ImageProfile")
            let imageDataProfile = UIImageJPEGRepresentation(myImagenPerfil.image!, 0.3)
            let imageProfileFile = PFFile(name: "userImageProfile.jpg", data: imageDataProfile!)
            
            imageProfile["imageProfile"] = imageProfileFile
            imageProfile["username"] = PFUser.current()?.username
            
            imageProfile.saveInBackground()
        }
    }
    
    func registerDeviceOnAPI() {
        
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
extension IME_RegistroTVC : UITextFieldDelegate {
    
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

extension IME_RegistroTVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func pickerPhoto(){
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            muestraMenu()
        } else {
            muestraLibreriaFotos()
        }
        
    }
    
    func muestraMenu(){
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        let tomaFoto = UIAlertAction(title: "Toma foto", style: .default) { _ in
            
            self.muestraCamaraDispositivo()
            
        }
        let seleccionaFoto = UIAlertAction(title: "Selecciona desde Fotos", style: .default) { _ in
            
            self.muestraLibreriaFotos()
            
        }
        
        alertVC.addAction(cancelAction)
        alertVC.addAction(tomaFoto)
        alertVC.addAction(seleccionaFoto)
        present(alertVC, animated: true, completion: nil)
    }
    
    func muestraLibreriaFotos(){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func muestraCamaraDispositivo(){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let imageData = info[UIImagePickerControllerOriginalImage] as? UIImage{
            myImagenPerfil.image = imageData
            fotoSeleccionada = true
            myLabelPerfil.isHidden = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
}

