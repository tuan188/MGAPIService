//
//  EventListViewController.swift
//  MGAPIService
//
//  Created by Tuan Truong on 5/27/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

import UIKit
import Reusable
import MGArchitecture
import RxSwift
import RxCocoa
import MGLoadMore

final class EventListViewController: UIViewController, BindableType {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: LoadMoreTableView!

    // MARK: - Properties
    
    var viewModel: EventListViewModel!

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    deinit {
        logDeinit()
    }

    // MARK: - Methods
    
    private func configView() {
        title = "Events"
        
        tableView.do {
            $0.estimatedRowHeight = 550
            $0.rowHeight = UITableView.automaticDimension
            $0.register(cellType: EventCell.self)
        }
        tableView.rx
            .setDelegate(self)
            .disposed(by: rx.disposeBag)
    }

    func bindViewModel() {
        let input = EventListViewModel.Input(
            loadTrigger: Driver.just(()),
            reloadTrigger: tableView.refreshTrigger,
            loadMoreTrigger: tableView.loadMoreTrigger,
            selectEventTrigger: tableView.rx.itemSelected.asDriver()
        )

        let output = viewModel.transform(input)
        
        output.eventList
            .drive(tableView.rx.items) { tableView, index, event in
                return tableView.dequeueReusableCell(
                    for: IndexPath(row: index, section: 0),
                    cellType: EventCell.self)
                    .then {
                        $0.bindViewModel(EventViewModel(event: event))
                    }
            }
            .disposed(by: rx.disposeBag)
        output.error
            .drive(rx.error)
            .disposed(by: rx.disposeBag)
        output.loading
            .drive(rx.isLoading)
            .disposed(by: rx.disposeBag)
        output.refreshing
            .drive(tableView.refreshing)
            .disposed(by: rx.disposeBag)
        output.loadingMore
            .drive(tableView.loadingMore)
            .disposed(by: rx.disposeBag)
        output.fetchItems
            .drive()
            .disposed(by: rx.disposeBag)
        output.selectedEvent
            .drive()
            .disposed(by: rx.disposeBag)
        output.isEmptyData
            .drive()
            .disposed(by: rx.disposeBag)
    }
}

// MARK: - Binders
extension EventListViewController {

}

// MARK: - UITableViewDelegate
extension EventListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - StoryboardSceneBased
extension EventListViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
