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
    @IBOutlet var strongDataSource: UICollectionViewDataSource!

    /**
     Displays the given campaign list.
     */
    func display(campaigns: [Campaign]) {
        let campaignDataSource = ListingDataSource(campaigns: campaigns)
        dataSource = campaignDataSource
        delegate = campaignDataSource
        let layout = CollectionViewDynamicLayout()
        layout.delegate = campaignDataSource
        self.collectionViewLayout = layout
        strongDataSource = campaignDataSource
        reloadData()
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
        case campaignCell
    }
}


/**
 The data source for the `CampaignsListingView` which is used to display the list of campaigns.
 */
class ListingDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, CollectionViewDynamicLayoutDelegate {

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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 450)
    }

    func collectionView(_ collectionView: UICollectionView, heightForCellAtIndexPath indexPath: IndexPath , cellWidth : CGFloat ) -> CGFloat {
        let campaign = campaigns[indexPath.row]
        let width = collectionView.frame.width - 16 // 16 as left and right padding set in labelWithh paddings
        //(taken 4:3 == 1.33 as ratio) as width will be screen width
        let imageHeight: CGFloat = UIScreen.main.bounds.width/1.33
        
        let titleHeight = requiredHeight(text: campaign.name, cellWidth: width,//for padding labels
                                         font: .helviticaBold.withSize(17), numberOfLines: 2) //for title maximum lines be 2
        
        let descriptionHeight = requiredHeight(text: campaign.description, cellWidth: width,//for padding labels
                                         font: .hoeflerTextRegular)
        // 16 as [top and bottom padding for labels set in Paddinglabels]
        return imageHeight + titleHeight + descriptionHeight + 16
    }
    
    func requiredHeight(text:String , cellWidth : CGFloat, font: UIFont, numberOfLines: Int = 0) -> CGFloat {
//        1. Using bounding rect
//        let paragraph = NSMutableParagraphStyle.init()
//        paragraph.minimumLineHeight = font.lineHeight
//        paragraph.maximumLineHeight = font.lineHeight
//        return (text as NSString).boundingRect(with: CGSize(width: cellWidth, height: 1000),
//                                               options: [.usesLineFragmentOrigin,.usesFontLeading],
//                                               attributes: [.font: font, .paragraphStyle: paragraph],
//                                               context: nil).height

//        1. Using label
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: cellWidth, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byClipping
        label.font = font
        label.text = text
        label.sizeToFit() // to fit the label
        label.layoutIfNeeded() // to seet the layout(redraw)
        return label.bounds.height
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
