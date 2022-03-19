//
//  Constants.swift
//  Seventhproject
//
//  Created by Tatsiana Marchanka on 18.03.22.
//

import Foundation
import UIKit

struct Constants {
	let symbol = ".,"
	let ruSymbols = "йцукенгшщзхъфывапролджэёячсмитьбюЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЁЯЧСМИТЬБЮ"
	let engSymbols = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM"
	let numbers = "1234567890"

	let textTypeIdentifier = "TEXT"
	let numericTypeIdentifier = "NUMERIC"
	let listTypeIdentifier = "LIST"

	let emptyStringUserResponse = "empty"

	let getUrl = "http://test.clevertec.ru/tt/meta/"
	let postUrl = "http://test.clevertec.ru/tt/data/"

	let heightForFooter: CGFloat = 30
	let heightForRow: CGFloat = 60
	let numberOfPickerComponents = 1
	let generalOffset: CGFloat = 10
	let widthOfTextFields = UIScreen.main.bounds.width/2.5

	let mainColor: UIColor = .systemMint
}
