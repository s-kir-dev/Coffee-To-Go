import UIKit

protocol PageNavigationDelegate: AnyObject {
    func goToNextPage()
    
    func skip()
}

class RootPageViewController: UIPageViewController {

    lazy var controllersArray: [UIViewController] = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let first = storyboard.instantiateViewController(identifier: "first") as! FirstViewController
        let second = storyboard.instantiateViewController(identifier: "second") as! SecondViewController
        let third = storyboard.instantiateViewController(identifier: "third") as! ThirdViewController
        let fourth = storyboard.instantiateViewController(identifier: "fourth") as! FourthViewController

        first.delegate = self
        second.delegate = self
        third.delegate = self
        fourth.delegate = self

        return [first, second, third, fourth]
    }()
    
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let controller = controllersArray.first {
            self.setViewControllers([controller], direction: .forward, animated: true)
        }
    }

    func goToNextPage() {
        let nextIndex = currentPage + 1
        guard nextIndex < controllersArray.count else { return }

        let nextController = controllersArray[nextIndex]
        setViewControllers([nextController], direction: .forward, animated: true)
        currentPage = nextIndex
    }
    
    func skip() {
        let lastController = controllersArray[controllersArray.endIndex-1]
        setViewControllers([lastController], direction: .forward, animated: true)
        currentPage = controllersArray.endIndex
    }
}

extension RootPageViewController: PageNavigationDelegate {}
