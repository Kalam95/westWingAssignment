//
//  CollectionViewDynamicLayout.swift
//  CampaignBrowser
//
//  Created by mehboob Alam on 24/08/21.
//  Copyright © 2021 Westwing GmbH. All rights reserved.
//

import UIKit

//MARK:- Customlayout
protocol CollectionViewDynamicLayoutDelegate: AnyObject {
  func collectionView(_ collectionView: UICollectionView, heightForCellAtIndexPath indexPath: IndexPath , cellWidth : CGFloat ) -> CGFloat
}

class CollectionViewDynamicLayout: UICollectionViewLayout {
    
  weak var delegate: CollectionViewDynamicLayoutDelegate?
  private let cellPadding: CGFloat = 8
  private var cache: [UICollectionViewLayoutAttributes] = []
  private var contentHeight: CGFloat = 0
  private var contentWidth: CGFloat {
    guard let collectionView = collectionView else {
      return 0
    }
    let insets = collectionView.contentInset
    return collectionView.bounds.width - (insets.left + insets.right)
  }

  override var collectionViewContentSize: CGSize {
    return CGSize(width: contentWidth, height: contentHeight)
  }
  
  override func prepare() {
    guard cache.isEmpty == true,let collectionView = collectionView else {
        return
    }
    let columnWidth = UIScreen.main.bounds.width
    var yOffset = CGFloat.zero
      
    for item in 0..<collectionView.numberOfItems(inSection: 0) {
      let indexPath = IndexPath(item: item, section: 0)
      let cellHight = delegate?.collectionView(collectionView,
        heightForCellAtIndexPath: indexPath , cellWidth: columnWidth) ?? 200
      let height = cellPadding * 2 + cellHight
      let frame = CGRect(x: 0,y: yOffset,width: columnWidth,height: height)

      let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
      attributes.frame = frame
      cache.append(attributes)
      contentHeight = max(contentHeight, frame.maxY)
      yOffset = yOffset + height
    }
  }

  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
    
    // Loop through the cache and look for items in the rect
    for attributes in cache {
      if attributes.frame.intersects(rect) {
        visibleLayoutAttributes.append(attributes)
      }
    }
    return visibleLayoutAttributes
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return cache[indexPath.item]
  }
}
