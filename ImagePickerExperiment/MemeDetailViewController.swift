//
//  MemeDetailViewController.swift
//  ImagePickerExperiment
//
//  Created by Rayan Aldafas on 08/12/2018.
//  Copyright © 2018 RayanAldafas. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var meme : Meme!
    
   
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView.image = self.meme.memedImage
    }
    

    

}
