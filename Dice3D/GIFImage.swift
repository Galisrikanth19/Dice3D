//
//  GIFImage.swift
//  Dice3D
//
//  Created by Raju on 05/12/25.
//

import SwiftUI
import UIKit
import ImageIO

struct GIFImage: UIViewRepresentable {
    let name: String
    
    func makeUIView(context: Context) -> UIView {
        let container = UIView()
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit   // or .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = animatedImage(named: name)
        
        container.addSubview(imageView)
        
        // Pin the image view to the container’s bounds
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: container.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
        
        return container
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // nothing to update for now
    }
    
    // Load animated UIImage from gif in bundle
    private func animatedImage(named: String) -> UIImage? {
        guard
            let path = Bundle.main.path(forResource: named, ofType: "gif"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
            let source = CGImageSourceCreateWithData(data as CFData, nil)
        else { return nil }
        
        var images: [UIImage] = []
        let count = CGImageSourceGetCount(source)
        
        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: cgImage))
            }
        }
        
        // adjust duration as needed
        return UIImage.animatedImage(with: images, duration: Double(count) * 0.1)
    }
}
