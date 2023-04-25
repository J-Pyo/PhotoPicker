//
//  ViewController.swift
//  Pixo
//
//  Created by 홍정표 on 2023/04/24.
//

import UIKit

class ViewController: UIViewController {

    let popupPhotoPicker = PhotoPickerCollectionViewController()
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        popupPhotoPicker.collectionView.delegate = self
//        popupPhotoPicker.collectionView.dataSource = self
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
        self.present(popupPhotoPicker, animated: true, completion: nil);
        
    }
}

//extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//
//
//}

