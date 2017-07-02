//
//  API_Utils.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 6/3/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit


let CONSTANTES = Constantes()

struct Constantes {
    let COLORES = Colores()
}

struct Colores {
    let ARRAY_COLORES = [#colorLiteral(red: 0.1662613613, green: 0.4032051037, blue: 0.2543297463, alpha: 1),#colorLiteral(red: 0.5450980392, green: 0.8509803922, blue: 0.7647058824, alpha: 1),#colorLiteral(red: 0.2502827563, green: 0.7019311045, blue: 0.8830132378, alpha: 1),#colorLiteral(red: 0, green: 0.4143941104, blue: 0.5748094916, alpha: 1),#colorLiteral(red: 0.822672526, green: 0.0745171441, blue: 0.7198893229, alpha: 1),#colorLiteral(red: 0.9137254902, green: 0.7568627451, blue: 0.9333333333, alpha: 1),#colorLiteral(red: 1, green: 0.385687934, blue: 0.536496949, alpha: 1),#colorLiteral(red: 1, green: 0.8448621962, blue: 0.2726894404, alpha: 1),#colorLiteral(red: 1, green: 0.7024071813, blue: 0.3223260045, alpha: 1),#colorLiteral(red: 0.6470377604, green: 0.4429990681, blue: 0.2726894404, alpha: 1)]
    
    let PRIMARY_COLOR_DARK = #colorLiteral(red: 0.1882352941, green: 0.2470588235, blue: 0.6235294118, alpha: 1)
    let PRIMARY_COLOR = #colorLiteral(red: 0.2470588235, green: 0.3176470588, blue: 0.7098039216, alpha: 1)
    let PRIMARY_COLOR_LIGHT = #colorLiteral(red: 0.7725490196, green: 0.7921568627, blue: 0.9137254902, alpha: 1)
    let FIRST_TEXT_COLOR = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
    let SECOND_TEXT_COLOR = #colorLiteral(red: 0.4588235294, green: 0.4588235294, blue: 0.4588235294, alpha: 1)
    let DIVIDER_COLOR = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
}

func personalizaBackBTN(_ title: String) -> UIBarButtonItem{
    //Personalizando el boton back
    let backButton = UIBarButtonItem()
    
    backButton.tintColor = CONSTANTES.COLORES.PRIMARY_COLOR_LIGHT
    backButton.style = .plain
    backButton.title = title
    backButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 16.0)!], for:.normal)
    
    return backButton
}

func muestraAlertVC (titulo: String, mensaje: String) -> UIAlertController{
    
    let alertVC = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alertVC.addAction(alertAction)
    
    return alertVC
    
}

func pdfUrl() -> URL? {
    if let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first{
        
        let customUrl = URL(fileURLWithPath: documentDirectory)
        return customUrl.appendingPathComponent("")
        
    } else {
        return nil
    }
}
