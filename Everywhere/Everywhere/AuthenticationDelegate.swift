//
//  AuthenticationDelegate.swift
//  Everywhere
//
//  Created by don't touch me on 4/7/17.
//  Copyright © 2017 trvl, LLC. All rights reserved.
//

import Foundation
import Buy

protocol AuthenticationDelegate: class {
    func authenticationDidSucceedForCustomer(_ customer: BUYCustomer, withToken token: String)
    func authenticationDidFailWithError(_ error: NSError?)
}
