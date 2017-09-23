//
//  IME_OpcionesTVC.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 23/2/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit

class IME_OpcionesTVC: UITableViewController {

    let mySwitch = UISwitch()
    
    // MARK: - IBOutlets
    @IBOutlet weak var myImagenPerfil: UIImageView!
    @IBOutlet weak var myPermitirPushCell: UITableViewCell!
    @IBOutlet weak var myPushOptionsCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myImagenPerfil.layer.borderWidth = 2
        myImagenPerfil.layer.borderColor = CONSTANTES.COLORES.PRIMARY_COLOR.cgColor
        myImagenPerfil.layer.cornerRadius = myImagenPerfil.frame.width / 2
        
        mySwitch.onTintColor = CONSTANTES.COLORES.PRIMARY_COLOR
        mySwitch.addTarget(self, action: #selector(printPush), for: UIControlEvents.valueChanged)
        
        myPermitirPushCell.accessoryView = mySwitch
        
        myPushOptionsCell.isUserInteractionEnabled = false
        myPushOptionsCell.textLabel?.textColor = UIColor.gray
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @objc func printPush(){
        
        if mySwitch.isOn {
            myPushOptionsCell.isUserInteractionEnabled = true
            myPushOptionsCell.textLabel?.textColor = UIColor.black
        } else {
            myPushOptionsCell.isUserInteractionEnabled = false
            myPushOptionsCell.textLabel?.textColor = UIColor.gray
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var filas = 0;
        
        switch section {
        case 0:
            filas = 1
        default:
            filas = 2
        }
        
        return filas
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {

        guard let footer = view as? UITableViewHeaderFooterView else {return}
        
        footer.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 10)
        footer.textLabel?.frame = footer.frame
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 40
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

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
