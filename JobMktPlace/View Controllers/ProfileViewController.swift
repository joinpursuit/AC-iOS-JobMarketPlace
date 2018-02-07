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
    
    private var authUserService = AuthUserService() 
    
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
        authUserService.delegate = self

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
        navigationItem.title = "@\(AuthUserService.getCurrentUser()?.displayName ?? "Jobs")"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "sign out", style: .plain, target: self, action: #selector(signOut))
    }
    
    @objc private func signOut() {
        authUserService.signOut()
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
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { alert in }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
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
            cell.delegate = self
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

extension ProfileViewController: JobCellDelegate {
    func jobCellDeleteAction(_ jobCell: JobCell, job: Job) {
        let alertController = UIAlertController(title: "Delete Action", message: "Select an Action", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete Job", style: .destructive, handler: {action in
            DBService.manager.removeJob(job: job)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension ProfileViewController: AuthUserServiceDelegate {
    func didSignOut(_ userService: AuthUserService) {
        let loginVC = LoginViewController.storyboardInstance()
        tabBarController?.tabBar.isHidden = true
        navigationController?.viewControllers = [loginVC]
    }
    func didFailSigningOut(_ userService: AuthUserService, error: Error) {
        showAlert(title: "Error Signing Out", message: error.localizedDescription)
    }
}
