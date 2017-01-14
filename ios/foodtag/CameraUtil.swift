//
//  CameraUtil.swift
//  foodtag
//
//  Created by Jack on 14/01/2017.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit
import AVFoundation

final class CameraUtil: NSObject {
    
    let imageOutput = AVCapturePhotoOutput()
    
    func findDevice(position: AVCaptureDevicePosition) -> AVCaptureDevice? {
        
        //        guard let device = AVCaptureDevice.devices().filter({
        //            ($0 as! AVCaptureDevice).position == AVCaptureDevicePosition.back
        //        }).first as? AVCaptureDevice else {
        //            fatalError("No front facing camera found")
        //        }
        //        return device
        
        return AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera,
                                             mediaType: AVMediaTypeVideo,
                                             position: position)
    }
    
    func createView(session: AVCaptureSession?,
                    device: AVCaptureDevice?) -> AVCaptureVideoPreviewLayer?{
        
        let videoInput = try! AVCaptureDeviceInput.init(device: device)
        session?.addInput(videoInput)
        session?.addOutput(imageOutput)
        return AVCaptureVideoPreviewLayer.init(session: session)
    }
    
    func takePhoto() {
        imageOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
    
    func savePhoto(imageDataBuffer: CMSampleBuffer) {
        
        if let imageData =
            AVCapturePhotoOutput.jpegPhotoDataRepresentation(
                forJPEGSampleBuffer: imageDataBuffer,
                previewPhotoSampleBuffer: nil),
            let image = UIImage(data: imageData) {
            
            // resize image
            let scale = 227 / image.size.width
            _ = image.size.height * scale
            UIGraphicsBeginImageContext(CGSize(width: 227, height: 227))
            image.draw(in: CGRect(x: 0, y: 0, width: 227, height: 227))
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            //UIImageWriteToSavedPhotosAlbum(newImage!, nil, nil, nil)
        }
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension CameraUtil: AVCapturePhotoCaptureDelegate {
    
    func capture(_ captureOutput: AVCapturePhotoOutput,
                 didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?,
                 previewPhotoSampleBuffer: CMSampleBuffer?,
                 resolvedSettings: AVCaptureResolvedPhotoSettings,
                 bracketSettings: AVCaptureBracketedStillImageSettings?,
                 error: Error?) {
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        savePhoto(imageDataBuffer: photoSampleBuffer!)
    }
}
