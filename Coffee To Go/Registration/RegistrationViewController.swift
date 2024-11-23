//
//  RegistrationViewController.swift
//  Coffee To Go
//
//  Created by Кирилл Сысоев on 7.09.24.
//

import UIKit
import Firebase

class RegistrationViewController: UIViewController {
   
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var codeField: UITextField!
    var userID = String()
    let db = Firestore.firestore()
    
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

    @IBAction func signInButtonTapped(_ sender: UIButton) {
        db.collection("users")
            .document("userID\(userID)")
            .setData([
                "ID": userID
            ]) { error in
                if let error = error {
                    print("Error adding order: \(error)")
                } else {
                    print("User was added correctly with \(self.userID)")
                }
            }
        
        UserDefaults.standard.set("userID\(userID)", forKey: "UserID")
        UserDefaults.standard.set(true, forKey: "Registered")
        performSegue(withIdentifier: "tabBarController", sender: self)
    }
    
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
