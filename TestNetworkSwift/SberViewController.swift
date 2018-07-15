//
//  SberViewController.swift
//  TestNetworkSwift
//
//  Created by Matvey Kravtsov on 13/07/2018.
//  Copyright © 2018 Matvey Kravtsov. All rights reserved.
//

import UIKit


class SberViewController: UIViewController {
    
    var server: LiveStreamingServer!
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let queue = DispatchQueue(label: "Live Streaming Queue");
        server = LiveStreamingServer(withViewController: nil, usingQueue: queue)
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        imageView.image = UIImage(named: "Sber")
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        view.addSubview(imageView)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(gesture)
        imageView.isUserInteractionEnabled = true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc
    func imageTapped() {
        let vc = DisplayViewController()
        server.controller = vc
        self.present(vc, animated: true, completion: nil)
    }
}
