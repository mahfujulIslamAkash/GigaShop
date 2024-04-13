//
//  CustomFilterView.swift
//  GigaShop
//

import Foundation
import UIKit

class CustomFilterView: UIView{
    
    lazy var statckView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.spacing = 5
        stack.addArrangedSubview(priceFilter)
        stack.addArrangedSubview(reviewFilter)
        stack.addArrangedSubview(reviewCountFilter)
        stack.layer.borderWidth = 0.5
        stack.layer.cornerRadius = 8
        stack.layer.masksToBounds = true
        stack.backgroundColor = .black
        return stack
    }()
    
    lazy var priceFilter: UIButton = {
        let button = UIButton()
        button.setTitle("   Price", for: .normal)
        
        if priceUp{
            button.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        }else{
            button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        }
        
        button.tintColor = .white
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(togglePrice), for: .touchDown)
        return button
    }()
    
    lazy var reviewFilter: UIButton = {
        let button = UIButton()
        button.setTitle("   Review", for: .normal)
        button.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        button.tintColor = .white
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(toggleReview), for: .touchDown)
        return button
    }()
    
    lazy var reviewCountFilter: UIButton = {
        let button = UIButton()
        button.setTitle("   Review Count", for: .normal)
        button.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        button.tintColor = .white
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(toggleReviewCount), for: .touchDown)
        return button
    }()
    
    
    var motherSize: CGSize = .zero
    
    var priceUp = true
    var reviewUp = true
    var reviewCountUp = true
    
    init(motherSize: CGSize){
        super.init(frame: .zero)
        self.motherSize = motherSize
        setupUI(motherSize: motherSize)
        
    }
    
    func setupUI(motherSize: CGSize){
        
        addSubview(statckView)
        statckView.anchorView(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 8, paddingRight: 8)
        statckView.heightAnchor.constraint(equalToConstant: motherSize.height).isActive = true
        
    }
    
    @objc func togglePrice(){
        priceUp.toggle()
        if priceUp{
            priceFilter.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        }else{
            priceFilter.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        }
    }
    @objc func toggleReview(){
        reviewUp.toggle()
        if reviewUp{
            reviewFilter.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        }else{
            reviewFilter.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        }
    }
    @objc func toggleReviewCount(){
        reviewCountUp.toggle()
        if reviewCountUp{
            reviewCountFilter.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        }else{
            reviewCountFilter.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
