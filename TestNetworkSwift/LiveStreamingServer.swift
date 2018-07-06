//
//  LiveStreamingServer.swift
//  TestNetworkSwift
//
//  Created by Matvey Kravtsov on 05/07/2018.
//  Copyright © 2018 Matvey Kravtsov. All rights reserved.
//

import Foundation
import Network
import UIKit


class LiveStreamingServer {
    
    var listener: NWListener
    var queue: DispatchQueue
    weak var controller: DisplayViewController!
    
    init(withViewController controller: DisplayViewController) {
        self.controller = controller
        
        queue = DispatchQueue(label: "Live Streaming Server")
        
        listener = try! NWListener(parameters: .udp, port: 1053)!
//        listener.service = NWListener.Service(type: "_camera._tcp")
//        listener.serviceRegistrationUpdateHandler = { serviceChange in
//            switch serviceChange {
//            case .add(let endpoint):
//                switch endpoint {
//                case .service(let name, _, _, _):
//                    print("listening \(name)")
//                default:
//                    break;
//                }
//            default:
//                break;
//            }
//        }
        
        listener.newConnectionHandler = { [weak self] newConnection in
            if let strongSelf = self {
                print("new connection")
                newConnection.start(queue: strongSelf.queue)
                strongSelf.recieve(on: newConnection)
            }
        }
        
        listener.stateUpdateHandler = { [weak self] state in
            switch state {
            case .ready:
                print("listening on port \(String(describing: self?.listener.port))")
            case .failed(let error):
                print("failed with error: \(error)")
            default:
                break
            }
        }
        
        listener.start(queue: queue)
    }
    
    func recieve(on connection: NWConnection) {
//        connection.batch {
            connection.receive { (content, context, isComplete, error) in
                if let frame = content {
                    
                    self.controller.recieved(frame: frame)

                    if error == nil {
                        self.recieve(on: connection)
                    }
                }
            }
//        }
    }
    
    
    
}
