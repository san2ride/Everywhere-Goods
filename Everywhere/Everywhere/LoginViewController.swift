//
//  LoginViewController.swift
//  Everywhere
//
//  Created by don't touch me on 4/27/17.
//  Copyright © 2017 trvl, LLC. All rights reserved.
//

import UIKit
import Buy

class LoginViewController: UITableViewController {
    
    weak var delegate: AuthenticationDelegate?
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var actionCell: ActionCell!
    
    private var email:    String { return self.emailField.text    ?? "" }
    private var password: String { return self.passwordField.text ?? "" }
    
    // View Loading
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.actionCell.loading = false
        
    }
    
    // Actions
    private func loginUser() {
        guard !self.actionCell.loading else { return }
        
        let credentials = BUYAccountCredentials(items: [
            BUYAccountCredentialItem(email: self.email),
            BUYAccountCredentialItem(password: self.password),
        ])
        
        self.actionCell.loading = true
        BUYClient.sharedClient.loginCustomer(with: credentials) { (customer, token, error) in
            self.actionCell.loading = false
            
            if let customer = customer,
                let token = token {
                self.clear()
                self.delegate?.authenticationDidSucceedForCustomer(customer, withToken: token.accessToken)
            } else {
                self.delegate?.authenticationDidFailWithError(error as NSError?)
            }
        }
    }
    
    private func clear() {
        self.emailField.text    = ""
        self.passwordField.text = ""
    }
    
    // UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 1 {
            
            if !self.email.isEmpty &&
                !self.password.isEmpty {
                
                self.loginUser()
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
