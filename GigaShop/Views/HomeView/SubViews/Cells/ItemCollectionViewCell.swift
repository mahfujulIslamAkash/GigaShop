//
//  ItemCollectionViewCell.swift
//  GigaShop
//
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    // Activity indicator to show loading state of the image
    let indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.tintColor = .white
        return view
    }()
    
    // Image view to display the product image
    lazy var productImage: UIImageView = {
        let view = UIImageView()
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        view.addSubview(indicatorView)
        indicatorView.fillSuperview()
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        
        // Additional setup for displaying price and review information
        let backImage = GradientShadowView()
        let stack = UIStackView()
        stack.axis = .vertical
        view.addSubview(backImage)
        backImage.addSubview(stack)
        backImage.anchorView(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 0, paddingBottom: 0)
        stack.fillSuperview(padding: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        stack.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        stack.addArrangedSubview(priceTitle)
        stack.addArrangedSubview(reviewTitle)
        stack.addArrangedSubview(reviewCountTitle)
        
        return view
    }()
    
    // Label to display the price of the product
    lazy var priceTitle: UILabel = {
        let title = UILabel()
        title.textColor = .white
        return title
    }()
    
    // Label to display the review rating of the product
    lazy var reviewTitle: UILabel = {
        let title = UILabel()
        title.textColor = .white
        return title
    }()
    
    // Label to display the total number of reviews for the product
    lazy var reviewCountTitle: UILabel = {
        let title = UILabel()
        title.textColor = .white
        return title
    }()
    
    // ViewModel to handle product-related data and actions
    var productViewModel = ProductViewModel()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(productImage)
        productImage.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    // Set up binders for observing ViewModel properties
    func setupBinders(){
        setupLoadedBinder()
        setupIsLoadingBinder()
        productViewModel.fetchImage()
        priceTitle.text = "Price: " + productViewModel.getPrice()
        reviewTitle.text = "⭐️: " + productViewModel.getReview()
        reviewCountTitle.text = "Reviews: " + productViewModel.getTotalReviews()
    }
    
    // MARK: - Binder Setups
    
    // Set up observer for data loaded state
    private func setupLoadedBinder(){
        productViewModel.isLoaded.binds({[weak self] success in
            if success{
                self?.updateUI()
            }
        })
    }
    
    // Set up observer for loading state
    private func setupIsLoadingBinder(){
        productViewModel.isLoading.binds({[weak self] isLoading in
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
}
