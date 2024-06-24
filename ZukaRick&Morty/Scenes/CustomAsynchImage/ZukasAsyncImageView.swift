//
//  ZukasAsyncImageView.swift
//  ZukaRick&Morty
//
//  Created by Zuka Papuashvili on 19.06.24.
//

import UIKit
import SwiftUI

class ZukasAsyncImageView: UIImageView {
    private static var imageCache = NSCache<NSString, UIImage>()
    
    func loadImage(from url: String) {
        if let cachedImage = ZukasAsyncImageView.imageCache.object(forKey: url as NSString) {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data), error == nil else { return }
            
            ZukasAsyncImageView.imageCache.setObject(image, forKey: url.absoluteString as NSString)
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}

struct ZukasAsyncImage: UIViewRepresentable {
    let url: String
    
    func makeUIView(context: Context) -> ZukasAsyncImageView {
        return ZukasAsyncImageView()
    }
    
    func updateUIView(_ uiView: ZukasAsyncImageView, context: Context) {
        uiView.loadImage(from: url)
    }
}
