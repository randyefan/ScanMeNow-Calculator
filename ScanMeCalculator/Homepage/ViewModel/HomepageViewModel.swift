//
//  HomepageViewModel.swift
//  ScanMeCalculator
//
//  Created by Randy Efan Jayaputra on 27/03/23.
//

import Combine
import UIKit
import Vision

class HomepageViewModel {
    // Public Properties
    var isSaveToDatabaseStorage = CurrentValueSubject<Bool, Never>(true)
    var imageResources = CurrentValueSubject<(UIImage, UIImagePickerController.SourceType)?, Never>(nil)
    
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
        imageResources.sink { [weak self] imageResources in
            guard let imageResources = imageResources else { return }
            self?.performCaptureArithmaticByImage(image: imageResources.0, sourceType: imageResources.1)
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Recognition Text Func
    
    private func performCaptureArithmaticByImage(image: UIImage, sourceType: UIImagePickerController.SourceType) {
        lazy var textRecognitionRequest = VNRecognizeTextRequest(completionHandler: nil)
        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.usesLanguageCorrection = false
        
        guard let ciImage = CIImage(image: image) else {
            return
        }
        
        let imageRequestHandler = VNImageRequestHandler(ciImage: ciImage, orientation: sourceType == .camera ? .right : CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue))!, options: [:])
        
        do {
            try imageRequestHandler.perform([textRecognitionRequest])
            guard let results = textRecognitionRequest.results else {
                return
            }
            
            let recognizedText = results.compactMap { observation in
                observation.topCandidates(1).first?.string
            }.joined(separator: "\n")
            
            if let result = preProcessingResponse(text: recognizedText) {
                guard let input = result.0, let amount = result.1 else { return }
                
                // Handle Later
                print("input \(input)")
                print(amount)
            } else {
                // Handle Later
                print(recognizedText)
            }
        } catch {
            // Handle Later
            print("Error: \(error)")
        }
    }
    
    private func preProcessingResponse(text: String) -> (String?, Double?)? {
        let arithmeticRegex = try! NSRegularExpression(pattern: #"\b(-?\d+(\.\d+)?|\.\d+)\s*([-+*/])\s*(-?\d+(\.\d+)?|\.\d+)\b"#)
        guard let match = arithmeticRegex.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)) else {
            return nil
        }
        
        // Extract the numbers and operator from the match
        let num1Range = Range(match.range(at: 1), in: text)!
        let num2Range = Range(match.range(at: 4), in: text)!
        let operatorRange = Range(match.range(at: 3), in: text)!
        let num1 = Double(text[num1Range])
        let num2 = Double(text[num2Range])
        let op = text[operatorRange]
        
        // Perform the arithmetic operation
        switch op {
        case "+":
            return ("\(num1 ?? 0) \(op) \(num2 ?? 0)", (num1! + num2!))
        case "-":
            return ("\(num1 ?? 0) \(op) \(num2 ?? 0)", (num1! - num2!))
        case "*":
            return ("\(num1 ?? 0) \(op) \(num2 ?? 0)", (num1! * num2!))
        case "/":
            return ("\(num1 ?? 0) \(op) \(num2 ?? 0)", (num1! / num2!))
        default:
            return nil
        }
    }
}
