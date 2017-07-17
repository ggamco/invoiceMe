//
//  IME_VistaProductoTVC.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 9/7/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit

class IME_VistaProductoTVC: UITableViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var myCodigo: UITextField!
    @IBOutlet weak var myTitulo: UITextField!
    @IBOutlet weak var myDescripccion: UITextView!
    @IBOutlet weak var mySelectorMedida: UISegmentedControl!
    @IBOutlet weak var myMedidaCustom: UITextField!
    @IBOutlet weak var myPrecio: UITextField!
    @IBOutlet weak var mySelectorMoneda: UIButton!
    @IBOutlet weak var myDescuento: UITextField!
    @IBOutlet weak var mySelectorTipoDescuento: UIButton!
    @IBOutlet weak var myIVA: UITextField!
    @IBOutlet weak var myExentoIVA: UISwitch!
    @IBOutlet weak var myIRPF: UITextField!
    @IBOutlet weak var myExentoIRPF: UISwitch!
    @IBOutlet weak var myCantidad: UITextField!
    @IBOutlet weak var myStepperCantidad: UIStepper!
    
    
    // MARK: - LIFE VC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mySelectorMoneda.layer.cornerRadius = 5
        mySelectorMoneda.layer.borderWidth = 0.5
        mySelectorMoneda.layer.borderColor = CONSTANTES.COLORES.FIRST_TEXT_COLOR.cgColor
        mySelectorTipoDescuento.layer.cornerRadius = 5
        mySelectorTipoDescuento.layer.borderWidth = 0.5
        mySelectorTipoDescuento.layer.borderColor = CONSTANTES.COLORES.FIRST_TEXT_COLOR.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 2
        default:
            return 5
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
