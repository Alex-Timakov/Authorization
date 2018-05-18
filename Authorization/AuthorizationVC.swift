//
//  AuthorizationVC.swift
//  Authorization
//
//  Created by Aleksandr Timakov on 17.05.2018.
//  Copyright © 2018 Aleksandr Timakov. All rights reserved.
//

import UIKit

extension String {
    private static let __firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
    private static let __serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
    private static let __emailRegex = __firstpart + "@" + __serverpart + "[A-Za-z]{2,6}"
    private static let __password =
    //"^(?=.*[A-Z].*[A-Z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8}$ "
    "(?=^.{6,}$)^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?!.*\\s).*$"
    public var isEmail: Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", type(of:self).__emailRegex)
        return predicate.evaluate(with: self)
    }
    public var isPassword: Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", type(of:self).__password)
        return predicate.evaluate(with: self)
    }
}

class AuthorizationVC: UIViewController {
   
    @IBOutlet weak var emailTextField: UITextField!
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
        var title = "Погода"
        var message = "Нет данных"
        if let errorMessage = validationErrorMessage() {
            title = "Ошибка валидации"
            message = errorMessage
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
    
    //MARK: - Validation
    func validationErrorMessage() -> String? {
        var errorMessage: String? = "Введите E-mail"
        if let email = emailTextField.text {
            if email.isEmail {
                errorMessage = nil
                if let password = passTextField.text {
                    if password.isPassword {
                        errorMessage = nil
                    } else {
                        errorMessage =  "Неверный пароль. Пароль - минимум 6 символов, должен обязательно содержать минимум 1 строчную букву, 1 заглавную, и 1 цифру."
                        passTextField.becomeFirstResponder()
                    }
                    
                } else {
                    errorMessage = "Введите пароль"
                }
            } else {
                errorMessage = "Неверный E-mail"
                emailTextField.becomeFirstResponder()
            }
        }
        

        if errorMessage == nil {
            view.endEditing(true)
        }
        return errorMessage
    }
    
}
