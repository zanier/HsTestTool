//
//  HsPlistBrowerPageCell.m
//  HsBusinessEngine
//
//  Created by zanier on 2020/6/8.
//  Copyright © 2020 zanier. All rights reserved.
//

#import "HsPlistBrowerPageCell.h"
#import "HsPlistBrowerNode.h"

@interface HsPlistBrowerPageCell ()

@end

@implementation HsPlistBrowerPageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.detailTextLabel.textColor = UIColor.grayColor;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setNode:(HsPlistBrowerNode *)node {
    if (_node == node) {
        return;
    }
    _node = node;
    // 设置缩进
    self.indentationLevel = node.depth;
    id value = node.value;
    NSString *valueString = nil;
    if ([value isKindOfClass:[NSArray class]]) {
        // 数组
        // text:    key
        // detail:  (0 item)
        NSInteger count = ((NSArray *)value).count;
        valueString =  [NSString stringWithFormat:@"(%li %@)", (long)count, (count == 1) ? @"item" : @"items"];
    } else if ([value isKindOfClass:[NSDictionary class]]) {
        // 字典
        // text:    key
        // detail:  (0 item)
        NSInteger count = ((NSDictionary *)value).count;
        valueString =  [NSString stringWithFormat:@"(%li %@)", (long)count, (count == 1) ? @"item" : @"items"];
    } else if ([value isKindOfClass:[NSNumber class]]) {
        // 数字
        // text:    0
        // detail:
        valueString = ((NSNumber *)value).description;
    } else if ([value isKindOfClass:[NSString class]]) {
        // 字符串
        // text:    String
        // detail:
        valueString = (NSString *)value;
    } else if ([value isKindOfClass:[NSData class]]) {
        // 数据
        // text:    key
        // detail:  (0 B)
        valueString = [NSString stringWithFormat:@"(%lu B)", (unsigned long)((NSData *)value).length];
    }
    
    if (node.key) {
        self.textLabel.text = node.key;
        self.textLabel.textColor = UIColor.blackColor;
        self.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
        self.detailTextLabel.text = valueString;
    } else {
        self.textLabel.text = valueString;
        self.textLabel.textColor = UIColor.grayColor;
        self.textLabel.font = [UIFont systemFontOfSize:12.0];
        self.detailTextLabel.text = nil;
    }
    
    [self setNeedsDisplay];
}

/// 设置 detail 文本
- (NSString *)detailTestStringFromValue:(id)value {
    if ([value isKindOfClass:[NSArray class]]) {
        NSInteger count = ((NSArray *)value).count;
        return [NSString stringWithFormat:@"(%li %@)", count, (count == 1) ? @"item" : @"items"];
    } else if ([value isKindOfClass:[NSDictionary class]]) {
        NSInteger count = ((NSDictionary *)value).count;
        return [NSString stringWithFormat:@"(%li %@)", count, (count == 1) ? @"item" : @"items"];
    } else if ([value isKindOfClass:[NSNumber class]]) {
        return ((NSNumber *)value).description;
    } else if ([value isKindOfClass:[NSString class]]) {
        return (NSString *)value;
    } else if ([value isKindOfClass:[NSData class]]) {
        return [NSString stringWithFormat:@"(%li B)", ((NSData *)value).length];
    }
    return @"";
}

- (void)highlightSearchText:(NSString *)searchText {
    if (self.textLabel.text) {
        NSRange textRange = [[self.textLabel.text uppercaseString] rangeOfString:[searchText uppercaseString]];
        NSMutableAttributedString *textAttributeString = [[NSMutableAttributedString alloc] initWithString:self.textLabel.text attributes:@{
            NSFontAttributeName : [UIFont boldSystemFontOfSize:17.0],
            NSForegroundColorAttributeName : UIColor.blackColor,
        }];
        [textAttributeString addAttributes:@{
            NSForegroundColorAttributeName : UIColor.redColor,
        } range:textRange];
        self.textLabel.attributedText = textAttributeString;
    }
    if (self.detailTextLabel.text) {
        NSRange detailTextRange = [[self.detailTextLabel.text uppercaseString] rangeOfString:[searchText uppercaseString]];
        NSMutableAttributedString *detailTextAttributeString = [[NSMutableAttributedString alloc] initWithString:self.detailTextLabel.text attributes:@{
            NSFontAttributeName : [UIFont systemFontOfSize:12.0],
            NSForegroundColorAttributeName : UIColor.grayColor,
        }];
        [detailTextAttributeString addAttributes:@{
            NSForegroundColorAttributeName : UIColor.redColor,
        } range:detailTextRange];
        self.detailTextLabel.attributedText = detailTextAttributeString;
    }
}

/// 回执收起展开的小三角
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.node.type == HsPlistNodeTypeArray || self.node.type == HsPlistNodeTypeDictionary) {
        CGFloat midX = self.node.depth * self.indentationWidth + 5.0f;
        CGFloat midY = CGRectGetMidY(self.contentView.bounds);
        CGContextRef context = UIGraphicsGetCurrentContext();
        if (self.node.expanded) {
            CGContextMoveToPoint(context, midX - 5, midY - 3);
            CGContextAddLineToPoint(context, midX + 5, midY - 3);
            CGContextAddLineToPoint(context, midX, midY + 3);
        } else {
            CGContextMoveToPoint(context, midX - 3, midY - 5);
            CGContextAddLineToPoint(context, midX - 3, midY + 5);
            CGContextAddLineToPoint(context, midX + 3, midY);
        }
        CGContextClosePath(context);
        CGContextSetFillColorWithColor(context, UIColor.blackColor.CGColor);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
}

@end
