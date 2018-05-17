//
//  AuthorizationVC.swift
//  Authorization
//
//  Created by Aleksandr Timakov on 17.05.2018.
//  Copyright © 2018 Aleksandr Timakov. All rights reserved.
//

import UIKit

class AuthorizationVC: UIViewController {
   
    @IBOutlet weak var forgetPassButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forgetPassButton.layer.borderColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1).cgColor
    }

}
