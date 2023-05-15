//
//  PhotoPickerCollectionViewController.swift
//  PhotoPicker
//
//  Created by 홍정표 on 2023/04/24.
//

import UIKit
import Photos

protocol PhotoPickerViewControllerDelegate: AnyObject{
    func didUpdateState(to state: PhotoPickerViewControllerState)
}
enum PhotoPickerViewControllerState{
    //선택된 Image 가져오기
    case getImage
    //Error
    case error(reason: String)
}

class PhotoPickerCollectionViewController: UICollectionViewController {
    //CollectionView Layout
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
    //선택된 Asset
    var selectedImage: UIImage?{
        didSet{
            dismiss(animated: true) {
                //사진앱 변화 감지를 안해도 되서 등록 해제
                PHPhotoLibrary.shared().unregisterChangeObserver(self)
                self.delegate?.didUpdateState(to: .getImage)
            }
        }
    }
    weak var delegate: PhotoPickerViewControllerDelegate?
    
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
        
        let cellSize = calcCellSize()
        //CellSize 적용
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        
        viewModel.delegate = self
        viewModel.fetchAllPhotos()
        //사진앱의 변화를 감지 하기 위해 등록
        PHPhotoLibrary.shared().register(self)
        // Register cell class
        self.collectionView?.register(PhotoPickerCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
    }
    // Cell 사이즈 구하기 = (화면크기 - (여백좌우 + (cell간격 * 간격 갯수))) / 열 갯수
    func calcCellSize() -> Int{
        let cellSize = (Int(deviceScreenWidth) - Int(self.sectionInsets.left + self.sectionInsets.right + (cellSpacing * CGFloat((columnCount - 1))))) / columnCount
        
        return cellSize
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    //셀 갯수
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.allPhoto?.count ?? 0
    }
    //셀을 indexpath에 맞게 반환함
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
    
    // cell을 선택했을때 로직
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let asset = viewModel.allPhoto?.object(at: indexPath.row)
        guard let asset = asset else{
            return true
        }
        viewModel.selectAsset(selectedAsset: asset)

        return true
    }

}
//PhotoPickerViewModel에 관한 Delegate
extension PhotoPickerCollectionViewController: PhotoPickerViewModelDelegate{
    func didUpdateState(to state: PhotoPickerViewModelState) {
        switch state {
        case .gotPhoto:
            //collectionView.reloadData()는 메인 스레드에서만 실행해야 한다.
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        case .gotImage:
            self.selectedImage = viewModel.pickImage
        case .error(let reason):
            print("error : \(reason)")
        }
    }
}
extension PhotoPickerCollectionViewController: PHPhotoLibraryChangeObserver{
    //사진앱에 변화가 생겼을 경우 실행됨
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        viewModel.fetchAllPhotos()
    }
}
