//
//  PhotoPickerCollectionViewCell.swift
//  Pixo
//
//  Created by 홍정표 on 2023/04/25.
//

import UIKit

class PhotoPickerCollectionViewCell: UICollectionViewCell {
    
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addImage(image: UIImage?, size: CGSize){
        guard let image = image else{
            return
        }
        imageView.image = image
        imageView.frame.size = size
        
        self.addSubview(imageView)
    }
    
}
