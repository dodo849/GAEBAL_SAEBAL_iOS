//
//  MyLayout.swift
//  GaebalSaebal
//
//  Created by 이봄이 on 2022/05/14.
//

import Foundation
import UIKit

protocol MyCollectionViewLayoutDelegate: AnyObject {
    func collectionView(_ collectioncollectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath) -> CGFloat
}

class MyLayout: UICollectionViewLayout {
    weak var delegate: MyCollectionViewLayoutDelegate?
    
    fileprivate var numberOfColumns: Int = 2
    fileprivate var cellPadding:CGFloat = 7.0
    fileprivate var cache: [UICollectionViewLayoutAttributes] = []
    fileprivate var contentHeight: CGFloat = 0.0
    
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0.0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    //바로 다음에 위치할 cell의 위치 구하기 위해서 xOffset, yOffset 계산
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        cache.removeAll()
        
        //xOffset 계산
        let columnWidth: CGFloat = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            let offset = CGFloat(column) * columnWidth
            xOffset += [offset]
        }
        
        //yOffset 계산
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let imageHeight = delegate?.collectionView(collectionView, heightForImageAtIndexPath: indexPath) ?? 0
            let height = cellPadding * 2 + imageHeight
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            // cache 저장
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            //다음 항목이 다음 열에 배치되도록 함. 현재 column이 0이면 1로, 1이면 0으로
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    // rect에 따른 layoutAttributes를 얻는 메서드 재정의
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { rect.intersects($0.frame) }
    }

    // indexPath에 따른 layoutAttribute를 얻는 메서드 재정의
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}

