//
//  DescriptionCoffeeViewController.swift
//  Coffee
//
//  Created by Кирилл Сысоев on 8.10.24.
//

import UIKit
import Firebase

class DescriptionCoffeeViewController: UIViewController {

    @IBOutlet weak var changeComponentsLabel: UILabel!
    @IBOutlet weak var additionComponents: UIView!
    var drink: Drink?
    var orderedProducts: [NewDrink] = []
    var buttonPrice: Double = 0.0
    var volume : String = ""
    var isArabicaSelected : Bool = false
    var isMilkSelected : Bool = false
    var isCaramelSelected : Bool = false
    var withSyrup : Bool = false
    var withSugar : Bool = false
    var selectedAdditions: [String] = []
    let db = Firestore.firestore()

    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addToBasketButton: UIButton!
    @IBOutlet weak var volumeSegmented: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        volumeSegmented.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        volumeSegmented.setTitleTextAttributes([.foregroundColor: UIColor.systemGray], for: .normal)

        if let drink = drink {
            if DrinksData.deserts.contains(where: { $0.name == drink.name }) {
                volumeSegmented.removeAllSegments()
                let segment = ["1 piece", "2 pieces", "3 pieces"]
                for (index, title) in segment.enumerated() {
                    volumeSegmented.insertSegment(withTitle: title, at: index, animated: false)
                }
                volumeSegmented.selectedSegmentIndex = 0
                additionComponents.isHidden = true
                changeComponentsLabel.isHidden = true
            } else {
                additionComponents.isHidden = false
                changeComponentsLabel.isHidden = false
            }
            titleBar.title = drink.name
            descriptionLabel.text = drink.description
            buttonPrice = drink.price
            addToBasketButton.setTitle("Add to cart \(drink.price)₽", for: .normal)
            imageView.image = UIImage(named: drink.image)
        }
        volume = volumeSegmented.titleForSegment(at: 0)!
    }

    @IBAction func drinkVolumeSegmented(_ sender: UISegmentedControl) {
        if let drink = drink {
            switch sender.selectedSegmentIndex {
            case 1:
                buttonPrice = drink.price * 1.5
            case 2:
                buttonPrice = drink.price * 2
            default:
                buttonPrice = drink.price
            }
            volume = sender.titleForSegment(at: sender.selectedSegmentIndex)!
        }
        addToBasketButton.setTitle("Add to cart \(buttonPrice)₽", for: .normal)
    }
    
    @IBAction func toggleArabica(_ sender: UIButton) {
        sender.isSelected.toggle()
        isArabicaSelected = sender.isSelected
        
        if isArabicaSelected {
            selectedAdditions.append("Arabica")
        } else {
            if let index = selectedAdditions.firstIndex(of: "Arabica") {
                selectedAdditions.remove(at: index)
            }
        }
        
        updateButtonState(sender, selectedImage: "Arabica1", normalImage: "Arabica2")
        UserDefaults.standard.set(isArabicaSelected, forKey: "isArabicaSelected")
    }

    @IBAction func toggleMilk(_ sender: UIButton) {
        sender.isSelected.toggle()
        isMilkSelected = sender.isSelected
        
        if isMilkSelected {
            selectedAdditions.append("Milk")
        } else {
            if let index = selectedAdditions.firstIndex(of: "Milk") {
                selectedAdditions.remove(at: index)
            }
        }
        
        updateButtonState(sender, selectedImage: "Milk1", normalImage: "Milk2")
        UserDefaults.standard.set(isMilkSelected, forKey: "isMilkSelected")
    }

    @IBAction func toggleCaramel(_ sender: UIButton) {
        sender.isSelected.toggle()
        isCaramelSelected = sender.isSelected
        
        if isCaramelSelected {
            selectedAdditions.append("Caramel")
        } else {
            if let index = selectedAdditions.firstIndex(of: "Caramel") {
                selectedAdditions.remove(at: index)
            }
        }
        
        updateButtonState(sender, selectedImage: "Caramel1", normalImage: "Caramel2")
        UserDefaults.standard.set(isCaramelSelected, forKey: "isCaramelSelected")
    }

    @IBAction func toggleSyrup(_ sender: UIButton) {
        sender.isSelected.toggle()
        withSyrup = sender.isSelected
        
        if withSyrup {
            selectedAdditions.append("Syrup")
        } else {
            if let index = selectedAdditions.firstIndex(of: "Syrup") {
                selectedAdditions.remove(at: index)
            }
        }
        
        updateButtonState(sender, selectedImage: "Plus1", normalImage: "Plus2")
        UserDefaults.standard.set(withSyrup, forKey: "withSyrup")
    }

    @IBAction func toggleSugar(_ sender: UIButton) {
        sender.isSelected.toggle()
        withSugar = sender.isSelected
        
        if withSugar {
            selectedAdditions.append("Sugar")
        } else {
            if let index = selectedAdditions.firstIndex(of: "Sugar") {
                selectedAdditions.remove(at: index)
            }
        }
        
        updateButtonState(sender, selectedImage: "Plus1", normalImage: "Plus2")
        UserDefaults.standard.set(withSugar, forKey: "withSugar")
    }
    
    func updateButtonState(_ button: UIButton, selectedImage: String, normalImage: String) {
        if button.isSelected {
            button.setImage(UIImage(named: normalImage), for: .normal)
            debugPrint("\(normalImage)")
        } else {
            button.setImage(UIImage(named: selectedImage), for: .selected)
            debugPrint("\(selectedImage)")
        }
    }

    @IBAction func addToBasketTapped(_ sender: UIButton) {
        if let drink = drink {
            // Создаем новый экземпляр Drink с изменённой ценой
            let newDrink = NewDrink(name: drink.name, description: drink.description, image: drink.image, price: buttonPrice, category: drink.category, volume: self.volume, isArabicaSelected: self.isArabicaSelected, isMilkSelected: self.isMilkSelected, isCaramelSelected: self.isCaramelSelected, withSyrup: self.withSyrup, withSugar: self.withSugar, additions: selectedAdditions)

            // Загружаем существующие продукты из UserDefaults
            if let savedData = UserDefaults.standard.data(forKey: "orderedProducts"),
               let savedProducts = try? JSONDecoder().decode([NewDrink].self, from: savedData) {
                orderedProducts = savedProducts
            }

            // Добавляем новый продукт
            orderedProducts.append(newDrink)

            // Сохраняем обновлённый список в UserDefaults
            if let encoded = try? JSONEncoder().encode(orderedProducts) {
                UserDefaults.standard.set(encoded, forKey: "orderedProducts")
            }

            // Отправляем уведомление о добавлении нового продукта
            NotificationCenter.default.post(name: Notification.Name("ProductAdded"), object: nil)
            
            // Показываем сообщение об успешном добавлении
            let message = "Товар успешно добавлен в корзину!"
            let alert = UIAlertController(title: "Успешно", message: message, preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.dismiss(animated: true)
            }

            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
}
