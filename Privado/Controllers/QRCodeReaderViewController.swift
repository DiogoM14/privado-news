import UIKit
import AVFoundation

class QrCodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    let session = AVCaptureSession()
    var previewLayer = AVCaptureVideoPreviewLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        } catch {
            print("Error with qrcode reader")
        }
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        
        previewLayer.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer)

        session.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObject: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObject.first {
            guard let readbleObject = metadataObject as?
                    AVMetadataMachineReadableCodeObject else { return }
            print(readbleObject.stringValue)
            session.stopRunning()
        }
    }

    
}
