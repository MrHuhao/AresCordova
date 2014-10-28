//
//  PNCLoadingViewController.m
//  MobileAppProjMobileAppIpad
//
//  Created by 彭小坚 on 14-6-25.
//
//

#import "PNCLoadingViewController.h"
@interface PNCLoadingViewController ()

@property(nonatomic,strong) IBOutlet UIPageControl *pageControl;
@property(nonatomic,strong) IBOutlet UILabel *loadLabel;
@property(nonatomic,assign) NSInteger selectedNum;
@property(nonatomic,retain) NSTimer *animationTimer;
@property(nonatomic) NSInteger num;
@property(nonatomic,strong)NSData* postData;
@property(nonatomic,strong)NSURLConnection *loginConnection;
@property(nonatomic,strong)NSDictionary *loginReasultDic;
@property (retain,nonatomic) NSMutableData *loginResultData;
@end

@implementation PNCLoadingViewController
@synthesize pageControl = _pageControl;
@synthesize loadLabel = _loadLabel;
@synthesize selectedNum = _selectedNum;
@synthesize animationTimer = _animationTimer;
@synthesize num;
@synthesize loginReasultDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil postData:(NSData*)postData
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        num =0;
        self.postData = postData;
    }
    return self;
}

-(void)awakeFromNib{
    
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, 200, 100)];
    [self.view addSubview:_pageControl];
    [_pageControl setPageIndicatorTintColor:[UIColor grayColor]];
    [_pageControl setCurrentPageIndicatorTintColor:[UIColor orangeColor]];
    _pageControl.numberOfPages = 6;
    _loadLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 128, 100)];
    [_loadLabel setTextAlignment:NSTextAlignmentCenter];
    [_loadLabel setCenter:CGPointMake(_pageControl.center.x, _pageControl.center.y+30)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.35 target:self selector:@selector(changeSelected:) userInfo:nil repeats:YES];
}

- (IBAction)changeSelected:(id)sender
{
    num++;
    if (num > 6)
    {
        return;
        [self.loginConnection cancel];
        [self.animationTimer invalidate];
        self.animationTimer = nil;
    }
	self.selectedNum++;
	self.selectedNum = self.selectedNum % 5;
	self.pageControl.currentPage = self.selectedNum;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration{
    NSLog(@"%f",   [UIScreen mainScreen].bounds.size.height);
    if(UIInterfaceOrientationIsPortrait(interfaceOrientation)){
           [_pageControl setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2)];
            [_loadLabel setCenter:CGPointMake(_pageControl.center.x, _pageControl.center.y+30)];
    }else{
            [_pageControl setCenter:CGPointMake([UIScreen mainScreen].bounds.size.height/2, [UIScreen mainScreen].bounds.size.width/2)];
            [_loadLabel setCenter:CGPointMake(_pageControl.center.x, _pageControl.center.y+30)];
    }
}



@end
