//
//  Extension-UIViewController.swift
//  Firebase-iOS
//
//  Created by Jaison on 11/01/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String?, message: String?, completion: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: completion))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert(message: String = "Something went wrong",completion: ((UIAlertAction) -> Void)?) {
        showAlert(title: "Error", message: message, completion: completion)
    }
    
}
