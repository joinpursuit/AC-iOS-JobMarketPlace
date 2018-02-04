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
    
    private let profileView = ProfileView()
    
    private var postedJobs = [Job]() {
        didSet {
            DispatchQueue.main.async {
                self.profileView.postedJobsCollectionView.reloadData()
            }
        }
    }
    
    private var scheduledJobs = [Job]()

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
        navigationItem.title = "Profile"
    }
    
    private func observeJobs() {        
        DBService.manager.getJobs().observe(.value) { (snapshot) in
            var postedJobs = [Job]()
            for child in snapshot.children {
                let dataSnapshot = child as! DataSnapshot
                if let dict = dataSnapshot.value as? [String: Any] {
                    // only my job posts and jobs i've added to my schedule
                    let job = Job.init(jobDict: dict)
                    if job.userId == AuthUserService.getCurrentUser()?.uid {
                        postedJobs.append(job)
                    }
                }
            }
            self.postedJobs = postedJobs
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
            
        }
        return cell
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
