import UIKit

class FirstViewController: UIViewController {

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
