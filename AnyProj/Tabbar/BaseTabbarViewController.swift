//
//  BaseTabbarViewController.swift
//  AnyProj
//
//  Created by Александр Иванин on 12.11.17.
//

import UIKit
import Cartography

class BaseTabbarViewController: UIViewController {
    var scrollView: UIScrollView!
    var contentView: UIView!
    
    var useScroll = false
    
    var basketDatasource = [Product]() {
        didSet {
            SearchManager.shared.updateBasket(with: basketDatasource)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        basketDatasource = SearchManager.shared.restoreBasket()

        if useScroll {
            scrollView = UIScrollView()
            self.view.addSubview(scrollView)
            
            contentView = UIView()
            contentView.backgroundColor = UIColor.clear
            scrollView.addSubview(contentView)
            
            constrain(self.view, scrollView, contentView) { (view, scroll, content) in
                scroll.edges == inset(view.edges, 0, 0, 0, 0)
                content.edges == inset(scroll.edges, 0, 0, 0, 0)
                content.width == scroll.width
            }
        }
    }
    
    
    func setTitle(_ title: String) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        titleLabel.textAlignment = .center
        self.view.addSubview(titleLabel)
        
        let delimiter = UIView()
        delimiter.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.view.addSubview(delimiter)
        
        constrain(self.view, titleLabel, delimiter) { (view, label, delimiter) in
            label.centerX == view.centerX
            label.top == view.top + 24
            
            delimiter.bottom == view.top + 64
            delimiter.left == view.left
            delimiter.right == view.right
            delimiter.height == 1
        }
    }

}
