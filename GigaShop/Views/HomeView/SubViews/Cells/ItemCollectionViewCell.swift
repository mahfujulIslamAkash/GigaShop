//
//  ItemCollectionViewCell.swift
//  GigaShop
//
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    let indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.tintColor = .white
        return view
    }()
    
    lazy var gifView: UIImageView = {
        let view = UIImageView()
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        view.addSubview(indicatorView)
        indicatorView.fillSuperview()
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        
        //
        let stack = UIStackView()
        stack.axis = .vertical
        view.addSubview(stack)
        stack.fillSuperview()
        
        stack.addArrangedSubview(priceTitle)
        stack.addArrangedSubview(reviewTitle)
        stack.addArrangedSubview(reviewCountTitle)
        
        //
        
        return view
    }()
    lazy var priceTitle: UILabel = {
        let title = UILabel()
        title.textColor = .white
        return title
    }()
    
    lazy var reviewTitle: UILabel = {
        let title = UILabel()
        title.textColor = .white
        return title
    }()
    lazy var reviewCountTitle: UILabel = {
        let title = UILabel()
        title.textColor = .white
        return title
    }()
    
    
    var itemViewModel = ItemViewModel()
    
    override init(frame: CGRect) {
        // Initialize your cell as usual
        super.init(frame: frame)
        contentView.addSubview(gifView)
        gifView.fillSuperview()
    }
    
    //MARK: Setup Binders
    func setupBinders(){
        setupLoadedBinder()
        setupIsLoadingBinder()
        itemViewModel.fetchGifImage()
        priceTitle.text = "price: " + (itemViewModel.price?.asString() ?? "")
        reviewTitle.text = "review: " + (itemViewModel.review?.asString() ?? "")
        reviewCountTitle.text = "reviews: " + (itemViewModel.reviewCount?.asString() ?? "")
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
    
    private func updateUI(){
        DispatchQueue.main.async {[weak self] in
            self?.gifView.image = self?.itemViewModel.getGifImage()
            self?.indicatorView.stopAnimating()
        }
        
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
