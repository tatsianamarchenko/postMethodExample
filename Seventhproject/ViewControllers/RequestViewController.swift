//
//  RequestViewController.swift
//  Seventhproject
//
//  Created by Tatsiana Marchanka on 15.03.22.
//

import UIKit
import SnapKit
import NVActivityIndicatorView

class RequestViewController: UIViewController {
	let constants = Constants()
	var tableFieldsArray = [Field]()
	var textValue = Constants().emptyStringUserResponse
	var numericValue = Constants().emptyStringUserResponse
	var listValue = Constants().emptyStringUserResponse
	var objectArray = [Row]()
	
	private lazy var image: UIImageView = {
		let image = UIImageView()
		image.translatesAutoresizingMaskIntoConstraints = false
		return image
	}()

	private lazy var activityIndicatorView = NVActivityIndicatorView(frame: CGRect(), type: nil, color: nil, padding: nil)

	private lazy var infoTable: UITableView = {
		let table = UITableView()
		table.register(TextNumericTypeTableViewCell.self, forCellReuseIdentifier: TextNumericTypeTableViewCell.cellIdentifier)
		table.translatesAutoresizingMaskIntoConstraints = false
		table.dataSource = self
		table.delegate = self
		return table
	}()

	private lazy var alert: UIAlertController = {
		var alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil))
		return alert
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: view.frame.midX-50, y: view.frame.midY-50, width: 100, height: 100), type: .ballZigZag, color: .systemMint, padding: nil)
		activityIndicatorView.startAnimating()
		loadInfo()
		view.backgroundColor = .systemBackground
		view.addSubview(infoTable)
		view.addSubview(image)
		view.addSubview(activityIndicatorView)
		NSLayoutConstraint.activate([
			infoTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			infoTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			infoTable.topAnchor.constraint(equalTo: view.topAnchor),
			infoTable.bottomAnchor.constraint(equalTo: view.centerYAnchor),
		])

		NSLayoutConstraint.activate([
			image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
			image.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
			image.topAnchor.constraint(equalTo: infoTable.bottomAnchor)
		])
	}

	func loadInfo() {
		API().fetch(urlString: constants.getUrl) { (result: Result<Empty, CustomError>)  in
			switch result {
			case .success(let success):
				self.tableFieldsArray = success.fields
				DispatchQueue.main.async { [self] in
					self.infoTable.reloadData()
					self.title = success.title
					self.image.downloadedFrom(url: success.image)
					var valuesRecived: Values?
					for index in 0..<tableFieldsArray.count {
						if tableFieldsArray[index].values != nil {
							valuesRecived = tableFieldsArray[index].values
						}
					}
					let valuesDictionary = ["none": valuesRecived?.none, "v1": valuesRecived?.v1, "v2": valuesRecived?.v2, "v3": valuesRecived?.v3 ]
					for (key, value) in valuesDictionary {
						objectArray.append(Row(key: key, value: value!))
					}
					objectArray.sort {
						$0.key < $1.key
					}
					self.activityIndicatorView.stopAnimating()
				}
			case .failure(let failure):
				DispatchQueue.main.async { [self] in
					alert.title = NSLocalizedString("error", comment: "")
					alert.message = failure.localizedDescription
					present(alert, animated: true)
				}
			}
		}
	}


	@objc func validateNumericTextField(textField: UITextField) {
		guard var textFilter = textField.text else { return }
		textFilter = textFilter.replacingOccurrences(of: ",", with: ".")
		textField.text = textFilter
		if let number = NumberFormatter().number(from: textFilter)?.doubleValue {
			if number > 1 && number < 1024 {
				numericValue = String(number)
			} else {
				numericValue = constants.emptyStringUserResponse
				textField.text = ""
			}
		}
	}

	@objc func send() {
		activityIndicatorView.startAnimating()
		API().makePOSTRequest(url: constants.postUrl, data: ["form": ["text": textValue, "numeric": numericValue, "list": listValue]]) { [self] (result:Result<Response, Error>)  in
			switch result {
			case .success(let success):
				print(success.result)
				DispatchQueue.main.async {
					alert.title = NSLocalizedString("sended", comment: "")
					alert.message = success.result
					present(alert, animated: true)
					activityIndicatorView.stopAnimating()
				}
			case .failure(let failure):
				DispatchQueue.main.async {
					alert.title = NSLocalizedString("error", comment: "")
					alert.message = failure.localizedDescription
					present(alert, animated: true)
				}
			}
		}
	}

	@objc func filterOfTextField(sender: UITextField) {

		if	sender.accessibilityIdentifier == constants.textTypeIdentifier {
			guard let textFilter = sender.text else { return }
			sender.text = textFilter.filter { constants.ruSymbols.contains($0) || constants.engSymbols.contains($0) || constants.numbers.contains($0)}
			textValue = sender.text ?? constants.emptyStringUserResponse
		}
		if	sender.accessibilityIdentifier == constants.numericTypeIdentifier {
			guard let textFilter = sender.text else { return }
			sender.text = textFilter.filter {constants.numbers.contains($0) || constants.symbol.contains($0)}
		}
	}

}

extension RequestViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tableFieldsArray.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = infoTable.dequeueReusableCell(withIdentifier: TextNumericTypeTableViewCell.cellIdentifier, for: indexPath)
			as? TextNumericTypeTableViewCell {
			cell.config(model: tableFieldsArray[indexPath.row])
			cell.textField.delegate = self
			cell.valuesPicker.dataSource = self
			cell.valuesPicker.delegate = self
			cell.backgroundColor = .clear
			cell.textField.addTarget(self, action: #selector(filterOfTextField(sender:)), for: UIControl.Event.editingChanged)
			return cell
		}
		return UITableViewCell()
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		constants.heightForRow
	}

	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let buttom = UIButton()
		buttom.backgroundColor = .systemMint
		buttom.setTitle(NSLocalizedString("buttonText", comment: ""), for: .normal)
		buttom.setTitleColor(.systemMint, for: .highlighted)
		buttom.addTarget(self, action: #selector(send), for: .touchUpInside)
		return buttom
	}

	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		constants.heightForFooter
	}
}

extension RequestViewController: UITextFieldDelegate {

	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if textField.accessibilityIdentifier == constants.textTypeIdentifier {
			let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
			print(text)
			return true
		}
		if textField.accessibilityIdentifier == constants.numericTypeIdentifier {
			NSObject.cancelPreviousPerformRequests(
				withTarget: self,
				selector: #selector(self.validateNumericTextField),
				object: textField)
			self.perform(
				#selector(self.validateNumericTextField),
				with: textField,
				afterDelay: 2)
			return true
		}
		return true
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}

extension RequestViewController: UIPickerViewDelegate, UIPickerViewDataSource {

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		constants.numberOfPickerComponents
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		objectArray.count
	}


	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		print(objectArray[row].value)
		return objectArray[row].value
	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		listValue = objectArray[row].key
	}

}

//Выбор значения (выбирается одно значение из списка возможных). Можно как UIPickerView, так и открытием отдельного UIViewController (желательно).
//Обязательно использовать Autolayout, URLSession, Codable.
