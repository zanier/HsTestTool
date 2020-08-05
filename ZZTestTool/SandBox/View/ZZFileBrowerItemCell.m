//
//  ZZFileBrowerItemCell.m
//  HsBusinessEngine
//
//  Created by zanier on 2020/6/28.
//  Copyright © 2020 zanier. All rights reserved.
//

#import "ZZFileBrowerItemCell.h"
#import "ZZFileBrowerManager.h"

@interface ZZFileBrowerItemCell () <UITextViewDelegate, UIContextMenuInteractionDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UITextView *renameTextView;

@end

@implementation ZZFileBrowerItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setItem:(ZZFileBrowerItem *)item {
    _item = item;
    [self reloadItem];
    [self setNeedsLayout];
}

- (void)reloadItem {
    self.textLabel.text = _item.name;
    if (_item.isDir) {
        self.imageView.image = [ZZFileBrowerManager imageWithFileType:_item.type];
        self.detailLabel.text = [NSString stringWithFormat:@"%lu 项", (unsigned long)_item.childrenCount];
    } else if (_item.isImage) {
        NSData *imageData = [NSData dataWithContentsOfFile:_item.path options:NSDataReadingMappedIfSafe error:nil];
        self.imageView.image = [UIImage imageWithData:imageData];
        self.detailLabel.text = [NSString stringWithFormat:@"%@", _item.sizeString];
    } else {
        self.imageView.image = [ZZFileBrowerManager imageWithFileType:_item.type];
        self.detailLabel.text = [NSString stringWithFormat:@"%@", _item.modifyDateString];
    }
}

/// MARK: - rename

- (void)beginRenamingItem {
    self.textLabel.hidden = YES;
    self.detailLabel.hidden = YES;
    self.renameTextView.hidden = NO;
    self.renameTextView.text = self.textLabel.text;
    [self textViewDidChange:self.renameTextView];
    [self.renameTextView becomeFirstResponder];
}

- (void)endRenamingItem {
    [self.renameTextView resignFirstResponder];
    self.renameTextView.hidden = YES;
    self.textLabel.hidden = NO;
    self.detailLabel.hidden = NO;
}

/// 长按单元格，代理回调
- (void)longPressAction:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if ([_delegate respondsToSelector:@selector(cellDidLongPress:)]) {
            [_delegate cellDidLongPress:self];
        }
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
//    if (selected) {
//        self.contentView.backgroundColor = [UIColor grayColor];
//    } else {
//        self.contentView.backgroundColor = [UIColor clearColor];
//    }
}

/// 在高亮时添加长按动画
//- (void)setHighlighted:(BOOL)highlighted {
//    [super setHighlighted:highlighted];
//    if (highlighted) {
//        //self.contentView.backgroundColor = [UIColor grayColor];
//        if ([self.imageView.layer animationForKey:@"animation"]) {
//            return;
//        }
//        CAKeyframeAnimation *keyFrameAniamtion = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
//        keyFrameAniamtion.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        keyFrameAniamtion.values = @[
//            @(CGSizeMake(1.0, 1.0)),
//            @(CGSizeMake(0.9, 0.9)),
//            @(CGSizeMake(1.0, 1.0)),
//        ];
//        keyFrameAniamtion.repeatCount = 1;
//        keyFrameAniamtion.duration = 0.5;
//        keyFrameAniamtion.removedOnCompletion = YES;
//        [self.imageView.layer addAnimation:keyFrameAniamtion forKey:@"animation"];
//    } else {
//        //self.contentView.backgroundColor = [UIColor lightGrayColor];
//    }
//}

/// MARK: - <UITextViewDelegate>

/// 文字即将改变
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([@"\n" isEqualToString:text]) {
        /// return 键换行，结束编辑
        /// 代理回调
        BOOL shouldEnd = YES;
        if ([_delegate respondsToSelector:@selector(cell:shouldEndRenamingWithName:)]) {
            shouldEnd = [_delegate cell:self shouldEndRenamingWithName:self.renameTextView.text];
        }
        if (shouldEnd) {
            [self endRenamingItem];
            [textView resignFirstResponder];
        }
        return shouldEnd;
    }
    return YES;
}

/// 文字发生改变
- (void)textViewDidChange:(UITextView *)textView {
    /// 改变输入框布局
    CGSize fitedSize = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(self.contentView.bounds), 42)];
    CGRect frame = self.renameTextView.frame;
    frame.size = fitedSize;
    frame.origin.x = (CGRectGetWidth(self.contentView.bounds) - fitedSize.width) / 2;
    self.renameTextView.frame = frame;
}

/// MARK: - layout

- (void)setupSubviews {
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.renameTextView];
    self.renameTextView.hidden = YES;
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
//    longPress.minimumPressDuration = 0.3f;
//    [self.contentView addGestureRecognizer:longPress];
    if (@available(iOS 13.0, *)) {
        UIContextMenuInteraction *interaction = [[UIContextMenuInteraction alloc] initWithDelegate:self];
        self.imageView.userInteractionEnabled = YES;
        [self.imageView addInteraction:interaction];
    } else {
        // Fallback on earlier versions
    }

}

- (UIContextMenuConfiguration *)contextMenuInteraction:(UIContextMenuInteraction *)interaction configurationForMenuAtLocation:(CGPoint)location  API_AVAILABLE(ios(13.0)) {
    UIContextMenuConfiguration *configuration = [UIContextMenuConfiguration configurationWithIdentifier:@"qwe" previewProvider:^UIViewController * _Nullable{
        
        return nil;
    } actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
        return [self menumenu];
    }];
    return configuration;
}

- (UIMenu *)menumenu API_AVAILABLE(ios(13.0)) {
    UIAction *action1 = [UIAction actionWithTitle:@"复制" image:nil identifier:@"qwe" handler:^(__kindof UIAction * _Nonnull action) {
    
    }];
    UIAction *action2 = [UIAction actionWithTitle:@"拷贝" image:nil identifier:@"qwe" handler:^(__kindof UIAction * _Nonnull action) {
    
    }];
    UIAction *action3 = [UIAction actionWithTitle:@"移动" image:nil identifier:@"qwe" handler:^(__kindof UIAction * _Nonnull action) {
    
    }];
    UIAction *action4 = [UIAction actionWithTitle:@"删除" image:nil identifier:@"qwe" handler:^(__kindof UIAction * _Nonnull action) {
    
    }];

    UIMenu *menu = [UIMenu menuWithTitle:@"" image:nil identifier:@"hello" options:UIMenuOptionsDestructive children:@[
        action1,
        action2,
        action3,
        action4,
    ]];
    return menu;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat contentWidth = CGRectGetWidth(self.contentView.bounds);
    CGFloat labelWidth = contentWidth;
    CGFloat imageWidth = 75.0f;
    _imageView.frame = CGRectMake((contentWidth - imageWidth) / 2, 10, imageWidth, imageWidth);
    CGSize fitedSize = [_textLabel sizeThatFits:CGSizeMake(labelWidth, 42)];
    CGSize detailFitedSize = [_detailLabel sizeThatFits:CGSizeMake(labelWidth, 42)];
    CGFloat textHeight = fitedSize.height < 42 ? fitedSize.height : 42;
    CGFloat detailHeight = detailFitedSize.height < 42 ? detailFitedSize.height : 42;
    _textLabel.frame = CGRectMake(0, CGRectGetMaxY(_imageView.frame) + 10, labelWidth, textHeight + 0);
    _detailLabel.frame = CGRectMake(0, CGRectGetMaxY(_textLabel.frame) + 5, labelWidth, detailHeight + 0);
    _renameTextView.frame = _textLabel.frame;
}

/// MARK: - getter

- (UIImageView *)imageView {
    if (_imageView) {
        return _imageView;
    }
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    return _imageView;
}

- (UILabel *)textLabel {
    if (_textLabel) {
        return _textLabel;
    }
    _textLabel = [[UILabel alloc] init];
    _textLabel.font = [UIFont systemFontOfSize:15.0f];
    _textLabel.textColor = [UIColor darkTextColor];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.numberOfLines = 0;
    _textLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    return _textLabel;
}

- (UILabel *)detailLabel {
    if (_detailLabel) {
        return _detailLabel;
    }
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.font = [UIFont systemFontOfSize:12.0f];
    _detailLabel.textColor = [UIColor grayColor];
    _detailLabel.textAlignment = NSTextAlignmentCenter;
    _detailLabel.numberOfLines = 0;
    _detailLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    return _detailLabel;
}

- (UITextView *)renameTextView {
    if (_renameTextView) {
        return _renameTextView;
    }
    _renameTextView = [[UITextView alloc] init];
    _renameTextView.delegate = self;
    _renameTextView.font = [UIFont systemFontOfSize:15.0f];
    _renameTextView.textColor = [UIColor darkTextColor];
    _renameTextView.returnKeyType = UIReturnKeyDone;
    _renameTextView.textAlignment = NSTextAlignmentCenter;
    _renameTextView.layer.cornerRadius = 5.0f;
    _renameTextView.layer.masksToBounds = YES;
    _renameTextView.showsVerticalScrollIndicator = YES;
    _renameTextView.showsHorizontalScrollIndicator = NO;
    _renameTextView.backgroundColor = [UIColor colorWithWhite:(222.0/255) alpha:1.0];
    return _renameTextView;
}

@end
