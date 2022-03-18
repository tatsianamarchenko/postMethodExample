//
//  ViewController.swift
//  Seventhproject
//
//  Created by Tatsiana Marchanka on 15.03.22.
//

import UIKit
import SnapKit
import NVActivityIndicatorView

class ViewController: UIViewController {

	let constants = Constants()
	private lazy var image = UIImageView()

	private lazy var infoTable: UITableView = {
		let table = UITableView()
		table.register(TextNumericTypeTableViewCell.self, forCellReuseIdentifier: TextNumericTypeTableViewCell.cellIdentifier)
		table.translatesAutoresizingMaskIntoConstraints = false
		return table
	}()

	private lazy var alert: UIAlertController = {
		var alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil))
		return alert
	}()
	var activityIndicatorView = NVActivityIndicatorView(frame: CGRect(), type: nil, color: nil, padding: nil)
	var array = [Field]()
	override func viewDidLoad() {
		super.viewDidLoad()
		activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: view.frame.midX-50, y: view.frame.midY-50, width: 100, height: 100), type: .ballZigZag, color: .systemMint, padding: nil)
		activityIndicatorView.startAnimating()
		API().fetch(urlString: constants.getUrl) { (result: Result<Empty, CustomError>)  in
			switch result {
			case .success(let success):
				self.array = success.fields
				DispatchQueue.main.async { [self] in
					self.infoTable.reloadData()
					self.title = success.title
					self.image.downloadedFrom(link: success.image)
					self.activityIndicatorView.stopAnimating()

					valuesRecived = array[2].values
					self.a = ["none": self.valuesRecived?.none, "v1": self.valuesRecived?.v1, "v2": self.valuesRecived?.v2, "v3": valuesRecived?.v3 ]
					print(a)

					for (key, value) in self.a {
						objectArray.append(Row(key: key, value: value!))
					}
					objectArray.sort {
						$0.key < $1.key
					}
				}
			case .failure(let failure):
				DispatchQueue.main.async { [self] in
					alert.title = NSLocalizedString("error", comment: "")
					alert.message = failure.localizedDescription
					present(alert, animated: true)
				}
				print("error")
			}
		}
		view.backgroundColor = .systemBackground
		view.addSubview(infoTable)
		view.addSubview(image)
		view.addSubview(activityIndicatorView)
		infoTable.dataSource = self
		infoTable.delegate = self
		//	infoTable.backgroundColor = .systemMint
		//		infoTable.backgroundView = self.image
		//		infoTable.backgroundView?.contentMode = .scaleAspectFit


		infoTable.snp.makeConstraints { (make) -> Void in
			make.leading.trailing.top.bottom.equalToSuperview()
			//	make.bottom.equalTo(image.snp_topMargin)
		}
		image.snp.makeConstraints { (make) -> Void in
			make.leading.equalToSuperview().offset(10)
			make.trailing.equalToSuperview().offset(-10)
			make.top.equalTo(infoTable.snp_topMargin).offset(230)
		}
		//		NSLayoutConstraint.activate([
		//			infoTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
		//			infoTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
		//			infoTable.topAnchor.constraint(equalTo: view.topAnchor),
		//			infoTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
		//		])
	}
	var text = Constants().emptyStringUserResponse
	var numeric = Constants().emptyStringUserResponse

	var valuesRecived: Values?
	var valuesPicker = UIPickerView()
	var a = [String: String?]()
	var objectArray = [Row]()
	var returnValue = ""

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return array.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = infoTable.dequeueReusableCell(withIdentifier: TextNumericTypeTableViewCell.cellIdentifier, for: indexPath)
			as? TextNumericTypeTableViewCell {
			cell.config(model: array[indexPath.row])
			cell.textField.delegate = self
			cell.valuesPicker.dataSource = self
			cell.valuesPicker.delegate = self
			cell.backgroundColor = .clear
			cell.textField.addTarget(self, action: #selector(textinfo(sender:)), for: UIControl.Event.editingChanged)
			return cell
		}
		return UITableViewCell()
	}
	@objc func textinfo(sender: UITextField) {

		if	sender.accessibilityIdentifier == constants.textTypeIdentifier {
			guard let textFilter = sender.text else { return }
			sender.text = textFilter.filter { constants.ruSymbols.contains($0) || constants.engSymbols.contains($0) || constants.numbers.contains($0)}
			text =  sender.text ?? constants.emptyStringUserResponse
		}
		if	sender.accessibilityIdentifier == constants.numericTypeIdentifier {
			guard let textFilter = sender.text else { return }
			sender.text = textFilter.filter {constants.numbers.contains($0) || constants.symbol.contains($0)}
		}
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		60
	}

	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
	}

	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let buttom = UIButton()
		buttom.backgroundColor = .systemMint
		buttom.setTitle(NSLocalizedString("buttonText", comment: ""), for: .normal)
		buttom.setTitleColor(.systemMint, for: .highlighted)
		buttom.addTarget(self, action: #selector(send), for: .touchUpInside)
		return buttom
	}

	//	@objc func values() {
	//
	//		let nav = UINavigationController(rootViewController: ValuesViewController(values: array[2].values!))
	//		nav.modalPresentationStyle = .automatic
	//		if let sheet = nav.sheetPresentationController {
	//			sheet.detents = [.medium(), .large()]
	//		}
	//		present(nav, animated: true, completion: nil)
	//
	//	}

	@objc func send() {
		activityIndicatorView.startAnimating()
		API().makePOSTRequest(url: constants.postUrl, data: ["form": ["text": text, "numeric": numeric, "list": returnValue]]) { [self] (result:Result<Response, Error>)  in
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

	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		30
	}
}

extension ViewController: UITextFieldDelegate {
	func textFieldDidEndEditing(_ textField: UITextField) {
		guard let cell = textField.superview?.superview as? UITableViewCell, let indexPath = infoTable.indexPath(for: cell) else { return }
		print(indexPath)
	}

	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if textField.accessibilityIdentifier == constants.textTypeIdentifier {
			let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
			print(text)
			return true
		}
		if textField.accessibilityIdentifier == constants.numericTypeIdentifier {
			NSObject.cancelPreviousPerformRequests(
				withTarget: self,
				selector: #selector(self.getHintsFromTextField),
				object: textField)
			self.perform(
				#selector(self.getHintsFromTextField),
				with: textField,
				afterDelay: 2)
			return true
		}
		return true
	}

	@objc func getHintsFromTextField(textField: UITextField) {
		guard var textFilter = textField.text else { return }
		textFilter = textFilter.replacingOccurrences(of: ",", with: ".")
		textField.text = textFilter
		if let number = NumberFormatter().number(from: textFilter)?.doubleValue {
			if number > 1 && number < 1024 {
				numeric = String(number)
				print("Hints for textField: \(numeric)")
			} else {
				numeric = constants.emptyStringUserResponse
				textField.text = ""
				print("Hints for textField: \(numeric)")
			}
		}
	}
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		1
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		a.values.count
	}


	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		print(objectArray[row].value)
		return objectArray[row].value
	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		returnValue = objectArray[row].key
	}

}

extension UIImageView {

	func downloadedFrom(link:String) {
		guard let url = URL(string: link) else { return }
		URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) -> Void in
			guard let data = data , error == nil, let image = UIImage(data: data) else { return }
			DispatchQueue.main.async { () -> Void in
				self.image = image
			}
		}).resume()
	}
}



//Выбор значения (выбирается одно значение из списка возможных). Можно как UIPickerView, так и открытием отдельного UIViewController (желательно).
//Обязательно использовать Autolayout, URLSession, Codable.
//Помните, что, несмотря на то, что данные прилетают всегда одни и те же, подразумевается, что список полностью динамический!
