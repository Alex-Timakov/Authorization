//
//  AuthorizationVC.swift
//  Authorization
//
//  Created by Aleksandr Timakov on 17.05.2018.
//  Copyright © 2018 Aleksandr Timakov. All rights reserved.
//

import UIKit

class AuthorizationVC: UIViewController {
   
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var forgetPassButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forgetPassButton.layer.borderColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1).cgColor
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    //MARK: - Action
    
    @IBAction func tapGestureAction(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func authorizationButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func emailTextFieldEnterAction(_ sender: UITextField) {
        passTextField.becomeFirstResponder()
    }
    
    @IBAction func passTextfieldEnterAction(_ sender: UITextField) {
        view.endEditing(true)
    }
    //MARK: - Keyboard
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            bottomConstraint.constant = keyboardSize.height
        }
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        bottomConstraint.constant = 0
    }

}
