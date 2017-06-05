//
//  TopBarViewController.swift
//  FBlogin
//
//  Created by BrianChen on 2017/6/4.
//  Copyright © 2017年 BrianChen. All rights reserved.
//

import UIKit

class TopBarViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fireLabel: UILabel!
    @IBOutlet weak var waterLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var windImageView: UIImageView!
    @IBOutlet weak var waterImageView: UIImageView!
    @IBOutlet weak var fireImageView: UIImageView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fireImageView.image = UIImage(named: "download-2.jpg")
        waterImageView.image = UIImage(named: "download-3.jpg")
        windImageView.image = UIImage(named:"images-6.jpg")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  }
