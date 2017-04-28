//
//  AccountViewController.swift
//  Everywhere
//
//  Created by don't touch me on 4/7/17.
//  Copyright © 2017 trvl, LLC. All rights reserved.
//

import UIKit
import Buy

class AccountViewController: UIViewController {

    @IBOutlet weak var loginContainerView: UIView!
    @IBOutlet weak var signupContainerView: UIView!
    
    private var loginViewController: LoginViewController!
    private var signupViewController: SignupViewController!
    
    // Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case .some("loginSegue"):
            self.loginViewController = segue.destination as! LoginViewController
            self.loginViewController.delegate = self
            
        case .some("signupSegue"):
            self.signupViewController = segue.destination as! SignupViewController
            self.signupViewController.delegate = self
            
        default:
            break
        }
        
        if self.loginViewController != nil && self.signupViewController != nil {
            self.updateSelectedIndex(0)
        }
    }
    
    
    
    
    // Updates
    private func updateSelectedIndex(_ index: Int) {
        self.loginContainerView.isHidden = (index != 0)
        self.signupContainerView.isHidden = (index == 0)
    }

    // UI Actions
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        self.updateSelectedIndex(sender.selectedSegmentIndex)
        
    }
}

    // AuthenticationDelegate
extension AccountViewController: AuthenticationDelegate {
    func authenticationDidSucceedForCustomer(_ customer: BUYCustomer, withToken token: String) {
        
        if let orders = self.storyboard?.instantiateViewController(withIdentifier: "ordersViewController") as? OrdersViewController {
            orders.customer = customer
            self.navigationController?.pushViewController(orders, animated: true)
        }
    }

    func authenticationDidFailWithError(_ error: NSError?) {
        let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
