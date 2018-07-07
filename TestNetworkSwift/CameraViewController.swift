//
//  CameraViewController.swift
//  TestNetworkSwift
//
//  Created by Matvey Kravtsov on 05/07/2018.
//  Copyright © 2018 Matvey Kravtsov. All rights reserved.
//

import UIKit
import AVFoundation


//protocol CameraViewControllerDelegate {
//    func cameraOutput(withData data:Data);
//}


class CameraViewController: UIViewController {
    
    var client: LiveStreamingClient!
    var captureSession: AVCaptureSession!
    var device: AVCaptureDevice!
    var imageView: UIImageView!
    var currentFrame: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .green
        
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
            if !granted {
                exit(1)
            } else {
                self.client = LiveStreamingClient(name: "Matvey’s MacBook Pro", controller: self)
                self.setupSession()
            }
        }
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        view.addSubview(imageView)
    }
    
    func setupSession() {
        device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .iFrame1280x720
        captureSession.beginConfiguration()
        try! captureSession.addInput(AVCaptureDeviceInput(device: device))
        
        let outputData = AVCaptureVideoDataOutput()
//        outputData.videoSettings = [
//            kCVPixelBufferPixelFormatTypeKey as String : Int(kCVPixelFormatType_32BGRA)
//        ]
        
        let queue = DispatchQueue(label: "Camera Output Queue")
        outputData.setSampleBufferDelegate(self, queue: queue)
        captureSession.addOutput(outputData)
        
        let connection = outputData.connection(with: .video)
        connection?.videoOrientation = .portrait
        
        captureSession.commitConfiguration()
        captureSession.startRunning()
    }
}


extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {

        let buffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        let ciImage = CIImage(cvPixelBuffer: buffer)
        let context = CIContext()
        let data = context.jpegRepresentation(of: ciImage, colorSpace: CGColorSpaceCreateDeviceRGB(), options:[:])
        self.currentFrame = data
        let image = UIImage(data: data!)
//        let image = UIImage(ciImage: ciImage)
        
        DispatchQueue.main.async {
            self.imageView.image = image
        }
        
        if client?.connection.state == .ready {
            self.client.startSending()
        }
    }
    
}
