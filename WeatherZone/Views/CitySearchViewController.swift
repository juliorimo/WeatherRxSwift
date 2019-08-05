//
//  CitySearchViewController.swift
//  WeatherZone
//
//  Created by Nischal Hada on 4/8/19.
//  Copyright © 2019 NischalHada. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CitySearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    private let selectedCitySubject = PublishSubject<CityListModel>()
    var selectedCity: Observable<CityListModel>? {
        return selectedCitySubject.asObserver()
    }

    private var cityList = [CityListModel]()
    private var viewModel: CitySearchViewModelProtocol!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupViewModel()
    }

    func setupUI() {
        self.title = "Search City"
        self.tableView.backgroundColor = UIColor.viewBackgroundColor
        self.cancelButton.rx.tap
            .subscribe { [weak self] _  in
                self?.dismiss(animated: true)
        }.disposed(by: disposeBag)
    }

    func setupViewModel() {
        viewModel = CitySearchViewModel()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cityList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {
            fatalError("Cell does not exist")
        }
        let city = self.cityList[indexPath.row]
        cell.textLabel?.text = city.name
        cell.detailTextLabel?.text = city.country
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let citySelected = self.cityList[indexPath.row]
        self.selectedCitySubject.onNext(citySelected)
    }

}
