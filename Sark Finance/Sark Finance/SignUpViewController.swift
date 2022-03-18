//
//  SignUpViewController.swift
//  Sark Finance
//
//  Created by Kevin on 3/17/22.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onCancel(_ sender: Any) {
        //testing code
        self.dismiss(animated: true, completion: nil)
        print("clicked cancel")
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        //testing code
        let user = PFUser();
        user.username = usernameField.text
        user.password = passwordField.text
        user["name"] = nameField.text
        user["age"] = ageField.text
        user["email"] = emailField.text
        
        user.signUpInBackground { (success, error) in
            if success {
                self.performSegue(withIdentifier: "signUpCompleteSegue", sender: nil)
            }
            else {
                print("Error: \(error)")
            }
            
        }
        print("clicked sign up")
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
