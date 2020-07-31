//
//  NSBundle+HsTestTool.m
//  HsTestTool
//
//  Created by zanier on 2020/7/1.
//  Copyright © 2020 zanier. All rights reserved.
//

#import "NSBundle+ZZTestTool.h"
#import "HsTestBaseViewController.h"

@implementation NSBundle (ZZTestTool)

+ (instancetype)hs_testToolBundle {
    static NSBundle *testToolBundle = nil;
    if (testToolBundle == nil) {
        testToolBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[HsTestBaseViewController class]] pathForResource:@"HsTestTool" ofType:@"bundle"]];
    }
    return testToolBundle;
}

+ (UIImage *)hs_imageNamed:(NSString *)imageName type:(NSString *)type inDirectory:(NSString *)directory {
    if (!imageName) return nil;
    UIImage *image = [[UIImage imageWithContentsOfFile:[[self hs_testToolBundle] pathForResource:imageName ofType:type inDirectory:directory]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

@end
