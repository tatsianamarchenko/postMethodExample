//
//  ViewController.swift
//  Seventhproject
//
//  Created by Tatsiana Marchanka on 15.03.22.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

	private lazy var image = UIImageView()

	private lazy var infoTable: UITableView = {
		let table = UITableView()
		table.register(InfoTableViewCell.self, forCellReuseIdentifier: InfoTableViewCell.cellIdentifier)
		return table
	}()

	private lazy var alert: UIAlertController = {
		var alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "отмена", style: .cancel, handler: nil))
		return alert
	}()
	
	var array = [Field]()
	override func viewDidLoad() {
		super.viewDidLoad()
		API().fetch(urlString: API().urlATMsString) { (result: Result<Empty, CustomError>)  in
			switch result {
			case .success(let success):
				self.array = success.fields
				print("xd")
				DispatchQueue.main.async {
					self.infoTable.reloadData()
					self.title = success.title
					self.image.downloadedFrom(link: success.image)
				}
			case .failure(let failure):
				print("error")
			}
		}
		view.backgroundColor = .systemBackground
		view.addSubview(infoTable)
		view.addSubview(image)
		infoTable.dataSource = self
		infoTable.delegate = self
		infoTable.snp.makeConstraints { (make) -> Void in
			make.leading.trailing.top.equalToSuperview()
			make.bottom.equalTo(image.snp_topMargin)
		}
		image.snp.makeConstraints { (make) -> Void in
			make.leading.equalToSuperview().offset(10)
			make.trailing.equalToSuperview().offset(-10)
			make.top.equalTo(infoTable.snp_topMargin).offset(200)
		}
	}
	var text = ""
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return array.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		if let cell = infoTable.dequeueReusableCell(withIdentifier: InfoTableViewCell.cellIdentifier, for: indexPath)
			as? InfoTableViewCell {
			cell.config(model: array[indexPath.row])
			cell.textField.delegate = self
			cell.textField.tag = indexPath.row
			cell.textField.addTarget(self, action: #selector(textinfo(sender:)), for: UIControl.Event.editingChanged)
			return cell
		}
		return UITableViewCell()
	}
	@objc func textinfo(sender: UITextField) {
		if	sender.tag == 0 {
		text =  "fvygbuhnijkm"
		}
		if	sender.tag == 1 {
		text =  "vgbhjnk"
		}
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		50
	}

	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
	}

	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let buttom = UIButton()
		buttom.backgroundColor = .orange
		buttom.setTitle("send info", for: .normal)
		buttom.setTitleColor(.systemMint, for: .highlighted)
		buttom.addTarget(self, action: #selector(send), for: .touchUpInside)
		return buttom
	}

	@objc func send() {

		API().makePOSTRequest(data: ["form": ["text": text, "numeric": text, "list": "v1"]]) { [self] (result:Result<Response, Error>)  in
			switch result {
			case .success(let success):
				print(success.result)
				DispatchQueue.main.async {
					alert.title = "отправлено"
					alert.message = success.result
					present(alert, animated: true)
				}
			case .failure(let failure):
				DispatchQueue.main.async {
					alert.title = "ошибка"
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
		   let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
		   print(text)
		   return true
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
