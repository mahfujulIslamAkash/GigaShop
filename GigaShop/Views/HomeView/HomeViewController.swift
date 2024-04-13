//
//  ViewController.swift
//  GigaShop
//
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: UI Component
    lazy var customSearchField: CustomSearchField = {
        let field = CustomSearchField(motherSize: CGSize(width: view.frame.width, height: 65))
        field.textFieldView.delegate = self
        field.seachButton.addTarget(self, action: #selector(searchTapped), for: .touchDown)
        return field
    }()
    
    lazy var customFilterView: CustomFilterView = {
        let field = CustomFilterView(motherSize: CGSize(width: view.frame.width, height: 65))
        field.priceFilter.addTarget(self, action: #selector(priceTapped), for: .touchDown)
        field.reviewFilter.addTarget(self, action: #selector(reviewTapped), for: .touchDown)
        field.reviewCountFilter.addTarget(self, action: #selector(reviewCountTapped), for: .touchDown)
        return field
    }()
    
    lazy var ItemCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .black
        view.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        view.showsVerticalScrollIndicator = false
        view.addSubview(indicatorView)
        indicatorView.centerX(inView: view)
        indicatorView.centerY(inView: view)
        return view
        
    }()
    let indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.transform = view.transform.scaledBy(x: 10, y: 10)
        view.tintColor = .white
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 15
        stack.addArrangedSubview(customSearchField)
        stack.addArrangedSubview(customFilterView)
        stack.addArrangedSubview(ItemCollectionView)
        stack.layer.borderWidth = 0.5
        return stack
    }()
    
    //MARK: View Model
    let homeViewModel = HomeViewModel(nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(stackView)
        stackView.anchorView(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, paddingTop: 60)
        setupObservers()
        
    }
    
    //MARK: Setup Binders
    private func setupObservers(){
        setupLoadedObserver()
        setupIsLoadingObserver()
        setupErrorObserver()
    }
    
    //This binder will trigger after fetching online data
    private func setupLoadedObserver(){
        homeViewModel.isLoaded.binds({[weak self] success in
            if let _ = success{
                //reload view
                //here we will reload collectionView
                DispatchQueue.main.async {
                    self?.ItemCollectionView.reloadData()
                }
            }
        })
    }
    
    //This binder will trigger when loading need to change its state
    private func setupIsLoadingObserver(){
        homeViewModel.isLoading.binds({[weak self] isLoading in
            self?.loadingAnimation(isLoading)
        })
    }
    
    //This binder will trigger after fetching online data
    private func setupErrorObserver(){
        homeViewModel.error.binds({[weak self] error in
            if let _ = error{
                //error handle
                self?.loadingAnimation(false)
                self?.homeViewModel.showingErrorToast()
            }
        })
    }
    
    
    //MARK: Loading View
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
    
    //MARK: Search Tap Action
    @objc func searchTapped(){
        let _ = homeViewModel.SearchAction(customSearchField.textFieldView)
    }
    
    //MARK: Filter Action
    @objc func priceTapped(){
        homeViewModel.priceFilter()
    }
    @objc func reviewTapped(){
        homeViewModel.reviewFilter()
    }
    @objc func reviewCountTapped(){
        homeViewModel.reviewCountFilter()
    }
}

//MARK: CollectionView Delegate
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel.countOfGifsResult()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return homeViewModel.getCell(collectionView, indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return homeViewModel.sizeOfCell(collectionView.frame.width)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        homeViewModel.copyToClipboard(indexPath)
    }
    
    
}

//MARK: Text Field Delegate
extension HomeViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return homeViewModel.SearchAction(customSearchField.textFieldView)
    }
}
