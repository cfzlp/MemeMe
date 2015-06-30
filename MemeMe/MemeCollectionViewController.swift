//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Carlos Lopes Pereira on 13/06/15.
//  Copyright (c) 2015 Carlos Lopes Pereira. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    var memes = [Meme]()
    
    override func viewWillAppear(animated: Bool) {
        // Get a copy of the data model
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        self.memes = appDelegate.memes
        self.collectionView?.reloadData()
    }

    @IBAction func createNewMeme(sender: UIBarButtonItem) {
        let newMemeVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditor") as! MemeEditor
        self.presentViewController(newMemeVC, animated: true, completion: nil)
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[indexPath.row]
        
        cell.topTextLabel.text = meme.topText
        cell.bottomTextLabel.text = meme.bottomText
        cell.memeImageView.image = meme.memedImage
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailVC: SentMemeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SentMeme") as! SentMemeViewController
        detailVC.sentMeme = self.memes[indexPath.item]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

}
