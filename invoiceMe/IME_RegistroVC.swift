//
//  IME_RegistroVC.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 25/6/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit

class IME_RegistroVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var myNombrePerfil: UITextField!
    @IBOutlet weak var myBarraNombre: UIView!
    @IBOutlet weak var myCorreo: UITextField!
    @IBOutlet weak var myBarraCorreo: UIView!
    @IBOutlet weak var myPassword: UITextField!
    @IBOutlet weak var myBarraPassword: UIView!
    @IBOutlet weak var myBotonRegistro: UIButton!
    
    // MARK: - IBActions
    @IBAction func registrarUsuario(_ sender: UIButton) {
        // TODO: - Funcion para registrar usuario en parse
    }
    
    // MARK: - LIFE VC
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Personaliza boton
        myBotonRegistro.layer.cornerRadius = 5
        
        //Delegado de UITextfield
        myNombrePerfil.delegate = self
        myCorreo.delegate = self
        myPassword.delegate = self
        
        //Personalizacion del boton back del navigationController
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "arrow2")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "arrow2mask")
        self.navigationController?.navigationBar.backItem?.title = ""
    }
    
    // MARK: - Funciones de Utilidades
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
extension IME_RegistroVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            myBarraNombre.backgroundColor = CONSTANTES.COLORES.PRIMARY_COLOR
        } else if textField.tag == 1{
            myBarraCorreo.backgroundColor = CONSTANTES.COLORES.PRIMARY_COLOR
        } else {
            myBarraPassword.backgroundColor = CONSTANTES.COLORES.PRIMARY_COLOR
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        if textField.tag == 0 {
            myBarraNombre.backgroundColor = CONSTANTES.COLORES.PRIMARY_COLOR_LIGHT
        } else if textField.tag == 1{
            myBarraCorreo.backgroundColor = CONSTANTES.COLORES.PRIMARY_COLOR_LIGHT
        } else {
            myBarraPassword.backgroundColor = CONSTANTES.COLORES.PRIMARY_COLOR_LIGHT
        }
    }
}
