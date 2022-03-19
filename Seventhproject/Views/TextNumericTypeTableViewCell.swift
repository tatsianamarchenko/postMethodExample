//
//  InfoTableViewCell.swift
//  Seventhproject
//
//  Created by Tatsiana Marchanka on 16.03.22.
//

import UIKit
import SnapKit

class TextNumericTypeTableViewCell: UITableViewCell {
	static var cellIdentifier = "InfoTableViewCell"

	var textField: UITextField = {
		var textfield = UITextField()
		textfield.layer.cornerRadius = 5
		textfield.layer.borderWidth = 1
		textfield.translatesAutoresizingMaskIntoConstraints = false
		return textfield
	}()
	var button: UIButton = {
		var button = UIButton()
		button.backgroundColor = .orange
		return button
	}()

	var valuesPicker = UIPickerView()

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
		contentView.addSubview(button)
		toolBar.barStyle = UIBarStyle.default
		toolBar.isTranslucent = true
		toolBar.tintColor = .systemMint
		toolBar.sizeToFit()
		let doneButton = UIBarButtonItem(title: NSLocalizedString("doneButtonText", comment: ""), style: UIBarButtonItem.Style.done, target: self, action: #selector(cancelClicked))

		toolBar.setItems([doneButton], animated: true)
		
		NSLayoutConstraint.activate([
			infoLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
			infoLable.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
		])
		NSLayoutConstraint.activate([
			textField.leadingAnchor.constraint(equalTo: infoLable.trailingAnchor, constant: 10),
			textField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2.5),
			textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
			textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
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
		textField.accessibilityIdentifier = model.name
		infoLable.lineBreakMode = NSLineBreakMode.byWordWrapping
		infoLable.numberOfLines = 0
		textField.inputAccessoryView = toolBar
		switch model.type {
		case "TEXT" :
			textField.keyboardType = .default
		case "NUMERIC" :
			textField.keyboardType = .numbersAndPunctuation
		case "LIST" :
			textField.inputView = valuesPicker
		default:
			break
		}
	}
}
