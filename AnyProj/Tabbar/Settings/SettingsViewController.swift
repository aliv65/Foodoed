//
//  SettingsViewController.swift
//  AnyProj
//
//  Created by Александр Иванин on 12.11.17.
//

import UIKit
import Cartography

class SettingsViewController: BaseTabbarViewController {
    var priceLabel: UILabel!
    var priceField: UITextField!
    var caloricityLabel: UILabel!
    var caloricityField: UITextField!
    var detailCaloricityLabel: UILabel!
    var detailCaloricity: UISwitch!
    var additionalButton: UIButton!
    var searchButton: UIButton!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        useScroll = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 230, green: 144, blue: 122, alpha: 1)
        self.setTitle("Настройки")
        
        setupUI()
    }
    
    private func setupUI() {
        priceLabel = UILabel()
        priceLabel.text = "Ваш бюджет"
        priceLabel.textColor = UIColor.black
        contentView.addSubview(priceLabel)
        
        priceField = UITextField()
        priceField.delegate = self
        priceField.placeholder = "Цена, руб."
        priceField.backgroundColor = UIColor.white
        priceField.keyboardType = .numberPad
        priceField.minimumFontSize = 18
        priceField.layer.borderColor = UIColor.black.cgColor
        priceField.layer.borderWidth = 1
        priceField.layer.cornerRadius = 8
        priceField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        priceField.text = String(SearchManager.shared.getValue(forParameter: .sum) as? Int ?? 0)
        contentView.addSubview(priceField)
        
        caloricityLabel = UILabel()
        caloricityLabel.text = "Количество калорий"
        caloricityLabel.textColor = UIColor.black
        contentView.addSubview(caloricityLabel)
        
        caloricityField = UITextField()
        caloricityField.delegate = self
        caloricityField.placeholder = "Калорийность, ккал"
        caloricityField.backgroundColor = UIColor.white
        caloricityField.keyboardType = .numberPad
        caloricityField.minimumFontSize = 18
        caloricityField.layer.borderColor = UIColor.black.cgColor
        caloricityField.layer.borderWidth = 1
        caloricityField.layer.cornerRadius = 8
        caloricityField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        caloricityField.text = String(SearchManager.shared.getValue(forParameter: .ccal) as? Int ?? 0)
        contentView.addSubview(caloricityField)
        
        detailCaloricityLabel = UILabel()
        detailCaloricityLabel.text = "Уточнить?"
        caloricityLabel.textColor = UIColor.black
        contentView.addSubview(detailCaloricityLabel)
        
        detailCaloricity = UISwitch()
        detailCaloricity.addTarget(self, action: #selector(self.detailCaloricity(_:)), for: .valueChanged)
        contentView.addSubview(detailCaloricity)
        
        detailCaloricity.isOn =
            SearchManager.shared.getValue(forParameter: .prots) != nil || SearchManager.shared.getValue(forParameter: .fats) != nil || SearchManager.shared.getValue(forParameter: .cabs) != nil
        
        searchButton = UIButton(type: .custom)
        searchButton.setImage(#imageLiteral(resourceName: "run"), for: .normal)
        searchButton.addTarget(self, action: #selector(self.search(_:)), for: .touchUpInside)
        searchButton.layer.cornerRadius = 5
        searchButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        searchButton.layer.shadowOpacity = 0.15
        searchButton.layer.shadowRadius = 7
        contentView.addSubview(searchButton)
        
        constrain(contentView, priceLabel, priceField, caloricityField, caloricityLabel) { (view, plabel, price, caloricity, clabel) in
            plabel.top == view.top + 84
            plabel.left == view.left + 30
            
            price.top == plabel.bottom + 20
            price.left == plabel.left
            price.right == view.right - 30
            price.height == 44
            
            clabel.top == price.bottom + 20
            clabel.left == plabel.left
            
            caloricity.top == clabel.bottom + 20
            caloricity.left == price.left
            caloricity.right == price.right
            caloricity.height == 44
        }
        
        constrain(caloricityField, detailCaloricityLabel, detailCaloricity) { (caloricity, detail, switcher) in
            detail.left == caloricity.left
            detail.top == caloricity.bottom + 20
            
            switcher.centerY == detail.centerY
            switcher.right == caloricity.right
        }
        
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.text = "Дополнительная информация"
        titleLabel.textAlignment = .left
        titleLabel.textColor = UIColor.black
        contentView.addSubview(titleLabel)

        let veganLabel = UILabel()
        veganLabel.text = "Я - вегитарианец"
        veganLabel.textColor = UIColor.black
        contentView.addSubview(veganLabel)

        let veganSwitch = UISwitch()
        veganSwitch.addTarget(self, action: #selector(self.veganValueChanged(_:)), for: .valueChanged)
        contentView.addSubview(veganSwitch)
        
        if let vegan = SearchManager.shared.getValue(forParameter: .vegan) as? Bool {
            veganSwitch.isOn = vegan
        }

        let diabeticLabel = UILabel()
        diabeticLabel.text = "Я - диабетик"
        diabeticLabel.textColor = UIColor.black
        contentView.addSubview(diabeticLabel)

        let diabeticSwitch = UISwitch()
        diabeticSwitch.addTarget(self, action: #selector(self.diabeticValueChanged(_:)), for: .valueChanged)
        contentView.addSubview(diabeticSwitch)
        
        if let diabetic = SearchManager.shared.getValue(forParameter: .diabetic) as? Bool {
            diabeticSwitch.isOn = diabetic
        }

        constrain(detailCaloricityLabel, titleLabel) { (detail, title) in
            title.top == detail.bottom + 20
            title.left == title.superview!.left + 10
            title.right == title.superview!.right - 10
        }

        constrain(titleLabel, veganLabel, veganSwitch, diabeticLabel, diabeticSwitch) { (title, vlabel, vswitch, dlabel, dswitch) in
            vlabel.top == title.bottom + 20
            vlabel.left == title.left

            vswitch.centerY == vlabel.centerY
            vswitch.right == title.right

            dlabel.top == vlabel.bottom + 20
            dlabel.left == vlabel.left

            dswitch.centerY == dlabel.centerY
            dswitch.right == title.right
        }
        
        
        constrain(contentView, diabeticLabel, searchButton) { (view, diabetic, button) in
            button.top == diabetic.bottom + 50
            button.centerX == view.centerX
            button.width == 100
            button.height == 100
            
            view.bottom == button.bottom + 20
        }
    }
    
    @objc
    private func detailCaloricity(_ sender: UISwitch) {
        if sender.isOn {
            let popupController = CaloricityPopupViewController()
            popupController.delegate = self
            popupController.modalPresentationStyle = .overCurrentContext
            self.present(popupController, animated: true, completion: nil)
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
    
    @objc
    private func veganValueChanged(_ sender: UISwitch) {
        SearchManager.shared.set(value: sender.isOn, forParameter: .vegan)
    }
    
    @objc
    private func diabeticValueChanged(_ sender: UISwitch) {
        SearchManager.shared.set(value: sender.isOn, forParameter: .diabetic)
    }
}

extension SettingsViewController : CaloricityPopupDelegate {
    func applyCaloricityValues(proteins: Float, fats: Float, carbohydrates: Float) {
        caloricityField.text = "\(Int(proteins * 4.1 + fats * 9.3 + carbohydrates * 4.1))"
        SearchManager.shared.set(value: Int(proteins * 4.1 + fats * 9.3 + carbohydrates * 4.1), forParameter: .ccal)
        SearchManager.shared.set(value: Int(proteins), forParameter: .prots)
        SearchManager.shared.set(value: Int(fats), forParameter: .fats)
        SearchManager.shared.set(value: Int(carbohydrates), forParameter: .cabs)
    }
    
    func controllerDismiss() {
        
    }
}

extension SettingsViewController : UITextFieldDelegate {
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
