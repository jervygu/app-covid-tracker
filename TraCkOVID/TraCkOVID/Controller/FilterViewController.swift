//
//  FilterViewController.swift
//  TraCkOVID
//
//  Created by Jervy Umandap on 6/29/21.
//

import UIKit

class FilterViewController: UIViewController {
    
    public var completion: ((State) -> Void)?
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var states: [State] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Select a state."
        
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchStates()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
    }
    
    private func fetchStates() {
        APICaller.shared.getStateList(completion: { [weak self] result in
            switch result {
            case .success(let state):
                self?.states = state
            case .failure(let error):
                print("Error fetching states list: - \(error)")
            }
        })
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return states.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let state = states[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = state.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let state = states[indexPath.row]
        
        // call completion
        completion?(state)
        
        // dismiss
        dismiss(animated: true, completion: nil)
    }
    
    
}
