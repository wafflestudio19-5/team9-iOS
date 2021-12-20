//
//  GradientIcon.swift
//  Facebook
//
//  Created by 박신홍 on 2021/12/17.
//

import SwiftUI

class GradientIcon: UIView {
    
    private lazy var iconSize: CGFloat = {
        return self.frame.size.width
    }()
    
    convenience init(width: CGFloat) {
        self.init(frame: CGRect(x: 0, y: 0, width: width, height: width))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setGradientBackground()
        self.setLayout()
        self.setIconImage()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setGradientBackground()
        self.setLayout()
        self.setIconImage()
    }
    
    private func setIconImage() {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: iconSize / 1.8)
        let image = UIImage(systemName: "hand.thumbsup.fill", withConfiguration: symbolConfig)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        let imageView = UIImageView(image: image)
        self.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    private func setLayout() {
        self.setContentHuggingPriority(.required, for: .horizontal)
        self.setContentHuggingPriority(.required, for: .vertical)
        self.layer.cornerRadius = iconSize / 2
        self.clipsToBounds = true
    }
    
    private func setGradientBackground() {
        let colorTop =  UIColor(red: 60.0/255.0, green: 160/255.0, blue: 251/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 39/255.0, green: 90/255.0, blue: 255/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: iconSize, height: iconSize)
        self.layer.insertSublayer(gradientLayer, at:0)
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: iconSize, height: iconSize)
    }
}

/*
 MARK: SwiftUI Preview
 */

struct GradientIconRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> GradientIcon {
        let view = GradientIcon(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        return view
    }
    
    func updateUIView(_ icon: GradientIcon, context: Context) {}
}

struct GradientIcon_Previews: PreviewProvider {
    static var previews: some View {
        GradientIconRepresentable()
    }
}
