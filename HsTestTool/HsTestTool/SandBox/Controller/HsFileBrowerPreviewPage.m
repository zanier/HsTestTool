//
//  HsFileBrowerPreviewPage.m
//  HsTestTool
//
//  Created by handsome on 2020/7/10.
//  Copyright © 2020 Hundsun. All rights reserved.
//

#import "HsFileBrowerPreviewPage.h"
#import <QuickLook/QuickLook.h>

@interface HsFileBrowerPreviewPage () <QLPreviewControllerDataSource>

@end

@implementation HsFileBrowerPreviewPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/// MARK: - <QLPreviewControllerDataSource>

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return nil;
}

@end
