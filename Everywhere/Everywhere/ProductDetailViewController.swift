//
//  ProductDetailViewController.swift
//  Everywhere
//
//  Created by don't touch me on 4/6/17.
//  Copyright © 2017 trvl, LLC. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    
    
    var productImageURL: String?
    var theProduct: Product?

    
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        productImageView.imageFromServer(urlString: productImageURL!)
        self.idLabel.text = numberFormatter.string(from: (theProduct?.id)!)
        self.titleLabel.text = theProduct?.title
        self.productLabel.text = theProduct?.productType
        self.priceLabel.text = theProduct?.price
        self.tagsLabel.text = theProduct?.tags
        
        
        
       
    }
    
    @IBAction func addToCartPressed(_ sender: UIButton) {
        
    }
    
    
}
