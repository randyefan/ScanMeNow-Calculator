//
//  HomepageViewModel.swift
//  ScanMeCalculator
//
//  Created by Randy Efan Jayaputra on 27/03/23.
//

import Combine
import UIKit

class HomepageViewModel {
    // Public Properties
    var imageResources = CurrentValueSubject<UIImage?, Never>(nil)
    
    // Private Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    init() {
        setupObserver()
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
    
    // MARK: - Private Function
    
    private func setupObserver() {
        imageResources.sink { [weak self] image in
            guard let image = image else { return }
            self?.performCaptureArithmaticByImage(with: image)
        }
        .store(in: &cancellables)
    }
    
    private func performCaptureArithmaticByImage(with image: UIImage) {
        
    }
}
