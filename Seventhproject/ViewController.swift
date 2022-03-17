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

	private lazy var image = UIImageView()

	private lazy var infoTable: UITableView = {
		let table = UITableView()
		table.register(InfoTableViewCell.self, forCellReuseIdentifier: InfoTableViewCell.cellIdentifier)
		table.register(ListTypeTableViewCell.self, forCellReuseIdentifier: ListTypeTableViewCell.cellIdentifier)
		return table
	}()

	private lazy var alert: UIAlertController = {
		var alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "отмена", style: .cancel, handler: nil))
		return alert
	}()
	var activityIndicatorView = NVActivityIndicatorView(frame: CGRect(), type: nil, color: nil, padding: nil)
	var array = [Field]()
	override func viewDidLoad() {
		super.viewDidLoad()
		 activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: view.frame.midX-50, y: view.frame.midY-50, width: 100, height: 100), type: .ballZigZag, color: .systemMint, padding: nil)
		activityIndicatorView.startAnimating()
		API().fetch(urlString: API().urlATMsString) { (result: Result<Empty, CustomError>)  in
			switch result {
			case .success(let success):
				self.array = success.fields
				print("xd")
				DispatchQueue.main.async {
					self.infoTable.reloadData()
					self.title = success.title
					self.image.downloadedFrom(link: success.image)
					self.activityIndicatorView.stopAnimating()
				}
			case .failure(let failure):
				print("error")
			}
		}
		view.backgroundColor = .systemBackground
		view.addSubview(infoTable)
		view.addSubview(image)
		view.addSubview(activityIndicatorView)
		infoTable.dataSource = self
		infoTable.delegate = self
		infoTable.snp.makeConstraints { (make) -> Void in
			make.leading.trailing.top.equalToSuperview()
			make.bottom.equalTo(image.snp_topMargin)
		}
		image.snp.makeConstraints { (make) -> Void in
			make.leading.equalToSuperview().offset(10)
			make.trailing.equalToSuperview().offset(-10)
			make.top.equalTo(infoTable.snp_topMargin).offset(230)
		}
	}
	var text: String = "empty"
	var numeric: String = "empty"
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return array.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if array[indexPath.row].name == "text" || array[indexPath.row].name == "numeric" {
			if let cell = infoTable.dequeueReusableCell(withIdentifier: InfoTableViewCell.cellIdentifier, for: indexPath)
				as? InfoTableViewCell {
				cell.config(model: array[indexPath.row])
				cell.textField.delegate = self
				cell.textField.addTarget(self, action: #selector(textinfo(sender:)), for: UIControl.Event.editingChanged)
				return cell
			}
		}

		if array[indexPath.row].name == "list" {
			if let cell = infoTable.dequeueReusableCell(withIdentifier: ListTypeTableViewCell.cellIdentifier, for: indexPath)
				as? ListTypeTableViewCell {
				cell.config(model: array[indexPath.row])
				cell.buttom.addTarget(self, action: #selector(values), for: .touchUpInside)
				return cell
			}
		}
		return UITableViewCell()
	}
	@objc func textinfo(sender: UITextField) {

		if	sender.accessibilityIdentifier == "text"  {
			text =  sender.text ?? "empty"
		}
		if	sender.accessibilityIdentifier == "numeric" {
			numeric = sender.text ?? "empty"
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
		buttom.setTitle("send info", for: .normal)
		buttom.setTitleColor(.systemMint, for: .highlighted)
		buttom.addTarget(self, action: #selector(send), for: .touchUpInside)
		return buttom
	}

	@objc func values() {

		let nav = UINavigationController(rootViewController: ValuesViewController(values: array[2].values!))
		nav.modalPresentationStyle = .automatic
		if let sheet = nav.sheetPresentationController {
			sheet.detents = [.medium(), .large()]
		}
		present(nav, animated: true, completion: nil)

	}

	@objc func send() {
		activityIndicatorView.startAnimating()
		API().makePOSTRequest(data: ["form": ["text": text, "numeric": numeric, "list":  ValuesViewController.returnValue]]) { [self] (result:Result<Response, Error>)  in
			switch result {
			case .success(let success):
				print(success.result)
				DispatchQueue.main.async {
					alert.title = "отправлено"
					alert.message = success.result
					present(alert, animated: true)
					activityIndicatorView.stopAnimating()
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

//Разработать приложение, выполняющее следующие функции:
//
//Прием от сервера метаинформации для построения формы
//Построение динамической формы ввода данных по принятой информации
//Ввод данных пользователя в построенной форме
//Отправка введенных данных на сервер
//Отображение результата, полученного от сервера
//Во время приёма и отправки на экране отображается ActivityView (любая loading анимация).
//
//Форма строится в виде таблицы:
//
//В левой части сроки (UITableViewCell) отображается имя поля
//В правой - элемент управления для ввода (UITextField) значения поля.
//Заголовок формы отображается в NavigationBar.
//
//Поля могут быть следующих типов:
//
//Ввод строки (вводится произвольная текстовая строка)
//Ввод числа (вводится целое или дробное число)
//Выбор значения (выбирается одно значение из списка возможных). Можно как UIPickerView, так и открытием отдельного UIViewController (желательно).
//В поля ввода добавить валидацию ввода (строка, число).
//
//Валидацию числа реализовать по окончанию ввода, через N миллисекунд. Число должно быть > 1 && < 1024
//Валидацию строки делать по мере ввода. В строке должны использоваться только RU & EN символы + цифры.
//Под таблицей расположить фоновую картинку из поля “image”. Картинка должна отображаться на экране всегда.
//
//Под таблицей (footer) располагается кнопка отправки значений.
//
//Числовые значения должны отправляться с точками в качестве десятичных разделителей.
//
//Результат операции отправки данных на сервер отображается в диалоге.
//
//Обязательно использовать Autolayout, URLSession, Codable.
//
//Помните, что, несмотря на то, что данные прилетают всегда одни и те же, подразумевается, что список полностью динамический!
