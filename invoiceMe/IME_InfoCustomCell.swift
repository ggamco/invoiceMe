//
//  IME_InfoCustomCell.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 20/10/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit

class IME_InfoCustomCell: UITableViewCell {

    @IBOutlet weak var myTitleLabel: UILabel!
    @IBOutlet weak var myNombreEmisorTF: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
