//
//  HomepageViewController.swift
//  ScanMeCalculator
//
//  Created by Randy Efan Jayaputra on 27/03/23.
//

import UIKit

class HomepageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavbar()
    }
    
    private func setupNavbar() {
        title = "Scan Me! Calculator"
        
        navigationController?.navigationBar.isHidden = false
    }
    
    
}
