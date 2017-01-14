import UIKit
import AVFoundation

final class ViewController: UIViewController {
    
    @IBOutlet weak var baseView: UIView!
    let session = AVCaptureSession()
    let camera = CameraUtil()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCameraView()
        session.startRunning()
    }
    
    private func setupCameraView() {
        
        let device = camera.findDevice(position: .back)
        
        if let videoLayer = camera.createView(session: session, device: device) {
            
            videoLayer.frame = baseView.bounds
            videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            baseView.layer.addSublayer(videoLayer)
        } else {
            fatalError("VideoLayerがNil")
        }
    }
    
    @IBAction func photoDidTap(_ sender: UIButton) {
        camera.takePhoto()
        self.session.stopRunning()
    }
}
