//
//  StartViewController.swift
//  AnyProj
//
//  Created by Александр Иванин on 11.11.17.
//

import Foundation
import UIKit
import Cartography

class SearchNaigationController: UINavigationController, ViewControllerInDrawer {
    func isDrawerEnable() -> Bool {
        guard let controller = self.viewControllers.last as? ViewControllerInDrawer else {
            return true
        }
        return controller.isDrawerEnable()
    }
}

class StartViewController : UIViewController {
    var priceLabel: UILabel!
    var priceField: UITextField!
    var caloricityLabel: UILabel!
    var caloricityField: UITextField!
    var detailCaloricityLabel: UILabel!
    var detailCaloricity: UISwitch!
    var additionalButton: UIButton!
    var searchButton: UIButton!
    
    var drawerEnable: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 230, green: 144, blue: 122, alpha: 1)
        self.view.layer.borderColor = UIColor.black.cgColor
        self.view.layer.borderWidth = 1
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "info"), style: .plain, target: self, action: #selector(self.showAdditionalInfo(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
        setupUI()
    }
    
    private func setupUI() {
        priceLabel = UILabel()
        priceLabel.text = "Ваш бюджет"
        priceLabel.textColor = UIColor.black
        self.view.addSubview(priceLabel)
        
        priceField = UITextField()
        priceField.delegate = self
        priceField.placeholder = "Цена, руб."
        priceField.backgroundColor = UIColor.white
        priceField.keyboardType = .numberPad
        priceField.minimumFontSize = 18
        priceField.layer.borderColor = UIColor.black.cgColor
        priceField.layer.borderWidth = 1
        priceField.layer.cornerRadius = 8
        priceField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
        self.view.addSubview(priceField)
        
        caloricityLabel = UILabel()
        caloricityLabel.text = "Количество калорий"
        caloricityLabel.textColor = UIColor.black
        self.view.addSubview(caloricityLabel)
        
        caloricityField = UITextField()
        caloricityField.delegate = self
        caloricityField.placeholder = "Калорийность, ккал"
        caloricityField.backgroundColor = UIColor.white
        caloricityField.keyboardType = .numberPad
        caloricityField.minimumFontSize = 18
        caloricityField.layer.borderColor = UIColor.black.cgColor
        caloricityField.layer.borderWidth = 1
        caloricityField.layer.cornerRadius = 8
        caloricityField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
        self.view.addSubview(caloricityField)
        
        detailCaloricityLabel = UILabel()
        detailCaloricityLabel.text = "Уточнить?"
        caloricityLabel.textColor = UIColor.black
        self.view.addSubview(detailCaloricityLabel)
        
        detailCaloricity = UISwitch()
        detailCaloricity.addTarget(self, action: #selector(self.detailCaloricity(_:)), for: .valueChanged)
        self.view.addSubview(detailCaloricity)
        
        searchButton = UIButton(type: .custom)
        searchButton.setImage(#imageLiteral(resourceName: "run"), for: .normal)
        searchButton.addTarget(self, action: #selector(self.search(_:)), for: .touchUpInside)
        searchButton.layer.cornerRadius = 5
        searchButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        searchButton.layer.shadowOpacity = 0.15
        searchButton.layer.shadowRadius = 7
        self.view.addSubview(searchButton)
        
        constrain(self.view, priceLabel, priceField, caloricityField, caloricityLabel) { (view, plabel, price, caloricity, clabel) in
            plabel.top == view.top + 100
            plabel.left == view.left + 30
            
            price.top == plabel.bottom + 20
            price.left == plabel.left
            price.right == view.right - 30
            price.height == 44
            
            clabel.top == price.bottom + 40
            clabel.left == plabel.left
            
            caloricity.top == clabel.bottom + 20
            caloricity.left == price.left
            caloricity.right == price.right
            caloricity.height == 44
        }
        
        constrain(self.view, caloricityField, detailCaloricityLabel, detailCaloricity) { (view, caloricity, detail, switcher) in
            detail.left == caloricity.left
            detail.top == caloricity.bottom + 20
            
            switcher.centerY == detail.centerY
            switcher.right == caloricity.right
            
        }
        
        constrain(self.view, searchButton) { (view, button) in
            button.centerX == view.centerX
            button.bottom == view.bottom - 50
            button.width == 150
            button.height == 150
        }
    }
    
    @objc
    private func showAdditionalInfo(_ sender: UIButton) {
        if let drawer = self.mm_drawerController {
            if drawer.openSide == .none {
                drawer.open(.left, animated: true, completion: nil)
            } else {
                drawer.closeDrawer(animated: true, completion: nil)
            }
        }
    }
    
    @objc
    private func detailCaloricity(_ sender: UISwitch) {
        if sender.isOn {
            let popupController = CaloricityPopupViewController()
            popupController.delegate = self
            popupController.modalPresentationStyle = .overCurrentContext
            self.present(popupController, animated: true, completion: nil)
            self.drawerEnable = false
        }
        SearchManager.shared.set(value: sender.isOn, forParameter: .considerDetails)
    }
    
    @objc
    private func search(_ sender: UIButton) {
        guard SearchManager.shared.isValid else {
            let alertController = UIAlertController(title: "Внимание!", message: "Укажите сумму, на которую Вы расчитываете", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        SearchManager.shared.search()
    }
}

extension StartViewController : ViewControllerInDrawer {
    func isDrawerEnable() -> Bool {
        return drawerEnable
    }
}

extension StartViewController : CaloricityPopupDelegate {
    func applyCaloricityValues(proteins: Float, fats: Float, carbohydrates: Float) {
        caloricityField.text = "\(Int(proteins * 4.1 + fats * 9.3 + carbohydrates * 4.1))"
        SearchManager.shared.set(value: Int(proteins * 4.1 + fats * 9.3 + carbohydrates * 4.1), forParameter: .ccal)
        SearchManager.shared.set(value: Int(proteins), forParameter: .prots)
        SearchManager.shared.set(value: Int(fats), forParameter: .fats)
        SearchManager.shared.set(value: Int(carbohydrates), forParameter: .cabs)
    }
    
    func controllerDismiss() {
        drawerEnable = true
    }
}

extension StartViewController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty, let value = Int(text) else {
            return
        }
        if textField == priceField {
            SearchManager.shared.set(value: value, forParameter: .sum)
        } else if textField == caloricityField {
            SearchManager.shared.set(value: value, forParameter: .ccal)
        }
    }
}
