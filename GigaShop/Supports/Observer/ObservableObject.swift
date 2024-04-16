//
//  ObservableObject.swift
//  GigaShop
//
//

import Foundation

/// A generic class representing an observable object.
final class ObservableObject<T> {
    /// The current value of the observable object.
    var value: T {
        didSet {
            // Notify the listener when the value changes.
            listener?(value)
        }
    }
    
    /// A closure to be called when the value changes.
    private var listener: ((T) -> Void)?
    
    /// Initializes the observable object with an initial value.
    ///
    /// - Parameter value: The initial value.
    init(_ value: T) {
        self.value = value
    }
    
    /// Binds a closure to the observable object.
    ///
    /// - Parameter listener: A closure that will be called whenever the value changes.
    func bind(_ listener: @escaping (T) -> Void) {
        // Call the listener immediately with the current value.
        listener(value)
        // Store the listener closure.
        self.listener = listener
    }
}
