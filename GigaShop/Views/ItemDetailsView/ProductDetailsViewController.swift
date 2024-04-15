//
//  ItemDetailsViewController.swift
//  GigaShop
//
//  Created by Appnap Mahfuj on 13/4/24.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var descriptionLable: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var reviewsLable: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    var productViewModel = ProductViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBinders()
        // Do any additional setup after loading the view.
    }
    func setupBinders(){
        setupLoadedBinder()
        setupIsLoadingBinder()
        productViewModel.fetchImage()
        
        titleLabel.text = "Title: " + productViewModel.getTitle()
        priceLabel.text = "Price: " + productViewModel.getPrice()
        reviewLabel.text = "⭐️: " + productViewModel.getReview()
        reviewsLable.text = "Reviews: " + productViewModel.getTotalReviews()
        descriptionLable.text = productViewModel.getDescription()
        
    }
    
    //This binder will trigger after fetching online data
    private func setupLoadedBinder(){
        productViewModel.isLoaded.binds({[weak self] success in
            if success{
                self?.updateUI()
            }
            
        })
    }
    
    //This binder will trigger when loading need to change its state
    private func setupIsLoadingBinder(){
        productViewModel.isLoading.binds({[weak self] isLoading in
            self?.loadingAnimation(isLoading)
        })
    }
    
    private func loadingAnimation(_ isLoading: Bool){
        if isLoading{
            DispatchQueue.main.async {[weak self] in
                self?.indicatorView.startAnimating()
            }
        }else{
            DispatchQueue.main.async {[weak self] in
                self?.indicatorView.stopAnimating()
            }
        }
    }
    
    private func updateUI(){
        DispatchQueue.main.async {[weak self] in
            self?.productImage.image = self?.productViewModel.getImage()
            self?.indicatorView.stopAnimating()
            
        }
        
    }

    @IBAction func backButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

}
