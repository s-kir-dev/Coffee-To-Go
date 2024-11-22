import UIKit

class DrinkCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var orderButton: UIButton!
    
    // Замыкание для кнопки заказа
    var orderButtonAction: (() -> Void)?
    
    @IBAction func orderButtonTapped(_ sender: UIButton) {
        // Вызов замыкания при нажатии на кнопку
        orderButtonAction?()
    }
}
