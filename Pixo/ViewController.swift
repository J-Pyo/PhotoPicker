//
//  ViewController.swift
//  Pixo
//
//  Created by 홍정표 on 2023/04/24.
//

import UIKit
import Photos

class ViewController: UIViewController {
    // PhotoPicker
    let popupPhotoPicker = PhotoPickerCollectionViewController()
    // 하단 SVG이미지들을 선택할 수 있는 scrollview
    let svgScrollView = SVGScrollView()
    // '저장하기'버튼을 눌렀을 경우 사용할 로딩뷰
    let loadingIndicator = UIActivityIndicatorView(style: .large)
    // 화면 넓이
    let screenWidth = UIScreen.main.bounds.size.width
    // Photopicker로 부터 선택된 이미지가 표시될 imageView
    var imageView = UIImageView()
    
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
    //상단 탑뷰를 더하고 버튼까지 더해준다.
    func addTopView(){
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 80))
        topView.backgroundColor = .black
        
        let saveButton = UIButton(frame: CGRect(x: screenWidth - 100, y: 40, width: 100, height: 40))
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
        loadingIndicator.color = .orange
        view.addSubview(loadingIndicator)
        
        loadingIndicator.startAnimating()
        
        guard let mergedImage = self.imageView.image else{
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
            print("Error: \(error!.localizedDescription)")
        } else {
            self.present(alert, animated: true, completion: nil)
        }
    }
    //사진앱에 선택되서 표시될 자리에 이미지 뷰 추가
    func addImageView(){
        let frame = CGRect(x: (screenWidth / 2) - (screenWidth / 2), y: (UIScreen.main.bounds.height / 2) - (screenWidth / 2), width: screenWidth, height: screenWidth)
        
        self.imageView.frame = frame
        self.imageView.contentMode = .scaleAspectFit
        
        self.view.addSubview(imageView)
    }
    //선택된 svg 이미지를 사진앱에서 선택된 이미지 가운데에 합성하는 로직
    func showSelectedSVG(image: UIImage){
        //svg이미지 사이즈 조정을 위한 이미지뷰
        let svgImage = UIImageView()
        
        svgImage.image = image
        svgImage.frame.size = CGSize(width: 70, height: 70)
        svgImage.contentMode = .scaleAspectFit
        
        guard let albumImg = self.imageView.image,
              let svgImg = svgImage.image else{
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
    
        imageView.image = mergedImage
        
    }
    // 사진앱에서 추가될 이미지 입히기
    func showSelectedImage(image: UIImage){
        self.imageView.image = image
    }
    //scrollview를 추가해주고 constraint 지정
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
        case .getImage:
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
