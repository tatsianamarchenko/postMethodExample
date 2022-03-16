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
		infoTable.backgroundColor = .magenta
		infoTable.dataSource = self
		infoTable.delegate = self
		infoTable.snp.makeConstraints { (make) -> Void in
			make.leading.trailing.top.equalToSuperview()
		 	make.bottom.equalToSuperview()
		}
//		image.snp.makeConstraints { (make) -> Void in
//			make.leading.equalToSuperview().offset(10)
//			make.trailing.equalToSuperview().offset(-10)
//			make.top.equalTo(infoTable.snp_bottomMargin)
//		}
	}
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return array.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		  if let cell = infoTable.dequeueReusableCell(withIdentifier: InfoTableViewCell.cellIdentifier, for: indexPath)
			  as? InfoTableViewCell {
			  cell.config(model: array[indexPath.row])
			return cell
		  }
		  return UITableViewCell()
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
		buttom.setTitleColor(.systemMint, for: .focused)
		buttom.addTarget(self, action: #selector(send), for: .touchUpInside)
		return buttom
	}

	@objc func send() {
		API().makePOSTRequest()
		print("lol")
		}

	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		30
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


//Ввод строки (вводится произвольная текстовая строка)
//Ввод числа (вводится целое или дробное число)
//Выбор значения (выбирается одно значение из списка возможных). Можно как UIPickerView, так и открытием отдельного UIViewController (желательно).
