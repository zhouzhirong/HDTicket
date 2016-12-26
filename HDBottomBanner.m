//
//  HDBottomBanner.m
//  HDTicket
//
//  Created by 周志荣 on 2016/12/23.
//  Copyright © 2016年 周志荣. All rights reserved.
//

#import "HDBottomBanner.h"
@interface HDBottomBanner ()

@property (weak, nonatomic) IBOutlet UIButton *filterButton;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *shootButton;

@end
@implementation HDBottomBanner
//代码加载的时候会依次调用 initWithFrame init
//xib加载的时候会依次调用 initWithCoder awakeFromNib

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

-(void)setDateString:(NSString *)dateString
{
    _dateString = dateString;
    _dateLabel.text = dateString;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)filter:(UIButton *)sender
{
    
    
    
}


- (IBAction)previousDay:(UIButton *)sender
{
    
    
}


- (IBAction)nextDay:(UIButton *)sender
{
    
    
}


- (IBAction)shoot:(UIButton *)sender
{
    
    
}



@end
