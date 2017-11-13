//
//  SearchManager.swift
//  AnyProj
//
//  Created by Александр Иванин on 11.11.17.
//

import Foundation
import UIKit
import Accelerate.vecLib.LinearAlgebra

protocol SearchManagerDelegate: class {
    
    func reloadMainController()
    func reloadSearchResults(with products: [Product])
}

enum Parameters: String {
    case sum
    case ccal
    case prots
    case fats
    case cabs
    case vegan
    case diabetic
    case considerDetails
}

final class SearchManager {
    static let shared = SearchManager()
    
    fileprivate let kSearchParameters = "kSearchParameters"
    
    private init() {}
    
    fileprivate var searchParameters = Dictionary<String, Any>()
    
    fileprivate var basketDatasource = [Product]()
    
    fileprivate var multi = Int()
    
    weak var delegate: SearchManagerDelegate?
    
    var emptySearchParameters: Bool {
        restore()
        return searchParameters.isEmpty
    }
    
    var scale: Int {
        return self.multi
    }
    
    var isValid: Bool {
        return getValue(forParameter: .sum) as? Int != nil
    }
    
    func getValue(forParameter parameter: Parameters) -> Any? {
        guard let value = searchParameters[parameter.rawValue] else {
            return nil
        }
        return value
    }
    
    func set(value: Any, forParameter parameter: Parameters) {
        searchParameters[parameter.rawValue] = value
    }
    
    func removeValue(forParameter parameter: Parameters) {
        searchParameters.removeValue(forKey: parameter.rawValue)
    }
    
    fileprivate func save() {
        UserDefaults.standard.set(searchParameters, forKey: kSearchParameters)
        UserDefaults.standard.synchronize()
    }
    
    fileprivate func restore() {
        if let dictionary = UserDefaults.standard.dictionary(forKey: kSearchParameters) {
            searchParameters = dictionary
        } else {
            save()
        }
    }
}

extension SearchManager {
    func search() {
        let dataSource = CSVSearchDatasource(filename: "products")
        var filteredDatasource = dataSource.products
        if let isVegan = SearchManager.shared.getValue(forParameter: .vegan) as? Bool, isVegan {
            filteredDatasource = filteredDatasource.filter { $0.isVegan }
        }
        if let isDiabetic = SearchManager.shared.getValue(forParameter: .diabetic) as? Bool, isDiabetic {
            filteredDatasource = filteredDatasource.filter { $0.isDiabetic }
        }
        
        performSearch(for: filteredDatasource)
    }
    
    private func performSearch(for products: [Product]) {
//        var numbers = [Double(SearchManager.shared.getValue(forParameter: .sum) as? Int ?? 0)]
//        numbers.append(contentsOf: products.map { $0.price })
//        let simplex = WDSimplexMethod(mainEquation: WDSimplexEquation(equationNumbers:products.map { $0.price }, equationSolution:Double(SearchManager.shared.getValue(forParameter: .sum) as? Int ?? 0), equationType:.LessOrEqual), constraintEquations: simplexEquations, equationTarget: .Min)
//        let solution = simplex.calculateOptimum()
        
//        var rowIndices = [Int32]()
//        for product in products {
//            rowIndices.append(Int32(products.index(of: product)!))
//        }
//
//        var columnStarts: [Int] = Array(repeating: 0, count: rowIndices.count)
//
//        var values = products.map { $0.price }
//
//        var attributes = SparseAttributes_t()
//        attributes.kind = SparseSymmetric
//
//        let structure = SparseMatrixStructure(rowCount: Int32(1), columnCount: Int32(products.count), columnStarts: &columnStarts, rowIndices: &rowIndices, attributes: attributes, blockSize: 1)
//
//        let A = SparseMatrix_Double(structure: structure,
//                                    data: &values)
//
//        let LLT = SparseFactor(SparseFactorizationCholesky, A)
//        var bValues = [Double(getValue(forParameter: .sum) as? Int ?? 0)]
//        let b = DenseVector_Double(count: Int32(1),
//                                   data: &bValues)
//        var xValues = Array(repeating: 0.0, count: bValues.count)
//        let x = DenseVector_Double(count: Int32(xValues.count),
//                                   data: &xValues)
//        SparseSolve(LLT, b, x)
//
//        stride(from: 0, to: x.count, by: 1).forEach {i in
//            Swift.print(x.data[Int(i)])
//        }
        for product in products {
            var xvectors = [Int]()
            for x in 1...Int.max {
                guard let sum = getValue(forParameter: .sum) as? Int else {
                    return
                }
                
                var ccalCondition = true
                if let ccal = getValue(forParameter: .ccal) as? Int {
                    ccalCondition = x * Int(product.caloricity.ccal) <= ccal
                }
                
                var protsCondition = true
                if let prots = getValue(forParameter: .prots) as? Int{
                    protsCondition = x * Int(product.caloricity.prots) <= prots
                }
                
                var fatsCondition = true
                if let fats = getValue(forParameter: .fats) as? Int {
                    fatsCondition = x * Int(product.caloricity.fats) <= fats
                }
                
                var cabsCondition = true
                if let cabs = getValue(forParameter: .cabs) as? Int {
                    cabsCondition = x * Int(product.caloricity.cabs) <= cabs
                }
                if x * Int(product.price) <= sum
                    && ccalCondition
                    && protsCondition
                    && fatsCondition
                    && cabsCondition {
                    xvectors.append(x)
                } else {
                    product.multi = xvectors.max() ?? 1
                    break
                }
            }
        }
        var sums = [Int]()
        var filteredProducts = [Product]()
        products.forEach {
            guard let sum = getValue(forParameter: .sum) as? Int, $0.multi >= 2 else {
                return
            }
            sums.append($0.multi * Int($0.price))
            if sums.reduce(0, +) > sum {
                sums.removeLast()
                return
            }
            filteredProducts.append($0)
        }
        save()
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let _ = appDelegate.window?.rootViewController as? TabbarController {
            self.delegate?.reloadSearchResults(with: filteredProducts)
        } else {
            self.delegate?.reloadMainController()
        }
    }
}

extension SearchManager {
    func updateBasket(with product: Product) {
        self.basketDatasource.append(product)
    }
    
    func removeProduct(at index: Int) {
        if (index < self.basketDatasource.count - 1) {
            self.basketDatasource.remove(at: index)
        }
    }
    
    func updateBasket(with products: [Product]) {
        self.basketDatasource.removeAll()
        self.basketDatasource = products
    }
    
    func restoreBasket() -> [Product] {
        return self.basketDatasource
    }
}
