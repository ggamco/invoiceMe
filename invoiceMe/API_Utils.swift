//
//  API_Utils.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 6/3/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit

let CONSTANTES = Constantes()
let CUSTOM_PREFS = UserDefaults.standard

struct Constantes {
    let COLORES = Colores()
    let PREFS = Preferencias()
    let DEVICE = DeviceSize()
    let URLS = Urls()
}

struct Colores {
    let ARRAY_COLORES = [#colorLiteral(red: 0.1662613613, green: 0.4032051037, blue: 0.2543297463, alpha: 1),#colorLiteral(red: 0.5450980392, green: 0.8509803922, blue: 0.7647058824, alpha: 1),#colorLiteral(red: 0.2502827563, green: 0.7019311045, blue: 0.8830132378, alpha: 1),#colorLiteral(red: 0, green: 0.4143941104, blue: 0.5748094916, alpha: 1),#colorLiteral(red: 0.822672526, green: 0.0745171441, blue: 0.7198893229, alpha: 1),#colorLiteral(red: 0.9137254902, green: 0.7568627451, blue: 0.9333333333, alpha: 1),#colorLiteral(red: 1, green: 0.385687934, blue: 0.536496949, alpha: 1),#colorLiteral(red: 1, green: 0.8448621962, blue: 0.2726894404, alpha: 1),#colorLiteral(red: 1, green: 0.7024071813, blue: 0.3223260045, alpha: 1),#colorLiteral(red: 0.6470377604, green: 0.4429990681, blue: 0.2726894404, alpha: 1)]
    
    let PRIMARY_COLOR_DARK = #colorLiteral(red: 0.003921568627, green: 0.3411764706, blue: 0.6078431373, alpha: 1)
    let PRIMARY_COLOR = #colorLiteral(red: 0.007843137255, green: 0.4666666667, blue: 0.7411764706, alpha: 1)
    let PRIMARY_COLOR_LIGHT = #colorLiteral(red: 0.8823529412, green: 0.9607843137, blue: 0.9960784314, alpha: 1)
    let FIRST_TEXT_COLOR = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
    let SECOND_TEXT_COLOR = #colorLiteral(red: 0.4588235294, green: 0.4588235294, blue: 0.4588235294, alpha: 1)
    let DIVIDER_COLOR = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
    let NAV_ITEMS = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    let PRESUPUESTO = #colorLiteral(red: 1, green: 0.7019607843, blue: 0, alpha: 1)
    let FACTURA = #colorLiteral(red: 0.8039215686, green: 0.862745098, blue: 0.2235294118, alpha: 1)
    let DESCONOCIDO = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
}

struct Preferencias {
    let REGISTERED = "registered"
    let FIRST_TIME = "firstTime"
}

struct DeviceSize {
    let SMALL: CGFloat = 480.0
    let MEDIUM: CGFloat = 568.0
    let STANDARD: CGFloat = 667.0
    let PLUS: CGFloat = 736.0
}

struct Urls {
    let AUTH_CODE = ""
    let URL_PDF_CREATE = "http://gmbdesign.es/PDFCreator/PDF"
    let URL_REGISTER_DEVICE = "http://gmbdesign.es/PDFCreator/RegisterDeviceOnAPI"
}

func personalizaBackBTN(_ title: String) -> UIBarButtonItem{
    //Personalizando el boton back
    let backButton = UIBarButtonItem()
    
    backButton.tintColor = CONSTANTES.COLORES.PRIMARY_COLOR_LIGHT
    backButton.style = .plain
    backButton.title = title
    backButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "HelveticaNeue", size: 16.0)!], for:.normal)
    
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

func emptyTable(_ tableView: UITableView) {
    let backTable = UIImageView(frame: tableView.bounds)
    backTable.contentMode = .scaleAspectFill
    backTable.image = #imageLiteral(resourceName: "placeHolderTable")
    tableView.backgroundView = backTable
    tableView.separatorStyle = .none
}

func resetTableUI(_ tableView: UITableView) {
    tableView.separatorStyle = .singleLine
    tableView.backgroundView = nil
}

// MARK: - Politica de nulos
func dimeString(_ texto: String?) -> String {
    if texto != nil {
        return texto!
    } else {
        return ""
    }
}

func dimeInt(_ numero: Int16?) -> Int {
    if numero != nil {
        return Int(numero!)
    } else {
        return -1
    }
}

func dimeDouble(_ double: Double?) -> Double {
    if double != nil {
        return double!
    } else {
        return 0.0
    }
}

func dimeBool(_ bool: Bool?) -> Bool {
    if bool != nil {
        return bool!
    } else {
        return false
    }
}

func convertirToEntero(_ convertible: String?) -> Int {
    if let conversion = Int(convertible!) {
        return conversion
    } else {
        return 0
    }
}
