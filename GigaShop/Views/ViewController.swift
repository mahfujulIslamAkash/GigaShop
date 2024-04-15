//
//  ViewController.swift
//  GigaShop
//
//  Created by Appnap Mahfuj on 15/4/24.
//
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var popUpButton: UIButton! // Connect this to your pop-up button in Interface Builder

    let options = ["Option 1", "Option 2", "Option 3"] // Define your options

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the pop-up button
        popUpButton.layer.borderWidth = 1
        popUpButton.layer.borderColor = UIColor.gray.cgColor
        popUpButton.layer.cornerRadius = 5

        // Set the items for the pop-up button
        var elements: [UIMenuElement] = []
        for option in options {
            let action = UIAction(title: option, handler: { [weak self] _ in
                self?.popUpButton.setTitle(option, for: .normal)
            })
            elements.append(action)
            
            
        }
        popUpButton.menu = UIMenu(title: "", children: elements)
    }

//    @IBAction func popUpButtonTapped(_ sender: UIButton) {
//        // Implement what happens when the pop-up button is tapped
//        // For example, you could show a UIAlertController to display the selected option
//        let alertController = UIAlertController(title: "Selected Option", message: "You selected \(sender.title(for: .normal) ?? "")", preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        present(alertController, animated: true, completion: nil)
//    }
}

//extension UIButton {
//    func addOption(option: String) {
//        let action = UIAction(title: option, handler: { [weak self] _ in
//            self?.setTitle(option, for: .normal)
//        })
//        menu = UIMenu(title: "", children: [action])
//    }
//}
