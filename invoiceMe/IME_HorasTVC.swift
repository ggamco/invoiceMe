//
//  IME_HorasTVC.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 18/1/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit

class IME_HorasTVC: UITableViewController {

    
    //MARK: - IBOutlets
    @IBOutlet var myTable: UITableView!
    
    
    //MARK: - LIFE VC
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let botonLateral = UILabel()
        let botonLateralDos = UILabel()
        let fontRegular = UIFont(name: "HelveticaNeue", size: 14.0)
        let fontLight = UIFont(name: "HelveticaNeue-Light", size: 14.0)
        
        botonLateral.text = "Today:"
        botonLateralDos.text = "0h 0m, €0.00"
        botonLateral.font = fontRegular
        botonLateralDos.font = fontLight
        botonLateral.sizeToFit()
        botonLateralDos.sizeToFit()
        botonLateral.textColor = CONSTANTES.COLORES.PRIMARY_COLOR_LIGHT
        botonLateralDos.textColor = CONSTANTES.COLORES.PRIMARY_COLOR_LIGHT
        
        let customItemUno = UIBarButtonItem(customView: botonLateral)
        let customItemDos = UIBarButtonItem(customView: botonLateralDos)
        let myArrayBotones: [UIBarButtonItem] = [customItemUno, customItemDos]
        
        self.navigationItem.leftBarButtonItems = myArrayBotones
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


