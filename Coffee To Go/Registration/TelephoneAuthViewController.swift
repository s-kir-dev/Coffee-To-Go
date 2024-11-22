//
//  TelephoneAuthViewController.swift
//  Coffee
//
//  Created by Кирилл Сысоев on 23.09.24.
//

import UIKit

class TelephoneAuthViewController: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var checkBoxButton: UIButton!
    var bool = false
    
    @IBAction func checkBox(_ sender: UIButton) {
        bool = !bool
        if bool {
            checkBoxButton.setImage(.selected, for: .normal)
        } else {
            checkBoxButton.setImage(.unselected, for: .normal)
            continueButton.isEnabled = false
        }
        continueIsEnabled()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneField.delegate = self
        addToolBarToKeyboard()
        continueButton.isEnabled = false
        continueButton.addTarget(self, action: #selector(authWithPhone), for: .touchUpInside)
        
        phoneField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    func addToolBarToKeyboard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([doneButton], animated: true)
        
        phoneField.inputAccessoryView = toolbar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        continueIsEnabled()
    }

    func continueIsEnabled() {
        if let phone = phoneField.text {
            if bool {
                continueButton.isEnabled = isValidPhone(phone)
            }
        }
    }
    
    @objc func authWithPhone() {
        guard let phone = phoneField.text, isValidPhone(phone) else {
            showAlert(message: "Неверный формат телефона")
            return
        }
        
//        PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { verificationID, error in
//            if let error = error {
//                print("Ошибка при отправке SMS: \(error.localizedDescription)")
//                self.showAlert(message: "Ошибка при отправке SMS")
//                return
//            }
//            
//            // Сохраняем verificationID в UserDefaults
//            if let verificationID = verificationID {
//                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
//                
//                // Переходим на экран ввода кода
//                DispatchQueue.main.async {
//                    let vc = RegistrationViewController()
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
//            }
//        }
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func isValidPhone(_ phone: String) -> Bool {
        return phone.hasPrefix("+") && phone.count == 13
    }
}

extension TelephoneAuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
