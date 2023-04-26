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
    
    let viewModel = PhotoPickerViewModel()
    //열 갯수
    let columnCount = 3
    //테두리 여백
    let sectionInsets = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    //디바이스 화면 크기
    let deviceScreenWidth = UIScreen.main.bounds.width
    //Cell 사이 간격
    let cellSpacing = 10.0
    
    init() {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //테두리 여백 적용
        layout.sectionInset = sectionInsets
        //Cell 양옆 최소 간격
        layout.minimumInteritemSpacing = cellSpacing
        //Cell 위아래 최소 간격
        layout.minimumLineSpacing = cellSpacing
        // Cell 사이즈 = (화면크기 - (여백좌우 + (cell간격 * 간격 갯수))) / 열 갯수
        let cellSize = calcCellSize()
        //CellSize 적용
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        
        viewModel.delegate = self
        viewModel.fetchAllPhotos()
        print("cellSize : \(cellSize)")
        // Register cell class
        self.collectionView?.register(PhotoPickerCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
    }
    
    // Cell 사이즈 구하기 = (화면크기 - (여백좌우 + (cell간격 * 간격 갯수))) / 열 갯수
    func calcCellSize() -> Int{
        let cellSize = (Int(deviceScreenWidth) - Int(self.sectionInsets.left + self.sectionInsets.right + (cellSpacing * CGFloat((columnCount - 1))))) / columnCount
        
        return cellSize
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
        return viewModel.allPhoto?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let imageManager = viewModel.imageManager
        let asset = viewModel.allPhoto?.object(at: indexPath.row)
        let cellSize = calcCellSize()
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoPickerCollectionViewCell,
              let asset = asset else{
            return UICollectionViewCell()
        }
        
        imageManager.requestImage(for: asset, targetSize: CGSize(width: cellSize, height: cellSize), contentMode: .aspectFill, options: nil) { image, _ in
            cell.addImage(image: image, size: CGSize(width: cellSize, height: cellSize))
        }
        
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

extension PhotoPickerCollectionViewController: PhotoPickerViewModelDelegate{
    func didUpdateState(to state: PhotoPickerViewModelState) {
        switch state {
        case .gotPhoto:
            self.collectionView.reloadData()
        case .error(let reason):
            print("error : \(reason)")
        }
    }
    
    
}
