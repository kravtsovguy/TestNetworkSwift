//
//  DisplayViewController.swift
//  TestNetworkSwift
//
//  Created by Matvey Kravtsov on 05/07/2018.
//  Copyright © 2018 Matvey Kravtsov. All rights reserved.
//

import UIKit


class DisplayViewController: UIViewController {

    var server: LiveStreamingServer!
    var imageView: UIImageView!
    var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        
        server = LiveStreamingServer(withViewController: self)
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        view.addSubview(imageView)
        
        label = UILabel(frame: CGRect(x: 0, y: 50, width: view.frame.width, height: 50))
        label.text = "test"
        view.addSubview(label)
    }
    
    func recieved(frame: Data) {
        DispatchQueue.main.async {
            self.label.text = "\(self.label.text ?? "") + length: \(frame.count)"
//            self.imageView.image = UIImage(data: frame)
            let text = String(data: frame, encoding: .utf8)
            print("\(text ?? "none")")
        }
    }
}

