//
//  InfoModel.swift
//  Seventhproject
//
//  Created by Tatsiana Marchanka on 17.03.22.
//

import Foundation

struct FullResponse: Codable {
	let title: String
	let image: String
	let fields: [Field]
}

struct Field: Codable {
	let title, name, type: String
	let values: Values?
}

struct Values: Codable {
	let noneValue, firstValue, secondValue, therdValue: String

	enum CodingKeys: String, CodingKey {
		case noneValue = "none"
		case firstValue = "v1"
		case secondValue = "v2"
		case therdValue = "v3"
	}
}
