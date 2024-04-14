//
//  ItemDetailsViewController.swift
//  GigaShop
//
//  Created by Appnap Mahfuj on 13/4/24.
//

import UIKit

class ItemDetailsViewController: UIViewController {
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var descriptionLable: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var reviewsLable: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    var itemViewModel = ItemViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBinders()
        // Do any additional setup after loading the view.
    }
    func setupBinders(){
        setupLoadedBinder()
        setupIsLoadingBinder()
        itemViewModel.fetchGifImage()
        priceLabel.text = "Price: " + (itemViewModel.price?.asString() ?? "")
        reviewLabel.text = "⭐️: " + (itemViewModel.review?.asString() ?? "")
        reviewsLable.text = "Reviews: " + (itemViewModel.reviewCount?.asString() ?? "")
        
    }
    
    //This binder will trigger after fetching online data
    private func setupLoadedBinder(){
        itemViewModel.isLoaded.binds({[weak self] success in
            if success{
                self?.updateUI()
            }
            
        })
    }
    
    //This binder will trigger when loading need to change its state
    private func setupIsLoadingBinder(){
        itemViewModel.isLoading.binds({[weak self] isLoading in
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
            self?.productImage.image = self?.itemViewModel.getGifImage()
            self?.indicatorView.stopAnimating()
            
        }
        
    }

    @IBAction func backButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

}
