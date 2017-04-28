//
//  OrdersViewController.swift
//  Everywhere
//
//  Created by don't touch me on 4/7/17.
//  Copyright © 2017 trvl, LLC. All rights reserved.
//

import UIKit
import Buy

class OrdersViewController: UIViewController {
    
    var customer: BUYCustomer!
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var orders = [BUYOrder]()
    
    fileprivate let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        return f
    }()
    
    // View Loading
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadOrders()
    }
    
    private func loadOrders() {
        BUYClient.sharedClient.getOrdersForCustomerCallback { (orders, error) in
            if let orders = orders {
                self.orders = orders
                self.tableView.reloadData()
            } else {
                print("Could not fetch orders: \(error)")
            }
        }
    }
    
    // UI Action
    @IBAction func logoutAction(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
        
    }
}

// UITableViewDataSource
extension OrdersViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.orders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orders[section].lineItems.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let order = self.orders[section]
        return "\(self.dateFormatter.string(from: order.processedAt)) - \(order.name!)"
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let order = self.orders[section]
        return "Order total: $\(order.totalPrice!)"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LineItemCell
        let lineItem = self.orders[(indexPath as NSIndexPath).section].lineItemsArray()[(indexPath as NSIndexPath).row]
        
        cell.setLineItem(lineItem)
        
        return cell
    }
    
}

    

