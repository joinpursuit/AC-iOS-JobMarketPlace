//
//  HistoryViewController.swift
//  JobMktPlace
//
//  Created by Alex Paul on 2/5/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//
//  Shows completed Jobs

import UIKit
import Firebase

class HistoryViewController: UIViewController {
    
    enum SegmentIndex: Int {
        case JobPosts
        case ScheduledJobs
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    private var jobsArchive = [Job]()
    private var filteredArchive = [Job]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var isScheduledJobsArchive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        observeHistory()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "History"
    }
    
    private func observeHistory() {
        DBService.manager.getJobs().observe(.value) { (snapshot) in
            var jobs = [Job]()
            for child in snapshot.children {
                let dataSnapshot = child as! DataSnapshot
                if let dict = dataSnapshot.value as? [String: Any] {
                    let job = Job.init(jobDict: dict)
                    jobs.append(job)
                }
            }
            self.jobsArchive = jobs
            
            self.segmentedControl.selectedSegmentIndex = SegmentIndex.JobPosts.rawValue
            self.segmentedControlChanged(self.segmentedControl)
            /*self.filteredArchive = jobs.filter{$0.isComplete == true }
                                    .filter{ $0.userId == AuthUserService.getCurrentUser()?.uid }
                                    .sorted{ $0.dateCreated > $1.dateCreated }*/
        }
    }

    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == SegmentIndex.JobPosts.rawValue {
            isScheduledJobsArchive = false
            self.filteredArchive = jobsArchive.filter{$0.isComplete == true }
                .filter{ $0.userId == AuthUserService.getCurrentUser()?.uid }
                .sorted{ $0.dateCreated > $1.dateCreated }
        } else {
            isScheduledJobsArchive = true
            self.filteredArchive = jobsArchive.filter{$0.isComplete == true }
                .filter{ $0.contractorId == AuthUserService.getCurrentUser()?.uid }
                .sorted{ $0.dateCreated > $1.dateCreated }
        }
    }
    
}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArchive.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        let job = filteredArchive[indexPath.row]
        cell.textLabel?.text = job.title
        cell.detailTextLabel?.text = "@\(job.contractor) completed this task"
        return cell
    }
}
