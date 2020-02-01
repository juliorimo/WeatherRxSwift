//
//  WeatherDetailViewController.swift
//  WeatherRxSwift
//
//  Created by Nischal Hada on 9/8/19.
//  Copyright © 2019 NischalHada. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class WeatherDetailViewController: UIViewController {

    @IBOutlet weak var labelCityName: UILabel!
    @IBOutlet weak var labelCityTemperature: UILabel!
    @IBOutlet weak var labelMainName: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!

    var weatherInfo: WeatherResult!

    private var viewModel: WeatherDetailDataSource!
    private var detailList = [DetailModel]()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = weatherInfo.name
        setupUI()
        setView()
        setupViewModel()
    }

    private func setupUI() {
        self.view.backgroundColor = UIColor.viewBackgroundColor
        self.tableView.backgroundColor = UIColor.viewBackgroundColor
        self.tableView.hideEmptyCells()
    }

    private func setupViewModel() {
        viewModel =  WeatherDetailViewModel(withWeatherResultModel: weatherInfo)
        viewModel.detailList
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] list in
                self?.detailList = list
                self?.tableView.reloadData()
            }).disposed(by: disposeBag)
    }

    private func setView() {
        labelCityName.text = weatherInfo.name
        if let main = weatherInfo.main {
            labelCityTemperature.text = "\(main.temp) °C"
        }
        if
            let weather = weatherInfo.weather,
            !weather.isEmpty {
            let weatherData = weather[0]

            if let url = URL.iconURL(weatherData.icon) {
                self.weatherImageView.setImage(url: url)
            }
            self.labelMainName.text = weatherData.main
            self.labelDescription.text = weatherData.description
        }

    }

}

// MARK: - TableViewDelegate Setup
extension WeatherDetailViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as WeatherDetailTableViewCell
        cell.detailInfo = self.detailList[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped")
    }
}
