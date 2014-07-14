//
//  CollectionLayoutAlignTop.m
//  CharacterLab
//
//  Created by Veronica Zheng on 7/13/14.
//  Copyright (c) 2014 Dropbox. All rights reserved.
//

#import "CollectionLayoutAlignTop.h"

@implementation CollectionLayoutAlignTop

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray* array = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes* attributes in array) {
        if (attributes.representedElementKind == nil) {
            NSIndexPath* indexPath = attributes.indexPath;
            attributes.frame = [self layoutAttributesForItemAtIndexPath:indexPath].frame;
        }
    }
    return array;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    CGFloat originX = self.sectionInset.left + indexPath.item * (self.itemSize.width + self.minimumInteritemSpacing);
    attributes.frame = CGRectMake(originX, 0, self.itemSize.width, attributes.frame.size.height);
    return attributes;
}


- (CGSize)collectionViewContentSize {
    NSInteger columns = [self.collectionView numberOfItemsInSection:0];
    CGFloat width = self.sectionInset.left + self.sectionInset.right + columns * self.itemSize.width + (columns - 1) * self.minimumInteritemSpacing;
    return CGSizeMake(width, self.collectionView.bounds.size.height);
}

@end
