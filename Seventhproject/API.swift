//
//  API.swift
//  Seventhproject
//
//  Created by Tatsiana Marchanka on 16.03.22.
//

import Foundation

class API: NSObject {
	let urlATMsString = "http://test.clevertec.ru/tt/meta/"


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
				if let error = error {
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

	func makePOSTRequest() {
		guard let url = URL(string: "http://test.clevertec.ru/tt/data/")
		else {return}
		var request = URLRequest(url: url)

		let jsonBody = ["form": ["text": "bhjnkl", "numeric": "fdbrb", "list": "v1"]]

		request.httpMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		guard let httpBody =  try? JSONSerialization.data(withJSONObject: jsonBody, options: []) else {return}
		request.httpBody = httpBody
		let session = URLSession.shared
		session.dataTask(with: request) {
			data, response, error in
			if let response = response {
				print(response)
			}
			guard let data = data, error == nil else {
				return
			}
			do {
				let response = try JSONSerialization.jsonObject(with: data, options: [])
				print(response)
				let decoder = JSONDecoder()
				let decodedData = try decoder.decode(Response.self, from: data)
				print(decodedData.result)
			} catch  {
				print(error)
			}

		}.resume()
	}
}

enum CustomError: Error {
	case corruptedData
	case errorGeneral
}

