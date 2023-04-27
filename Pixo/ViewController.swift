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
    let svgScrollView = SVGScrollView()
    
    let screenWidth = UIScreen.main.bounds.size.width
    
    var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupPhotoPicker.delegate = self
        addImageView()
        addScrollViewForSVG()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.present(popupPhotoPicker, animated: true, completion: nil);
    }
    
    func addImageView(){
        let frame = CGRect(x: (screenWidth / 2) - (screenWidth / 2), y: (UIScreen.main.bounds.height / 2) - (screenWidth / 2), width: screenWidth, height: screenWidth)
        
        self.imageView.frame = frame
//        self.imageView.image = image
        self.imageView.contentMode = .scaleAspectFit
        
        self.view.addSubview(imageView)
    }
    func showSelectedImage(image: UIImage){
        self.imageView.image = image
    }
    func addScrollViewForSVG(){
        self.view.addSubview(svgScrollView)
        
        svgScrollView.translatesAutoresizingMaskIntoConstraints = false
        svgScrollView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        svgScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        svgScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        svgScrollView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        svgScrollView.stackView.translatesAutoresizingMaskIntoConstraints = false
        svgScrollView.stackView.topAnchor.constraint(equalTo: svgScrollView.topAnchor).isActive = true
        svgScrollView.stackView.leadingAnchor.constraint(equalTo: svgScrollView.leadingAnchor).isActive = true
        svgScrollView.stackView.trailingAnchor.constraint(equalTo: svgScrollView.trailingAnchor).isActive = true
        svgScrollView.stackView.heightAnchor.constraint(equalTo: svgScrollView.heightAnchor).isActive = true
        svgScrollView.addSvgImageToStackView()
    }
}
extension ViewController: PhotoPickerViewControllerDelegate{
    func didUpdateState(to state: PhotoPickerViewControllerState) {
        switch state {
        case .getAsset:
            print("get Asset")
            guard let image = popupPhotoPicker.selectedImage else{
                return
            }
            showSelectedImage(image: image)
        case .error(let reason):
            print("error : \(reason)")
        }
    }
}
