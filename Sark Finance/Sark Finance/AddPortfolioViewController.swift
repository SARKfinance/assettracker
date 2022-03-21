//
//  AddPortfolioViewController.swift
//  Sark Finance
//
//  Created by Alan Kuo on 3/20/22.
//

import UIKit
import Parse

class AddPortfolioViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tickerName: UITextField!
    @IBOutlet weak var numShares: UITextField!
    @IBOutlet weak var brokerageName: UITextField!
    
    override func viewDidLoad() {
        numShares.delegate = self
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // Restrict input to decimal and integer values for number of shares
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let isNumber = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string))
        let withDecimal = (
            string == NumberFormatter().decimalSeparator &&
            textField.text?.contains(string) == false
        )
        return isNumber || withDecimal
    }
    
    // Function called when submit button is pressed. Saves new investment object
    @IBAction func onSubmit(_ sender: Any) {
        let investment = PFObject(className:"investments")
        investment["ticker"] = self.tickerName.text
        investment["numShares"] = self.numShares.text
        investment["brokerage"] = self.brokerageName.text
        investment["owner"] = PFUser.current()!
        
        investment.saveInBackground { (success, error) in
            if success {
                // Print success message to console and go back to previous view controller
                print("Investment saved")
                self.navigationController?.popViewController(animated: false)
            }
            else {
                print("Error: \(error)")
            }
        }
    }
    
    // Called when cancel button is pressed. Dismisses current view
    @IBAction func onCancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
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
