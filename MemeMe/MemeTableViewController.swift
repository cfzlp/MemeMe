//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Carlos Lopes Pereira on 25/05/15.
//  Copyright (c) 2015 Carlos Lopes Pereira. All rights reserved.
//

import UIKit


class MemeTableViewController: UITableViewController {

    // TODO: should this not be initialized here? what happens when I initialize and then assign?
    var memes = [Meme]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        // Get a copy of the data model
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        self.memes = appDelegate.memes
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        // If there are no sent memes, create a new one
        if (self.memes.count == 0) {
            let newMemeVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditor") as! MemeEditor
            self.presentViewController(newMemeVC, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func createNewMeme(sender: UIBarButtonItem) {
        let newMemeVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditor") as! MemeEditor
        self.presentViewController(newMemeVC, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell", forIndexPath: indexPath) as! UITableViewCell
        let meme = self.memes[indexPath.row]
        
        // set image and text
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = meme.topText

        return cell
    }
    
    // MARK: - Table view delegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC: SentMemeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SentMeme") as! SentMemeViewController
        detailVC.sentMeme = self.memes[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

}
