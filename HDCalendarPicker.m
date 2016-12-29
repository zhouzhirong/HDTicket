


#import "HDCalendarPicker.h"
#import "HDCalenderCell.h"


NSString *const HDCalendarCellIdentifier = @"cell";

@interface HDCalendarPicker ()
@property (nonatomic , weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic , weak) IBOutlet UILabel *monthLabel;
@property (nonatomic , strong) NSArray *weekDayArray;
@property (nonatomic , strong) UIView *mask;
@end

@implementation HDCalendarPicker


- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self addSwipe];
    [self show];
}

/**
 使用xib 会调用本方法
 */
- (void)awakeFromNib
{
    [super awakeFromNib];
    [_collectionView registerClass:[HDCalendarCell class] forCellWithReuseIdentifier:HDCalendarCellIdentifier];
     _weekDayArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
}

- (void)customInterface
{
    CGFloat itemWidth = _collectionView.frame.size.width / 7;
    CGFloat itemHeight = _collectionView.frame.size.height / 7;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    [_collectionView setCollectionViewLayout:layout animated:YES];
}

//date 的set方法 主要驱动力
- (void)setDate:(NSDate *)date
{
    _date = date;
    [_monthLabel setText:[NSString stringWithFormat:@"%.2ld 年 %li 月",(long)[self year:date],(long)[self month:date]]];
    _monthLabel.textAlignment = NSTextAlignmentCenter;
    [_monthLabel setTextColor:[UIColor blackColor]];
    [_collectionView reloadData]; //驱动力
}

#pragma mark - date
//日期
- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}
//月份
- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}
//年份
- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}

//当月1号为星期几,2016年12月1号---周四     按照周日为每周第一天计算
- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //设置周日 为每个星期第一天
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    // 当月的第一天 date类型
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange totaldaysInMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return totaldaysInMonth.length;
}

- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

- (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

//给定date日期,求星期几
- (NSString *)weekdayStringFromDate:(NSDate *)date
{
    NSArray *weekdays = @[[NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timezone = [[NSTimeZone alloc]initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone:timezone];
    NSCalendarUnit unit = NSCalendarUnitWeekday;
    NSDateComponents *comp = [calendar components:unit fromDate:date];
    return [weekdays objectAtIndex:comp.weekday];
}


#pragma -mark collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return _weekDayArray.count;
    } else {
        return 42;
    }
}
// 以2016年 12月为例分析
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HDCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HDCalendarCellIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        [cell.dateLabel setText:_weekDayArray[indexPath.row]];
         //星期的颜色
        [cell.dateLabel setTextColor:[UIColor blackColor]];
    } else {
        //每个月多少天 31
        NSInteger daysInThisMonth = [self totaldaysInMonth:_date];
        //每个月第一天是星期几
        NSInteger firstWeekday = [self firstWeekdayInThisMonth:_date];
        
        NSInteger day = 0;
        //i 表示第几个item
        NSInteger i = indexPath.row;
        
        if (i < firstWeekday) {  /*  小于4号的情况-----属于上一个月 */
            
            [cell.dateLabel setText:@""];
            
        }else if (i > firstWeekday + daysInThisMonth - 1){  /*  属于下一个月  */
            
            [cell.dateLabel setText:@""];
            
        }else{    /*  属于这个月 day==1 代表1号那一天 */
            day = i - firstWeekday + 1;
            [cell.dateLabel setText:[NSString stringWithFormat:@"%li",(long)day]];
            //早于当前日期的颜色
            [cell.dateLabel setTextColor:RGB(159, 159, 159)];
            
            //this month
            if ([_today isEqualToDate:_date])
            {
                if (day == [self day:_date])
                {
                    //当日的颜色
                    [cell.dateLabel setTextColor:[UIColor redColor]];
                } else if (day > [self day:_date])
                {
                     //当月未到来的日期颜色
                    [cell.dateLabel setTextColor:[UIColor blackColor]];
                }
            } else if ([_today compare:_date] == NSOrderedAscending)
            {
                //除当月外 将来时间的颜色
                [cell.dateLabel setTextColor:[UIColor blackColor]];
            } else if ([_today compare:_date] == NSOrderedDescending)
            {
                //过去的月份
                [cell.dateLabel setTextColor:RGB(159, 159, 159)];
            }
        }
    }
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        NSInteger daysInThisMonth = [self totaldaysInMonth:_date];  //31
        NSInteger firstWeekday = [self firstWeekdayInThisMonth:_date]; //4
        
        NSInteger day = 0;
        NSInteger i = indexPath.row;
        
        if (i >= firstWeekday && i <= firstWeekday + daysInThisMonth - 1) {
            day = i - firstWeekday + 1;
            
            //this month
            if ([_today isEqualToDate:_date])
            {
                if (day >= [self day:_date])
                {
                    return YES;
                }
            } else if ([_today compare:_date] == NSOrderedAscending) //NSOrderedAscending = -1 _today<_date
            {
                return YES;
            }
        }
    }
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.date];
    NSInteger firstWeekday = [self firstWeekdayInThisMonth:_date];
    
    NSInteger day = 0;
    NSInteger i = indexPath.row;
    day = i - firstWeekday + 1;
    
#pragma mark //这里利用代理处理回调
   
    UIViewController *calenderVC = (UIViewController *)self.superview.nextResponder;
    [calenderVC.navigationController popViewControllerAnimated:YES];
    
    self.delegate = calenderVC.navigationController.viewControllers[0];
    
    if ([self.delegate respondsToSelector:@selector(updateTableViewWithSource:)]) {
        NSDictionary *dic = @{
                              @"index":@2,
                              @"detail":[NSString stringWithFormat:@"%ld年%ld月%ld日",[comp year],[comp month],day]
                              };
        [self.delegate updateTableViewWithSource:dic];
    }
}

- (IBAction)previouseAction:(UIButton *)sender
{
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlDown animations:^(void) {
        self.date = [self lastMonth:self.date];
    } completion:nil];
}

- (IBAction)nexAction:(UIButton *)sender
{
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlUp animations:^(void) {
        self.date = [self nextMonth:self.date];
    } completion:nil];
}


/**
 这个view是VC.view
 */
+ (instancetype)showOnView:(UIView *)view
{
    HDCalendarPicker *calendarPicker = [[[NSBundle mainBundle] loadNibNamed:@"HDCalendarPicker" owner:self options:nil] firstObject];
    calendarPicker.mask = [[UIView alloc] initWithFrame:view.bounds];
    calendarPicker.mask.backgroundColor = [UIColor blackColor];
    calendarPicker.mask.alpha = 0.3;
    [view addSubview:calendarPicker.mask];
    [view addSubview:calendarPicker];
    return calendarPicker;
}

- (void)show
{
    self.transform = CGAffineTransformTranslate(self.transform, 0, - self.frame.size.height);
    [UIView animateWithDuration:0.5 animations:^(void) {
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL isFinished) {
        [self customInterface];
    }];
}


- (void)addSwipe
{
    UISwipeGestureRecognizer *swipLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nexAction:)];
    swipLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipLeft];
    
    UISwipeGestureRecognizer *swipRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previouseAction:)];
    swipRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipRight];
}


@end













