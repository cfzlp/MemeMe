//
//  Meme.swift
//  MemeMe
//
//  Created by Carlos Lopes Pereira on 11/04/15.
//  Copyright (c) 2015 Carlos Lopes Pereira. All rights reserved.
//

import UIKit

class Meme: NSObject {
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memedImage:UIImage
    
    init(topText:String, bottomText:String, image:UIImage, memedImage:UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = image
        self.memedImage = memedImage
    }
}
