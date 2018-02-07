//
//  JobsFeedView.swift
//  JobMktPlace
//
//  Created by Alex Paul on 2/4/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import UIKit
import SnapKit

class JobsFeedView: UIView {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cellSpacing: CGFloat = 10.0
        let itemWidth: CGFloat = bounds.width - (cellSpacing * 2)
        let itemHeight: CGFloat = bounds.height * 0.80
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.sectionInset = UIEdgeInsetsMake(cellSpacing, cellSpacing, cellSpacing, cellSpacing)
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

extension JobsFeedView {
    private func setupViews() {
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
}
