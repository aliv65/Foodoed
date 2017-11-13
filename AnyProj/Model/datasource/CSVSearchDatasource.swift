//
//  CSVSearchDatasource.swift
//  AnyProj
//
//  Created by Александр Иванин on 11.11.17.
//

import Foundation

class CSVSearchDatasource {
    var products: [Product]
    
    var names = ["Грибы", "Мясо", "Соленые огурцы", "Крабовые палочки", "Яблоки", "Семга тунец", "Кукуруза", "Огурцы", "Кабачок", "Армянский лаваш", "Брынза", "Яйцо куриное", "Мука", "Капуста цветная", "Сыр", "Орехи грецкие", "Чеснок", "Лук репчатый", "Помидоры", "Морковь", "Картофель", "Сухие дрожжи", "Колбаса", "Сахар", "Рис", "Петрушка (корень)", "Петрушка (зелень)", "Майонез", "Укроп", "Соль", "Масло ростительное", "Масло подсолнечное", "Масло сливочное", "Лавровый лист"]
    
    init(filename: String) {
        products = []
        
        guard let url = Bundle.main.url(forResource: filename, withExtension: "csv") else {
            assertionFailure("can't find country code file \(filename) in main bundle")
            return
        }
        guard let data = try? Data(contentsOf: url) else {
            assertionFailure("can't read country code file \(filename) in main bundle")
            return
        }
        guard let csvString = String(data: data, encoding: .utf8) else {
            assertionFailure("can't read utf8 string in file \(filename) in main bundle")
            return
        }
        let strings = csvString.components(separatedBy: CharacterSet(charactersIn: "\r\n"))
        for eachRecord in strings {
            let cc = eachRecord.components(separatedBy: ",")
            if !cc.isEmpty && cc.count == 44 {
                let lastIndex = cc.count - 1
                let product = Product(id: NSNumber(value: Int(cc[0])!).intValue, name: cc[1], isDiabetic: NSNumber(value: Int(cc[2])!).boolValue, isVegan: NSNumber(value: Int(cc[3])!).boolValue, price: Double(cc[4])!, prots: Double(cc[lastIndex - 3])!, fats: Double(cc[lastIndex - 2])!, cabs: Double(cc[lastIndex - 1])!, ccal: Int(cc[lastIndex])!)
                for var i in 6 ..< lastIndex-3 {
                    if let value = Double(cc[i]), value > 0 {
                        product.setIngridients(form: [cc[i], names[i - 6]])
                    }
                }
                products.append(product)
                print(products)
            }
        }
    }
}
