import UIKit
import RxSwift

/**
 The view which displays the list of campaigns. It is configured in the storyboard (Main.storyboard). The corresponding
 view controller is the `CampaignsListingViewController`.
 */
class CampaignListingView: UICollectionView {

    /**
     A strong reference to the view's data source. Needed because the view's dataSource property from UIKit is weak.
     */
    var strongDataSource: UICollectionViewDataSource!
    /**
     Displays the given campaign list.
     */

    func display(campaigns: [Campaign]) {
        setupCollectionView()
        let campaignDataSource = ListingDataSource(campaigns: campaigns)
        dataSource = campaignDataSource
        delegate = campaignDataSource
        strongDataSource = campaignDataSource
        self.reloadData()
    }

    private func setupCollectionView() {
        register(UINib(nibName: Self.Cells.campaignCell.rawValue, bundle: nil),
                 forCellWithReuseIdentifier: Self.Cells.campaignCell.rawValue)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.collectionViewLayout = layout
    }

    struct Campaign {
        let name: String
        let description: String
        let moodImage: Observable<UIImage>
    }

    /**
     All the possible cell types that are used in this collection view.
     */
    enum Cells: String {

        /** The cell which is used to display the loading indicator. */
        case loadingIndicatorCell

        /** The cell which is used to display a campaign. */
        case campaignCell = "CampaignCell"
    }
}


/**
 The data source for the `CampaignsListingView` which is used to display the list of campaigns.
 */
class ListingDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    /** The campaigns that need to be displayed. */
    let campaigns: [CampaignListingView.Campaign]

    /**
     Designated initializer.

     - Parameter campaign: The campaigns that need to be displayed.
     */
    init(campaigns: [CampaignListingView.Campaign]) {
        self.campaigns = campaigns
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return campaigns.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let campaign = campaigns[indexPath.item]
        let reuseIdentifier =  CampaignListingView.Cells.campaignCell.rawValue
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if let campaignCell = cell as? CampaignCell {
            campaignCell.moodImage = campaign.moodImage
            campaignCell.name = campaign.name
            campaignCell.descriptionText = campaign.description
        } else {
            assertionFailure("The cell should a CampaignCell")
        }
        return cell
    }

    
    ///Method to calculate the height of the Cell by with thee help of Cell's nib
    /// - Parameter indexPath: IndexPath for which the height is required.
    /// - Returns: Exact Size of the cell.
    func computeHeight(atIndexPath indexPath: IndexPath) -> CGSize {
        let cellName = CampaignListingView.Cells.campaignCell.rawValue
        guard let campaignCell = Bundle.main.loadNibNamed(cellName, owner: nil, options: nil)?.first as? CampaignCell else { return .zero }
        let campaign = campaigns[indexPath.item]
        campaignCell.nameLabel.text = campaign.name
        campaignCell.descriptionLabel.text = campaign.description
        campaignCell.layoutIfNeeded()
        if #available(iOS 13.0, *) {
            campaignCell.translatesAutoresizingMaskIntoConstraints = false// only reequireed in later versions.
        }
        // get the height of the cell with the traget Size(maximum size)
        return campaignCell.systemLayoutSizeFitting(CGSize(width: UIScreen.main.bounds.width,
                                                           height: UIView.layoutFittingExpandedSize.height))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Cell width will be as the width of the collectionView
        return  CGSize(width: collectionView.frame.width,
                       height: computeHeight(atIndexPath: indexPath).height)
    }

}



/**
 The data source for the `CampaignsListingView` which is used while the actual contents are still loaded.
 */
class LoadingDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = CampaignListingView.Cells.loadingIndicatorCell.rawValue
        return collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                  for: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
