//
//  ViewController.swift
//  GitHubSearcher
//
//  Created by Vadim Khomenok on 16.09.21.
//

import UIKit

class ViewController: UIViewController, TapOutsideHideKeyboardProtocol, LoadingStateProtocol, OpenSafariProtocol, AlertPresentableProtocol {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var reposTableView: UITableView!
    @IBOutlet weak var noResultsLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var reposSearcher = ReposSearcher()
    
    private var reposList: [Repository] = []
    {
        didSet {
            DispatchQueue.main.async {
                self.noResultsLabel.isHidden = self.reposList.count > 0
            }
        }
    }
    
    var hideKeyboardTapGestureRecognizer: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reposTableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        reposTableView.scrollIndicatorInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        reposTableView.estimatedRowHeight = 150.0
        reposTableView.rowHeight = UITableView.automaticDimension
        reposTableView.tableFooterView?.isHidden = true
        
        reposSearcher.delegate = self
        searchTextField.delegate = self
        
        setupTapGesture()
    }
    
    @objc fileprivate func searchRepos() {
        guard let searchText = searchTextField.text, !searchText.isEmpty else { return }
        loading(inProgress: true)
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.reposSearcher.searchRepositories(withKeyword: searchText)
        }
    }
    
    @IBAction func loadMoreButtonClicked(_ sender: Any) {
        loadMore()
    }
    
    fileprivate func loadMore() {
        guard let searchText = searchTextField.text, !searchText.isEmpty else { return }
        loading(inProgress: true)
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.reposSearcher.fetchMore(withKeyword: searchText)
        }
    }
}


// MARK: - UITableView Data Source

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reposList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RepoTableViewCell.self))
        if let repoCell = cell as? RepoTableViewCell, reposList.count > indexPath.row {
            let isLastCell = (indexPath.row == reposList.count - 1)
            repoCell.setup(withRepo: reposList[indexPath.row], isLastCell: isLastCell)
            repoCell.layoutIfNeeded()
        }
        
        return cell ?? UITableViewCell()
    }
}


// MARK: - UITableView Delegate

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard reposList.count > indexPath.row else { return }
        let selectedRepo = reposList[indexPath.row]
        if let urlString = selectedRepo.url {
            open(url: urlString)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if maximumOffset - currentOffset <= 10.0 {
            loadMore()
        }
    }
}


// MARK: - UITextField Delegate

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchRepos), object: nil)
        perform(#selector(searchRepos), with: nil, afterDelay: Constants.typeSearchDelay)
        return true
    }
}


// MARK: - ReposSearcher Delegate

extension ViewController: ReposSearcherDelegate {
    func repositoriesLoaded(repositoriesList: [Repository], hasMore: Bool) {
        loading(inProgress: false)
        reposList = repositoriesList
        
        DispatchQueue.main.async {
            self.reposTableView.reloadData()
            self.reposTableView.tableFooterView?.isHidden = !hasMore
        }
    }
    
    func moreRepositoriesLoaded(newRepositoriesList: [Repository], hasMore: Bool) {
        loading(inProgress: false)
        reposList.append(contentsOf: newRepositoriesList)
        
        DispatchQueue.main.async {
            // TODO: - Better to implement with performBatchUpdates and insertRows
            self.reposTableView.reloadData()
            self.reposTableView.tableFooterView?.isHidden = !hasMore
        }
    }
    
    func errorHappened(error: SearchError) {
        loading(inProgress: false)
        showErrorAlert(withError: error)
    }
}
