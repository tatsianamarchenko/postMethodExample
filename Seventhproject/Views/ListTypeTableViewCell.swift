//
//  ListTypeTableViewCell.swift
//  Seventhproject
//
//  Created by Tatsiana Marchanka on 17.03.22.
//

import UIKit

class ListTypeTableViewCell: UITableViewCell {

	static var cellIdentifier = "ListTypeTableViewCell"
	let constants = Constants()
	private lazy var infoLable = UILabel()

	var button: UIButton = {
		var button = UIButton()
		button.backgroundColor = .systemMint
		button.layer.cornerRadius = 3
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.addSubview(button)
		contentView.addSubview(infoLable)
		contentView.backgroundColor = .clear
		infoLable.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			infoLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: constants.generalOffset),
			infoLable.topAnchor.constraint(equalTo: contentView.topAnchor, constant: constants.generalOffset)
		])
		NSLayoutConstraint.activate([
			button.leadingAnchor.constraint(equalTo: infoLable.trailingAnchor, constant: constants.generalOffset),
			button.widthAnchor.constraint(equalToConstant: constants.widthOfTextFields),
			button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -constants.generalOffset),
			button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: constants.generalOffset)
		])
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func config (model: Field) {
		infoLable.text = model.title
		infoLable.lineBreakMode = NSLineBreakMode.byWordWrapping
		infoLable.numberOfLines = 0
		button.setTitle(model.type, for: .normal)
	}
}
