//
//  CustomFilterView.swift
//  GigaShop
//

import Foundation
import UIKit

protocol PriceDelegate{
    func priceRangeFilter(price: Double)
    func sortedBy(sortedBy: SortType)
}

class CustomFilterView: UIView{
    
    var delegate: PriceDelegate?
    
    lazy var filterStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 5
        stack.addArrangedSubview(sortStack)
        stack.addArrangedSubview(sliderStatckView)
        stack.layer.borderWidth = 0.5
        stack.layer.cornerRadius = 8
        stack.layer.masksToBounds = true
        stack.backgroundColor = .black
        return stack
    }()
    
    lazy var sortStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 5
        stack.addArrangedSubview(sortedByButton)
        stack.addArrangedSubview(sortedByLabel)
        stack.layer.borderWidth = 0.5
        stack.layer.cornerRadius = 8
        stack.layer.masksToBounds = true
        stack.backgroundColor = .black
        return stack
    }()
    
    lazy var sortedByButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sorted By", for: .normal)
        button.tintColor = .white
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 8
        button.showsMenuAsPrimaryAction = true
        
        var elements: [UIMenuElement] = []
        for sortedBy in self.sortingItemList {
            let action = UIAction(title: sortedBy.description, handler: { [weak self] value in
                self?.sortedByLabel.text = sortedBy.description
                self?.delegate?.sortedBy(sortedBy: sortedBy)
            })
            elements.append(action)
            
            
        }
        button.menu = UIMenu(title: "Sorted by", children: elements)
        return button
    }()
    
    lazy var sortedByLabel: UILabel = {
        let label = UILabel()
        label.text = "Low Price"
        label.textColor = .white
        label.textAlignment = .center
        label.layer.borderWidth = 1.5
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.cornerRadius = 8
        return label
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
        slider.maximumValue = 100000
        slider.minimumValue = 0
        slider.value = slider.maximumValue
        slider.tintColor = .white
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderEndWith), for: [.touchUpInside, .touchUpOutside])
        return slider
    }()
    
    lazy var sliderValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = Int(slider.value).asString()
        return label
    }()
    
    private var sortingItemList: [SortType] = [
        .lowPrice,
        .highPrice,
        .lowRating,
        .highRating,
        .lowReviews,
        .highReviews,
    ]
    
    
    var motherSize: CGSize = .zero
    
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
    
    @objc func sliderEndWith(_ sender: UISlider){
        delegate?.priceRangeFilter(price: Double(sender.value))
        
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        sliderValueLabel.text = Int(sender.value).asString()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

