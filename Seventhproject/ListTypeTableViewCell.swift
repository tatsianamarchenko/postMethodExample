//
//  ListTypeTableViewCell.swift
//  Seventhproject
//
//  Created by Tatsiana Marchanka on 17.03.22.
//

import UIKit

class ListTypeTableViewCell: UITableViewCell {

	static var cellIdentifier = "ListTypeTableViewCell"

	private lazy var infoLable = UILabel()

	var buttom: UIButton = {
		var buttom = UIButton()
		buttom.backgroundColor = .systemMint
		buttom.layer.cornerRadius = 3
		return buttom
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.addSubview(buttom)
		contentView.addSubview(infoLable)
		infoLable.snp.makeConstraints { (make) -> Void in
			make.leading.equalTo(contentView.snp_leadingMargin)
			make.trailing.equalTo(buttom.snp_leadingMargin).offset(-40)
			make.top.equalTo(contentView.snp_topMargin)
		}

		buttom.snp.makeConstraints { (make) -> Void in
			make.trailing.equalTo(contentView.snp_trailingMargin)
			make.top.equalTo(contentView.snp_topMargin)
		}
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func config (model: Field) {
		infoLable.text = model.title
		infoLable.lineBreakMode = NSLineBreakMode.byWordWrapping
		infoLable.numberOfLines = 0
		buttom.setTitle(model.type, for: .normal)
	}
}
