//
//  SVGScrollView.swift
//  Pixo
//
//  Created by 홍정표 on 2023/04/26.
//

import UIKit
class SVGScrollView: UIScrollView {
    var svgImageName = ["001", "002", "003", "004", "005", "006", "007", "008", "009", "010", "011", "012", "013", "014"]
    //이미지를 담을 View
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
        }()
    
    var imageBtn = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(stackView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addSvgImageToStackView(){
        for name in svgImageName {
            //stackView 이미지를 표현할 이미지뷰
            let imageView = UIImageView()
            imageView.image = UIImage(named: name)
            imageView.translatesAutoresizingMaskIntoConstraints = true
            imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
            imageView.contentMode = .scaleAspectFit
            stackView.addArrangedSubview(imageView)
        }
    }
}

