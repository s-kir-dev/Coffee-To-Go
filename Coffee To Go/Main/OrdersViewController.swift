//
//  OrdersViewController.swift
//  Coffee To Go
//
//  Created by Кирилл Сысоев on 23.11.2024.
//

import UIKit
import Firebase

class OrdersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let userID = UserDefaults.standard.string(forKey: "UserID")!
    var orders: [NewDrink] = []
    
    @IBOutlet weak var ordersTableView: UITableView!
    @IBOutlet weak var qrCodeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ordersTableView.dataSource = self
        ordersTableView.delegate = self
        
        loadOrders()
        
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(loadOrders), userInfo: nil, repeats: true)
    }
    
    @objc private func loadOrders() {
        let db = Firestore.firestore()
        let clientID = userID
        let ordersCollection = db.collection("orders").document(clientID).collection("clientOrders")

        ordersCollection.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error loading orders: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else { return }
            self.orders = documents.compactMap { document -> NewDrink? in
                let data = document.data()
                
                var additions: [String] = []
                
                if data["with arabica"] as? Bool == true {
                    additions.append("Arabica")
                }
                if data["with milk"] as? Bool == true {
                    additions.append("Milk")
                }
                if data["with caramel"] as? Bool == true {
                    additions.append("Caramel")
                }
                if data["with syrup"] as? Bool == true {
                    additions.append("Syrup")
                }
                if data["with sugar"] as? Bool == true {
                    additions.append("Sugar")
                }
                
                return NewDrink(
                    name: data["name"] as? String ?? "",
                    description: data["description"] as? String ?? "",
                    image: data["image"] as? String ?? "",
                    price: data["price"] as? Double ?? 0,
                    category: Category(rawValue: (data["category"] as? Category.RawValue)!) ?? .coffee,
                    volume: data["volume/pieces"] as? String ?? "",
                    isArabicaSelected: data["with arabica"] as? Bool ?? false,
                    isMilkSelected: data["with milk"] as? Bool ?? false,
                    isCaramelSelected: data["with caramel"] as? Bool ?? false,
                    withSyrup: data["with syrup"] as? Bool ?? false,
                    withSugar: data["with sugar"] as? Bool ?? false,
                    additions: additions
                )
            }
            
            print("\(NewDrink.self)")

            DispatchQueue.main.async {
                self.ordersTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        qrCodeButton.isEnabled = !orders.isEmpty
        return orders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! OrderViewCell
        let drink = orders[indexPath.row]
        cell.productName.text = drink.name
        cell.productPrice.text = "\(drink.price)₽"
        cell.productImage.image = UIImage(named: drink.image)
        cell.productVolume.text = drink.volume
        
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
}
