//
//  BUYClient+Extensions.swift
//  Everywhere
//
//  Created by don't touch me on 4/7/17.
//  Copyright © 2017 trvl, LLC. All rights reserved.
//

import Foundation
import Buy

extension BUYClient {
    
    static var sharedClient: BUYClient {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            return delegate.client
        }
        fatalError("Could not retrieve shared BUYClient")
    }
}
