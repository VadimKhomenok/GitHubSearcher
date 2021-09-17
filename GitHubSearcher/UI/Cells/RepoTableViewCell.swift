//
//  RepoTableViewCell.swift
//  GitHubSearcher
//
//  Created by Vadim Khomenok on 17.09.21.
//

import UIKit

class RepoTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var updatedDate: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    func setup(withRepo repo: Repository, isLastCell: Bool = false) {
        DispatchQueue.main.async {
            self.nameLabel.text = repo.name
            self.descriptionLabel.text = repo.description
            self.updatedDate.text = repo.updatedDate
            self.ownerLabel.text = repo.owner?.login
            self.separatorView.isHidden = isLastCell
        }
    }
}
