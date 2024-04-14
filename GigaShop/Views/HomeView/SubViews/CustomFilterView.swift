//
//  CustomFilterView.swift
//  GigaShop
//

import Foundation
import UIKit

protocol PriceDelegate{
    func priceRange(price: Double)
    func tappedPrice()
    func tappedReview()
    func tappedReviewCount()
}

class CustomFilterView: UIView{
    
    var delegate: PriceDelegate?
    
    lazy var filterStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 5
        stack.addArrangedSubview(statckView)
        stack.addArrangedSubview(sliderStatckView)
        stack.layer.borderWidth = 0.5
        stack.layer.cornerRadius = 8
        stack.layer.masksToBounds = true
        stack.backgroundColor = .black
        return stack
    }()
    
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
    
    lazy var sliderStatckView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 5
        let view = UILabel()
        view.text = "Price range"
        view.textColor = .white
        stack.addArrangedSubview(view)
        stack.addArrangedSubview(slider)
        stack.addArrangedSubview(sliderValueLabel)
        stack.layer.borderWidth = 0.5
        stack.layer.cornerRadius = 8
        stack.layer.masksToBounds = true
        stack.backgroundColor = .black
        return stack
    }()
    
    lazy var slider: UISlider = {
        let slider = UISlider()
        slider.maximumValue = 1000
        slider.minimumValue = 0
        slider.value = 500
        slider.tintColor = .white
        
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderEndWith), for: [.touchUpInside, .touchUpOutside])
        return slider
    }()
    
    lazy var sliderValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "\(slider.value)"
        return label
    }()
    
    
    var motherSize: CGSize = .zero
    
    private var priceUp = true
    private var reviewUp = true
    private var reviewCountUp = true
    
    init(motherSize: CGSize){
        super.init(frame: .zero)
        self.motherSize = motherSize
        setupUI(motherSize: motherSize)
        
    }
    
    func setupUI(motherSize: CGSize){
        
        addSubview(filterStack)
        filterStack.anchorView(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 8, paddingRight: 8)
        filterStack.heightAnchor.constraint(equalToConstant: motherSize.height).isActive = true
        
    }
    
    @objc func togglePrice(){
        priceUp.toggle()
        if priceUp{
            priceFilter.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        }else{
            priceFilter.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        }
        delegate?.tappedPrice()
    }
    @objc func toggleReview(){
        reviewUp.toggle()
        if reviewUp{
            reviewFilter.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        }else{
            reviewFilter.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        }
        delegate?.tappedReview()
    }
    @objc func toggleReviewCount(){
        reviewCountUp.toggle()
        if reviewCountUp{
            reviewCountFilter.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        }else{
            reviewCountFilter.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        }
        delegate?.tappedReviewCount()
    }
    
    @objc func sliderEndWith(_ sender: UISlider){
//        sliderValueLabel.text = ((slider.value*10).rounded()/10).asString()
        delegate?.priceRange(price: Double(sender.value))
        
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        sliderValueLabel.text = ((slider.value*10).rounded()/10).asString()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
