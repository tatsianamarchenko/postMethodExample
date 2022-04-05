//
//  RequestViewController.swift
//  Seventhproject
//
//  Created by Tatsiana Marchanka on 15.03.22.
//

import UIKit

import NVActivityIndicatorView

class RequestViewController: UIViewController {
	let constants = Constants()
	var tableFieldsArray = [Field]()
	var textValue = Constants().emptyStringUserResponse
	var numericValue = Constants().emptyStringUserResponse
	static var listValue = Constants().emptyStringUserResponse
	var objectArray = [PickerRow]()

	private lazy var image: UIImageView = {
		let image = UIImageView()
		image.translatesAutoresizingMaskIntoConstraints = false
		return image
	}()

	private lazy var activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: view.frame.midX-50, y: view.frame.midY-50, width: 100, height: 100),
																	 type: .ballZigZag, color: constants.mainColor, padding: nil)

	private lazy var infoTable: UITableView = {
		let table = UITableView()
		table.register(TextNumericTypeTableViewCell.self, forCellReuseIdentifier: TextNumericTypeTableViewCell.cellIdentifier)
		table.register(ListTypeTableViewCell.self, forCellReuseIdentifier: ListTypeTableViewCell.cellIdentifier)
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
		activityIndicatorView.startAnimating()
		loadInfo()
		view.backgroundColor = .systemBackground
		view.addSubview(infoTable)
		view.addSubview(image)
		view.addSubview(activityIndicatorView)
		NSLayoutConstraint.activate([
			infoTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			infoTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			infoTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			infoTable.bottomAnchor.constraint(equalTo: view.centerYAnchor)
		])

		NSLayoutConstraint.activate([
			image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constants.generalOffset),
			image.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constants.generalOffset),
			image.topAnchor.constraint(equalTo: infoTable.bottomAnchor)
		])
	}

	func loadInfo() {
		API().fetch(urlString: constants.getUrl) { (result: Result<FullResponse, CustomError>)  in
			switch result {
			case .success(let success):
				self.tableFieldsArray = success.fields
				self.image.downloadedFrom(url: success.image)
				DispatchQueue.main.async { [weak self] in
					self?.title = success.title
					self?.fillFields()
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

	func fillFields() {
		self.infoTable.reloadData()
		var valuesRecived: Values?
		for index in 0..<self.tableFieldsArray.count {
			if self.tableFieldsArray[index].values != nil {
				valuesRecived = self.tableFieldsArray[index].values
			}
		}
		let valuesDictionary = ["none": valuesRecived?.noneValue,
								"v1": valuesRecived?.firstValue,
								"v2": valuesRecived?.secondValue,
								"v3": valuesRecived?.therdValue ]
		for (key, value) in valuesDictionary {
			self.objectArray.append(PickerRow(key: key, value: value!))
		}
		self.objectArray.sort {
			$0.key < $1.key
		}
		self.activityIndicatorView.stopAnimating()
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
		let userData = ["form": ["text": textValue, "numeric": numericValue, "list": RequestViewController.listValue]]
		API().makePOSTRequest(url: constants.postUrl, data: userData) { [self] (result: Result<Response, Error>)  in
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
			sender.text = textFilter.filter { constants.ruSymbols.contains($0) ||
				constants.engSymbols.contains($0) ||
				constants.numbers.contains($0)}
			textValue = sender.text ?? constants.emptyStringUserResponse
		}
		if	sender.accessibilityIdentifier == constants.numericTypeIdentifier {
			guard let textFilter = sender.text else { return }
			sender.text = textFilter.filter {constants.numbers.contains($0) || constants.symbol.contains($0)}
		}
	}

	@objc func openPickerVC() {

			let nav = UINavigationController(rootViewController: ValuesViewController(values: objectArray))
			nav.modalPresentationStyle = .automatic
			if let sheet = nav.sheetPresentationController {
				sheet.detents = [.medium(), .large()]
			}
			present(nav, animated: true, completion: nil)

		}
}

extension RequestViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tableFieldsArray.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if tableFieldsArray[indexPath.row].type == constants.textTypeIdentifier ||
			tableFieldsArray[indexPath.row].type == constants.numericTypeIdentifier {
			if let cell = infoTable.dequeueReusableCell(withIdentifier: TextNumericTypeTableViewCell.cellIdentifier,
														for: indexPath)
				as? TextNumericTypeTableViewCell {
				cell.config(model: tableFieldsArray[indexPath.row])
				cell.textField.delegate = self
				cell.backgroundColor = .clear
				cell.textField.addTarget(self, action: #selector(filterOfTextField(sender:)), for: UIControl.Event.editingChanged)
				return cell
			}
		}
		if tableFieldsArray[indexPath.row].type == constants.listTypeIdentifier {
			if let cell = infoTable.dequeueReusableCell(withIdentifier: ListTypeTableViewCell.cellIdentifier, for: indexPath)
				as? ListTypeTableViewCell {
				cell.config(model: tableFieldsArray[indexPath.row])
				cell.button.addTarget(self, action: #selector(openPickerVC), for: .touchUpInside)
				return cell
			}
		}
		return UITableViewCell()
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		constants.heightForRow
	}

	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let buttom = UIButton()
		buttom.backgroundColor = constants.mainColor
		buttom.setTitle(NSLocalizedString("buttonText", comment: ""), for: .normal)
		buttom.setTitleColor(.systemPink, for: .highlighted)
		buttom.addTarget(self, action: #selector(send), for: .touchUpInside)
		return buttom
	}

	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		constants.heightForFooter
	}
}

extension RequestViewController: UITextFieldDelegate {

	func textField(_ textField: UITextField,
				   shouldChangeCharactersIn range: NSRange,
				   replacementString string: String) -> Bool {
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
				afterDelay: constants.delayTime)
			return true
		}
		return true
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}
