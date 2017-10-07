//
//  IME_NotificacionesTVC.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 25/2/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit

class IME_NotificacionesTVC: UITableViewController {

    
    
    
    
    
    
    //MARK: - IBActions
    @IBAction func cancelarAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func salvarCambios(_ sender: Any) {
        print("Aqui guardar cambios")
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - LIFE TVC
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        switch section {
        case 0:
            return 2
        default:
            return 3
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

}
