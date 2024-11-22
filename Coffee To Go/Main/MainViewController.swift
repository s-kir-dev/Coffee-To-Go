import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var drinksSegmented: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var selectedDrink: Drink? // Изменено на выбранный напиток
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Настраиваем цвет текста для выбранного и обычного состояний в UISegmentedControl
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.systemGray], for: .normal)
        
        // Добавляем действие для изменения сегмента
        drinksSegmented.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }
    
    @objc func valueChanged(_ sender: UISegmentedControl) {
        // Сбрасываем позицию контента и обновляем данные коллекции
        collectionView.setContentOffset(.zero, animated: true)
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DescriptionCoffeeViewController {
            // Передаём выбранный напиток
            destination.drink = selectedDrink
        }
    }
}

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch drinksSegmented.selectedSegmentIndex {
        case 0: return DrinksData.coffee.count
        case 1: return DrinksData.tea.count
        case 2: return DrinksData.coldDrinks.count
        case 3: return DrinksData.deserts.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? DrinkCollectionViewCell else {
            return UICollectionViewCell()
        }

        // Настройка данных в зависимости от выбранного сегмента
        let drink: Drink
        
        switch drinksSegmented.selectedSegmentIndex {
        case 0:
            drink = DrinksData.coffee[indexPath.row]
        case 1:
            drink = DrinksData.tea[indexPath.row]
        case 2:
            drink = DrinksData.coldDrinks[indexPath.row]
        case 3:
            drink = DrinksData.deserts[indexPath.row]
        default:
            return UICollectionViewCell()
        }

        cell.nameLabel.text = drink.name
        cell.priceLabel.textColor = .systemGray
        cell.priceLabel.text = "From \(drink.price)₽"
        cell.imageView.image = UIImage(named: drink.image)

        // Настройка действия для кнопки заказа
        cell.orderButtonAction = {
            self.selectedDrink = drink // Устанавливаем выбранный напиток
            debugPrint("Ordered: \(drink.name), Price \(drink.price)")  // Выводим имя напитка
        }
        
        return cell
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(
            width: collectionView.frame.width / 3.2,
            height: collectionView.frame.width / 3.2
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
