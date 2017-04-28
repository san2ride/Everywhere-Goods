//
//  LineItemCell.swift
//  Everywhere
//
//  Created by don't touch me on 4/9/17.
//  Copyright © 2017 trvl, LLC. All rights reserved.
//

import UIKit
import Buy

class LineItemCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    
    // Setters
    func setLineItem(_ item: BUYLineItem) {
        self.titleLabel.text = item.title
        self.subtitleLabel.text = item.variantTitle
        self.priceLabel.text = "$\(item.linePrice!)"
    }
}
