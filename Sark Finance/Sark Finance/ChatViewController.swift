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
    
    @IBAction func sendMessage(_ sender: Any) {
        let message = PFObject(className: "Message")
        message["text"] = messageField.text
        message["owner"] = PFUser.current()!
        
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
        // Load new messages every 5 seconds
        let timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(loadMessages), userInfo: nil, repeats: true)
        self.loadMessages()
        // Do any additional setup after loading the view.
    }
    
    @objc
    func loadMessages() {
        let query = PFQuery(className:"Message")
        query.includeKeys(["owner"])
        query.order(byDescending: "createdAt")
        
        query.findObjectsInBackground { (messages, error) in
            if messages != nil {
                self.messages = messages!
                self.tableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageTableViewCell", for: indexPath) as! ChatMessageTableViewCell
        let message = messages[indexPath.row]
        
        let user = message["owner"] as! PFUser
        
        if user.username == PFUser.current()?.username {
            cell.userName.textColor = UIColor.systemBlue
        }
        else {
            cell.userName.textColor = UIColor.black
        }
        
        
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
