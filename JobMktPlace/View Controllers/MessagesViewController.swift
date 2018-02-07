//
//  MessagesViewController.swift
//  JobMktPlace
//
//  Created by Alex Paul on 2/4/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import UIKit
import Firebase

class MessagesViewController: UIViewController {
    
    enum SegmentIndex: Int {
        case SentMessage
        case ReceivedMessage
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    private var messages = [Message]()
    private var filteredMessages = [Message]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var isReceivedSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        observeMessages()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Messages"
    }
    
    public static func storyboardInstance() -> MessagesViewController {
        let storyboard = UIStoryboard(name: "Messages", bundle: nil)
        let messagesViewController = storyboard.instantiateViewController(withIdentifier: "MessagesViewController") as! MessagesViewController
        return messagesViewController
    }
    
    private func observeMessages() {
        DBService.manager.getMessages().observe(.value) { (snapshot) in
            var messages = [Message]()
            for child in snapshot.children {
                let dataSnapshot = child as! DataSnapshot
                if let dict = dataSnapshot.value as? [String: Any] {
                    let message = Message.init(messageDict: dict)
                    messages.append(message)
                }
            }
            self.messages = messages.sorted{ $0.dateCreated > $1.dateCreated }
            self.filteredMessages = messages.filter{ $0.senderId == AuthUserService.getCurrentUser()?.uid }
                                    .sorted{ $0.dateCreated > $1.dateCreated }

        }
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == SegmentIndex.SentMessage.rawValue {
            isReceivedSelected = false
            filteredMessages = messages.filter{ $0.senderId == AuthUserService.getCurrentUser()?.uid }
        } else {
            isReceivedSelected = true
            filteredMessages = messages.filter{ $0.recipientId == AuthUserService.getCurrentUser()?.uid }
        }
    }
    
}

extension MessagesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMessages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        let message = filteredMessages[indexPath.row]
        cell.textLabel?.text = message.messageTitle
        cell.detailTextLabel?.text = message.messageBody
        return cell
    }
}
