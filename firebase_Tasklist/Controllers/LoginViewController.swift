//
//  ViewController.swift
//  firebase_Tasklist
//
//  Created by Igor on 31.07.2023.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet var warningLabel: UILabel!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    
    //MARK: - Properties
    private let segueID = "taskSegue"
    private var ref: DatabaseReference! = nil
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference(withPath: "users")
        warningLabel.alpha = 0
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            if user != nil {
                self?.performSegue(withIdentifier: (self?.segueID)!, sender: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTF.text = ""
        passwordTF.text = ""
    }
    
    //MARK: - IBActions
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let email = emailTF.text, let password = passwordTF.text, email != "", password != "" else {
            displayWarning(withText: "Incorrect data")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            if error != nil {
                self?.displayWarning(withText: "Error occured")
                return
            }
            if user != nil {
                self?.performSegue(withIdentifier: (self?.segueID)!, sender: nil)
                return
            }
            self?.displayWarning(withText: "No such user")
        }
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        guard let email = emailTF.text, let password = passwordTF.text, email != "", password != ""
        else {
            displayWarning(withText: "Incorrect data")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            guard error == nil, user != nil else {
                print(error?.localizedDescription as Any)
                return
            }
            let userRef = self?.ref.child((user?.user.uid)!)
            userRef?.setValue(["email": user?.user.email])
        }
    }
    
    //MARK: - functions
    func displayWarning(withText text: String) {
        warningLabel.text = text
        UIView.animate(
            withDuration: 3,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseInOut,
            animations: { [weak self] in
                self?.warningLabel.alpha = 1
            }
        ) { [weak self] complete in
            self?.warningLabel.alpha = 0
        }
    }
}

