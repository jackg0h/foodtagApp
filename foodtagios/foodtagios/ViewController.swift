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

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate  {
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    
    // remove this later
    @IBOutlet var uploadProgressView: UIView!
    
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCapturePhotoOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()
    var foodImage: UIImage!
    let URL_PATH : String = "https://ca9b4884.ngrok.io"
    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
    /** end render view **/

    /** start capture **/
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        if let sampleBuffer = photoSampleBuffer, let previewBuffer = photoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
        
                self.foodImage = UIImage(data: dataImage)
                let data = UIImageJPEGRepresentation(self.foodImage!, 0.8)
            
                captureSession.stopRunning()
                //previewLayer.removeFromSuperlayer()
           
            
            let headers: HTTPHeaders = [
                "Origin": "http://ca9b4884.ngrok.io",
                "Content-type": "multipart/form-data; boundary=----WebKitFormBoundaryg9qBUnBrYZZ2rZOy",
                "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.95 Safari/537.36",
                "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
                "Referer": "http://ca9b4884.ngrok.io/picture"
            ]
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(data!, withName: "file",fileName: "file", mimeType: "image/jpeg")
                   
            },
                to: "https://ca9b4884.ngrok.io/picture",
                headers: headers,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            debugPrint(response.result)
                            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "results")
                            self.present(vc, animated: true, completion:  nil)
                        }
                        
                        
                        upload.uploadProgress { progress in // main queue by default
                                //print("Upload Progress: \(progress.fractionCompleted)")
                                let progress = Float(progress.fractionCompleted)
                                print(progress)
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
    
    /** start take photo **/
    @IBAction func takePhoto(_ sender: Any) {
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String : previewPixelType, kCVPixelBufferWidthKey as String : 160, kCVPixelBufferHeightKey as String : 160]
        
        settings.previewPhotoFormat = previewFormat
        sessionOutput.capturePhoto(with: settings, delegate: self)
        
    }
    /** end take photo **/


}

