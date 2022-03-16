//
//  InfoModel.swift
//  Seventhproject
//
//  Created by Tatsiana Marchanka on 17.03.22.
//

import Foundation

struct Empty: Codable {
	let title: String
	let image: String
	let fields: [Field]
}

struct Field: Codable {
	let title, name, type: String
	let values: Values?
}

struct Values: Codable {
	let none, v1, v2, v3: String
}
