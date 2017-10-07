//
//  IME_ProjectBasicCell.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 6/1/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit

class IME_ProjectBasicCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var myLogoProject: UIImageView!
    @IBOutlet weak var myProjectName: UILabel!
    
    //MARK: - Metodos propios CELLView
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
