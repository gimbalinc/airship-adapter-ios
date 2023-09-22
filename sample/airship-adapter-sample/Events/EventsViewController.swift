//
//  EventsViewController.swift
//  airship-adapter-sample
//
//  Created by Andrew Tran on 6/9/22.
//

import Foundation
import UIKit

class EventsViewController: BaseViewController<EventsView> {
    private var presenter: EventsPresenter?
    private var eventsTable: UITableView { self.mainView.eventsTable }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.presenter = EventsPresenter(
            view: self,
            defaultsService: DependencyInjector.getInstance().getDefaultsService()
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.eventsTable.register(LabelCell.self, forCellReuseIdentifier: LabelCell.defaultReuseIdentifier)
        self.eventsTable.dataSource = self
        self.eventsTable.delegate = self
        self.eventsTable.allowsSelection = false
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onGimbalEventReceived),
                                               name: .didReceiveNewGimbalEvent,
                                               object: nil
        )
    }
    
    @objc func onGimbalEventReceived(_ notification: Notification) {
        self.presenter?.handleNewEvent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refreshEventsTable() {
        self.eventsTable.reloadData()
    }
}

extension EventsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter?.eventsCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let presenter = self.presenter,
              let cell = self.eventsTable.dequeueReusableCell(
                withIdentifier: LabelCell.defaultReuseIdentifier,
                for: indexPath
              ) as? LabelCell
        else {
            return LabelCell()
        }
        
        let event = presenter.getEvent(forIndex: indexPath.row)
        cell.firstLabel.font = UIFont.brandonRegular(ofSize: 14.0)
        cell.firstLabel.text = event.firstDescriptor
        cell.secondLabel.font = UIFont.brandonRegular(ofSize: 14.0)
        cell.secondLabel.text = event.secondDescriptor
        return cell
    }
}

extension EventsViewController: UITableViewDelegate {
}
