//
//  SearchViewController.swift
//  AnyProj
//
//  Created by Александр Иванин on 12.11.17.
//

import UIKit
import Cartography

class SearchViewController: BaseTabbarViewController {
    var searchTableView: UITableView!
    var refreshControl: UIRefreshControl!
    
    var dataSource = [Product]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 230, green: 144, blue: 122, alpha: 1)
        self.setTitle("Поиск")
        
        setupUI()
    }
    
    private func setupUI() {
        searchTableView = UITableView()
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.separatorStyle = .none
        self.view.addSubview(searchTableView)
        
        constrain(self.view, searchTableView) { (view, table) in
            table.edges == inset(view.edges, 64, 16, 0, 16)
        }
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.pullRefreshControll(_:)), for: .valueChanged)
        searchTableView.addSubview(refreshControl)
    }
    
    func reloadData(with products: [Product]) {
        self.dataSource = products
        searchTableView.reloadData()
    }
    
    @objc
    private func pullRefreshControll(_ sender: UIRefreshControl) {
        performSearch()
    }
    
    private func performSearch() {
        SearchManager.shared.search()
        refreshControl.endRefreshing()
    }
}

extension SearchViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: SearchTableViewCell
        if let reusableCell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseIdentifier) as? SearchTableViewCell {
            cell = reusableCell
        } else {
            cell = SearchTableViewCell()
        }
        cell.model = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailController = SearchDetailViewController(product: dataSource[indexPath.row])
        let navigationController = UINavigationController(rootViewController: detailController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let basket = SearchManager.shared.restoreBasket()
        let add = UITableViewRowAction(style: .normal, title: basket.contains(dataSource[indexPath.row]) ? "Из корзины" : "В корзину") { action, index in
            if basket.contains(self.dataSource[indexPath.row]) {
                SearchManager.shared.removeProduct(at: indexPath.row)
            } else {
                SearchManager.shared.updateBasket(with: self.dataSource[indexPath.row])
            }
        }
        add.backgroundColor = UIColor.blue
        return [add]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
