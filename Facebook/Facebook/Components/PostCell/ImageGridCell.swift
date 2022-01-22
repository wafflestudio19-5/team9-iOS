//
//  ImageGridCell.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/30.
//

import UIKit
import PhotosUI
import Kingfisher

class ImageGridCell: UICollectionViewCell {
    static let reuseIdentifier = "ImageGridCell"
    
    let progressView: UIProgressView = {
        let progress = UIProgressView()
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let livePhotoView: PHLivePhotoView = {
        let imageView = PHLivePhotoView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.grayscales.imageBorder.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        contentView.addSubview(progressView)
        contentView.addSubview(imageView)
        contentView.addSubview(livePhotoView)
        
        NSLayoutConstraint.activateFourWayConstraints(subview: imageView, containerView: contentView)
        NSLayoutConstraint.activateFourWayConstraints(subview: livePhotoView, containerView: contentView)
        NSLayoutConstraint.activateCenterConstraints(subview: progressView, containerView: contentView)
    }
}

// MARK: From URL
extension ImageGridCell {
    func displayMedia(from url: URL?) {
        guard let url = url else {
            return
        }

        KF.url(url)
          .setProcessor(KFProcessors.shared.downsampling)
          .loadDiskFileSynchronously()
          .cacheMemoryOnly()
          .fade(duration: 0.1)
          .set(to: imageView)
    }
}

// MARK: From PHPicker
extension ImageGridCell {
    func displayMedia(from pickerResult: PHPickerResult) {
        let progress: Progress?
        let itemProvider = pickerResult.itemProvider
        
        if itemProvider.canLoadObject(ofClass: PHLivePhoto.self) {
            progress = itemProvider.loadObject(ofClass: PHLivePhoto.self) { [weak self] livePhoto, error in
                DispatchQueue.main.async {
                    self?.handleCompletion(object: livePhoto, error: error)
                }
            }
        }
        else if itemProvider.canLoadObject(ofClass: UIImage.self) {
            progress = itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.async {
                    self?.handleCompletion(object: image, error: error)
                }
            }
        } else if itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
            progress = itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { [weak self] url, error in
                do {
                    guard let url = url, error == nil else {
                        throw error ?? NSError(domain: NSFileProviderErrorDomain, code: -1, userInfo: nil)
                    }
                    let localURL = FileManager.default.temporaryDirectory.appendingPathComponent(url.lastPathComponent)
                    try? FileManager.default.removeItem(at: localURL)
                    try FileManager.default.copyItem(at: url, to: localURL)
                    DispatchQueue.main.async {
                        self?.handleCompletion(object: localURL)
                    }
                } catch let catchedError {
                    DispatchQueue.main.async {
                        self?.handleCompletion(object: nil, error: catchedError)
                    }
                }
            }
        } else {
            progress = nil
        }
        
        displayProgress(progress)
    }
    
    private func handleCompletion(object: Any?, error: Error? = nil) {
        if let livePhoto = object as? PHLivePhoto {
            displayLivePhoto(livePhoto)
        } else if let image = object as? UIImage {
            displayImage(image)
        } else if let url = object as? URL {
//            displayVideoPlayButton(forURL: url)
        } else if let error = error {
            displayErrorImage()
        } else {
            displayUnknownImage()
        }
    }
    
    private func displayEmptyImage() {
        displayImage(UIImage(systemName: "photo.on.rectangle.angled"))
    }
    
    private func displayErrorImage() {
        displayImage(UIImage(systemName: "exclamationmark.circle"))
    }
    
    private func displayUnknownImage() {
        displayImage(UIImage(systemName: "questionmark.circle"))
    }
    
    private func displayProgress(_ progress: Progress?) {
        imageView.image = nil
        imageView.isHidden = true
        livePhotoView.livePhoto = nil
        livePhotoView.isHidden = true
        progressView.observedProgress = progress
        progressView.isHidden = progress == nil
    }
    
//    func displayVideoPlayButton(forURL videoURL: URL?) {
//        imageView.image = nil
//        imageView.isHidden = true
//        livePhotoView.livePhoto = nil
//        livePhotoView.isHidden = true
//        progressView.observedProgress = nil
//        progressView.isHidden = true
//    }
    
    private func displayLivePhoto(_ livePhoto: PHLivePhoto?) {
        imageView.image = nil
        imageView.isHidden = true
        livePhotoView.livePhoto = livePhoto
        livePhotoView.isHidden = livePhoto == nil
        progressView.observedProgress = nil
        progressView.isHidden = true
    }
    
    private func displayImage(_ image: UIImage?) {
        imageView.image = UIImage(data: (image?.jpegData(compressionQuality: 0.2))!, scale: 0.2)
        imageView.isHidden = image == nil
        livePhotoView.livePhoto = nil
        livePhotoView.isHidden = true
        progressView.observedProgress = nil
        progressView.isHidden = true
    }
}
