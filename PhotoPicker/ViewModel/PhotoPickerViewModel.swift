//
//  PhotoPickerViewModel.swift
//  PhotoPicker
//
//  Created by 홍정표 on 2023/04/25.
//

import Foundation
import Photos
import UIKit

protocol PhotoPickerViewModelDelegate: AnyObject{
    func didUpdateState(to state: PhotoPickerViewModelState)
}
enum PhotoPickerViewModelState{
    //이미지 불러오기 완료
    case gotPhoto
    //이미지 데이터 가져오기 완료
    case gotImage
    //Error
    case error(reason: String)
}
class PhotoPickerViewModel{
    weak var delegate: PhotoPickerViewModelDelegate?

    var allPhoto: PHFetchResult<PHAsset>?{
        didSet{
            self.delegate?.didUpdateState(to: .gotPhoto)
        }
    }
    var pickImage: UIImage?{
        didSet{
            self.delegate?.didUpdateState(to: .gotImage)
        }
    }
    let imageManager = PHImageManager()
    //모든 사진의 Asset을 가져옴
    func fetchAllPhotos(){
        let options = PHFetchOptions()
        //최신순
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        self.allPhoto = PHAsset.fetchAssets(with: options)
    }
    //사진을 선택했을 경우 이미지를 꺼내옴
    func selectAsset(selectedAsset: PHAsset) {
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = PHImageRequestOptionsDeliveryMode.opportunistic
        options.isNetworkAccessAllowed = true
        
        imageManager.requestImage(for: selectedAsset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: options) { image, _ in
           
            self.pickImage = image
        }
    }
}
