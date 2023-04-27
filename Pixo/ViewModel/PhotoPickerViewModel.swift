//
//  PhotoPickerViewModel.swift
//  Pixo
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
    
    func fetchAllPhotos(){
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        self.allPhoto = PHAsset.fetchAssets(with: options)
        
        guard let allPhoto = allPhoto else{
            return
        }
        print(allPhoto.count)
    }
    
    func selectAsset(selectedAsset: PHAsset) {
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
        options.isNetworkAccessAllowed = true
        
        imageManager.requestImage(for: selectedAsset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: options) { image, _ in
           
            self.pickImage = image
        }
    }
    
}
