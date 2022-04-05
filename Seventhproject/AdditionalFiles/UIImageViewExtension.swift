//
//  ImageExtension.swift
//  Seventhproject
//
//  Created by Tatsiana Marchanka on 18.03.22.
//

import UIKit

extension UIImageView {

	func downloadedFrom(url: String) {
		guard let url = URL(string: url) else { return }
		URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
			guard let data = data, error == nil, let image = UIImage(data: data) else { return }
			DispatchQueue.main.async { () -> Void in
				self.image = image
			}
		}).resume()
	}
}
