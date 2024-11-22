//
//  SecondViewController.swift
//  Coffee To Go
//
//  Created by Кирилл Сысоев on 6.09.24.
//

import UIKit

class SecondViewController: UIViewController {

    weak var delegate: PageNavigationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func nextButtonTapped(_ sender: UIButton) {
        delegate?.goToNextPage()
    }
    
    @IBAction func skipButtonTapped(_ sender: UIButton) {
        delegate?.skip()
    }
    
}
