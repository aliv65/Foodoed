//
//  SearchTableViewCell.swift
//  AnyProj
//
//  Created by Александр Иванин on 12.11.17.
//

import UIKit
import Cartography

class SearchTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: SearchTableViewCell.self)
    
    var productImageView: UIImageView!
    var nameLabel: UILabel!
    var priceLabel: UILabel!
    var weightLabel: UILabel!
    
    var model: Product? {
        didSet {
            onModelSet()
        }
    }
    
    init() {
        super.init(style: .default, reuseIdentifier: SearchTableViewCell.reuseIdentifier)
        
        self.backgroundColor = UIColor.white
        self.selectionStyle = .none
        self.translatesAutoresizingMaskIntoConstraints = false
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        productImageView = UIImageView()
        productImageView.contentMode = .scaleAspectFill
        self.contentView.addSubview(productImageView)
        
        nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 17)
        self.contentView.addSubview(nameLabel)
        
        priceLabel = UILabel()
        priceLabel.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        self.contentView.addSubview(priceLabel)
        
        weightLabel = UILabel()
        weightLabel.font = UIFont.systemFont(ofSize: 15)
        self.contentView.addSubview(weightLabel)
        
        constrain(contentView, productImageView, nameLabel, priceLabel, weightLabel) { (content, image, name, price, weigth) in
            image.top == content.top + 20
            image.left == content.left
            image.width == 80
            image.height == 80
            content.bottom == image.bottom
            
            name.top == image.top + 4
            name.left == image.right + 20
            
            price.bottom == image.bottom
            price.left == name.left
            
            weigth.left == price.right + 4
            weigth.centerY == price.centerY
        }
        
        let underline = UIView()
        underline.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        contentView.addSubview(underline)
        
        constrain(contentView, underline) { (content, underline) in
            underline.bottom == content.bottom
            underline.height == 1
            underline.left == content.left
            underline.right == content.right
        }
    }
    
    override func prepareForReuse() {
        clear()
        
        super.prepareForReuse()
    }
    
    private func clear() {
        productImageView.image = nil
        nameLabel.text = nil
        priceLabel.text = nil
        weightLabel.text = nil
    }
    
    private func onModelSet() {
        productImageView.image = UIImage(named: "\(model?.id ?? 1)")
        nameLabel.text = model?.name
        priceLabel.text = "\((model?.multi ?? 1) * Int(model?.price ?? 0)) руб."
        weightLabel.text = "\((model?.multi ?? 1) * 100) грамм"
    }
}
