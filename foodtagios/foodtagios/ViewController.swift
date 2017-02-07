//
//  ViewController.swift
//  foodtagios
//
//  Created by Jack on 15/01/2017.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate  {
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    var documentController: UIDocumentInteractionController!
    
    // remove this later
    @IBOutlet var uploadProgressView: UIView!
    
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCapturePhotoOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()
    var foodImage: UIImage!
    let URL_PATH : String = "https://5daf5f33.ngrok.io/picture"
    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let deviceSession = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInDuoCamera,.builtInTelephotoCamera,.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .unspecified)
        
        for device in (deviceSession?.devices)! {
            
            if device.position == AVCaptureDevicePosition.back {
                
                do {
                    
                    let input = try AVCaptureDeviceInput(device: device)
                    
                    if captureSession.canAddInput(input){
                        captureSession.addInput(input)
                        
                        if captureSession.canAddOutput(sessionOutput){
                            captureSession.addOutput(sessionOutput)
                            
                            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                            //previewLayer.frame = self.view.bounds;
                            previewLayer.frame = cameraView.frame
                            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                            previewLayer.connection.videoOrientation = .portrait
                            
                            
                            
                            cameraView.layer.addSublayer(previewLayer)
                            
                            
                            //cameraView.addSubview(button)
                            
                            previewLayer.position = CGPoint (x: self.cameraView.frame.width / 2, y: self.cameraView.frame.height / 2)
                            previewLayer.bounds = cameraView.frame
                            
                            
                            captureSession.startRunning()
                            
                        }
                        if captureSession.canSetSessionPreset(AVCaptureSessionPreset640x480){
                            captureSession.sessionPreset = AVCaptureSessionPresetMedium
                        }
                    }
                    
                    
                } catch let avError {
                    print(avError)
                }
                
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
 
        
    }
    
    /** end render view **/

    /** start capture **/
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        if let sampleBuffer = photoSampleBuffer, let previewBuffer = photoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
        
                self.foodImage = UIImage(data: dataImage)
                //c = CGSize(width: 100, height: 100)
            
            
            
                let data = UIImageJPEGRepresentation(resizeImage(image: self.foodImage, targetSize: CGSize(width: 227, height: 227)), 0.8)
            
                captureSession.stopRunning()
            
                //previewLayer.removeFromSuperlayer()

            
            let headers: HTTPHeaders = [
                "Origin": "https://38a31a76.ngrok.io",
                "Content-type": "multipart/form-data; boundary=----WebKitFormBoundaryg9qBUnBrYZZ2rZOy",
                "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.95 Safari/537.36",
                "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
                "Referer": "https://38a31a76.ngrok.io/picture"
            ]
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(data!, withName: "file",fileName: "file", mimeType: "image/jpeg")
                   
            },
                to: URL_PATH,
                headers: headers,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            //print("Response: \(response.response)")
                            let responsedata = response.result.value
                            let json = JSON(responsedata)
                            
                            
                            let top1prob = Float(json["top1"]["proba"].string!)
                            let top2prob = Float(json["top2"]["proba"].string!)
                            let top3prob = Float(json["top3"]["proba"].string!)
                            let top4prob = Float(json["top4"]["proba"].string!)
                            let top5prob = Float(json["top5"]["proba"].string!)
                            
                            let controller = self.storyboard?.instantiateViewController(withIdentifier: "statView") as! StatViewController
                            controller.top1LabelPassed = json["top1"]["label"].string!
                            controller.top2LabelPassed = json["top2"]["label"].string!
                            controller.top3LabelPassed = json["top3"]["label"].string!
                            controller.top4LabelPassed = json["top4"]["label"].string!
                            controller.top5LabelPassed = json["top5"]["label"].string!
                            
                            controller.top1ProbaPassed = top1prob!/100
                            controller.top2ProbaPassed = top2prob!/100
                            controller.top3ProbaPassed = top3prob!/100
                            controller.top4ProbaPassed = top4prob!/100
                            controller.top5ProbaPassed = top5prob!/100
                            
                            
                            controller.theImagePassed = self.foodImage!
                            
                            
                            //controller.top1ProbaPassed = Float(json["top5"]["proba"].number!)

                            self.present(controller, animated: true, completion: nil)
                            self.button.isEnabled = true
                            
                            /** pass image to second view **/
                            //vc.theImagePassed = self.foodImage!
                        }
                        
                        
                        upload.uploadProgress { progress in // main queue by default
                                //print("Upload Progress: \(progress.fractionCompleted)")
                                let progress = Float(progress.fractionCompleted)
                                //print(progress)
                                self.progressView.progress = progress
                        
                            if(progress == 1){

                            }
                        }
                        
                        
                        
                    case .failure(let encodingError):
                        print(encodingError)
                    }
                    
            }
            )
            
        }
    }
    /** end capture **/
    
    /** resize image start **/
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        var newSize: CGSize
        /* resize based on ratio
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height

        // Figure out what our orientation is, and use that to form the rectangle
        
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        */
        
        // This is the rect that we've calculated out and this is what is actually used below
        newSize = CGSize(width: 227,  height: 227)
        let rect = CGRect(x: 0, y: 0, width: 227, height: 227)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    /** resize image end **/
    
    
    /** start take photo **/
    @IBAction func takePhoto(_ sender: Any) {
        self.button.isEnabled = false
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String : previewPixelType, kCVPixelBufferWidthKey as String : 160, kCVPixelBufferHeightKey as String : 160]
        
        settings.previewPhotoFormat = previewFormat
        sessionOutput.capturePhoto(with: settings, delegate: self)
        
    }
    /** end take photo **/


}

