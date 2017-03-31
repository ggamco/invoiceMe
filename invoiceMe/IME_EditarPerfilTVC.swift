//
//  IME_EditarPerfilTVC.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 25/2/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit

class IME_EditarPerfilTVC: UITableViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var myImagenPerfil: UIImageView!
    @IBOutlet weak var myNombreCompletoTF: UITextField!
    @IBOutlet weak var myEmailTF: UITextField!
    @IBOutlet weak var myZonaHorariaLB: UILabel!
    
    
    
    //MARK: - IBActions
    @IBAction func cancelarAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func salvarCambios(_ sender: Any) {
        print("Aqui almacenamos los cambios")
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    //MARK: - LIFE TVC
    override func viewDidLoad() {
        super.viewDidLoad()

        myImagenPerfil.layer.cornerRadius = myImagenPerfil.frame.width / 2
        myImagenPerfil.layer.borderWidth = 2
        myImagenPerfil.layer.borderColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1).cgColor
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
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
