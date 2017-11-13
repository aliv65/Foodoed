//
//  SearchDetailViewController.swift
//  AnyProj
//
//  Created by Александр Иванин on 12.11.17.
//

import UIKit
import Cartography

class SearchDetailViewController: BaseTabbarViewController {
    var product: Product
    
    init(product: Product) {
        self.product = product
        
        super.init(nibName: nil, bundle: nil)
        
        useScroll = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.backButtonPressed(_:)))
        if !basketDatasource.contains(product) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addButtonPressed(_:)))
        }
        self.navigationItem.title = product.name
        
        self.view.backgroundColor = UIColor(red: 230, green: 144, blue: 122, alpha: 1)
        
        setupUI()
    }
    
    private func setupUI() {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "\(product.id)")
        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(imageView)
        
        let priceLabel = UILabel()
        priceLabel.text = "\(product.multi * Int(product.price)) руб."
        priceLabel.font = UIFont.systemFont(ofSize: 17)
        contentView.addSubview(priceLabel)
        
        let weightLabel = UILabel()
        weightLabel.text = "за \(product.multi * 100) грамм"
        weightLabel.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(weightLabel)
        
        let energyLabel = UILabel()
        energyLabel.text = "Энергетическая ценность продукта"
        energyLabel.font = UIFont.systemFont(ofSize: 17)
        contentView.addSubview(energyLabel)
        
        constrain(contentView, imageView, priceLabel, weightLabel, energyLabel) { (content, image, price, weight, energy) in
            image.top == content.top + 10
            image.centerX == content.centerX
            image.width == 170
            image.height == 150
            
            price.top == image.bottom + 30
            price.left == content.left + 16
            
            weight.centerY == price.centerY
            weight.left == price.right + 8
            
            energy.top == price.bottom + 30
            energy.left == price.left
        }
        
        let protsInfoLabel = UILabel()
        protsInfoLabel.text = "Белки"
        protsInfoLabel.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(protsInfoLabel)
        
        let protsLabel = UILabel()
        protsLabel.text = "\(product.caloricity.prots)"
        protsLabel.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(protsLabel)
        
        let fatsInfoLabel = UILabel()
        fatsInfoLabel.text = "Жиры"
        fatsInfoLabel.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(fatsInfoLabel)
        
        let fatsLabel = UILabel()
        fatsLabel.text = "\(product.caloricity.fats)"
        fatsLabel.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(fatsLabel)
        
        constrain(energyLabel, protsInfoLabel, protsLabel, fatsInfoLabel, fatsLabel) { (energy, pinfo, plabel, finfo, flabel) in
            pinfo.top == energy.bottom + 15
            pinfo.left == energy.left + 10
            
            plabel.centerY == pinfo.centerY
            plabel.left == pinfo.right + 40
            
            finfo.top == pinfo.bottom + 15
            finfo.left == pinfo.left
            
            flabel.centerY == finfo.centerY
            flabel.left == finfo.right + 40
        }
        
        let cabsInfoLabel = UILabel()
        cabsInfoLabel.text = "Углеводы"
        cabsInfoLabel.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(cabsInfoLabel)
        
        let cabsLabel = UILabel()
        cabsLabel.text = "\(product.caloricity.cabs)"
        cabsLabel.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(cabsLabel)
        
        let ccalsInfoLabel = UILabel()
        ccalsInfoLabel.text = "ккал"
        ccalsInfoLabel.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(ccalsInfoLabel)
        
        let ccalsLabel = UILabel()
        ccalsLabel.text = "\(product.caloricity.ccal)"
        ccalsLabel.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(ccalsLabel)
        
        constrain(fatsInfoLabel, cabsInfoLabel, cabsLabel, ccalsInfoLabel, ccalsLabel) { (finfo, cinfo, clabel, ccalinfo, ccallabel) in
            cinfo.top == finfo.bottom + 15
            cinfo.left == finfo.left
            
            clabel.centerY == cinfo.centerY
            clabel.left == cinfo.right + 40
            
            ccalinfo.top == cinfo.bottom + 15
            ccalinfo.left == cinfo.left
            
            ccallabel.centerY == ccalinfo.centerY
            ccallabel.left == ccalinfo.right + 40
        }
        
        let ingridientsLabel = UILabel()
        ingridientsLabel.text = "Ингридиенты (цена на 100 грамм блюда)"
        ingridientsLabel.font = UIFont.systemFont(ofSize: 17)
        contentView.addSubview(ingridientsLabel)
        
        constrain(ccalsInfoLabel, ingridientsLabel) { (ccalinfo, ing) in
            ing.top == ccalinfo.bottom + 30
            ing.left == ccalinfo.left - 10
        }
        
        var previousView = ingridientsLabel
        for ingridient in product.ingridients {
            let ingLabel = UILabel()
            ingLabel.text = ingridient.name
            ingLabel.font = UIFont.systemFont(ofSize: 15)
            contentView.addSubview(ingLabel)
            
            let valueLabel = UILabel()
            valueLabel.text = "\(ingridient.price)"
            valueLabel.font = UIFont.systemFont(ofSize: 15)
            contentView.addSubview(valueLabel)
            
            constrain(previousView, ingLabel, valueLabel) { (prev, name, value) in
                name.top == prev.bottom + 15
                name.left == prev.left
                
                value.centerY == name.centerY
                value.left == name.right + 40
            }
            
            previousView = ingLabel
        }
        
        constrain(contentView, previousView) { (content, prev) in
            content.bottom == prev.bottom + 20
        }
    }
    
    @objc
    private func addButtonPressed(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Добавить продукт в корзину?", message: nil, preferredStyle: .alert)
        let addAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.basketDatasource.append(self.product)
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(addAction)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc
    private func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
