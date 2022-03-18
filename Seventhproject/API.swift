//
//  API.swift
//  Seventhproject
//
//  Created by Tatsiana Marchanka on 16.03.22.
//

import Foundation

class API: NSObject {

	// MARK: - Block implementation

	func fetch<T: Decodable> (urlString: String,
							  completion: @escaping((Result<T, CustomError>) -> Void)) {
			guard let url = URL(string: urlString) else {
				print("Error: Invalid URL.")
				return
			}
			let configuration = URLSessionConfiguration.default
			configuration.timeoutIntervalForRequest = 30
			let session = URLSession(configuration: configuration)
			session.dataTask(with: url) { (data, _, error) in
				if error != nil {
					completion(.failure(.errorGeneral))
					return
				}
				guard let data = data else {
					completion(.failure(.corruptedData))
					return
				}
				let decoder = JSONDecoder()
				do {
					let decodedData = try decoder.decode(T.self, from: data)
						completion(.success(decodedData))
				} catch {
					print("Error: \(error.localizedDescription)")
				}
			}.resume()
	}

	func makePOSTRequest <T: Decodable> (url: String, data: [String : [String : String]], completion: @escaping((Result<T, Error>) -> Void)) {
		guard let url = URL(string: url)
		else {return}
		var request = URLRequest(url: url)

		let jsonBody = data

		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		guard let httpBody =  try? JSONSerialization.data(withJSONObject: jsonBody, options: []) else {return}
		request.httpBody = httpBody

		let configuration = URLSessionConfiguration.default
		configuration.timeoutIntervalForRequest = 30
		let session = URLSession(configuration: configuration)
		session.dataTask(with: request) {
			data, _, error in

			if error != nil {
				completion(.failure(error!))
			}

			guard let data = data, error == nil else {
				return
			}
			do {
				let decoder = JSONDecoder()
				let decodedData = try decoder.decode(T.self, from: data)
				completion(.success(decodedData))
			} catch  {
				completion(.failure(error))
				print(error)
			}

		}.resume()
	}
}

enum CustomError: Error {
	case corruptedData
	case errorGeneral
}
