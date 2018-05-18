//
//  AuthorizationVC.swift
//  Authorization
//
//  Created by Aleksandr Timakov on 17.05.2018.
//  Copyright © 2018 Aleksandr Timakov. All rights reserved.
//

import UIKit
import Alamofire

class AuthorizationVC: UIViewController {
   
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var authorizationButton: UIButton!
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
    
    @IBAction func forgetPassButtonAction(_ sender: UIButton) {
        showAlertController(title: "Восстановление пароля", message: "Восстановить пароль")
    }
    
    @IBAction func createButtonAction(_ sender: UIButton) {
        showAlertController(title: "Создание Аккаунта", message: "Создать новый аккаунт")
    }
    
    @IBAction func authorizationButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        if let errorMessage = validationErrorMessage() {
            showAlertController(title: "Ошибка валидации", message: errorMessage)
        } else {
            loadData()
        }
        
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
        if !(emailTextField.text != nil && emailTextField.text!.isEmail)  {
            emailTextField.becomeFirstResponder()
            return "Неверный E-mail"
        }
        if !(passTextField.text != nil && passTextField.text!.isPassword) {
            passTextField.becomeFirstResponder()
            return "Неверный пароль. \nПароль - минимум 6 символов, должен обязательно содержать минимум 1 строчную букву, 1 заглавную, и 1 цифру."
        }
        return nil
    }
    
    //MARK: - Service
    func showAlertController(title: String, message: String ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func loadData() {
        let url:String = "http://api.openweathermap.org/data/2.5/weather"
        let key:String = "dc734cb6ed792c3d6d0dc4fd0aec12f9"
        let parameters = ["q": "Novosibirsk", "APPID": key]
        let alertTitle = "Погода"
        let errorMessage = "Не удалось загрузить погоду"
        authorizationButton.isEnabled = false;

        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                self.authorizationButton.isEnabled = true
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                print(response)
                if response.result.isFailure {
                    self.showAlertController(title: alertTitle, message: errorMessage)
                    return
                }
                
                if let json:[String:Any] = response.result.value as? [String:Any] {
                    
                    let mainObject:[String:Any] = json["main"] as! [String:Any]
                    let temperatureInt:Float = mainObject["temp"] as! Float
                    let humidityInt:Int = mainObject["humidity"] as! Int
                    self.showAlertController(title: alertTitle, message: "Температура в Новосибирске сейчас: \(temperatureInt - 273.15) градусов, влажность воздуха: \(humidityInt) %")
                } else {
                    self.showAlertController(title: alertTitle, message: errorMessage)
                    return
                }
        }
    }
}
