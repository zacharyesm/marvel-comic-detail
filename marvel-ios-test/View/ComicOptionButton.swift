//
//  ComicOptionButton.swift
//  marvel-ios-test
//
//  Created by Zachary Esmaelzada on 3/18/20.
//  Copyright © 2020 Zachary Esmaelzada. All rights reserved.
//

import UIKit

protocol ComicOptionButtonDelegate {
    func comicOptionButtonPressed(text: String)
}

class ComicOptionButton: UIView {
    
    var delegate: ComicOptionButtonDelegate?
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var label: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 1
        lbl.textColor = .white
        lbl.font = UIFont.customFontBold(size: 14)
        return lbl
    }()
    
    convenience init(image: UIImage, text: String) {
        self.init(frame: CGRect.zero)
        imageView.image = image
        label.text = text
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonPressed() {
        guard let text = label.text else { return }
        delegate?.comicOptionButtonPressed(text: text)
    }
    
    private func configureView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = COLOR_BACKGROUND_BLACK
        layer.cornerRadius = 10
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(buttonPressed))
        addGestureRecognizer(tap)
        
        let margins = layoutMarginsGuide
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: margins.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            imageView.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.2)
        ])
        
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .white
        separatorView.alpha = 0.2
        addSubview(separatorView)
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: margins.topAnchor),
            separatorView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 5),
            separatorView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            separatorView.widthAnchor.constraint(equalToConstant: 1)
        ])
        
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: margins.topAnchor),
            label.leadingAnchor.constraint(equalTo: separatorView.leadingAnchor, constant: 5),
            label.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        ])
        
    }

}
