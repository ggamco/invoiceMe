//
//  IME_MenuItemCell.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 25/6/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit

class IME_MenuItemCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var mySelectedItem: UIView!
    @IBOutlet weak var myMenuItem: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
