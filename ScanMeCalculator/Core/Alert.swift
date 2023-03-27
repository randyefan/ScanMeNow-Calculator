//
//  Alert.swift
//  ScanMeCalculator
//
//  Created by Randy Efan Jayaputra on 27/03/23.
//

import UIKit



class Alert {
    class func showBasic(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
    }
}
