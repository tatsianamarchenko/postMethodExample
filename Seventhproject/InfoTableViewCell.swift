//
//  InfoTableViewCell.swift
//  Seventhproject
//
//  Created by Tatsiana Marchanka on 16.03.22.
//

import UIKit
import SnapKit

class InfoTableViewCell: UITableViewCell {
	static var cellIdentifier = "InfoTableViewCell"

	private lazy var textField: UITextField = {
		var textfield = UITextField()
		textfield.layer.cornerRadius = 5
		textfield.layer.borderWidth = 1
		return textfield
	}()

	var buttom: UIButton = {
		var buttom = UIButton()
		buttom.tintColor = .magenta
		return buttom
	}()

	private lazy var infoLable = UILabel()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.addSubview(textField)
		contentView.addSubview(infoLable)
		infoLable.snp.makeConstraints { (make) -> Void in
			make.leading.equalTo(contentView.snp_leadingMargin)
			make.top.equalTo(contentView.snp_topMargin)
		}

		textField.snp.makeConstraints { (make) -> Void in
			make.leading.equalTo(infoLable.snp_trailingMargin).offset(20)
			make.trailing.equalTo(contentView.snp_trailingMargin)
			make.top.equalTo(contentView.snp_topMargin)
		}

	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func config (model: Field) {
		infoLable.text = model.title
		textField.placeholder = model.type
		switch model.type {
		case "TEXT" : print("TEXT")
			textField.keyboardType = .default
		case "NUMERIC" : print("NUMERIC")
			textField.keyboardType = .numberPad
		case "LIST" : print("LIST")
		default:
			break
		}
		
	}

}
