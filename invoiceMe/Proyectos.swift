//
//  Proyectos.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 17/1/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit

class Proyectos: NSObject {

    var hasProgress: Bool?
    var projectColor: UIColor?
    var projectName: String?
    var clientName: String?
    var horasProgramadas: Int?
    
    init(hasProgress: Bool, projectColor: UIColor, projectName: String, clientName: String, horasProgramadas: Int){
        self.hasProgress = hasProgress
        self.projectColor = projectColor
        self.projectName = projectName
        self.clientName = clientName
        self.horasProgramadas = horasProgramadas
    }
    
}
