//
//  AdditionalInfoViewController.swift
//  AnyProj
//
//  Created by Александр Иванин on 11.11.17.
//

import UIKit
import Cartography

class AdditionalInfoViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 230, green: 144, blue: 122, alpha: 1)
        
        setupUI()
    }
    
    private func setupUI() {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.text = "Дополнительная\nинформация"
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.black
        self.view.addSubview(titleLabel)
        
        let veganLabel = UILabel()
        veganLabel.text = "Я - вегитарианец"
        veganLabel.textColor = UIColor.black
        self.view.addSubview(veganLabel)
        
        let veganSwitch = UISwitch()
        veganSwitch.addTarget(self, action: #selector(self.veganValueChanged(_:)), for: .valueChanged)
        self.view.addSubview(veganSwitch)
        
        let diabeticLabel = UILabel()
        diabeticLabel.text = "Я - диабетик"
        diabeticLabel.textColor = UIColor.black
        self.view.addSubview(diabeticLabel)
        
        let diabeticSwitch = UISwitch()
        diabeticSwitch.addTarget(self, action: #selector(self.diabeticValueChanged(_:)), for: .valueChanged)
        self.view.addSubview(diabeticSwitch)
        
        constrain(titleLabel, veganLabel, veganSwitch, diabeticLabel, diabeticSwitch) { (title, vlabel, vswitch, dlabel, dswitch) in
            title.top == title.superview!.top + 24
            title.left == title.superview!.left + 10
            title.right == title.superview!.right - 10
            
            vlabel.top == title.bottom + 40
            vlabel.left == title.left
            
            vswitch.centerY == vlabel.centerY
            vswitch.right == title.right
            
            dlabel.top == vlabel.bottom + 40
            dlabel.left == vlabel.left
            
            dswitch.centerY == dlabel.centerY
            dswitch.right == title.right
        }
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
