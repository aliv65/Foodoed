//
//  CaloricityPopupViewController.swift
//  AnyProj
//
//  Created by Александр Иванин on 11.11.17.
//

import UIKit
import Cartography

protocol CaloricityPopupDelegate: class {
    func applyCaloricityValues(proteins: Float, fats: Float, carbohydrates: Float)
    func controllerDismiss()
}

class CaloricityPopupViewController : UIViewController {
    var proteinsLabel: UILabel!
    var proteinsSlider: UISlider!
    var proteinsValueLabel: UILabel!
    
    var fatsLabel: UILabel!
    var fatsSlider: UISlider!
    var fatsValueLabel: UILabel!
    
    var carbohydratesLabel: UILabel!
    var carbohydratesSlider: UISlider!
    var carbohydratesValueLabel: UILabel!
    
    var applyButton: UIButton!
    
    weak var delegate: CaloricityPopupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        setupUI()
        preloadValues()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.delegate?.controllerDismiss()
    }
    
    private func setupUI() {
        let contentView = UIView()
        contentView.backgroundColor = UIColor(red: 230, green: 144, blue: 122, alpha: 1)
        self.view.addSubview(contentView)
        
        constrain(self.view, contentView) { (view, content) in
            content.center == view.center
            
            content.left == view.left + 20
            content.right == view.right - 20
        }
        
        proteinsLabel = UILabel()
        proteinsLabel.text = "Белки"
        proteinsLabel.textColor = UIColor.black
        contentView.addSubview(proteinsLabel)
        
        proteinsSlider = UISlider()
        proteinsSlider.minimumValue = 0
        proteinsSlider.maximumValue = 500
        proteinsSlider.addTarget(self, action: #selector(self.proteinsValueChanged(_:)), for: .valueChanged)
        contentView.addSubview(proteinsSlider)
        
        proteinsValueLabel = UILabel()
        proteinsValueLabel.text = "\(Int(proteinsSlider.value)) грамм"
        proteinsValueLabel.textColor = UIColor.black
        contentView.addSubview(proteinsValueLabel)
        
        fatsLabel = UILabel()
        fatsLabel.text = "Жиры"
        fatsLabel.textColor = UIColor.black
        contentView.addSubview(fatsLabel)
        
        fatsSlider = UISlider()
        fatsSlider.minimumValue = 0
        fatsSlider.maximumValue = 500
        fatsSlider.addTarget(self, action: #selector(self.fatsValueChanged(_:)), for: .valueChanged)
        contentView.addSubview(fatsSlider)
        
        fatsValueLabel = UILabel()
        fatsValueLabel.text = "\(Int(fatsSlider.value)) грамм"
        fatsValueLabel.textColor = UIColor.black
        contentView.addSubview(fatsValueLabel)
        
        carbohydratesLabel = UILabel()
        carbohydratesLabel.text = "Углеводы"
        contentView.addSubview(carbohydratesLabel)
        
        carbohydratesSlider = UISlider()
        carbohydratesSlider.minimumValue = 0
        carbohydratesSlider.maximumValue = 500
        carbohydratesSlider.addTarget(self, action: #selector(self.carbohydratesValueChanged(_:)), for: .valueChanged)
        contentView.addSubview(carbohydratesSlider)
        
        carbohydratesValueLabel = UILabel()
        carbohydratesValueLabel.text = "\(Int(carbohydratesSlider.value)) грамм"
        carbohydratesValueLabel.textColor = UIColor.black
        contentView.addSubview(carbohydratesValueLabel)
        
        applyButton = UIButton(type: .custom)
        applyButton.setTitle("Применить", for: .normal)
        applyButton.setTitleColor(UIColor.blue, for: .normal)
        applyButton.setTitleColor(UIColor.blue.withAlphaComponent(0.7), for: .highlighted)
        applyButton.addTarget(self, action: #selector(self.apply(_:)), for: .touchUpInside)
        contentView.addSubview(applyButton)
        
        constrain(contentView, proteinsLabel, proteinsSlider, proteinsValueLabel, fatsLabel) { (view, proteins, slider, value, fats) in
            proteins.top == view.top + 20
            proteins.left == view.left + 10
            
            value.centerY == proteins.centerY
            value.left == proteins.right + 4
            
            slider.top == proteins.bottom + 8
            slider.left == proteins.left
            slider.right == view.right - 10
            
            fats.top == slider.bottom + 20
            fats.left == proteins.left
        }
        
        constrain(contentView, fatsLabel, fatsSlider, fatsValueLabel, carbohydratesLabel) { (view, fats, slider, value, carbohydrates) in
            value.centerY == fats.centerY
            value.left == fats.right + 4
            
            slider.top == fats.bottom + 8
            slider.left == fats.left
            slider.right == view.right - 10
            
            carbohydrates.top == slider.bottom + 20
            carbohydrates.left == fats.left
        }
        
        constrain(contentView, carbohydratesLabel, carbohydratesSlider, carbohydratesValueLabel) { (view, carbohydrates, slider, value) in
            value.centerY == carbohydrates.centerY
            value.left == carbohydrates.right + 4
            
            slider.top == carbohydrates.bottom + 8
            slider.left == carbohydrates.left
            slider.right == view.right - 10
        }
        
        constrain(contentView, carbohydratesSlider, applyButton) { (view, slider, button) in
            button.top == slider.bottom + 30
            button.centerX == view.centerX
            button.left == view.left + 30
            button.right == view.right - 30
            
            view.bottom == button.bottom + 20
        }
    }
    
    private func preloadValues() {
        proteinsSlider.value = Float(SearchManager.shared.getValue(forParameter: .prots) as? Int ?? 0)
        self.proteinsValueChanged(proteinsSlider)
        fatsSlider.value = Float(SearchManager.shared.getValue(forParameter: .fats) as? Int ?? 0)
        self.fatsValueChanged(fatsSlider)
        carbohydratesSlider.value = Float(SearchManager.shared.getValue(forParameter: .cabs) as? Int ?? 0)
        self.carbohydratesValueChanged(carbohydratesSlider)
    }
    
    @objc
    private func proteinsValueChanged(_ sender: UISlider) {
        proteinsValueLabel.text = nil
        proteinsValueLabel.text = "\(Int(sender.value)) ккал"
    }
    
    @objc
    private func fatsValueChanged(_ sender: UISlider) {
        fatsValueLabel.text = nil
        fatsValueLabel.text = "\(Int(sender.value)) ккал"
    }
    
    @objc
    private func carbohydratesValueChanged(_ sender: UISlider) {
        carbohydratesValueLabel.text = nil
        carbohydratesValueLabel.text = "\(Int(sender.value)) ккал"
    }
    
    @objc
    private func apply(_ sender: UIButton) {
        self.delegate?.applyCaloricityValues(proteins: proteinsSlider.value, fats: fatsSlider.value, carbohydrates: carbohydratesSlider.value)
        self.dismiss(animated: true, completion: nil)
    }
}

extension CaloricityPopupViewController : ViewControllerInDrawer {
    func isDrawerEnable() -> Bool {
        return false
    }
}
