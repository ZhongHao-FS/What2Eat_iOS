//
//  SignUpViewController.swift
//  What2Eat_iOS
//
//  Created by Hao Zhong on 3/22/22.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import PhotosUI

class SignUpViewController: UIViewController, PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        guard !results.isEmpty else {
            dismiss(animated: true)
            return
        }
        dismiss(animated: true)
        let item = results.first?.itemProvider
        if let provider = item, provider.canLoadObject(ofClass: UIImage.self) {
            provider.loadObject(ofClass: UIImage.self) { image, error in
                if let pickedImage = image as? UIImage, let data = pickedImage.jpegData(compressionQuality: 1.0) {
                    DispatchQueue.main.async {
                        self.profileImage.image = pickedImage
                        self.imageData = data
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var pwdInput: UITextField!
    
    var imageData = Data()
    var name = ""
    var email = ""
    var pwd = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func chooseImage(_ sender: UIButton) {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        name = Utility.validateStrInput(nameInput.text)
        email = Utility.validateStrInput(emailInput.text)
        pwd = Utility.validateStrInput(pwdInput.text)
        
        if name != "" && email.contains("@") && pwd != "" {
            Auth.auth().createUser(withEmail: email, password: pwd) { authResult, error in
                guard let user = authResult?.user, error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                
                let fileRef = Utility.createStorageReference(user.uid)
                let url = URL(fileURLWithPath: "\(fileRef.bucket)/\(fileRef.fullPath)")
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = self.name
                changeRequest.photoURL = url
                changeRequest.commitChanges { error in
                    guard error == nil else {
                        print(error!.localizedDescription)
                        return
                    }
                    
                    _ = fileRef.putData(self.imageData, metadata: nil) { metadata, error in
                        guard error == nil else {
                            print(error!.localizedDescription)
                            return
                        }
                        
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Congrats", message: "You have successfully created user \(user.displayName!)!", preferredStyle: .alert)
                            let okButton = UIAlertAction(title: "OK", style: .default) { action in
                                self.performSegue(withIdentifier: "unwindToLogin", sender: sender)
                            }
                            alert.addAction(okButton)
                            self.present(alert, animated: true)
                        }
                    }
                }
            }
        } else {
            let alert = UIAlertController(title: "Invalid Input", message: "Please type in your name, email, and password!", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okButton)
            present(alert, animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
