//
//  NecessaryCallViewController.swift
//  Contact
//
//  Created by Le Thanh Tan on 6/14/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import UIKit

class NecessaryCallViewController: UIViewController {

	@IBOutlet weak var control: UISegmentedControl!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var segmentButton: UIButton!
	@IBOutlet weak var segmentBarButton: UIBarButtonItem!

	// to store
	var necessaryCountry: [NecessaryNumberCountry]! = []
	// to show
	var necessaryCategory: [NecessaryNumberCategory]! = []
	var numberRowsInSection: [(Int, Int)] = []
	var templeRowInSection: [(Int, Int)]!
	let listTitleInSection = ["Cứu hộ", "Chăm sóc khách hàng", "Taxi", "Tư vấn", "Ngân Hàng"]

	override func viewDidLoad() {
		super.viewDidLoad()
		let data = loadJSONFromFile()
		if let data = data {
			let listCountry = data["body"] as! NSArray
			for country in listCountry {
				necessaryCountry.append(NecessaryNumberCountry(dictionary: country as! NSDictionary))
			}
		} else {
			print("Cannot open file")
		}

		insertDataForTableView(index: 2)
	}

	override func viewDidLayoutSubviews() {
		segmentButton.transform = CGAffineTransformMakeScale(-1.0, 1.0)
		segmentButton.titleLabel?.transform = CGAffineTransformMakeScale(-1.0, 1.0)
		segmentButton.imageView?.transform = CGAffineTransformMakeScale(-1.0, 1.0)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	@IBAction func onControlSegmentTapped(sender: UIButton) {
		if isExistChoiceCityViewInSuperView() {
			removeChoiceCityViewFromSuperView()
			return
		}

		let segmentView: NecessaryNumberChoiceCity = NSBundle.mainBundle().loadNibNamed("NecessaryNumberChoiceCity", owner: self, options: nil)[0] as! NecessaryNumberChoiceCity

		segmentView.frame = CGRectMake(0, -120, self.view.frame.width, 120)
		segmentView.delegate = self
		segmentView.tag = 10
		view.addSubview(segmentView)

		UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 10, initialSpringVelocity: 5, options: [], animations: {
			segmentView.frame = CGRectMake(0, 0 + 60, self.view.frame.width, 120)
			}, completion: nil)
	}

}

extension NecessaryCallViewController: NecessaryNumberChoiceCityDelegate {
	func necessaryNumber(necessaryNumberChoiceCity: NecessaryNumberChoiceCity,
	                     didTapCityWithName name: City) {
		segmentButton.setAttributedTitle(nil, forState: UIControlState.Normal)
		segmentButton.setTitle(name.description, forState: UIControlState.Normal)
		segmentButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
		
		removeChoiceCityViewFromSuperView()

		// action
		insertDataForTableView(index: name.hashValue)
		tableView.reloadData()
	}

	private func removeChoiceCityViewFromSuperView() {
		for v in self.view.subviews {
			if v.tag == 10 {
				UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 10, initialSpringVelocity: 5, options: [], animations: {
					v.frame = CGRectMake(0, -120, self.view.frame.width, 120)
					}, completion: { (complete: Bool) in
						v.removeFromSuperview()
				})
			}
		}
	}

	private func isExistChoiceCityViewInSuperView() -> Bool {
		for v in self.view.subviews {
			if v.tag == 10 {
				return true
			}
		}
		return false
	}
}

// MARK: - UITableViewDelegate
extension NecessaryCallViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("necessaryNumberCell") as! NecessaryNumberCell
		cell.necessaryNumberModel = necessaryCategory[indexPath.section].data[indexPath.row]
		return cell
	}

	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return necessaryCategory.count
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return templeRowInSection[section].1
	}

	func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let viewArray = NSBundle.mainBundle().loadNibNamed("HeaderNecessaryTableView", owner: self, options: nil) as NSArray
		let view = viewArray.objectAtIndex(0) as! HeaderNecessaryTableView
		view.configHeaderWithSection(section, title: listTitleInSection[section])
		view.delegate = self
		return view
	}

	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 60
	}
}

extension NecessaryCallViewController: HeaderNecessaryViewDelegate {
	func headerNecessary(headerNecessaryTableView: HeaderNecessaryTableView, didTapHeader: Bool) {
		let section = headerNecessaryTableView.sectionCell
		let index = templeRowInSection.indexOf({ (temple: (Int, Int)) -> Bool in
			return temple.0 == section
		})

		if templeRowInSection[index!].1 == 0 {
			templeRowInSection[index!] = (section, numberRowsInSection[section].1)
			tableView.reloadSections(NSIndexSet(index: section), withRowAnimation: UITableViewRowAnimation.Bottom)
		} else {
			templeRowInSection[index!] = (section, 0)
			tableView.reloadSections(NSIndexSet(index: section), withRowAnimation: UITableViewRowAnimation.Fade)
		}


	}
}

// MARK: - Private Method
extension NecessaryCallViewController {
	private func loadJSONFromFile() -> NSDictionary? {
		if let path = NSBundle.mainBundle().pathForResource("necessaryNumber", ofType: "json") {
			do {
				let jsonData = try NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingMappedIfSafe)
				let jsonResult: NSDictionary = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
				return jsonResult
			} catch let error as NSError {
				print("Error: \(error)")
			}
		}
		return nil
	}

	private func insertDataForTableView(index index: Int) {
		necessaryCategory = necessaryCountry[index].data

		if numberRowsInSection.count > 0 {
			numberRowsInSection.removeAll()
			templeRowInSection.removeAll()
		}

		for i in 0...necessaryCategory.count-1 {
			numberRowsInSection.append((i, necessaryCategory[i].data.count))
		}
		templeRowInSection = numberRowsInSection

	}
}
