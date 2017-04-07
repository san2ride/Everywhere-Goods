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
    
    var productImageURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productImageView.imageFromServer(urlString: productImageURL!)
       
    }
    
}
