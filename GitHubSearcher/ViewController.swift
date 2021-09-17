//
//  ViewController.swift
//  GitHubSearcher
//
//  Created by Vadim Khomenok on 16.09.21.
//

import UIKit

class ViewController: UIViewController, TapOutsideHideKeyboardProtocol {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var reposTableView: UITableView!
    @IBOutlet weak var loadMoreButton: UIButton!
    
    private var reposSearcher = ReposSearcher()
    
    private var reposList: [Repository] = [] {
        didSet {
            DispatchQueue.main.async {
                self.reposTableView.reloadData()
            }
        }
    }
    
    #warning("Should be removed")
    private var hasMore: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.loadMoreButton.isHidden = !self.hasMore
            }
        }
    }
    
    var hideKeyboardTapGestureRecognizer: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reposTableView.estimatedRowHeight = 44.0
        reposTableView.rowHeight = UITableView.automaticDimension
        
        reposSearcher.delegate = self
        searchTextField.delegate = self
        
        setupTapGesture()
    }
    
    @objc fileprivate func searchRepos() {
        print("-- searchRepos() called")
        guard let searchText = searchTextField.text, !searchText.isEmpty else { return }
        reposSearcher.searchRepositories(withKeyword: searchText)
    }
    
    @IBAction func loadMoreButtonClicked(_ sender: Any) {
        guard let searchText = searchTextField.text, !searchText.isEmpty else { return }
        reposSearcher.fetchMore(withKeyword: searchText)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reposList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RepoTableViewCell.self))
        if let repoCell = cell as? RepoTableViewCell, reposList.count > indexPath.row {
            repoCell.setup(withRepo: reposList[indexPath.row])
        }
        
        return cell ?? UITableViewCell()
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchRepos), object: nil)
        perform(#selector(searchRepos), with: nil, afterDelay: Constants.typeSearchDelay)
        return true
    }
}

extension ViewController: ReposSearcherDelegate {
    func repositoriesLoaded(repositoriesList: [Repository], hasMore: Bool) {
        reposList = repositoriesList
        self.hasMore = hasMore
    }
    
    func moreRepositoriesLoaded(newRepositoriesList: [Repository], hasMore: Bool) {
        self.reposList.append(contentsOf: newRepositoriesList)
        self.hasMore = hasMore
        DispatchQueue.main.async {
            self.reposTableView.reloadData()
            
//            self.reposTableView.performBatchUpdates {
                
//                self.reposTableView.insertRows(at: [IndexPath(row: self.reposList.count - 1, section: 0)], with: .automatic)
            }
//        }
    }
}
