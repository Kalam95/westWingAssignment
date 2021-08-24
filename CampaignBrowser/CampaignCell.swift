//
//  CampaignCell.swift
//  CampaignBrowser
//
//  Created by mehboob Alam on 24/08/21.
//  Copyright © 2021 Westwing GmbH. All rights reserved.
//

import UIKit
import RxSwift

class CampaignCell: UICollectionViewCell {
    
    private let disposeBag = DisposeBag()

    /** Used to display the campaign's title. */
    @IBOutlet private(set) weak var nameLabel: UILabel!

    /** Used to display the campaign's description. */
    @IBOutlet private(set) weak var descriptionLabel: UILabel!

    /** The image view which is used to display the campaign's mood image. */
    @IBOutlet private(set) weak var imageView: UIImageView!

    /** Height of the The image view which is used to display the campaign's mood image. */
    @IBOutlet var imageViewHeight: NSLayoutConstraint!

    /** The mood image which is displayed as the background. */
    var moodImage: Observable<UIImage>? {
        didSet {
            moodImage?
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] image in
                    self?.imageView.image = image
                    })
                .disposed(by: disposeBag)
        }
    }

    /** The campaign's name. */
    var name: String? {
        didSet {
            nameLabel?.text = name
        }
    }

    var descriptionText: String? {
        didSet {
            descriptionLabel?.text = descriptionText
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Setting height as 4:3(1.33) ratio whhere width will be the full screen width of collectionView
        // we can also provid etehe aspect ratio constraint there.
        imageViewHeight?.constant = UIScreen.main.bounds.width/1.33
        assert(nameLabel != nil)
        assert(descriptionLabel != nil)
        assert(imageView != nil)
    }
}
