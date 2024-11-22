//
//  FourthViewController.swift
//  Coffee To Go
//
//  Created by Кирилл Сысоев on 6.09.24.
//

import UIKit

class FourthViewController: UIViewController {
    
    weak var delegate: PageNavigationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func nextButtonTapped(_ sender: UIButton) {
        delegate?.goToNextPage()
        makeFlag(state: true)
    }
    
    func makeFlag(state: Bool) {
        UserDefaults.standard.set(state, forKey: "Flag")
        debugPrint("State changed")
    }

}
