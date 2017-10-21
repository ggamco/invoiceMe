//
//  IME_MailComposeCustom.swift
//  invoiceMe
//
//  Created by Gustavo Gamboa on 17/10/17.
//  Copyright © 2017 gmbDesign. All rights reserved.
//

import UIKit
import MessageUI

class IME_MailComposeCustom: MFMailComposeViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }

}
