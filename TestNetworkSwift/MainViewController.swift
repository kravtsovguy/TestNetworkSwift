//
//  MainViewController.swift
//  TestNetworkSwift
//
//  Created by Matvey Kravtsov on 07/07/2018.
//  Copyright © 2018 Matvey Kravtsov. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var serverButton: UIButton!
    var clientButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        serverButton = UIButton(type: UIButton.ButtonType.system)
        serverButton.setTitle("Start Server", for: UIControl.State.normal)
        serverButton.frame = CGRect(x: 0, y: view.frame.height / 2 - 50, width: view.frame.width, height: 50)
        serverButton.addTarget(self, action: #selector(serverTapped), for: UIControl.Event.touchUpInside)
        view.addSubview(serverButton)
        
        clientButton = UIButton(type: UIButton.ButtonType.system)
        clientButton.setTitle("Start Client", for: UIControl.State.normal)
        clientButton.frame = CGRect(x: 0, y: view.frame.height / 2, width: view.frame.width, height: 50)
        clientButton.addTarget(self, action: #selector(clientTapped), for: UIControl.Event.touchUpInside)
        view.addSubview(clientButton)
    }
    
    @objc
    func serverTapped() {
        present(DisplayViewController(), animated: true, completion: nil)
    }
    
    @objc
    func clientTapped() {
        present(CameraViewController(), animated: true, completion: nil)
    }
    
}
