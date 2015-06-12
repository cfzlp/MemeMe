//
//  SentMemeViewController.swift
//  MemeMe
//
//  Created by Carlos Lopes Pereira on 13/06/15.
//  Copyright (c) 2015 Carlos Lopes Pereira. All rights reserved.
//

import UIKit

class SentMemeViewController: UIViewController {

    @IBOutlet weak var sentMemeView: UIImageView!

    var sentMeme: Meme?

    override func viewDidLoad() {
        super.viewDidLoad()

       self.sentMemeView.image = self.sentMeme?.memedImage
    }
}
