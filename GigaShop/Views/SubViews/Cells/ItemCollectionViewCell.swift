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
        
        return view
    }()
    
    var gifViewModel = ItemViewModel()
    
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
        gifViewModel.fetchGifImage()
    }
    
    //This binder will trigger after fetching online data
    private func setupLoadedBinder(){
        gifViewModel.isLoaded.binds({[weak self] success in
            if success{
                self?.updateUI()
            }
            
        })
    }
    
    //This binder will trigger when loading need to change its state
    private func setupIsLoadingBinder(){
        gifViewModel.isLoading.binds({[weak self] isLoading in
            self?.loadingAnimation(isLoading)
        })
    }
    
    private func updateUI(){
        DispatchQueue.main.async {[weak self] in
            self?.gifView.image = self?.gifViewModel.getGifImage()
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
