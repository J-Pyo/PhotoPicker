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
    let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    let screenWidth = UIScreen.main.bounds.size.width
    
    var imageView = UIImageView()
    
    let svgImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
        popupPhotoPicker.delegate = self
        svgScrollView.svgDelegate = self
        addTopView()
        addImageView()
        addScrollViewForSVG()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.present(popupPhotoPicker, animated: true, completion: nil);
    }
    func addTopView(){
        var topView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 80))
        topView.backgroundColor = .black
        
        var saveButton = UIButton(frame: CGRect(x: screenWidth - 100, y: 40, width: 100, height: 40))
        saveButton.setTitle("저장하기", for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.addTarget(self, action: #selector(savingImage), for: .touchUpInside)

        
        self.view.addSubview(topView)
        self.view.addSubview(saveButton)
    }
    //이미지 저장하기
    @objc func savingImage(){
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)

        loadingIndicator.startAnimating()
        
        guard let albumImg = self.imageView.image,
              let svgImg = self.svgImage.image else{
            return
        }
        //이미지를 합성할때 메모리 이슈가 있어서 scale 수정
        UIGraphicsBeginImageContextWithOptions(albumImg.size, false, 1.0)

        albumImg.draw(in: CGRect(origin: CGPoint.zero, size: albumImg.size))
        
        let centerX = (albumImg.size.width - svgImg.size.width) / 2.0
        let centerY = (albumImg.size.height - svgImg.size.height) / 2.0

        svgImg.draw(at: CGPoint(x: centerX, y: centerY))
        
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        guard let mergedImage = mergedImage else{
            return
        }
        UIImageWriteToSavedPhotosAlbum(mergedImage, self, #selector(self.didFinishSavingImage(_:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    //사진 앱에 저장 후 동작
    @objc func didFinishSavingImage(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        loadingIndicator.stopAnimating()
        let alert = UIAlertController(title: "알림", message: "저장 완료", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)

        alert.addAction(action)

        if error != nil {
            // Error occurred while saving the image
            print("Error: \(error!.localizedDescription)")
        } else {
            // Image was saved successfully
            self.present(alert, animated: true, completion: nil)
        }
    }
    //사진앱에 선택되서 표시될 자리에 이미지 뷰 추가
    func addImageView(){
        let frame = CGRect(x: (screenWidth / 2) - (screenWidth / 2), y: (UIScreen.main.bounds.height / 2) - (screenWidth / 2), width: screenWidth, height: screenWidth)
        
        self.imageView.frame = frame
//        self.imageView.image = image
        self.imageView.contentMode = .scaleAspectFit
        
        self.view.addSubview(imageView)
    }
    //선택된 svg 이미지를 사진앱에서 선택된 이미지 가운데에 올리는 로직
    func showSelectedSVG(image: UIImage){
        
        let imageViewBount = imageView.bounds
        svgImage.image = image
        svgImage.frame = CGRect(x: (Int(imageViewBount.width) / 2) - 35, y: (Int(imageViewBount.height) / 2) - 35, width: 70, height: 70)
        imageView.addSubview(svgImage)
        
    }
    // 사진앱에서 추가될 이미지 입히기
    func showSelectedImage(image: UIImage){
        self.imageView.image = image
    }
    //scrollview를 추가해줌
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
        svgScrollView.addSvgImageToStackView(target: self)
    }
}
//PhotoPicker에 관한 Delegate
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
//ScrollView에 관한 Delegate
extension ViewController: SVGScrollViewDelegate{
    func didUpdateState(to state: SVGScrollViewState) {
        switch state {
        case .sendImageInfo:
            showSelectedSVG(image: svgScrollView.sendedImg!)
        case .error(let reason):
            print("error: \(reason)")
        }
    }
}
