//
//  PBFacialLayout.h
//  SayPal
//
//  Created by Jpache on 16/2/19.
//  Copyright © 2016年 cusflo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBFacialLayout : UICollectionViewFlowLayout
/**
 *  有几列
 */
@property (nonatomic, assign) NSInteger m_numberOfColums;
/**
 *  有几行
 */
@property (nonatomic, assign) NSInteger m_numberOfLines;
/**
 *  cell之间的间隔
 */
@property (nonatomic, assign) CGFloat m_lineSpacing;

@end

