//
//  ValuesViewController.swift
//  Seventhproject
//
//  Created by Tatsiana Marchanka on 17.03.22.
//

import UIKit
import SnapKit

//class ValuesViewController: UIViewController {
//	var valuesRecived: Values
//	var valuesPicker = UIPickerView()
//	var a = [String: String]()
//	var objectArray = [Row]()
//	static var returnValue = ""
//	override func viewDidLoad() {
//		super.viewDidLoad()
//		view.backgroundColor = .systemBackground
//		view.addSubview(valuesPicker)
//
//		valuesPicker.dataSource = self
//		valuesPicker.delegate = self
//
//		valuesPicker.snp.makeConstraints { (make) -> Void in
//			make.leading.equalToSuperview().offset(10)
//			make.trailing.equalToSuperview().offset(-10)
//			make.top.equalToSuperview()
//		}
//		a = ["none": valuesRecived.none, "v1": valuesRecived.v1, "v2": valuesRecived.v2, "v3": valuesRecived.v3 ]
//
//		for (key, value) in a {
//			objectArray.append(Row(key: key, value: value))
//		}
//		objectArray.sort {
//			$0.key < $1.key
//		}
//	}
//
//	init(values: Values) {
//		self.valuesRecived = values
//		super.init(nibName: nil, bundle: nil)
//	}
//
//	required init?(coder: NSCoder) {
//		fatalError("init(coder:) has not been implemented")
//	}
//
//}

//extension ValuesViewController: UIPickerViewDelegate, UIPickerViewDataSource {
//
//	func numberOfComponents(in pickerView: UIPickerView) -> Int {
//		1
//	}
//
//	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//		a.values.count
//	}
//
//
//	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//		return objectArray[row].value
// }
//
// func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//	 ValuesViewController.returnValue = objectArray[row].key
// }
//
//}

struct Row {
	var key: String
	var value: String
}
