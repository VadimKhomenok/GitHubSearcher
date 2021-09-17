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
    @IBOutlet weak var licenseLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutIfNeeded()
        descriptionLabel.preferredMaxLayoutWidth = descriptionLabel.bounds.width
    }

    func setup(withRepo repo: Repository, isLastCell: Bool = false) {
        DispatchQueue.main.async {
            self.nameLabel.text = "Owner: \(repo.name ?? "Unnamed")"
            self.descriptionLabel.text = repo.description ?? "No description"
            self.updatedDate.text = "Updated: \(repo.updatedDate ?? "-")"
            self.ownerLabel.text = "Owner: \(repo.owner?.login ?? "-")"
            self.licenseLabel.text = "License: \(repo.license?.name ?? "-")"
            self.separatorView.isHidden = isLastCell
        }
    }
}
