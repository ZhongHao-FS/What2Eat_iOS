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
    
    var email = ""
    var pwd = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        email = Utility.validateStrInput(emailInput.text)
        pwd = Utility.validateStrInput(pwdInput.text)
        
        if email.contains("@") && pwd != "" {
            Auth.auth().signIn(withEmail: email, password: pwd) { [weak self] authResult, error in
                guard let strongSelf = self, let result = authResult else {
                    self?.incorrectAlert()
                    return
                    }
                if error == nil {
                    strongSelf.performSegue(withIdentifier: "signIn", sender: sender)
                } else {
                    print(result.user.displayName!)
                    print(error!.localizedDescription)
                        strongSelf.incorrectAlert()
                }
            }
        } else {
            incorrectAlert()
        }
    }
    
    func incorrectAlert() {
        let alert = UIAlertController(title: "Please try again!", message: "Incorrect Email/Password", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    @IBAction func unwindToRoot(_ unwindSegue: UIStoryboardSegue) {
        
    }
}

