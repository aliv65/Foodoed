//
//  Product.swift
//  AnyProj
//
//  Created by Александр Иванин on 11.11.17.
//

import Foundation

class Ingridient: NSObject {
    var price: Double
    var name: String
    
    init(price: Double, name: String) {
        self.price = price
        self.name = name
    }
    
    override var description : String {
        return "Ingridient: name=\(name) price=\(price)"
    }
}

class Caloricity: NSObject {
    var prots: Double
    var fats: Double
    var cabs: Double
    var ccal: Int
    
    init(prots: Double, fats: Double, cabs: Double, ccal: Int) {
        self.prots = prots
        self.fats = fats
        self.cabs = cabs
        self.ccal = ccal
    }
    
    override var description : String {
        return "Caloricity: prots=\(prots) fats=\(fats) cabs=\(cabs) ccal=\(ccal)"
    }
}

class Product: NSObject {
    var id: Int
    var name: String
    var isVegan: Bool
    var isDiabetic: Bool
    var price: Double
    var ingridients: [Ingridient]
    var caloricity: Caloricity
    
    var multi: Int = Int()
    
    init(id: Int, name: String, isDiabetic: Bool, isVegan: Bool, price: Double, prots: Double, fats: Double, cabs: Double, ccal: Int) {
        self.id = id
        self.name = name
        self.isVegan = isVegan
        self.isDiabetic = isDiabetic
        self.price = price
        
        self.ingridients = [Ingridient]()
        
        self.caloricity = Caloricity(prots: prots, fats: fats, cabs: cabs, ccal: ccal)
    }
    
    func setIngridients(form strings: [String]) {
        let ingridient = Ingridient(price: Double(strings[0])!, name: strings[1])
        self.ingridients.append(ingridient)
    }
    
    override var description : String {
        return "Product: id=\(id) name=\(name) diabetic=\(isDiabetic) vegan=\(isVegan) price=\(price) ingridients=\(ingridients) caloricity=\(caloricity)"
    }
}
