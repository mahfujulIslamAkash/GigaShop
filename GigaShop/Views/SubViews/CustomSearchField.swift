//
//  CustomSearchField.swift
//  GigaShop
//


import UIKit

class CustomSearchField: UIView {
    
    var searchText: String?
    lazy var statckView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.spacing = 5
        stack.addArrangedSubview(fieldIcon)
        stack.addArrangedSubview(textField)
        stack.addArrangedSubview(seachButton)
        stack.layer.borderWidth = 0.5
        stack.backgroundColor = .white
        stack.layer.cornerRadius = 4
        stack.layer.masksToBounds = true
        return stack
    }()
    
    lazy var fieldIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "shippingbox")?.withAlignmentRectInsets(UIEdgeInsets(top: -12, left: -12, bottom: -12, right: -12))
        view.widthAnchor.constraint(equalToConstant: motherSize.height).isActive = true
        view.backgroundColor = .black
        view.tintColor = .white
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        
        return view
    }()
    
    
    
    lazy var textField: UIView = {
        let view = UIView()
        view.addSubview(textFieldView)
        textFieldView.anchorView(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5)
        return view
    }()
    
    lazy var textFieldView: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder  = NSAttributedString(
            string: "Search Gif",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.3)]
        )
        textField.textColor = .black.withAlphaComponent(0.5)
        return textField
    }()
    
    lazy var seachButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        view.tintColor = .white
        view.widthAnchor.constraint(equalToConstant: motherSize.height).isActive = true
        view.backgroundColor = UIColor(hexString: "FF2DAF")
        return view
    }()
    
    var motherSize: CGSize = .zero
    
    init(motherSize: CGSize){
        super.init(frame: .zero)
        self.motherSize = motherSize
        setupUI(motherSize: motherSize)
        
    }
    
    func setupUI(motherSize: CGSize){
        addSubview(statckView)
        statckView.anchorView(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        heightAnchor.constraint(equalToConstant: motherSize.height).isActive = true
        widthAnchor.constraint(equalToConstant: motherSize.width).isActive = true
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

