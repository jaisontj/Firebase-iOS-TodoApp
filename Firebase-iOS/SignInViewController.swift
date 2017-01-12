//
//  SignInViewController.swift
//  Firebase-iOS
//
//  Created by Jaison on 10/01/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailId: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            if let user = user {
                self.handleSignedInUser(user: user)
            }
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailId.text = ""
        password.text = ""
    }
    
    @IBAction func onSignInClicked() {
        FIRAuth.auth()?.signIn(withEmail: emailId.text!, password: password.text!, completion: { (user, error) in
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription,completion: nil)
            } else {
                self.handleSignedInUser(user: user!)
            }
        })
    }
    
    func handleSignedInUser(user: FIRUser) {
        DispatchQueue.main.async {
            let todoVCNavigationVC = self.storyboard!.instantiateViewController(withIdentifier: "HomeNavigationController") as! UINavigationController
            let todoVC = todoVCNavigationVC.topViewController as! ToDoTableViewController
            todoVC.FIREBASE_TABLENAME = "todo/\(user.uid)"
            self.present(todoVCNavigationVC, animated: true, completion: nil)
        }        
    }
    
    @IBAction func onCreateNewAccountClicked() {
        FIRAuth.auth()?.createUser(withEmail: emailId.text!, password: password.text!, completion: { (user, error) in
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription,completion: nil)
            } else {
                self.handleSignedInUser(user: user!)
            }
        })
    }
    
    
}
