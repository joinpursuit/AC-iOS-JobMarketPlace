//
//  DetailViewController.swift
//  JobMktPlace
//
//  Created by Alex Paul on 2/4/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {
    
    
    @IBOutlet weak var titleCell: UITableViewCell!
    @IBOutlet weak var descriptionCell: UITableViewCell!
    @IBOutlet weak var imageCell: UITableViewCell!
    @IBOutlet weak var jobCreatorCell: UITableViewCell!
    @IBOutlet weak var contractorCell: UITableViewCell!
    @IBOutlet weak var isScheduledCell: UITableViewCell!
    @IBOutlet weak var isCompleteCell: UITableViewCell!
    
    @IBOutlet weak var isScheduledSwitch: UISwitch!
    @IBOutlet weak var isCompleteSwitch: UISwitch!
    
    @IBOutlet weak var jobImage: UIImageView!
    
    public var job: Job!
    public var image: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        configureDetailView()
        
        // business rules
        // creator can't schedule job
        // only creator can mark a job complete
        if job.userId == AuthUserService.getCurrentUser()?.uid {
            isScheduledSwitch.isEnabled = false
            isCompleteSwitch.isEnabled = true
            jobCreatorCell.textLabel?.text = "@me"
        } else {
            isScheduledSwitch.isEnabled = true
            isCompleteSwitch.isEnabled = false
            jobCreatorCell.textLabel?.text = "@\(job.creator)"
            jobCreatorCell.textLabel?.textColor = .blue
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        isScheduledSwitch.isOn = job.isScheduled
        isCompleteSwitch.isOn = job.isComplete
    }
    
    private func configureDetailView() {
        titleCell.textLabel?.text = job.title
        descriptionCell.textLabel?.text = job.description
        jobImage.contentMode = .scaleAspectFill
        jobImage.image = image
        descriptionCell.textLabel?.numberOfLines = 0
        if job.contractorId == AuthUserService.getCurrentUser()?.uid {
            contractorCell.textLabel?.text = "@me"
        } else {
            if !job.contractor.isEmpty { contractorCell.textLabel?.text = "@\(job.contractor)" }
            else { contractorCell.textLabel?.text = "not yet assigned" }
        }
    }
    
    public static func storyboardInstance() -> DetailViewController {
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        return detailViewController
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { alert in }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension DetailViewController {
    @IBAction private func isScheduledSwitchChanged(sender: UISwitch) {
        DBService.manager.updateJobSchedule(job: job, isScheduled: sender.isOn)
    }
    @IBAction private func isCompleteSwitchChanged(sender: UISwitch) {
        DBService.manager.markComplete(job: job, isComplete: sender.isOn)
    }
}

extension DetailViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if cell == jobCreatorCell {
            if job.userId == AuthUserService.getCurrentUser()?.uid { print("can't send message to self"); return }
            DBService.manager.sendMessage(messageTitle: "\(job.title)", messageBody: "@\(job.contractor) has completed your task, you can now mark it complete", recipientId: job.userId, jobId: job.jobId)
            showAlert(title: "Message Sent to @\(job.creator)", message: "")
        }
    }
}



