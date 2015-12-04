//
//  DropdownItem.m
//  WXGTableView
//
//  Created by 风往北吹_ on 15/11/30.
//  Copyright © 2015年 wangxg. All rights reserved.
//

#import "DropdownItem.h"

@interface DropdownItem ()

@property (nonatomic, assign) CGSize size;

@end

@implementation DropdownItem

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andImage:(UIImage *)image {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = frame;
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.imageView];
        
        _titleLabel.text = title;
        _imageView.image = image;

        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:TEXTFONT(13)}];
        CGSize imageSize = image.size;
        
        CGFloat offsetX = 0,offsetY = 0;
        CGFloat sizeHeight = 0, sizeWidth = 0;
        
        // title最大宽度
        CGFloat titleMaxWidth = frame.size.width - image.size.width - 25;
        CGFloat titleWidth = titleSize.width;
        if (titleSize.width > titleMaxWidth) {
            titleWidth = titleMaxWidth;
        }
        
        // 控件总高
        if (titleSize.height > imageSize.height) {
            sizeHeight = titleSize.height;
        } else {
            sizeHeight = imageSize.height;
        }
        //控件总宽
        sizeWidth = titleWidth + imageSize.width;
        _size = CGSizeMake(sizeWidth, sizeHeight);
        offsetX = (frame.size.width - sizeWidth) / 2;
        offsetY = (frame.size.height - sizeHeight) / 2;
        
        // 计算位置
        _titleLabel.frame = CGRectMake(offsetX, offsetY, titleWidth, titleSize.height);
        _imageView.frame = CGRectMake(offsetX + titleWidth + 5,offsetY+(sizeHeight-imageSize.height)/2,
                                      imageSize.width, imageSize.height);
    }
    return self;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = TEXTFONT(13);
        _titleLabel.textColor = ColorWihtRGBA(68, 68, 68);
    }
    return _titleLabel;
}

- (UIImageView *)imageView {
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

@end
