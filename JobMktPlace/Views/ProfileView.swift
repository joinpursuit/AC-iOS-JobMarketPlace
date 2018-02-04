//
//  ProfileView.swift
//  JobMktPlace
//
//  Created by Alex Paul on 2/4/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import UIKit
import SnapKit

class ProfileView: UIView {
    
    lazy var postedJobsHeader: UILabel = {
        let label = UILabel()
        label.text = "My Job Posts"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.backgroundColor = .lightGray
        return label
    }()
    
    lazy var postedJobsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cellSpacing: CGFloat = 10.0
//        let itemWidth: CGFloat = 100
//        let itemHeight: CGFloat = 100
//        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.register(JobCell.self, forCellWithReuseIdentifier: "JobCell")
        cv.backgroundColor = .white
        return cv
    }()
    
    lazy var scheduledJobsHeader: UILabel = {
        let label = UILabel()
        label.text = "My Scheduled Jobs"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.backgroundColor = .lightGray
        return label
    }()
    
    lazy var scheduledJobsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cellSpacing: CGFloat = 10.0
//        let itemWidth: CGFloat = 100
//        let itemHeight: CGFloat = 100
//        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.register(JobCell.self, forCellWithReuseIdentifier: "JobCell")
        cv.backgroundColor = .white
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension ProfileView {
    private func setupViews() {
        setupMyJobPostsHeader()
        setupMyJobPostsCollectionView()
        setupMyScheduledJobsCollectionHeader()
        setupMyScheduledJobsCollectionView()
    }
    
    private func setupMyJobPostsHeader() {
        addSubview(postedJobsHeader)
        postedJobsHeader.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.05)
        }
    }
    
    private func setupMyJobPostsCollectionView() {
        addSubview(postedJobsCollectionView)
        postedJobsCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(postedJobsHeader.snp.bottom)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.45)
        }
    }
    
    private func setupMyScheduledJobsCollectionHeader() {
        addSubview(scheduledJobsHeader)
        scheduledJobsHeader.snp.makeConstraints { (make) in
            make.top.equalTo(postedJobsCollectionView.snp.bottom)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.05)
        }
    }
    
    private func setupMyScheduledJobsCollectionView() {
        addSubview(scheduledJobsCollectionView)
        scheduledJobsCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(scheduledJobsHeader.snp.bottom)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.45)
        }
    }
}
