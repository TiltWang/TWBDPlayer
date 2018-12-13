//
//  UIImage+BDImage.m
//  testBDPlayer
//
//  Created by Tilt on 2018/12/12.
//  Copyright © 2018年 eoffcn. All rights reserved.
//

#import "UIImage+BDImage.h"
#import "NSBundle+BDBundle.h"

@implementation UIImage (BDImage)
+ (UIImage *)bd_imageNamed:(NSString *)name {
    return [UIImage imageNamed:name inBundle:[NSBundle bd_Bundle] compatibleWithTraitCollection:nil];
}
@end
