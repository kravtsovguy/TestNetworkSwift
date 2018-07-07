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
    var frame = Data()
    
    init(withViewController controller: DisplayViewController) {
        self.controller = controller
        
        queue = DispatchQueue(label: "Live Streaming Server")
        
        listener = try! NWListener(parameters: NetworkParameters, port: NetworkPort)!
        listener.service = NWListener.Service(type: NetworkServiceType)
        listener.serviceRegistrationUpdateHandler = { serviceChange in
            switch serviceChange {
            case .add(let endpoint):
                switch endpoint {
                case .service(let name, _, _, _):
                    print("listening \(name)")
                default:
                    break;
                }
            default:
                break;
            }
        }
        
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
        connection.batch {
        connection.receive(minimumIncompleteLength: 1, maximumLength: NetworkFrameSize) { (content, context, isComplete, error) in
            if let frame = content {
                
                self.frame.append(frame)
                
                if (frame.count < NetworkFrameSize) {
//                    print("server: whole frame count \(self.frame.count)")
                    self.controller.recieved(frame: self.frame)
                    self.frame = Data()
                }
//                self.frame.append(frame)
//
//                if (self.frame.count % NetworkFrameSize != 0)
//                {
//                    print("server: whole frame count \(self.frame.count)")
//                    self.controller.recieved(frame: self.frame)
//                    self.frame = Data()
//                }
                
                if error == nil {
                    self.recieve(on: connection)
                }
            }
        }
        }
    }
    
    
    
}
