import UIKit
import AVFoundation

class QRScannerController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
//    @IBOutlet var messageLabel:UILabel!
//    @IBOutlet var topbar: UIView!
//
//    var captureSession = AVCaptureSession()
//    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
//    var qrCodeFrameView: UIView?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        self.verifyAutorizationStatus()
//    }
//
//    func verifyAutorizationStatus () {
//        switch AVCaptureDevice.authorizationStatus(for: .video) {
//        case .authorized: // The user has previously granted access to the camera. self.setupCaptureSession()
//        case .notDetermined: // The user has not yet been asked for camera access. AVCaptureDevice.requestAccess(for: .video) { granted in
//        if granted { self.setupCaptureSession()
//        } }
//        case .denied:
//            return
//        case .restricted:
//            return
//        // The user has previously denied access.
//        // The user can't grant access due to restrictions.
//        @unknown default:
//        print("Unexpected authorization status found.")
//    }
//
//    func setupCaptureSession () { self.setupCaptureDeviceInput() self.setupCaptureDeviceOutput() self.initializeVideoPreview()
//    // Move the message label and top bar to the front
//    view.bringSubviewToFront(messageLabel) view.bringSubviewToFront(topbar)
//    // Optional: setup a rectangle to be shown when a QR is found
//    self.setupQrCodeFrameView()
//
//    }
     
}
