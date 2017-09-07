//
//  ViewController.m
//  ScrollWithHeader
//
//  Created by Rey on 2017/9/7.
//  Copyright © 2017年 Rey. All rights reserved.
//

#import "ViewController.h"
#import "MutibleTableView.h"
#import "UIViewExt.h"
#define screen_wid [[UIScreen mainScreen] bounds].size.width
#define screen_hei [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    UIView *headerView;
}
@property (strong, nonatomic)MutibleTableView *backTable;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic,copy)NSString *upSwipeStr;
@property (nonatomic, strong)UIImageView * aboveView;
@property (nonatomic, strong)UIImageView * belowView;
@property (nonatomic,assign)CGFloat historyY;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)createUI{
    
    _dataArray = [NSMutableArray array];
    for(NSInteger i=0;i<15;i++){
        NSString *string = [NSString stringWithFormat:@"I am have a good position,my number is %ld",(long)i];
        [_dataArray addObject:string];
    }
    
    _backTable = [[MutibleTableView alloc]initWithFrame:CGRectMake(0, 0, screen_wid, screen_hei) style:UITableViewStylePlain];
    _backTable.delegate = self;
    _backTable.dataSource = self;
    [self.view addSubview:_backTable];
    UISwipeGestureRecognizer *upSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(moveTable:)];
    upSwipe.delegate = self;
    upSwipe.direction = UISwipeGestureRecognizerDirectionUp;
    [_backTable addGestureRecognizer:upSwipe];
    
    
    UISwipeGestureRecognizer *downSwip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(moveTable:)];
    downSwip.delegate = self;
    downSwip.direction = UISwipeGestureRecognizerDirectionDown;
    [_backTable addGestureRecognizer:downSwip];
    self.backTable.userInteractionEnabled = YES;
    
    UIImage *headerImage = [UIImage imageNamed:@"header"];
    UIImage *topImage = [UIImage imageNamed:@"topImage"];
    
    CGFloat topHei0 = screen_wid*headerImage.size.height/headerImage.size.width;
    CGFloat topHei1 = screen_wid*topImage.size.height/topImage.size.width;
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_wid, MAX(topHei0, topHei1))];
    _aboveView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screen_wid, topHei0)];
    _aboveView.image = headerImage;
    _belowView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (topHei0-topHei1), screen_wid, topHei1)];
    _belowView.image = topImage;
    [headerView addSubview:_belowView];
    [headerView addSubview:_aboveView];
    self.backTable.tableHeaderView = headerView;


}


-(void)moveTable:(UISwipeGestureRecognizer *)swp{
    if(swp.direction == UISwipeGestureRecognizerDirectionUp){
        self.upSwipeStr = @"1";
        
    }
    else if(swp.direction == UISwipeGestureRecognizerDirectionDown){
        self.upSwipeStr = @"2";
    }
    
}



#pragma mark -- tableviewDelegate----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _dataArray.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (80+10+10);
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIImage *cellImage = [UIImage imageNamed:@"little"];
    CGFloat width = 80;
    CGFloat height = cellImage.size.height*width/cellImage.size.width;
    static NSString *reuseStr = @"reuseCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseStr];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseStr];
        UIImageView *pictureImgv = [[UIImageView alloc]initWithFrame:CGRectMake(10,10, width,height)];
        
        pictureImgv.image = cellImage;
        pictureImgv.clipsToBounds = YES;
        pictureImgv.layer.cornerRadius = 8;
        pictureImgv.tag = 91;
        UILabel *titLab = [[UILabel alloc]init];
        titLab.frame = CGRectMake(CGRectGetMaxX(pictureImgv.frame)+10, pictureImgv.frame.origin.y, screen_wid-(CGRectGetMaxX(pictureImgv.frame)+10+10+10), 40);
        titLab.font = [UIFont systemFontOfSize:14];
        titLab.textColor = [UIColor blackColor];
        titLab.numberOfLines = 0;
        titLab.tag = 92;
        [cell.contentView addSubview:pictureImgv];
        [cell.contentView addSubview:titLab];
        
    }
    
    UILabel *titLab = [cell.contentView viewWithTag:92];
    titLab.numberOfLines = 0;
//    UIImageView *picture = [cell.contentView viewWithTag:91];
    titLab.text = _dataArray[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
    
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView == _backTable){
        
        
        
        CGFloat cha = self.aboveView.height-self.belowView.height;
        CGFloat factor = self.aboveView.height/cha-1;
        
        if ([self.upSwipeStr isEqualToString:@"1"]) {//上滑动
            if(scrollView.contentOffset.y<self.aboveView.height){
                if(self.aboveView.top<self.aboveView.height){
                    self.aboveView.top = -factor*scrollView.contentOffset.y;
                }
            }
        }else if([self.upSwipeStr isEqualToString:@"2"]){//下滑动
            if(scrollView.contentOffset.y<self.aboveView.height){
                if(self.aboveView.top<=0){
                    if(scrollView.contentOffset.y>0){
                        self.aboveView.top = -factor*scrollView.contentOffset.y;
                    }
                }
            }
        }
        
        
    }
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if(scrollView==_backTable){
        _historyY = scrollView.contentOffset.y;
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
   
    if(scrollView==_backTable){
        if(!decelerate){
            [self doSomeScroll:scrollView];
        }
    }
    
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


-(void)doSomeScroll:(UIScrollView *)scrollView{
    
        CGFloat lessValue = self.aboveView.height-self.belowView.height;
        //       if (scrollView.contentOffset.y<headerView.height/2 ){
        if ([self.upSwipeStr isEqualToString:@"1"]){
            if(_historyY==0){
                [scrollView setContentOffset:CGPointMake(0, lessValue) animated:YES];
            }
            
            else if(scrollView.contentOffset.y<headerView.height/2){
                
                [UIView animateWithDuration:0.1 animations:^{
                    self.aboveView.top = -self.aboveView.height;
                    [scrollView setContentOffset:CGPointMake(0, self.aboveView.height-self.belowView.height) animated:NO];
                    
                } completion:^(BOOL finished) {
                    if(finished){
                    }
                }];
            }
        }else if ([self.upSwipeStr isEqualToString:@"2"]){
            
            //            if(_historyY>cha && scrollView.contentOffset.y<=_ycView.height){
            //                [scrollView setContentOffset:CGPointMake(0, cha) animated:NO];
            //            }
            //
            //            else
            if(self.aboveView.top<0 && scrollView.contentOffset.y<self.aboveView.height-self.belowView.height){
                
                [UIView animateWithDuration:0.1 animations:^{
                    self.aboveView.top = 0;
                    [scrollView setContentOffset:CGPointMake(0,0) animated:NO];
                } completion:^(BOOL finished) {
                    if(finished){
                    }
                }];
            }
        }
        
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView   // called on finger up as we are moving
{
    
    //    if(scrollView == _backTable  && _zixunListArray.count>0){
    if(scrollView == _backTable){
        [self doSomeScroll:scrollView];
    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if(scrollView==_backTable){
        
        
        [self doSomeScroll:scrollView];
        
    }
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
