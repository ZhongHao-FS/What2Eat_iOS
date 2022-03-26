//
//  ViewController.swift
//  What2Eat_iOS
//
//  Created by Hao Zhong on 3/21/22.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var pwdInput: UITextField!
    
    var handle: AuthStateDidChangeListenerHandle?
    var email = ""
    var pwd = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            self.performSegue(withIdentifier: "signIn", sender: user)
            }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        email = Utility.validateStrInput(emailInput.text)
        pwd = Utility.validateStrInput(pwdInput.text)
        
        if email.contains("@") && pwd != "" {
            Auth.auth().signIn(withEmail: email, password: pwd) { authResult, error in
                if error != nil {
                    print(error!.localizedDescription)
                }
            }
        } else {
            let alert = UIAlertController(title: "Incorrect Email/Password", message: "Please try again!", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okButton)
            present(alert, animated: true)
        }
    }
    
    @IBAction func unwindToRoot(_ unwindSegue: UIStoryboardSegue) {
        
    }
}

