//
//  Utils.swift
//  iOS Example
//  
//  Copyright © 2018 Coinbase All rights reserved.
// 

import Foundation
import CoinbaseSDK

public struct Utils {
    
    public static func loadImage(from link: String?, completion: @escaping (UIImage?) -> Void ) {
        guard let link = link,
            let url = URL(string: link) else {
                completion(nil)
                return
        }
        URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let data = data else {
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                completion(image)
            }
        }).resume()
    }
    
}
