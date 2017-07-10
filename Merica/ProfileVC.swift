//
//  ProfileVC.swift
//  Merica
//
//  Created by Matt Deuschle on 7/9/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        DataService.dataService.refCurrentUser.child("userName").observeSingleEvent(of: .value, with: { (snapshot) in
            let name = snapshot.value as! String
            print("NAME: \(name)")
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

