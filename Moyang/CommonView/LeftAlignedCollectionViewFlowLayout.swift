//
//  LeftAlignedCollectionViewFlowLayout.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/01.
//

import UIKit

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = 0.0
        attributes?.forEach { layoutAttribute in
            // 모든 cell이 순차적으로 왼쪽 위에서 오른쪽 아래로 attribute가 정렬되어 있다는 것을 기준 전제로 가지고 있는 로직.
            if layoutAttribute.representedElementCategory == .cell {
                // 해당 행의 첫 번째 cell인지 아닌지 확인하는 부분 - 왼쪽 좌표 초기화
                if layoutAttribute.frame.origin.y >= maxY {
                    // 보통 여기서 0이 할당 됨 - 기본 인셋을 줬을 경우 해당 값
                    leftMargin = sectionInset.left
                }
                // 부모뷰를 기준으로 내 위치의 x값을 바꾸는 부분
                layoutAttribute.frame.origin.x = leftMargin
                leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
                maxY = max(layoutAttribute.frame.maxY, maxY)
            }
        }
        return attributes
    }
}
