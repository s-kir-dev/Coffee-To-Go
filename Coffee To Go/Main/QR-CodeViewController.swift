//
//  QR-CodeViewController.swift
//  Coffee To Go
//
//  Created by Кирилл Сысоев on 25.11.2024.
//

import UIKit

class QR_CodeViewController: UIViewController {

    let userID: String = UserDefaults.standard.string(forKey: "UserID") ?? ""
    
    @IBOutlet weak var qrCodeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        qrCodeImageView.image = generateQRCode(from: userID)
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: .ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "InputMessage")
            
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            
            if let outputImage = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: outputImage)
            }
        }
        
        return nil
    }
    
}
