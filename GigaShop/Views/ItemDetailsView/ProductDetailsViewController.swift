//
//  ItemDetailsViewController.swift
//  GigaShop
//
//

import UIKit

class ProductDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    // ViewModel to handle product-related data and actions
    var productViewModel = ProductViewModel()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinders()
    }
    
    // MARK: - Setup
    
    // Set up binders for observing ViewModel properties and update UI accordingly
    func setupBinders(){
        setupLoadedBinder()
        setupIsLoadingBinder()
        productViewModel.fetchImage()
        
        titleLabel.text = "Title: " + productViewModel.getTitle()
        priceLabel.text = "Price: " + productViewModel.getPrice()
        reviewLabel.text = "⭐️: " + productViewModel.getReview()
        reviewsLabel.text = "Reviews: " + productViewModel.getTotalReviews()
        descriptionLabel.text = productViewModel.getDescription()
    }
    
    // MARK: - Binder Setups
    
    // Set up observer for data loaded state
    private func setupLoadedBinder(){
        productViewModel.isLoaded.bind({[weak self] success in
            if success {
                self?.updateUI()
            }
        })
    }
    
    // Set up observer for loading state
    private func setupIsLoadingBinder(){
        productViewModel.isLoading.bind({[weak self] isLoading in
            self?.loadingAnimation(isLoading)
        })
    }
    
    // MARK: - UI Updates
    
    // Update UI when product image is loaded
    private func updateUI(){
        DispatchQueue.main.async {[weak self] in
            self?.productImage.image = self?.productViewModel.getImage()
            self?.indicatorView.stopAnimating()
        }
    }
    
    // MARK: - Loading Animation
    
    // Animate activity indicator based on loading state
    private func loadingAnimation(_ isLoading: Bool){
        if isLoading {
            DispatchQueue.main.async {[weak self] in
                self?.productImage.image = self?.productViewModel.getPlaceholder()
                self?.indicatorView.startAnimating()
            }
        } else {
            DispatchQueue.main.async {[weak self] in
                self?.indicatorView.stopAnimating()
            }
        }
    }
    
    // MARK: - Actions
    
    // Navigate back to previous screen
    @IBAction func backButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func openBrowser(_ sender: UIButton) {
        productViewModel.tryingToOpenBrowser()
    }
    @IBAction func copyLink(_ sender: UIButton) {
        productViewModel.copyToClipboard()
    }
}
