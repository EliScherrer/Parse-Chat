//
//  ChatViewController.swift
//  Parse-Chat
//
//  Created by Eli Scherrer on 2/4/18.
//  Copyright © 2018 Eli Scherrer. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageField: UITextField!
    
    var parseObjects: [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //adjust the table view
        tableView.dataSource = self
        tableView.delegate = self
        //self.tableView.separatorStyle = .none //no grey lines between cells
        // Auto size row height based on cell autolayout constraints
        tableView.rowHeight = UITableViewAutomaticDimension
        // Provide an estimated row height. Used for calculating scroll indicator
        tableView.estimatedRowHeight = 65
        
        //refresh data immediately and every 2 seconds
        onTimer()
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
        
        
    }

    
    //when the send button is clicked save the message object to the database
    @IBAction func sendClicked(_ sender: Any) {
    
        let chatMessage = PFObject(className: "Message")
        chatMessage["text"] = messageField.text ?? ""
        chatMessage["user"] = PFUser.current()
        
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
                self.messageField.text = ""
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
    
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let parsedbb = parseObjects {
            return parsedbb.count
        }
        else {
            print("parsedbb not working :(")
            return 0
        }
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        
        let object = parseObjects![indexPath.row]
        cell.messageLabel.text = object["text"] as? String
        cell.usernameLabel.text = (object["user"] as! PFUser).username
        
        return cell
    }
    
    //code to run periodicially
    @objc func onTimer() {
        let query = PFQuery(className: "Message")
        query.includeKey("user")
        query.addDescendingOrder("createdAt")
        
        query.findObjectsInBackground { (objects, error) in
            if let objects = objects {
                
                self.parseObjects = objects
                self.tableView.reloadData()
                
//                for object in self.parseObjects! {
//                    print(object)
//                }
            } else {
                print(error!)
            }
        }
    }
    
    //log the user out of parse and send them back to the login screen
    @IBAction func logoutButtonClick(_ sender: Any) {
        PFUser.logOut()
        self.performSegue(withIdentifier: "logoutSegue", sender: nil)
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
