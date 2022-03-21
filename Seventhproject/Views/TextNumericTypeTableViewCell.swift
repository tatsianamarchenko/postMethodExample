//
//  InfoTableViewCell.swift
//  Seventhproject
//
//  Created by Tatsiana Marchanka on 16.03.22.
//

import UIKit
import SnapKit

class TextNumericTypeTableViewCell: UITableViewCell {
let constants = Constants()
	static var cellIdentifier = "InfoTableViewCell"

	var textField: UITextField = {
		var textfield = UITextField()
		textfield.layer.cornerRadius = 5
		textfield.layer.borderWidth = 1
		textfield.translatesAutoresizingMaskIntoConstraints = false
		return textfield
	}()
	
	private lazy var infoLable: UILabel = {
		let infolable = UILabel()
		infolable.translatesAutoresizingMaskIntoConstraints = false
		return infolable
	}()

	var toolBar = UIToolbar()
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.addSubview(textField)
		contentView.addSubview(infoLable)
		toolBar.barStyle = UIBarStyle.default
		toolBar.isTranslucent = true
		toolBar.tintColor = constants.mainColor
		toolBar.sizeToFit()
		let doneButton = UIBarButtonItem(title: NSLocalizedString("doneButtonText", comment: ""), style: UIBarButtonItem.Style.done, target: self, action: #selector(cancelClicked))

		toolBar.setItems([doneButton], animated: true)
		
		NSLayoutConstraint.activate([
			infoLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: constants.generalOffset),
			infoLable.topAnchor.constraint(equalTo: contentView.topAnchor, constant: constants.generalOffset)
		])
		NSLayoutConstraint.activate([
			textField.leadingAnchor.constraint(equalTo: infoLable.trailingAnchor, constant: constants.generalOffset),
			textField.widthAnchor.constraint(equalToConstant: constants.widthOfTextFields),
			textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -constants.generalOffset),
			textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: constants.generalOffset)
		])
	}


	@objc func cancelClicked(_ button: UIBarButtonItem?) {
		textField.resignFirstResponder()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func config (model: Field) {
		infoLable.text = model.title
		textField.placeholder = model.type
		textField.accessibilityIdentifier = model.type
		infoLable.lineBreakMode = NSLineBreakMode.byWordWrapping
		infoLable.numberOfLines = 0
		textField.inputAccessoryView = toolBar
		switch model.type {
		case constants.textTypeIdentifier :
			textField.keyboardType = .default
		case constants.numericTypeIdentifier :
			textField.keyboardType = .numbersAndPunctuation
		default:
			break
		}
	}
}
