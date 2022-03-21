//
//  ValuesViewController.swift
//  Seventhproject
//
//  Created by Tatsiana Marchanka on 17.03.22.
//

import UIKit
import SnapKit

class ValuesViewController: UIViewController {

	let constants = Constants()
	var objectArray = [Row]()

	var valuesPicker: UIPickerView = {
		let picker = UIPickerView()
		picker.translatesAutoresizingMaskIntoConstraints = false
		return picker
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground
		view.addSubview(valuesPicker)

		valuesPicker.dataSource = self
		valuesPicker.delegate = self

		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .close,
			target: self,
			action: #selector(cancel))

		valuesPicker.snp.makeConstraints { (make) -> Void in
			make.leading.equalToSuperview().offset(10)
			make.trailing.equalToSuperview().offset(-10)
			make.top.equalToSuperview()
		}
		NSLayoutConstraint.activate([
			valuesPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constants.generalOffset),
			valuesPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constants.generalOffset),
			valuesPicker.topAnchor.constraint(equalTo: view.topAnchor)
		])
	}

	@objc func cancel() {
		dismiss(animated: true)
	}

	init(values: [Row]) {
		super.init(nibName: nil, bundle: nil)
		self.objectArray = values
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}

extension ValuesViewController: UIPickerViewDelegate, UIPickerViewDataSource {

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		constants.numberOfPickerComponents
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		objectArray.count
	}

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return objectArray[row].value
	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		RequestViewController.listValue = objectArray[row].key
	}
}
