//
//  ChatViewController.swift
//  ParseChat
//
//  Created by Brendan Raftery on 2/5/18.
//  Copyright © 2018 Brendan Raftery. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    var messages: [PFObject] = []
    var refreshController: UIRefreshControl!
    
    func updateMessages() {
        let query = PFQuery(className: "Message")
        query.includeKey("user")
        query.addDescendingOrder("createdAt")
        
        // fetch data asynchronously
        query.findObjectsInBackground { (messages: [PFObject]?, error: Error?) in
            if error != nil {
                print("Error: \(error?.localizedDescription ?? "")")
            } else {
                self.messages = messages!
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        //query.addDescendingOrder("createdAt")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = .none
        
        tableView.reloadData()
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
        refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshController, at: 0)
    }
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        // Reload the list of messages
        updateMessages()
        
        // Reload the tableView now that there is new data
        tableView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            // Stop the refresh controller
            self.refreshController.endRefreshing()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        updateMessages()
        tableView.reloadData()
    }
    
    @objc func onTimer() {
        updateMessages()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendButtonPushed(_ sender: Any) {
        self.messageField.resignFirstResponder()
        let chatMessage = PFObject(className: "Message")
        chatMessage["user"] = PFUser.current()
        chatMessage["text"] = messageField.text ?? ""
        
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
                self.messageField.text = ""
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
        updateMessages()
        print(messages)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatCell
        
        cell.messageField.text = messages[indexPath.row]["text"] as! String?
        if let user = messages[indexPath.row]["user"] as? PFUser {
            cell.nameField.text = user.username
        } else {
            cell.nameField.text = "Anonymous"
        }
        
        return cell
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
