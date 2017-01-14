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
            print("new,image")
            UploadRequest(newImage: newImage!)
            UIImageWriteToSavedPhotosAlbum(newImage!, nil, nil, nil)
            print("saved")
        }
    }
    
    func UploadRequest(newImage: UIImage)
    {
        
        let url = URL(string: "http://127.0.0.1/imgJSON/img.php")
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        let image_data = UIImageJPEGRepresentation(newImage, 0.8)!
        if(image_data == nil)
        {
            print("image data null")
            return
        }
        
        let body = NSMutableData()
        
        let fname = "test.png"
        let mimetype = "image/jpeg"
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"test\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("hi\r\n".data(using: String.Encoding.utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"file\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(image_data)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        
        request.httpBody = body as Data
        let session = URLSession.shared
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {            (
            data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("no data")
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            
            print(dataString)            
        }
        task.resume()
    }    
    
    func generateBoundaryString() -> String
    {
        return "Boundary-\(UUID().uuidString)"
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
