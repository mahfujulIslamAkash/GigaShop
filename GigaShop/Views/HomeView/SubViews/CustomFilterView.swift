//
//  CustomFilterView.swift
//  GigaShop
//

import Foundation
import UIKit

class CustomFilterView: UIView {
    
    // MARK: - Properties
    
    var delegate: FilterDelegate?
    
    // Stack view to organize UI components vertically for sorting and price range filtering
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
    
    // Stack view to organize sorting options horizontally
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
    
    // Button to select sorting criteria
    lazy var sortedByButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sorted By", for: .normal)
        button.tintColor = .white
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 8
        button.showsMenuAsPrimaryAction = true
        
        // Creating sorting options menu
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
    
    // Label to display the currently selected sorting criteria
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
    
    // Stack view to organize price range slider and its label horizontally
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
    
    // Slider to select price range
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
    
    // Label to display the value of the price range selected by the slider
    lazy var sliderValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = Int(slider.value).asString()
        return label
    }()
    
    // List of sorting options
    private var sortingItemList: [SortType] = [
        .lowPrice,
        .highPrice,
        .lowRating,
        .highRating,
        .lowReviews,
        .highReviews,
    ]
    
    var motherSize: CGSize = .zero
    
    // MARK: - Initializers
    
    init(motherSize: CGSize){
        super.init(frame: .zero)
        self.motherSize = motherSize
        setupUI(motherSize: motherSize)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    // Set up UI components and constraints
    func setupUI(motherSize: CGSize){
        addSubview(filterStack)
        filterStack.anchorView(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 8, paddingRight: 8)
        filterStack.heightAnchor.constraint(equalToConstant: motherSize.height).isActive = true
    }
    
    // MARK: - Slider Actions
    
    // Action when slider value changes
    @objc func sliderValueChanged(_ sender: UISlider) {
        sliderValueLabel.text = Int(sender.value).asString()
    }
    
    // Action when slider interaction ends
    @objc func sliderEndWith(_ sender: UISlider){
        delegate?.priceRangeFilter(price: Double(sender.value))
    }
}
