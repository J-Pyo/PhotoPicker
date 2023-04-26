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
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
        self.present(popupPhotoPicker, animated: true, completion: nil);
        
    }
}

