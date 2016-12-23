//
//  CustomCell.m
//  HDTicket
//
//  Created by 周志荣 on 16/12/12.
//  Copyright © 2016年 周志荣. All rights reserved.
//

#import "CustomCell.h"

@interface CustomCell ()

@property (nonatomic,strong)UILabel *label;

@end
@implementation CustomCell

/**
 为什么会走多次: 复用--从缓存池中取出来的cell没有这个属性 所以会在此创建一次导致会创建两个label   如果复用很多的话就会创建很多个！！！
 */
-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2-120/2, self.frame.size.height/2-30/2,120, 30)];
        _label.center = self.center;
        NSLog(@"center");
    }
    return _label;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
//由于cell复用会出现一些颜色 标签错用等等
-(void)setModel:(Model *)model
{
    _model = model;
    switch (model.cellType) {
            
        case CellTypeRegular:    //常规cell
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            self.imageView.image = IMAGE(model.imageName);
            self.textLabel.text = model.title;
            self.textLabel.textColor = RGB(25, 25, 25);
            self.detailTextLabel.text = model.detalTitle;
            self.detailTextLabel.textColor = RGB(56, 57, 136);
            
            break;
        case CellTypeSingle:     //只有一个标签
            
//            添加一个label
//            self.label.text = self.model.title;
//            _label.textAlignment = NSTextAlignmentCenter;
//            _label.textColor = RGB(51, 125, 255);
//            [self addSubview:_label];
//            NSLog(@"self----%@,_label---%@",self,_label);
            
            
//            使用系统的textLabel  改变位置在layoutSubviews改变
                self.textLabel.text = self.model.title;
                self.textLabel.textAlignment = NSTextAlignmentCenter; //文字居中
                self.textLabel.textColor = RGB(51, 125, 255);   //文字颜色
            //由于复用cell 会导致section1复用了section0的cell  把多余的部分去掉
            if (self.detailTextLabel.text) {
                self.imageView.image = nil;
                self.detailTextLabel.text = nil;
                self.accessoryType = UITableViewCellAccessoryNone;
            }
            
            break;
        case CellTypeTriple:     //有三个标签
            
            //先不管
            
            break;
        default:
            break;
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    if (self.model.cellType == CellTypeSingle) {
        //点击cell也会触发 layoutSubviews  加一个保护
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
            self.textLabel.frame = CGRectMake(WIDTH/2-120/2, self.frame.size.height/2-30/2,120, 30);
//        });
    }else if (self.model.cellType == CellTypeTriple){
        
        //同理可以设置 三个标签的cell
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
