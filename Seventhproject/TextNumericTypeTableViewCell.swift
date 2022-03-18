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
		return textfield
	}()
	var button: UIButton = {
		var button = UIButton()
		button.backgroundColor = .orange
		return button
	}()

	var valuesPicker = UIPickerView()
	private lazy var infoLable = UILabel()
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
		let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(cancelClicked))

		toolBar.setItems([doneButton], animated: true)

		infoLable.snp.makeConstraints { (make) -> Void in
			make.leading.equalTo(contentView.snp_leadingMargin)
			make.top.equalTo(contentView.snp_topMargin)
			make.trailing.equalTo(textField.snp_leadingMargin).offset(-40)
		}

		textField.snp.makeConstraints { (make) -> Void in
		//	make.leading.equalTo(infoLable.snp_trailingMargin).offset(20)
			make.trailing.equalTo(contentView.snp_trailingMargin)
			make.top.equalTo(contentView.snp_topMargin)
		}
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
		case "TEXT" : print("TEXT")
			textField.keyboardType = .default
		case "NUMERIC" : print("NUMERIC")
			textField.keyboardType = .numbersAndPunctuation
		case "LIST" : print("NUMERIC")
			textField.inputView = valuesPicker
		default:
			break
		}
	}
}
