//
//  ViewController.swift
//  ImageCache
//
//  Created by Shilpa Kumari on 19/01/21.
//  Copyright © 2021 Shilpa Kumari. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var image: ImageLoader!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://picsum.photos/200/300")!
        image.loadImage(from: url)
    }
    
    
}

class ImageLoader: UIImageView {
    
    static var cache = NSCache<NSString, UIImage>()
    
    func loadImage(from url: URL) {
        if let img = ImageLoader.cache.object(forKey: url.absoluteString as NSString) {
            self.image = img
        } else {
            URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                if error != nil {
                    print("error")
                } else {
                    if let imgData = data {
                        let newImage = UIImage(data: imgData)!
                        
                        DispatchQueue.main.async {
                            self?.image = newImage
                        }
                        ImageLoader.cache.setObject(newImage, forKey: url.absoluteString as NSString)
                        
                    }
                }
            }.resume()
        }
    }
}

