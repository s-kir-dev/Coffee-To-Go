import UIKit
import Firebase

class BasketViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var emptyBasketImage: UIImageView!
    @IBOutlet weak var deleteAllButton: UIButton!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var viewOrdersButton: UIButton!
    
    let db = Firestore.firestore()
    var basket: [NewDrink] = []
    let userID = UserDefaults.standard.string(forKey: "UserID")!
    
    var totalPrice: Double = 0 {
        didSet {
            updateLabel()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadBasket()
        calculateTotalPrice()
        
        table.dataSource = self
        table.delegate = self
        
        basketState()
        
        orderButton.addTarget(self, action: #selector (orderButtonTapped), for: .touchUpInside)
        
        viewOrdersButton.addTarget(self, action: #selector(viewOrdersButtonTapped), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateBasket), name: Notification.Name("ProductAdded"), object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func loadBasket() {
        if let savedData = UserDefaults.standard.data(forKey: "orderedProducts") {
            if let decodedProducts = try? JSONDecoder().decode([NewDrink].self, from: savedData) {
                basket = decodedProducts
                basketState()
                calculateTotalPrice()
                debugPrint("\(String(describing: decodedProducts.last))")
            }
        }
    }
    
    @objc func orderButtonTapped() {
        let clientID = userID // Получаем ID пользователя
        let ordersCollection = db.collection("orders").document(clientID).collection("clientOrders") // Коллекция заказов пользователя

        for newDrink in basket {
            let productID = UUID().uuidString // Уникальный ID для каждого продукта

            ordersCollection.document(productID).setData([
                "category": newDrink.category.rawValue,
                "name": newDrink.name,
                "description": newDrink.description,
                "price": newDrink.price,
                "image": newDrink.image,
                "volume/pieces": newDrink.volume,
                "with arabica": newDrink.isArabicaSelected,
                "with milk": newDrink.isMilkSelected,
                "with caramel": newDrink.isCaramelSelected,
                "with syrup": newDrink.withSyrup,
                "with sugar": newDrink.withSugar,
                "userID": userID
            ]) { error in
                if let error = error {
                    print("Error adding product to order: \(error)")
                } else {
                    print("Product \(newDrink.name) added successfully for client \(clientID)")
                }
            }
        }

        basket.removeAll()
        saveBasket()
        totalPrice = 0
        table.reloadData()
        basketState()

        let alert = UIAlertController(title: "Заказ оформлен", message: "Ваш заказ успешно сохранен!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @IBAction func backToBasket(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func clearBasketTapped(_ sender: Any) {
        basket.removeAll()
        totalPrice = 0

        UserDefaults.standard.removeObject(forKey: "orderedProducts")
        
        let alert = UIAlertController(title: "Корзина очищена", message: "Все товары удалены из корзины.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)

        table.reloadData()
        
        basketState()
    }
    
    @objc func viewOrdersButtonTapped() {
        performSegue(withIdentifier: "orders", sender: self)
    }

    @objc func updateBasket() {
        loadBasket()
        basketState()
        table.reloadData()
    }
    
    func updateLabel() {
        totalPriceLabel.text = "\(totalPrice)₽"
    }

    func basketState() {
        if basket.isEmpty {
            emptyBasketImage.isHidden = false
            orderButton.isHidden = true
        } else {
            emptyBasketImage.isHidden = true
            orderButton.isHidden = false
        }
        
        deleteAllButton.isHidden = !emptyBasketImage.isHidden
        totalPriceLabel.isHidden = !emptyBasketImage.isHidden
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basket.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! OrderViewCell
        let drink = basket[indexPath.row]
        cell.productName.text = drink.name
        cell.productPrice.text = "\(drink.price)₽"
        cell.productImage.image = UIImage(named: drink.image)
        cell.productVolume.text = drink.volume
        
        // Join additions into a single string and set it to productAdds
        if !drink.additions.isEmpty {
            cell.productAdds.text = "+ \(drink.additions.joined(separator: ", "))"
        } else {
            cell.productAdds.text = "No additions"
        }

        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }

    // MARK: - Swipe to Delete

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            basket.remove(at: indexPath.row)

            saveBasket()
            calculateTotalPrice()

            tableView.deleteRows(at: [indexPath], with: .fade)

            basketState()
        }
    }

    private func saveBasket() {
        if let encoded = try? JSONEncoder().encode(basket) {
            UserDefaults.standard.set(encoded, forKey: "orderedProducts")
        }
    }
    
    private func calculateTotalPrice() {
        totalPrice = basket.reduce(0) { $0 + $1.price }
    }
}
