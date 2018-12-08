//
//  MemeTableViewController.swift
//  ImagePickerExperiment
//
//  Created by Rayan Aldafas on 07/12/2018.
//  Copyright © 2018 RayanAldafas. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {

    // retrieve memes from the app delegate
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        print("////////////\(memes.count)//////////")
        
    }
    
    // refresh table view data
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    
    
//    @objc func addMeme() {
//        let memeEditor = self.storyboard!.instantiateViewController(withIdentifier: "memeEditor")
//        if let navigationController = navigationController {
//            navigationController.pushViewController(memeEditor, animated: true)
//        }
//    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("////////////\(memes.count)//////////")

        return self.memes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")!
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = meme.topText + ".." + meme.bottomText
        cell.imageView?.image = meme.memedImage

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
