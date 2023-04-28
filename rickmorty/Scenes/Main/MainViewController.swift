//
//  MainViewController.swift
//  rickmorty
//
//  Created by Tiago Henrique Piantavinha on 24/04/23.
//

import UIKit

protocol MainViewControllerLogic: AnyObject {
    func fetch(viewModel: MainModels.Fetch.ViewModel) async
    func fetch(viewModel: MainModels.Fetch.ViewModel)
}

class MainViewController: UIViewController {
    
    private let MARGIN_SIZE = 24.0
    private var usePrommise = false
    
    var interactor: MainInteractorLogic?
    var tableData: [CharacterModel] = []
    var isLastPage: Bool = false
    
    @objc func onSegmentedOpcValueChanged(_ sender: AnyObject) {
        usePrommise = segmentedOpc.selectedSegmentIndex == 1
    }
    
    lazy var segmentedOpc: UISegmentedControl = {
        let segmented = UISegmentedControl(items: ["Async/Await", "PromisseKit"])
        segmented.translatesAutoresizingMaskIntoConstraints = false
        segmented.addTarget(self, action: #selector(onSegmentedOpcValueChanged), for: .valueChanged)
        segmented.selectedSegmentIndex = 0
        return segmented
    }()
    
    lazy var filterField: UITextField = {
        let text = UITextField()
        
        let searchPlaceHolder = "Search Character"
        let rangePlaceHolder = (searchPlaceHolder as NSString).range(of: searchPlaceHolder)
        var attributedPlaceholder = NSMutableAttributedString(string: searchPlaceHolder)
        attributedPlaceholder.addAttribute(.foregroundColor, value: UIColor.greenMedium as Any, range: rangePlaceHolder)
        
        text.translatesAutoresizingMaskIntoConstraints = false
        text.borderStyle = .roundedRect
        text.backgroundColor = .whiteLigth
        text.textColor = .greenDark
        text.returnKeyType = .search
        text.attributedPlaceholder = attributedPlaceholder
        text.autocapitalizationType = .none
        text.autocorrectionType = .no
        text.delegate = self
        return text
    }()
    
    lazy var tableResult: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.applyCornerRadius()
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.allowsSelection = false
        table.register(MainTableResultViewCell.self, forCellReuseIdentifier: MainTableResultViewCell.REUSABLE_IDENTIFIER)
        return table
    }()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .greenDark
        
        view.addSubview(segmentedOpc)
        view.addSubview(filterField)
        view.addSubview(tableResult)
        
        configureLayout()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshData()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, deprecated, message: "init(coder:) has not been implemented")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            segmentedOpc.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: MARGIN_SIZE),
            segmentedOpc.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: MARGIN_SIZE),
            segmentedOpc.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: MARGIN_SIZE * -1),
            
            filterField.topAnchor.constraint(equalTo: segmentedOpc.bottomAnchor, constant: MARGIN_SIZE),
            filterField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: MARGIN_SIZE),
            filterField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: MARGIN_SIZE * -1),
            
            tableResult.topAnchor.constraint(equalTo: filterField.bottomAnchor, constant: MARGIN_SIZE),
            tableResult.leadingAnchor.constraint(equalTo: filterField.leadingAnchor),
            tableResult.trailingAnchor.constraint(equalTo: filterField.trailingAnchor),
            tableResult.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func refreshData() {
        let text = filterField.text ?? ""
        
        if usePrommise {
            LoadingView.shared.show(in: self.view)
            interactor?.fetch(name: text)
        } else {
            Task {
                LoadingView.shared.show(in: self.view)
                await interactor?.fetch(name: text)
            }
        }
    }
    
    private func emptyData() -> UIImageView {
        let imageView = UIImageView(frame: tableResult.frame)
        imageView.image = UIImage(named: "splash")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
    
    private func finishProcessDataRequest(viewModel: MainModels.Fetch.ViewModel) {
        isLastPage = viewModel.isLastPage
        if let data = viewModel.data, data.results.count > 0 {
            if viewModel.reloadedData {
                tableData = data.results
            } else {
                tableData.append(contentsOf: data.results)
            }
        } else {
            tableData = []
        }
        
        tableResult.reloadData()
        LoadingView.shared.hide()
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableData.count > 0 {
            tableResult.backgroundView?.removeFromSuperview()
        } else {
            tableResult.backgroundView = emptyData()
        }
        
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mainTableResultCell = tableView
            .dequeueReusableCell(withIdentifier: MainTableResultViewCell.REUSABLE_IDENTIFIER, for: indexPath) as! MainTableResultViewCell
        
        mainTableResultCell.configureCell(character: tableData[indexPath.item])
        return mainTableResultCell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableData.count - 10 && !isLastPage {
            refreshData()
        }
    }
}

extension MainViewController: MainViewControllerLogic {
    func fetch(viewModel: MainModels.Fetch.ViewModel) async {
        finishProcessDataRequest(viewModel: viewModel)
    }
    
    func fetch(viewModel: MainModels.Fetch.ViewModel) {
        finishProcessDataRequest(viewModel: viewModel)
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        refreshData()
        view.endEditing(true)
        return true
    }
}
