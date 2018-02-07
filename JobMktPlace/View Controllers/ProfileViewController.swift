//
//  ProfileViewController.swift
//  JobMktPlace
//
//  Created by Alex Paul on 2/1/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import UIKit
import Firebase

enum CollectionViewType: Int {
    case PostedJobs
    case ScheduledJobs
}

class ProfileViewController: UIViewController {
    
    private var profileView = ProfileView()
    
    private var postedJobs = [Job]() {
        didSet {
            DispatchQueue.main.async {
                self.profileView.postedJobsCollectionView.reloadData()
            }
        }
    }
    
    private var scheduledJobs = [Job]() {
        didSet {
            DispatchQueue.main.async {
                self.profileView.scheduledJobsCollectionView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(profileView)
        configureNavBar()
        
        profileView.postedJobsCollectionView.dataSource = self
        profileView.postedJobsCollectionView.delegate = self
        profileView.scheduledJobsCollectionView.dataSource = self
        profileView.scheduledJobsCollectionView.delegate = self
        
        observeJobs()
    }
    
    private func configureNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Profile - @\(AuthUserService.getCurrentUser()?.displayName ?? "Jobs")"
    }
    
    private func observeJobs() {
        DBService.manager.getJobs().observe(.value) { (snapshot) in
            var postedJobs = [Job]()
            var scheduledJobs = [Job]()
            for child in snapshot.children {
                let dataSnapshot = child as! DataSnapshot
                if let dict = dataSnapshot.value as? [String: Any] {
                    // only my job posts and jobs i've added to my schedule
                    let job = Job.init(jobDict: dict)
                    if job.userId == AuthUserService.getCurrentUser()?.uid {
                        postedJobs.append(job)
                    }
                    if job.contractorId == AuthUserService.getCurrentUser()?.uid {
                        scheduledJobs.append(job)
                    }
                }
            }
            self.postedJobs = postedJobs.filter{ $0.isComplete == false }
            self.scheduledJobs = scheduledJobs.filter{ $0.isComplete == false }
        }
    }
    
}

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == profileView.postedJobsCollectionView {
            return postedJobs.count
        } else {
            return scheduledJobs.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobCell", for: indexPath) as! JobCell
        cell.jobImage.contentMode = .scaleAspectFill
        cell.jobImage.clipsToBounds = true
        if collectionView == profileView.postedJobsCollectionView {
            let postedJob = postedJobs[indexPath.row]
            cell.configureCell(job: postedJob)
        } else {
            let scheduledJob = scheduledJobs[indexPath.row]
            cell.configureCell(job: scheduledJob)
        }
        return cell
    }
}

extension ProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! JobCell
        var job: Job
        if collectionView == profileView.postedJobsCollectionView {
            job = postedJobs[indexPath.row]
        } else {
            job = scheduledJobs[indexPath.row]
        }
        let detailVC = DetailViewController.storyboardInstance()
        detailVC.image = cell.jobImage.image
        detailVC.job = job
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSpacing: CGFloat = 10.0
        let itemWidth: CGFloat = (view.bounds.width - (cellSpacing * 3)) / 2
        let itemHeight: CGFloat = (collectionView.bounds.height - (cellSpacing * 2.0))
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
