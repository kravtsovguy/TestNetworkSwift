//
//  LiveStreamingClient.swift
//  TestNetworkSwift
//
//  Created by Matvey Kravtsov on 05/07/2018.
//  Copyright © 2018 Matvey Kravtsov. All rights reserved.
//

import Foundation
import Network
import UIKit


class LiveStreamingClient {
    var connection: NWConnection
    var queue: DispatchQueue
    weak var controller: CameraViewController!
    
    init(name: String, controller: CameraViewController) {
        self.controller = controller
        
        queue = DispatchQueue(label: "Live Streaming Server")
        
//        connection = NWConnection(host: "10.42.72.5", port: NetworkPort, using: NetworkParameters)
        connection = NWConnection(to: NWEndpoint.service(name: name, type: NetworkServiceType, domain: "local", interface: nil), using: NetworkParameters)
        
        connection.stateUpdateHandler = { [weak self] state in
            switch state {
            case .ready:
                print("client ready")
//                sleep(2)
//                self?.startSending()
            case .failed(let error):
                print("client failed: \(error)")
            default:
                break
            }
        }
        
        connection.start(queue: queue)
    }
    
    func startSending() {
        var frame = self.controller.currentFrame!
//        frame = "hello".data(using: .utf8)!
        var frames = [Data]()
        
        let preferredChunkSize = NetworkFrameSize
        let totalSize = frame.count
        var offset = 0
        
        frame.withUnsafeBytes { (u8Ptr: UnsafePointer<UInt8>) in
            let mutRawPointer = UnsafeMutableRawPointer(mutating: u8Ptr)
            
            while offset < totalSize {
                
                let chunkSize = (totalSize - offset) >= preferredChunkSize ? preferredChunkSize : totalSize - offset
                let chunk = Data(bytesNoCopy: mutRawPointer + offset, count: chunkSize, deallocator: Data.Deallocator.none)
                offset += chunkSize
                
                frames.append(chunk)
            }
        }
        
//        print("whole frame size \(frame.count)")
        self.sendFrame(connection: connection, frames: frames)
    }
    
    func sendFrame(connection: NWConnection, frames: [Data]) {
//        if frames.last?.count == NetworkFrameSize {
//            print("OOOOOPS")
//            exit(1)
//        }
         connection.batch {
            for frame in frames {
//                connection.send(content: frame, completion: .idempotent)
                connection.send(content: frame, completion: .contentProcessed({ error in
                    if let error = error {
                        print("error while sending: \(error)")
                    } else {
//                        print("sended: \(frame.count)")
//                        connection.cancel()
//                        self.startSending()
                    }
                }))
            }
        }
    }
    
}


//extension LiveStreamingClient: CameraViewControllerDelegate {
//    func cameraOutput(withData data: Data) {
//        self.startSending()
//    }
//}
