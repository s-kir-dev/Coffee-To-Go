//
//  AuthManager.swift
//  Coffee
//
//  Created by Кирилл Сысоев on 23.09.24.
//

import Foundation

class AuthManager {
    
    static let shared = AuthManager()
    
    //private let auth = Auth.auth()
    
    private var verificationID: String?
    
//    public func startAuth(phoneNumber: String, completion: @escaping(Bool) -> Void) {
//        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] (verificationID, error) in
//            guard let verificationID = verificationID, error == nil else {
//                completion(false)
//                return
//            }
//            self?.verificationID = verificationID
//            completion(true)
//        }
//    }
    
//    public func verifyVode(smsCode: String, completion: @escaping(Bool) -> Void) {
//        
//        guard let verificationID = verificationID else {
//            completion(false)
//            return
//        }
//        let credential = PhoneAuthProvider.provider().credential(
//            withVerificationID: verificationID,
//            verificationCode: smsCode
//        )
//        
//        auth.signIn(with: credential) { result, error in
//            guard result != nil, error == nil else {
//                completion(false)
//                return
//            }
//            completion(true)
//        }
//    }
}