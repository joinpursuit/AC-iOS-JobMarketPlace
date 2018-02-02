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
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cellSpacing: CGFloat = 10.0
        let itemWidth: CGFloat = view.bounds.width - (cellSpacing * 2)
        let itemHeight: CGFloat = view.bounds.height * 0.80
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.sectionInset = UIEdgeInsetsMake(cellSpacing, cellSpacing, cellSpacing, cellSpacing)
        let cv = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        cv.register(JobCell.self, forCellWithReuseIdentifier: "JobCell")
        cv.backgroundColor = .yellow
        cv.dataSource = self
        return cv
    }()

    private var authUserService = AuthUserService()
    
    // data model
    private var jobs = [Job]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        authUserService.delegate = self
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
            self.jobs = jobs
        }
    }
    
    private func configureNavBar() {
        navigationItem.title = "Jobs"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "sign out", style: .plain, target: self, action: #selector(signOut))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addJob))
    }
    
    @objc private func signOut() {
        authUserService.signOut()
    }
    
    @objc private func addJob() {
        //DBService.manager.addJob(title: "Need Swift help!!!!", description: "I can't understand custom delegation :-((((((")
        //DBService.manager.addJob(title: "Leaking faucet, NEED PLUMBER", description: "I am experiencing a leaky faucet. Please Help! Estimations are welcome")
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

extension JobsFeedViewController: AuthUserServiceDelegate {
    func didSignOut(_ userService: AuthUserService) {
        let loginVC = LoginViewController.storyboardInstance()
        tabBarController?.tabBar.isHidden = true
        navigationController?.viewControllers = [loginVC]
    }
    func didFailSigningOut(_ userService: AuthUserService, error: Error) {
        showAlert(title: "Error Signing Out", message: error.localizedDescription)
    }
}


