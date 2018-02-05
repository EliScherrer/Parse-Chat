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
        //no grey lines between cells
        self.tableView.separatorStyle = .none
        // Auto size row height based on cell autolayout constraints
        tableView.rowHeight = UITableViewAutomaticDimension
        // Provide an estimated row height. Used for calculating scroll indicator
        tableView.estimatedRowHeight = 50
        
        //refresh data immediately and every 2 seconds
        onTimer()
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
        
        
    }

    
    //when the send button is clicked save the message object to the database
    @IBAction func sendClicked(_ sender: Any) {
    
        let chatMessage = PFObject(className: "Message")
        chatMessage["text"] = messageField.text ?? ""
        
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
            print(parsedbb.count)
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
        
        
        return cell
    }
    
    //code to run periodicially
    @objc func onTimer() {
        let query = PFQuery(className: "Message")
        query.addDescendingOrder("createdAt")
        
        query.findObjectsInBackground { (objects, error) in
            if let objects = objects {
                
                self.parseObjects = objects
                self.tableView.reloadData()
                
                for object in self.parseObjects! {
                    print(object["text"])
                }
            } else {
                print(error!)
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
