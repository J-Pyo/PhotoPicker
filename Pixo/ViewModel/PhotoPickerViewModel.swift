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
    
    func requestImage(){
        
    }
    
}
