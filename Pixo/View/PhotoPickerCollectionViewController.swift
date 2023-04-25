//
//  PhotoPickerCollectionViewController.swift
//  Pixo
//
//  Created by 홍정표 on 2023/04/24.
//

import UIKit

private let reuseIdentifier = "Cell"

class PhotoPickerCollectionViewController: UICollectionViewController {
    
    let layout = UICollectionViewFlowLayout()
    
    init() {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //열 갯수
        let columnCount = 3
        //테두리 여백
        let sectionInsets = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        //디바이스 화면 크기
        let deviceScreenWidth = UIScreen.main.bounds.width
        //테두리 여백 적용
        layout.sectionInset = sectionInsets
        //Cell 양옆 최소 간격
        layout.minimumInteritemSpacing = 10
        //Cell 위아래 최소 간격
        layout.minimumLineSpacing = 10
        // Cell 사이즈 = (화면크기 - (여백좌우 + (cell간격 * 간격 갯수))) / 열 갯수
        let cellSize = (Int(deviceScreenWidth) - Int(sectionInsets.left + sectionInsets.right + (layout.minimumInteritemSpacing * CGFloat((columnCount - 1))))) / columnCount
        print(cellSize)
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        
        // Register cell class
        self.collectionView!.register(PhotoPickerCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 30
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoPickerCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        cell.backgroundColor = .red
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

