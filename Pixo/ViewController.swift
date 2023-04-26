//
//  ViewController.swift
//  Pixo
//
//  Created by 홍정표 on 2023/04/24.
//

import UIKit
import Photos

class ViewController: UIViewController {

    let popupPhotoPicker = PhotoPickerCollectionViewController()
    let screenWidth = UIScreen.main.bounds.size.width
    var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupPhotoPicker.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
        self.present(popupPhotoPicker, animated: true, completion: nil);
    }
    func showImage(asset: PHAsset){
        let imageManager = PHImageManager()
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
        options.isNetworkAccessAllowed = true
        
//        options.progressHandler = {  (progress, error, stop, info) in
//                print("progress: \(progress)")
//            }
//
        let frame = CGRect(x: (screenWidth / 2) - (screenWidth / 2), y: (UIScreen.main.bounds.height / 2) - (screenWidth / 2), width: screenWidth, height: screenWidth)
        
        self.imageView.frame = frame
        imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: options) { image, _ in
            guard let image = image else{
                print("nill Image")
                return
            }
            self.imageView.image = image

            self.imageView.contentMode = .scaleAspectFit
        }
        
        self.view.addSubview(imageView)
    }
}
extension ViewController: PhotoPickerViewControllerDelegate{
    func didUpdateState(to state: PhotoPickerViewControllerState) {
        switch state {
        case .getAsset:
            print("get Asset")
            guard let asset = popupPhotoPicker.selectedAsset else{
                return
            }
            showImage(asset: asset)
        case .error(let reason):
            print("error : \(reason)")
        }
    }
}
