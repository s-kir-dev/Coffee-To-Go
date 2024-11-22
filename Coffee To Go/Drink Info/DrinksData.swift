//
//  DrinksData.swift
//  Coffee
//
//  Created by Кирилл Сысоев on 8.09.24.
//

import Foundation

struct DrinksData {
    static let coffee: [Drink] = [
        Drink(name: "Cappuccino", description: "Espresso-based coffee with the addition of warmed foamed milk", image: "Cappuccino", price: 180.0, category: .coffee),
        Drink(name: "Espresso", description: "Strong black coffee made by forcing steam through ground coffee beans", image: "Espresso", price: 180.0, category: .coffee),
        Drink(name: "Latte", description: "Espresso mixed with steamed milk and topped with foam", image: "Latte", price: 180.0, category: .coffee),
        Drink(name: "Cacao", description: "Hot chocolate drink made with cocoa powder", image: "Cacao", price: 180.0, category: .coffee)
    ]
    
    static let tea: [Drink] = [
        Drink(name: "Black tea", description: "Strong brewed tea", image: "B tea", price: 150.0, category: .tea),
        Drink(name: "Green tea", description: "Tea made from unoxidized leaves", image: "G tea", price: 150.0, category: .tea),
        Drink(name: "Red tea", description: "Tea with a robust, earthy flavor", image: "R tea", price: 150.0, category: .tea),
        Drink(name: "Chamomile tea", description: "Herbal tea made with chamomile flowers", image: "C tea", price: 150.0, category: .tea)
    ]
    
    static let coldDrinks: [Drink] = [
        Drink(name: "Coca-Cola", description: "Popular carbonated soft drink", image: "Cola", price: 120.0, category: .drinks),
        Drink(name: "Sprite", description: "Lemon-lime flavored soft drink", image: "Sprite", price: 120.0, category: .drinks),
        Drink(name: "Fanta", description: "Fruit-flavored soft drink", image: "Fanta", price: 120.0, category: .drinks),
        Drink(name: "MezzoMix", description: "Orange and cola mixed soft drink", image: "Mezzo", price: 120.0, category: .drinks)
    ]
    
    static let deserts: [Drink] = [
        Drink(name: "Cookies", description: "Assortment of delicious cookies", image: "Cookies", price: 150.0, category: .desserts),
        Drink(name: "Cheesecake", description: "Rich dessert made with cream cheese", image: "Cheesecake", price: 150.0, category: .desserts),
        Drink(name: "Choco Brownie", description: "Rich, fudgy chocolate brownie", image: "C brownie", price: 150.0, category: .desserts),
        Drink(name: "Vanilla Brownie", description: "Soft vanilla flavored brownie", image: "V brownie", price: 150.0, category: .desserts),
        Drink(name: "Croissant", description: "Flaky, buttery French pastry", image: "Croissant", price: 150.0, category: .desserts),
        Drink(name: "Chocolate Cake", description: "Rich chocolate cake with layers", image: "Cake", price: 150.0, category: .desserts)
    ]
}
