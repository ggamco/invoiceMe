//
//  IME_HostViewController.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 25/6/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit
import InteractiveSideMenu

class IME_HostViewController: MenuContainerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Configuramos las opciones de transicion
        self.transitionOptions = cargarOpciones()
        
        // Cargamos el controlador del menu
        self.menuViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuTVC") as! MenuViewController
        
        // Cargamos los controladores de las vistas asociadas al menu
        self.contentViewControllers = contentControllers()
        
        // Select initial content controller. It's needed even if the first view controller should be selected.
        self.selectContentViewController(contentViewControllers.first!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func cargarOpciones() -> TransitionOptions {
        let screenSize = UIScreen.main.bounds
        
        var options = TransitionOptions()
        options.duration = 0.4
        options.contentScale = 1.0
        options.visibleContentWidth = screenSize.width - (screenSize.width - 64)
        
        return options
    }
    
    private func contentControllers() -> [UIViewController] {
        let controllersIdentifiers = ["Nav"]
        var contentList = [UIViewController]()
        
        // Cargamos las vistas usando sus identificadores
        for identifier in controllersIdentifiers {
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: identifier) {
                contentList.append(viewController)
            }
        }
        
        return contentList
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
