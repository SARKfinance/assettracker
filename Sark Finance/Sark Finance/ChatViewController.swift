//
//  chatViewController.swift
//  Sark Finance
//
//  Created by Alan Kuo on 4/1/22.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var messages = [PFObject]()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageField: UITextField!
    
    // Function for saving a new message to the database
    @IBAction func sendMessage(_ sender: Any) {
        let message = PFObject(className: "Messages")
        message["text"] = messageField.text
        message["author"] = PFUser.current()!
        
        message.saveInBackground { (success, error) in
            if success {
                print("Message saved")
                self.messageField.text = ""
                self.loadMessages()
            }
            else {
                print("Error: \(error)")
            }
        }
    }
    
    // Function for signing user out and returning to login screen
    @IBAction func signOut(_ sender: Any) {
        PFUser.logOut()
        // Show the initial log in screen after user logs out
        let main = UIStoryboard(name:"Main", bundle:nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else {return}
        delegate.window?.rootViewController = loginViewController
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Set timer to load new messages every 0.5 seconds
        let timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(loadMessages), userInfo: nil, repeats: true)
        // Load new messages on initial load
        self.loadMessages()
    }
    
    // Function for loading messages from database
    @objc
    func loadMessages() {
        let query = PFQuery(className:"Messages")
        query.includeKeys(["author"])
        query.order(byDescending: "createdAt")
        
        query.findObjectsInBackground { (messages, error) in
            if messages != nil {
                self.messages = messages!
                self.tableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Initialize reusable cells
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageTableViewCell", for: indexPath) as! ChatMessageTableViewCell
        // Find corresponding message object
        let message = messages[indexPath.row]
        
        // Get the author of the message and check if the current user posted it.
        let user = message["author"] as! PFUser
        if user.username == PFUser.current()?.username {
            cell.userName.textColor = UIColor.systemBlue
        }
        else {
            cell.userName.textColor = UIColor.black
        }
        
        // Set values for labels
        cell.userName.text = user.username
        cell.chatMessage.text = message["text"] as? String

        return cell
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
