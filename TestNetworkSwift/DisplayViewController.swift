//
//  DisplayViewController.swift
//  TestNetworkSwift
//
//  Created by Matvey Kravtsov on 05/07/2018.
//  Copyright © 2018 Matvey Kravtsov. All rights reserved.
//

import UIKit


class DisplayViewController: UIViewController {

//    var server: LiveStreamingServer!
    var imageView: UIImageView!
    var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .green
        
//        let queue = DispatchQueue(label: "Live Streaming Queue");
//        server = LiveStreamingServer(withViewController: self, usingQueue: queue)
        
//        label = UILabel(frame: CGRect(x: 0, y: view.frame.height / 2, width: view.frame.width, height: 50))
//        label.text = "Server Started"
//        label.textAlignment = .center
//        view.addSubview(label)
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        view.addSubview(imageView)
    }
    
    func recieved(frame: Data) {
        DispatchQueue.main.async {
            self.imageView.image = UIImage(data: frame)
        }
    }
}

