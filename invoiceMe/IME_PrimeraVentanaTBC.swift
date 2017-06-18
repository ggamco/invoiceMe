//
//  IME_PrimeraVentanaTBC.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 1/1/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit

class IME_PrimeraVentanaTBC: UITabBarController {

    //MARKS: - Variables Locales
    let selectedColor   = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    let unselectedColor = UIColor(red: 103.0/255.0, green: 124.0/255.0, blue: 11.0/255.0, alpha: 1.0)
    
    //MARKS: - IBOutlets
    
    
    //MARKS: - LIFE VC
    override func viewDidLoad() {
        super.viewDidLoad()
        //UINavigationBar.appearance().barTintColor = CONSTANTES.COLORES.PRIMARY_COLOR
        //self.tabBar.barStyle = .black
        //self.tabBar.barTintColor = CONSTANTES.COLORES.PRIMARY_COLOR
        //self.tabBar.unselectedItemTintColor = CONSTANTES.COLORES.FIRST_TEXT_COLOR
        //self.tabBar.tintColor = CONSTANTES.COLORES.PRIMARY_COLOR_LIGHT
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Cargamos la status bar en negro
        //UIApplication.shared.statusBarStyle = .default
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
