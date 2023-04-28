//
//  SVGScrollView.swift
//  Pixo
//
//  Created by 홍정표 on 2023/04/26.
//

import UIKit
protocol SVGScrollViewDelegate: AnyObject{
    func didUpdateState(to state: SVGScrollViewState)
}
enum SVGScrollViewState{
    //ViewController 이미지 보내기
    case sendImageInfo
    //Error
    case error(reason: String)
}
class SVGScrollView: UIScrollView {
    // svg 이미지 이름 리스트
    var svgImageName = ["001", "002", "003", "004", "005", "006", "007", "008", "009", "010", "011", "012", "013", "014"]
    //이미지를 담을 View
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
        }()
    
    
    weak var svgDelegate: SVGScrollViewDelegate?
    
    var sendedImg: UIImage?{
        didSet{
            self.svgDelegate?.didUpdateState(to: .sendImageInfo)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(stackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addSvgImageToStackView(target: ViewController){
        
        for name in svgImageName {
            //stackView 이미지를 표현할 이미지뷰
            let imageView = UIImageView()
            imageView.image = UIImage(named: name)
            imageView.translatesAutoresizingMaskIntoConstraints = true
            imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
            imageView.contentMode = .scaleAspectFit
            
            //클릭 가능하도록 설정
            imageView.isUserInteractionEnabled = true
            //제쳐스 추가
            let gesture = MyTapGesture(target: self, action: #selector(self.viewTapped))
            gesture.image = UIImage(named: name) ?? UIImage()
            imageView.addGestureRecognizer(gesture)
    
            stackView.addArrangedSubview(imageView)
        }
    }
    @objc func viewTapped(_ sender: MyTapGesture) {
        let image = sender.image
        sendedImg = image
    }
}
class MyTapGesture: UITapGestureRecognizer {
    var image = UIImage()
}
