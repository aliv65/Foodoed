//
//  BasketViewController.swift
//  AnyProj
//
//  Created by Александр Иванин on 12.11.17.
//

import UIKit
import Cartography

class BasketViewController: BaseTabbarViewController {
    var basketTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 230, green: 144, blue: 122, alpha: 1)
        self.setTitle("Корзина")
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        basketDatasource = SearchManager.shared.restoreBasket()
        basketTableView.reloadData()
    }
    
    func reloadData() {
        basketDatasource = SearchManager.shared.restoreBasket()
        basketTableView.reloadData()
    }
    
    private func setupUI() {
        basketTableView = UITableView()
        basketTableView.dataSource = self
        basketTableView.delegate = self
        basketTableView.separatorStyle = .none
        self.view.addSubview(basketTableView)
        
        constrain(self.view, basketTableView) { (view, table) in
            table.edges == inset(view.edges, 64, 16, 0, 16)
        }
    }
}

extension BasketViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basketDatasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: SearchTableViewCell
        if let reusableCell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseIdentifier) as? SearchTableViewCell {
            cell = reusableCell
        } else {
            cell = SearchTableViewCell()
        }
        cell.model = basketDatasource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailController = SearchDetailViewController(product: basketDatasource[indexPath.row])
        let navigationController = UINavigationController(rootViewController: detailController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let add = UITableViewRowAction(style: .normal, title: "Из корзины") { action, index in
            SearchManager.shared.removeProduct(at: indexPath.row)
            self.reloadData()
        }
        add.backgroundColor = UIColor.blue
        return [add]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
