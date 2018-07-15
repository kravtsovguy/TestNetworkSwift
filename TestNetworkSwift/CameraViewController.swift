//
//  CameraViewController.swift
//  TestNetworkSwift
//
//  Created by Matvey Kravtsov on 05/07/2018.
//  Copyright © 2018 Matvey Kravtsov. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    var client: LiveStreamingClient?
    var captureSession: AVCaptureSession!
    var device: AVCaptureDevice!
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .green
        
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
            if !granted {
                exit(1)
            } else {
                let queue = DispatchQueue(label: "Live Streaming Queue");
                self.client = LiveStreamingClient(withViewController: self, usingQueue: queue)
                self.setupSession()
            }
        }
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        view.addSubview(imageView)
    }
    
    func setupSession() {
        device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .hd1920x1080
        captureSession.beginConfiguration()
        try! captureSession.addInput(AVCaptureDeviceInput(device: device))
        
        let outputData = AVCaptureVideoDataOutput()
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
        let data = context.jpegRepresentation(of: ciImage, colorSpace: CGColorSpaceCreateDeviceRGB(), options:[:])!
        let image = UIImage(data: data)
        self.client?.send(frame: data)
        
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }
    
}
