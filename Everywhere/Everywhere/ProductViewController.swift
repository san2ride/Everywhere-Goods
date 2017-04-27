//
//  ProductViewController.swift
//  Everywhere
//
//  Created by don't touch me on 4/6/17.
//  Copyright © 2017 trvl, LLC. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ProductViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var searchProducts: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    let manager = CLLocationManager()
    var products: ProductAPI!
    var productData = [Product]()
    var filteredProducts = [Product]()
    var userZipcode: String = ""
    var currentProduct: Product?
    
        
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        products.fetchProducts() { (products) -> Void in
            self.productData = products
            print(self.productData)
            
            OperationQueue.main.addOperation {
                
                if self.userZipcode != "" {
                    self.reloadProductsFrom(zipcode: self.userZipcode)
                } else {
                    self.collectionView.reloadData()
                }
            }
        }
    }
        
    override func viewWillAppear(_ animated: Bool) {
        collectionView.prefetchDataSource = self
        self.searchProducts.delegate = self
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 128, height: 42))
        imageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named: "logoBlack")
        imageView.image = image
        
        navigationItem.titleView = imageView
        
    }
    
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if searchProducts.text != "" {
            return self.filteredProducts.count
        }
        
        if filteredProducts.count > 0 {
            print(filteredProducts)
            return self.filteredProducts.count
        }
        
        print(self.productData.count)
        return self.productData.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Product", for: indexPath) as! ProductCollectionViewCell
        
        let product: Product
        
        if searchProducts.text != "" {
            product = filteredProducts[indexPath.row]
        } else if filteredProducts.count > 0{
            product = filteredProducts[indexPath.row]
        } else {
            product = productData[indexPath.row]
        }
        
        cell.imageView?.imageFromServer(urlString: product.image)
        cell.name.text = product.title
        cell.price.text = product.price
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ProductCollectionViewCell else {
            return
        }
        
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut], animations: {
            cell.imageView?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (finished) in
            UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseIn], animations: {
                cell.imageView?.transform = CGAffineTransform.identity
            }, completion: { [weak self] finished in
                self?.performSegue(withIdentifier: "ShowItem", sender: self)
            })
        }
        
        self.currentProduct = self.productData[(indexPath as NSIndexPath).row]

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let selectedIndex = collectionView.indexPathsForSelectedItems?.first {
            
            var photo: Product
            
            if filteredProducts.count > 0 {
                photo = filteredProducts[selectedIndex.row]
                
            } else {
                photo = productData[selectedIndex.row]
            }
            
            let showImage = segue.destination as! ProductDetailViewController
            print(photo.image)
            
            showImage.productImageURL = photo.image
            
            let controller = segue.destination as? ProductDetailViewController
            
            controller?.theProduct = self.currentProduct
        }
    }
    
    func reloadProductsFrom(zipcode: String) {
        print("Reload products")
        print(zipcode)
        if productData.isEmpty {
            return
        }
        filteredProducts = self.productData.filter({ (p) -> Bool in
            return p.tags.lowercased().range(of: zipcode.lowercased()) != nil
        })
        
        self.collectionView.reloadData()
    }
}

extension UIImageView {
    public func imageFromServer(urlString: String) {
        URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, response, error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
                
            })
        }.resume()
    }
}

extension ProductViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredProducts = self.productData.filter({ (p) -> Bool in
            return p.tags.lowercased().range(of: searchText.lowercased()) != nil
        })
        self.collectionView.reloadData()
    }
}

extension ProductViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
    }
}

extension ProductViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.first
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let userLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location!.coordinate.latitude, location!.coordinate.longitude)
        
        let region: MKCoordinateRegion = MKCoordinateRegionMake(userLocation, span)
        
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error) -> Void in
            
            if (error != nil) {
                print(error?.localizedDescription)
            }
            
            if (placemarks?.count)! > 0 {
                let pm = (placemarks?[0])! as CLPlacemark
                if let zipcode = pm.postalCode {
                    manager.stopUpdatingLocation()
                    self.userZipcode = zipcode
                }
            }
        })
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    

}
