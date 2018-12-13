//
//  NSBundle+BDBundle.m
//  testBDPlayer
//
//  Created by Tilt on 2018/12/12.
//  Copyright © 2018年 eoffcn. All rights reserved.
//

#import "NSBundle+BDBundle.h"

@implementation NSBundle (BDBundle)

+ (NSBundle *)bd_Bundle {
    static NSBundle *bdBundle = nil;
    if (!bdBundle) {
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"TWBDPlayerFiles" ofType:@"bundle"];
        bdBundle = [NSBundle bundleWithPath:bundlePath];
    }
    return bdBundle;
}

@end
