//
//  TelephoneAuthViewController.swift
//  Coffee
//
//  Created by Кирилл Сысоев on 23.09.24.
//

import UIKit
import Firebase

class TelephoneAuthViewController: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var checkBoxButton: UIButton!
    let db = Firestore.firestore()
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
        checkUserIDAndNavigate()
        //view.endEditing(true)
        
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
        
        performSegue(withIdentifier: "registrationCodeScreen", sender: self)
    }
    
    func checkUserIDAndNavigate() {
        guard let userID = phoneField.text, !userID.isEmpty else {
            view.endEditing(true)
            return
        }

        let userDocument = Firestore.firestore().collection("users").document("userID\(userID)")
        
        userDocument.getDocument { document, error in
            if let error = error {
                print("Ошибка при проверке документа: \(error.localizedDescription)")
                return
            }
            
            if let document = document, document.exists {
                DispatchQueue.main.async {
                    if let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabVC") as? UITabBarController {
                        UserDefaults.standard.set(true, forKey: "Registered")
                        tabBarController.modalPresentationStyle = .fullScreen
                        self.present(tabBarController, animated: true)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.view.endEditing(true)
                }
            }
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let registrationVC = segue.destination as? RegistrationViewController {
            registrationVC.userID = self.phoneField.text!
        }
    }
}

extension TelephoneAuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
