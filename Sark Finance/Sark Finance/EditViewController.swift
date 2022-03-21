//
//  EditViewController.swift
//  Sark Finance
//
//  Created by Alan Kuo on 3/21/22.
//

import UIKit
import Parse

class EditViewController: UIViewController, UITextFieldDelegate {
    
    var ticker = ""
    var sharesHeld = ""
    var brokerage = ""
    var investment = PFObject(className: "investments")
    
    
    @IBOutlet weak var tickerField: UITextField!
    @IBOutlet weak var numSharesField: UITextField!
    @IBOutlet weak var brokerageField: UITextField!
    
    override func viewDidLoad() {
        numSharesField.delegate = self
        super.viewDidLoad()
        print(investment)
        tickerField.text = investment["ticker"] as! String
        numSharesField.text = investment["numShares"] as! String
        brokerageField.text = investment["brokerage"] as! String

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
    
    // Function called when submit button is pressed. Updates investment object parameters in the database
    @IBAction func onSubmit(_ sender: Any) {
        investment["ticker"] = tickerField.text
        investment["numShares"] = numSharesField.text
        investment["brokerage"] = brokerageField.text
        
        // Use blocking save function, then notify table view to refresh
        do {
            try investment.save()
        }
        catch {
            print("Failed to save investment!")
        }
        NotificationCenter.default.post(name: NSNotification.Name("refresh"), object: nil)
        // Dismiss after investment object is updated
        self.dismiss(animated: true, completion: nil)
    }
    
    // Function called when cancel button is pressed. Dismisses current view
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
