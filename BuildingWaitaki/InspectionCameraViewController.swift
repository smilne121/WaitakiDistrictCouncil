//
//  InspectionCameraViewController.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 6/08/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import UIKit
import AVFoundation

class InspectionCameraViewController: UIViewController {
        
        let captureSession = AVCaptureSession()
        var previewLayer : AVCaptureVideoPreviewLayer?
        
        // If we find a device we'll store it here for later use
        var captureDevice : AVCaptureDevice?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Do any additional setup after loading the view, typically from a nib.
            captureSession.sessionPreset = AVCaptureSessionPresetHigh
            
            let devices = AVCaptureDevice.devices()
            
            // Loop through all the capture devices on this phone
            for device in devices {
                // Make sure this particular device supports video
                if (device.hasMediaType(AVMediaTypeVideo)) {
                    // Finally check the position and confirm we've got the back camera
                    if(device.position == AVCaptureDevicePosition.Back) {
                        captureDevice = device as? AVCaptureDevice
                        if captureDevice != nil {
                            println("Capture device found")
                            beginSession()
                        }
                    }
                }
            }
            
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

        
        func configureDevice() {
           // if let device = captureDevice {
             //   device.lockForConfiguration(nil)
               // device.focusMode = .Locked
              //  device.unlockForConfiguration()
            //}
            
        }
        
        func beginSession() {
            
            configureDevice()
            
            var err : NSError? = nil
            captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: &err))
            
            if err != nil {
                println("error: \(err?.localizedDescription)")
            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            self.view.layer.addSublayer(previewLayer)
            previewLayer?.frame = self.view.layer.frame
            captureSession.startRunning()
        }
    
    func capturePicture(){
        
        println("Capturing image")
        stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        captureSession.addOutput(stillImageOutput)
        
        if let videoConnection = stillImageOutput.connectionWithMediaType(AVMediaTypeVideo){
            stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {
                (sampleBuffer, error) in
                var imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                var dataProvider = CGDataProviderCreateWithCFData(imageData)
                var cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, kCGRenderingIntentDefault)
                var image = UIImage(CGImage: cgImageRef, scale: 1.0, orientation: UIImageOrientation.Right)
                
                var imageView = UIImageView(image: image)
                imageView.frame = CGRect(x:0, y:0, width:self.screenSize.width, height:self.screenSize.height)
                
                //Show the captured image to
                self.view.addSubview(imageView)
                
                //Save the captured preview to image
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                
            })
        }
    }
        
}
