//
//  JobsFeedViewController.swift
//  JobMktPlace
//
//  Created by Alex Paul on 2/1/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import UIKit
import Firebase

class JobsFeedViewController: UIViewController {
    
    private let jobsFeedView = JobsFeedView()

    private var authUserService = AuthUserService()
    
    private var jobs = [Job]() {
        didSet {
            DispatchQueue.main.async {
                self.jobsFeedView.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(jobsFeedView)
        jobsFeedView.collectionView.dataSource = self
        jobsFeedView.collectionView.delegate = self 
        configureNavBar()
        
        // get data from our "jobs" reference
        DBService.manager.getJobs().observe(.value) { (snapshot) in
            var jobs = [Job]()
            for child in snapshot.children {
                let dataSnapshot = child as! DataSnapshot
                if let dict = dataSnapshot.value as? [String : Any] {
                    let job = Job.init(jobDict: dict)
                    jobs.append(job)
                }
            }
            // filter out current user's job posts
            // filter out isScheduled jobs
            // filter out isComplete jobs
            self.jobs = jobs.filter{ $0.userId != AuthUserService.getCurrentUser()?.uid }
                .filter{ $0.isScheduled == false }
                .filter{ $0.isComplete == false }
                .sorted{ $0.dateCreated > $1.dateCreated }
        }
    }
    
    private func configureNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "JobMarketPlace"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addJob))
    }
    
    @objc private func addJob() {
        let addJobVC = AddJobViewController.storyboardInstance()
        addJobVC.modalTransitionStyle = .crossDissolve
        addJobVC.modalPresentationStyle = .overCurrentContext
        let navController = UINavigationController(rootViewController: addJobVC)
        present(navController, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { alert in }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension JobsFeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("there are \(jobs.count) in the database")
        return jobs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobCell", for: indexPath) as! JobCell
        let job = jobs[indexPath.row]
        cell.configureCell(job: job)
        cell.backgroundColor = .white
        return cell
    }
}

extension JobsFeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! JobCell
        let job = jobs[indexPath.row]
        let detailVC = DetailViewController.storyboardInstance()
        detailVC.job = job
        detailVC.image = cell.jobImage.image
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
