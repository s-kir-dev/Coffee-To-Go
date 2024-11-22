//
//  RegistrationViewController.swift
//  Coffee To Go
//
//  Created by Кирилл Сысоев on 7.09.24.
//

import UIKit

class RegistrationViewController: UIViewController {
   
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var codeField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        codeField.delegate = self
        addToolBarToKeyboard()
        signInButton.isEnabled = false
        codeField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    func addToolBarToKeyboard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([doneButton], animated: true)
        
        codeField.inputAccessoryView = toolbar
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let code = textField.text {
            signInButton.isEnabled = !code.isEmpty
        }
    }

//    @IBAction func signInButtonTapped(_ sender: UIButton) {
//        if let code = codeField.text, !code.isEmpty {
//            // Получаем сохраненный verificationID из UserDefaults
//            guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
//                showAlert(message: "Ошибка при получении verificationID")
//                return
//            }
//            
//            let credential = PhoneAuthProvider.provider().credential(
//                withVerificationID: verificationID,
//                verificationCode: code
//            )
//            
//            // Верификация кода с помощью Firebase
//            Auth.auth().signIn(with: credential) { [weak self] authResult, error in
//                if let error = error {
//                    print("Ошибка верификации: \(error.localizedDescription)")
//                    self?.showAlert(message: "Неверный код")
//                    return
//                }
//                
//                // Успешная верификация, выполняем переход в главное приложение
//                DispatchQueue.main.async {
//                    UserDefaults.standard.set(true, forKey: "Flag")  // Устанавливаем флаг входа
//                    if let tabBarController = self?.storyboard?.instantiateViewController(withIdentifier: "MainTabVC") as? UITabBarController {
//                        tabBarController.modalPresentationStyle = .fullScreen
//                        self?.navigationController?.pushViewController(tabBarController, animated: true)
//                    }
//                }
//            }
//        } else {
//            showAlert(message: "Введите код")
//        }
//    }
//    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
