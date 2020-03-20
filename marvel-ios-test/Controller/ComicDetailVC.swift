//
//  ViewController.swift
//  marvel-ios-test
//
//  Created by Zachary Esmaelzada on 3/18/20.
//  Copyright © 2020 Zachary Esmaelzada. All rights reserved.
//

import UIKit

class ComicDetailVC: UIViewController {
    
    private var loadingIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.color = .white
        ai.hidesWhenStopped = true
        return ai
    }()
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private var coverBackgroundImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private var coverImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private lazy var readNowButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("READ NOW", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        btn.backgroundColor = COLOR_PURPLE
        btn.layer.cornerRadius = 10
        
        btn.addTarget(self, action: #selector(readNowButtonPressed), for: .touchUpInside)
        return btn
    }()
    
    @objc func readNowButtonPressed() {
        presentAlert(title: "Read Now", message: "readNowButtonPressed()")
    }
    
    private var comicTitle: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .white
        lbl.font = UIFont.customFont(size: 22)
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private var comicDescription: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.textColor = .white
        tv.font = UIFont.customFont(size: 18)
        tv.textContainer.lineBreakMode = .byWordWrapping
        tv.isScrollEnabled = false
        tv.backgroundColor = .clear
        return tv
    }()
    
    var comicDetail: ComicDetail? {
        didSet {
            DispatchQueue.main.async {
                self.comicTitle.text = self.comicDetail?.title
                self.comicDescription.text = self.comicDetail?.description.htmlToString
                
                if let imageUrl = self.comicDetail?.imageUrl {
                    self.getImage(url: imageUrl)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        loadingIndicator.startAnimating()
        MarvelService.service.getComicInfo(id: 1994) { (comicDetail) in
            DispatchQueue.main.async {
                self.loadingIndicator.stopAnimating()
            }
            
            guard let comic = comicDetail else {
                self.presentAlert(title: "Error", message: "Could not load Comic :(")
                return
            }
            
            self.comicDetail = comic
        }
        
    }
    
    private func getImage(url: String) {
        if let cachedImage = imageCache.object(forKey: url as NSString) {
            DispatchQueue.main.async {
                self.coverBackgroundImage.image = cachedImage
                self.coverImage.image = cachedImage
            }
            return
        }
        
        if let url = URL(string: url),
            let imageData = try? Data(contentsOf: url) {
            let image = UIImage(data: imageData)
            self.coverBackgroundImage.image = image
            self.coverImage.image = image
        }
    }
    
    private func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func setupView() {
        view.backgroundColor = COLOR_BACKGROUND_BLACK
        
        view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        let margins = containerView.layoutMarginsGuide
        
        containerView.addSubview(coverBackgroundImage)
        NSLayoutConstraint.activate([
            coverBackgroundImage.topAnchor.constraint(equalTo: containerView.topAnchor),
            coverBackgroundImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            coverBackgroundImage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            coverBackgroundImage.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        let blurEffect = UIBlurEffect(style: .regular)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurredEffectView.alpha = 0.3
        containerView.addSubview(blurredEffectView)
        NSLayoutConstraint.activate([
            blurredEffectView.topAnchor.constraint(equalTo: coverBackgroundImage.topAnchor),
            blurredEffectView.leadingAnchor.constraint(equalTo: coverBackgroundImage.leadingAnchor),
            blurredEffectView.trailingAnchor.constraint(equalTo: coverBackgroundImage.trailingAnchor),
            blurredEffectView.bottomAnchor.constraint(equalTo: coverBackgroundImage.bottomAnchor)
        ])
        
        containerView.addSubview(coverImage)
        NSLayoutConstraint.activate([
            coverImage.topAnchor.constraint(equalTo: margins.topAnchor),
            coverImage.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            coverImage.bottomAnchor.constraint(equalTo: coverBackgroundImage.bottomAnchor, constant: -10),
            coverImage.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.4)
        ])
        
        containerView.addSubview(readNowButton)
        NSLayoutConstraint.activate([
            readNowButton.topAnchor.constraint(equalTo: margins.topAnchor),
            readNowButton.leadingAnchor.constraint(equalTo: coverImage.trailingAnchor, constant: 10),
            readNowButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            readNowButton.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        let markReadButton = ComicOptionButton(image: #imageLiteral(resourceName: "check"), text: "MARK AS READ")
        markReadButton.delegate = self
        let addToLibraryButton = ComicOptionButton(image: #imageLiteral(resourceName: "plus"), text: "ADD TO LIBRARY")
        addToLibraryButton.delegate = self
        let readOfflineButton = ComicOptionButton(image: #imageLiteral(resourceName: "download"), text: "READ OFFLINE")
        readOfflineButton.delegate = self
        
        let comicOptionSV = UIStackView(arrangedSubviews: [markReadButton, addToLibraryButton, readOfflineButton])
        comicOptionSV.translatesAutoresizingMaskIntoConstraints = false
        comicOptionSV.axis = .vertical
        comicOptionSV.distribution = .fillEqually
        comicOptionSV.spacing = 10
        containerView.addSubview(comicOptionSV)
        NSLayoutConstraint.activate([
            comicOptionSV.topAnchor.constraint(equalTo: readNowButton.bottomAnchor, constant: 10),
            comicOptionSV.leadingAnchor.constraint(equalTo: coverImage.trailingAnchor, constant: 10),
            comicOptionSV.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            comicOptionSV.bottomAnchor.constraint(equalTo: coverBackgroundImage.bottomAnchor, constant: -10)
        ])
        
        containerView.addSubview(comicTitle)
        NSLayoutConstraint.activate([
            comicTitle.topAnchor.constraint(equalTo: coverBackgroundImage.bottomAnchor, constant: 10),
            comicTitle.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            comicTitle.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        ])
        
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .white
        separatorView.alpha = 0.3
        containerView.addSubview(separatorView)
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: comicTitle.bottomAnchor, constant: 20),
            separatorView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        let storyLabel = UILabel()
        storyLabel.translatesAutoresizingMaskIntoConstraints = false
        storyLabel.text = "The Story"
        storyLabel.textColor = .white
        storyLabel.font = UIFont.customFontBold(size: 18)
        containerView.addSubview(storyLabel)
        NSLayoutConstraint.activate([
            storyLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 20),
            storyLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            storyLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        containerView.addSubview(comicDescription)
        NSLayoutConstraint.activate([
            comicDescription.topAnchor.constraint(equalTo: storyLabel.bottomAnchor, constant: 5),
            comicDescription.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            comicDescription.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            comicDescription.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        ])
        
        
    }

}

extension ComicDetailVC: ComicOptionButtonDelegate {
    func comicOptionButtonPressed(text: String) {
        presentAlert(title: text, message: "Button Pressed")
    }
}

