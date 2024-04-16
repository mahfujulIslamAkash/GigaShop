//
//  ViewController.swift
//  GigaShop
//
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - UI Components
    
    // Search field for user input
    lazy var customSearchField: CustomSearchField = {
        let field = CustomSearchField(motherSize: CGSize(width: view.frame.width, height: 65))
        field.textFieldView.delegate = self
        field.seachButton.addTarget(self, action: #selector(searchTapped), for: .touchDown)
        return field
    }()
    
    // View for applying filters
    lazy var customFilterView: CustomFilterView = {
        let field = CustomFilterView(motherSize: CGSize(width: view.frame.width, height: 80))
        field.delegate = self
        return field
    }()
    
    // Collection view to display search results
    lazy var itemCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .black
        view.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    // Activity indicator to show loading state
    let indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.transform = view.transform.scaledBy(x: 10, y: 10)
        view.tintColor = .white
        return view
    }()
    
    // Stack view to organize UI components
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 15
        stack.addArrangedSubview(customSearchField)
        stack.addArrangedSubview(customFilterView)
        stack.addArrangedSubview(itemCollectionView)
        stack.layer.borderWidth = 0.5
        stack.addSubview(indicatorView)
        indicatorView.centerX(inView: stack)
        indicatorView.centerY(inView: stack)
        return stack
    }()
    
    // MARK: - View Model
    
    let homeViewModel = HomeViewModel(nil)
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(stackView)
        
        stackView.anchorView(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, paddingTop: 60)
        setupObservers()
    }
    
    // MARK: - Setup Binders
    
    // Set up observers for view model properties
    private func setupObservers() {
        setupLoadedObserver()
        setupIsLoadingObserver()
        setupErrorObserver()
    }
    
    // Set up observer for data loaded state
    private func setupLoadedObserver() {
        homeViewModel.isLoaded.binds({[weak self] success in
            if let _ = success {
                DispatchQueue.main.async {
                    self?.itemCollectionView.reloadData()
                }
            }
        })
    }
    
    // Set up observer for loading state
    private func setupIsLoadingObserver() {
        homeViewModel.isLoading.binds({[weak self] isLoading in
            self?.loadingAnimation(isLoading)
        })
    }
    
    // Set up observer for error state
    private func setupErrorObserver() {
        homeViewModel.error.binds({[weak self] error in
            if let _ = error {
                self?.loadingAnimation(false)
                self?.homeViewModel.showingErrorToast()
            }
        })
    }
    
    // MARK: - Loading View
    
    // Handle loading animation
    private func loadingAnimation(_ isLoading: Bool) {
        if isLoading {
            DispatchQueue.main.async {[weak self] in
                self?.itemCollectionView.layer.opacity = 0
                self?.indicatorView.startAnimating()
            }
        } else {
            DispatchQueue.main.async {[weak self] in
                self?.itemCollectionView.layer.opacity = 1
                self?.indicatorView.stopAnimating()
            }
        }
    }
    
    // MARK: - Search Tap Action
    
    // Action when search button is tapped
    @objc func searchTapped() {
        let _ = homeViewModel.SearchAction(customSearchField.textFieldView)
    }
}

// MARK: - CollectionView Delegate

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // Number of items in collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel.countOfItemResults()
    }
    
    // Cell for item at index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return homeViewModel.getCell(collectionView, indexPath)
    }
    
    // Size for item at index path
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return homeViewModel.sizeOfCell(collectionView.frame.width)
    }
    
    // Action when item is selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "itemVC") as! ProductDetailsViewController
        vc.productViewModel = homeViewModel.viewModelOfItem(indexPath)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Text Field Delegate

extension HomeViewController: UITextFieldDelegate {
    // Action when return key is pressed in text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return homeViewModel.SearchAction(customSearchField.textFieldView)
    }
}

// MARK: - Filter Delegate

extension HomeViewController: FilterDelegate {
    // Action when sorting by a specific criteria
    func sortedBy(sortedBy: SortType) {
        homeViewModel.sortedBy(sortedBy: sortedBy)
    }
    
    // Action when filtering by price range
    func priceRangeFilter(price: Double) {
        homeViewModel.priceRangeFilter(price)
    }
}
