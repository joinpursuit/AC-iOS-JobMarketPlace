//
//  TabBarController.swift
//  JobMktPlace
//
//  Created by Alex Paul on 2/1/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public static func storyboardInstance() -> TabBarController {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        return tabBarController
    }

}
