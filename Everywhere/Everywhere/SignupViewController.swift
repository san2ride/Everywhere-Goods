//
//  SignupViewController.swift
//  Everywhere
//
//  Created by don't touch me on 4/27/17.
//  Copyright © 2017 trvl, LLC. All rights reserved.
//

import UIKit
import Buy

class SignupViewController: UITableViewController {
    
    weak var delegate: AuthenticationDelegate?
    
    @IBOutlet private weak var firstNameField:       UITextField!
    @IBOutlet private weak var lastNameField:        UITextField!
    @IBOutlet private weak var emailField:           UITextField!
    @IBOutlet private weak var passwordField:        UITextField!
    @IBOutlet private weak var passwordConfirmField: UITextField!
    @IBOutlet private weak var actionCell:           ActionCell!
    
    private var firstName:       String { return self.firstNameField.text       ?? "" }
    private var lastName:        String { return self.lastNameField.text        ?? "" }
    private var email:           String { return self.emailField.text           ?? "" }
    private var password:        String { return self.passwordField.text        ?? "" }
    private var passwordConfirm: String { return self.passwordConfirmField.text ?? "" }

    // View Loading
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.actionCell.loading = false
    }
    
    // Actions
    private func createUser() {
        guard !self.actionCell.loading else { return }
        
        let credentials = BUYAccountCredentials(items: [
            BUYAccountCredentialItem(firstName: self.firstName),
            BUYAccountCredentialItem(lastName: self.lastName),
            BUYAccountCredentialItem(email: self.email),
            BUYAccountCredentialItem(password: self.password)
        ])
        
        self.actionCell.loading = true
        BUYClient.sharedClient.createCustomer(with: credentials) { (customer, token, error) in
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
        self.firstNameField.text       = ""
        self.lastNameField.text        = ""
        self.emailField.text           = ""
        self.passwordField.text        = ""
        self.passwordConfirmField.text = ""
    }
    
    // UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 2 {
            
            if !self.email.isEmpty &&
                !self.password.isEmpty &&
                !self.firstName.isEmpty &&
                !self.lastName.isEmpty &&
                !self.passwordConfirm.isEmpty {
                
                self.createUser()
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
