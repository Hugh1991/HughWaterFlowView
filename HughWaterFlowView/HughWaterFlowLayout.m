//
//  HughWaterFlowLayout.m
//  HughWaterFlowView
//
//  Created by xiaoniu-mac on 2018/12/12.
//  Copyright © 2018 Hugh. All rights reserved.
//

#import "HughWaterFlowLayout.h"

#define HughScreenWidth [UIScreen mainScreen].bounds.size.width
#define HughColumnsCount 3 //列数

@interface HughWaterFlowLayout ()

@property (nonatomic,weak,nullable) id<UICollectionViewDelegateFlowLayout> delegate;

@property (nonatomic,strong) NSMutableDictionary *attributes;//存放item的位置信息
@property (nonatomic,strong) NSMutableArray *heightArray;//存放每一个列的高度的数组

@end

@implementation HughWaterFlowLayout

/**
 准备布局item前调用，可以在这里面完成必要属性的初始化
 */
- (void)prepareLayout {
    [super prepareLayout];
    
    self.attributes = [NSMutableDictionary dictionary];
    self.heightArray = [NSMutableArray arrayWithCapacity:HughColumnsCount];
    
    for (int i = 0; i < HughColumnsCount; ++i) {
        [self.heightArray addObject:@(0.f)];
    }
    
    self.delegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    
    NSUInteger sectionCount = [self.collectionView numberOfSections];
    
    for (int section = 0; section < sectionCount; ++section) {
        NSUInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        
        for (int row = 0; row < itemCount; ++row) {
            [self layoutItemFrameAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
        }
    }
}

/**
 设置每个item的尺寸并和indexPath为键值对存在字典里
 */
- (void)layoutItemFrameAtIndexPath:(NSIndexPath *)indexPath {
    UIEdgeInsets edgeInsets = [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:indexPath.section];
    CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    
    CGFloat itemWidth = (HughScreenWidth - HughColumnsCount * edgeInsets.left - HughColumnsCount * edgeInsets.right) / HughColumnsCount;
    CGFloat itemHeight = itemWidth * itemSize.height / itemSize.width;
    
    itemSize = CGSizeMake(itemWidth, itemHeight);
    
    NSUInteger miniIndex = 0;
    CGFloat miniHeight = [self.heightArray[miniIndex] floatValue];
    
    //获取最小的y值 (通过获取最小y值进行设置frame 保证在collectionView加载完成之后底部item的bottom相差较小)
    for (int index = 1; index < self.heightArray.count; ++index) {
        CGFloat currentCloHeight = [self.heightArray[index] floatValue];
        
        if (miniHeight > currentCloHeight) {
            miniHeight = currentCloHeight;
            miniIndex = index;
        }
    }
    
    //在当前高度最低的列上面追加item并且存储位置信息
    CGFloat x = edgeInsets.left + miniIndex * (edgeInsets.left + edgeInsets.right + itemWidth);
    CGFloat y = edgeInsets.top + miniHeight + edgeInsets.bottom;
    
    CGRect frame = CGRectMake(x, y, itemSize.width, itemSize.height);
    
    [self.attributes setValue:indexPath forKey:NSStringFromCGRect(frame)];
    
    [self.heightArray replaceObjectAtIndex:miniIndex withObject:@(CGRectGetMaxY(frame))];
}

/**
 返回所有当前在可视范围内的item的布局属性
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *indexPaths = [NSMutableArray array];
    
    for (NSString *itemRectInfo in self.attributes) {
        CGRect itemRect = CGRectFromString(itemRectInfo);
        
        if (CGRectIntersectsRect(itemRect, rect)) {
            NSIndexPath *indexPath = self.attributes[itemRectInfo];
            [indexPaths addObject:indexPath];
        }
    }
    
    NSMutableArray *attributeArray = [NSMutableArray arrayWithCapacity:indexPaths.count];
    
    for (NSIndexPath *index in indexPaths) {
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:index];
        [attributeArray addObject:attribute];
    }
    
    return attributeArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    for (NSString * itemFrame in self.attributes) {
        if (self.attributes[itemFrame] == indexPath) {
            attribute.frame = CGRectFromString(itemFrame);
            break;
        }
    }
    
    return attribute;
}

/**
 计算collectionView的可滚动范围，必重写 (在视图预加载计算完成位置信息之后进行调用)
 */
- (CGSize)collectionViewContentSize {
    CGFloat maxHeight = [self.heightArray[0] floatValue];
    
    for (int clo = 1; clo < self.heightArray.count; ++clo) {
        CGFloat currentCloHeight = [self.heightArray[clo] floatValue];
        
        if (maxHeight < currentCloHeight) {
            maxHeight = currentCloHeight;
        }
    }
    
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame), maxHeight + self.collectionView.contentInset.bottom);
}

@end
