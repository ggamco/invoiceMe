//
//  IME_ProjectBudgeCell.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 17/1/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit

class IME_ProjectBudgeCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var myLogoProject: UIImageView!
    @IBOutlet weak var myProjectName: UILabel!
    @IBOutlet weak var myProgressLabel: UILabel!
    @IBOutlet weak var myProgressBar: UIProgressView!
    
    
    //MARK: - Metodos propios CELLView
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
