//
//  ZZFileBrowerController.h
//  ZZTestTool
//
//  Created by zanier on 2020/7/5.
//  Copyright © 2020 zanier. All rights reserved.
//

#import "ZZTestBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

/// `createPage:` 参数中基本根目录的key
static NSString *const ZZFileBrowerControllerRootPathKey = @"ZZFileBrowerControllerRootPathKey";

/// 沙盒文件浏览页面
@interface ZZFileBrowerController : ZZTestBaseViewController

/// 工程创建方法，参数内容参考上面的 key
+ (instancetype)createPage:(nullable NSDictionary*)params;

/// 初始化方法
/// @param rootPath 根目录文件路径，传 nil 则进入沙盒根目录
- (instancetype)initWithRootPath:(nullable NSString *)rootPath;

/// 根目录文件路径
@property (nonatomic, copy) NSString *rootPath;

@end

NS_ASSUME_NONNULL_END
