//
//  ActionCell.swift
//  Everywhere
//
//  Created by don't touch me on 4/9/17.
//  Copyright © 2017 trvl, LLC. All rights reserved.
//

import UIKit

class ActionCell: UITableViewCell {

    @IBOutlet private weak var actionLabel: UILabel!
    @IBOutlet private weak var loader: UIActivityIndicatorView!
    
    var loading: Bool {
        get {
            return self.actionLabel.isHidden
        }
        set {
            self.actionLabel.isHidden = newValue
            self.loader.isHidden      = !newValue
        }
    }
    
}
