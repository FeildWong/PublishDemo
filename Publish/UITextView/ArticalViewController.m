//
//  ViewController.m
//  XTextView
//
//  Created by 张迎秋 on 2017/5/13.
//  Copyright © 2017年 Arthur. All rights reserved.
//

#import "ArticalViewController.h"
#import "UITextView+PlaceHolder.h"
#import "ZWTextView.h"
#import "ToolBar.h"
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kColor [UIColor orangeColor]
#define kToolBarHeight 50
@interface ArticalViewController ()<UIScrollViewDelegate>
{
    CGFloat _lastContentOffset;

}
@property (nonatomic,strong) ToolBar * toolBar; //底部工具栏
@property (nonatomic,strong) ZWTextView * titleView; // 标题
@property (strong, nonatomic) ZWTextView *textView;  // 正文
@property (nonatomic,strong) UIView * lineView;      //分割线
@property (strong, nonatomic) UILabel *wordLabel;    //字数显示

@property (nonatomic,assign) NSInteger number;
@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,assign) CGFloat totalKeyBoardHeight;
@end

@implementation ArticalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self setNaviagtionBar];
    [self setSubViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - 设置导航栏
- (void) setNaviagtionBar{
    //发布按钮
    UIButton * postButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [postButton setTitle:@"发布" forState:UIControlStateNormal];
    [postButton setTitleColor:kColor  forState:UIControlStateNormal];
    [postButton addTarget:self action:@selector(postAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * postItem = [[UIBarButtonItem alloc] initWithCustomView:postButton];
    self.navigationItem.rightBarButtonItem = postItem;
    
    //字数显示Label
    self.wordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,50, 30)];
    self.wordLabel.textColor = kColor;
    self.wordLabel.text = @"0字";
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.wordLabel];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0, 0, 50, 30);
    [closeButton setTitleColor:kColor forState:UIControlStateNormal];
    [closeButton setTitle:@"close" forState:UIControlStateNormal];
    
    [closeButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    
    self.navigationItem.leftBarButtonItems = @[backItem,leftItem];

}

/**
 返回按钮触发事件
 */
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES ];
}

#pragma mark - 设置子视图
- (void) setSubViews{

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    self.scrollView.delegate =self;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.contentSize = CGSizeMake(0, kHeight);
    [self.view addSubview:self.scrollView];
    
    self.titleView = [[ZWTextView alloc] initWithFrame:CGRectMake(10, 70,kWidth-20, 50) TextFont:[UIFont systemFontOfSize:23] MoveStyle:styleMove_Down];
    self.titleView.tintColor = kColor;
    self.titleView.maxNumberOfLines = MAXFLOAT;
    self.titleView.placeholder = @"请输入标题";
    [self.scrollView addSubview:self.titleView];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleView.frame)+10,kWidth - 20 , 1)];
    self.lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.scrollView addSubview:self.lineView];
    
    
    self.textView = [[ZWTextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.lineView.frame)+10,kWidth - 20 , 30) TextFont:[UIFont systemFontOfSize:17] MoveStyle:styleMove_Down];
    self.textView.tintColor = kColor;
    self.textView.maxNumberOfLines = MAXFLOAT;
    self.textView.placeholder = @"请输入正文";
    [self.scrollView addSubview:self.textView];
    
    self.toolBar = [[ToolBar alloc] initWithFrame:CGRectMake(0, kHeight-kToolBarHeight, kWidth, kToolBarHeight) btImgArray:@[@"",@"",@"",@"",@"",@""]];
    self.toolBar.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.toolBar setToolBarButtonClickBlock:^(long btTag){
        
        NSLog(@"点击了第%ld个按钮",btTag);
        
    }];
    [self.view addSubview:self.toolBar];
    
}
#pragma mark - ScrollView代理
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    _lastContentOffset = scrollView.contentOffset.y;
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y<_lastContentOffset){
        [self.titleView resignFirstResponder];
        [self.textView resignFirstResponder];
    }
}
#pragma mark - TextView代理，获取输入字数
- (void)textViewEditChanged:(NSNotification*)obj {
    UITextView * tx = obj.object;
    UITextView *textView = self.textView;
    NSString *textStr = textView.text;
    NSInteger fontNum =  textStr.length;

    fontNum = fontNum < 0 ? 0 : fontNum;
    self.wordLabel.text = [NSString stringWithFormat:@"%@字",@(fontNum)];
    
    self.lineView.frame = CGRectMake(10, CGRectGetMaxY(self.titleView.frame)+10,kWidth - 20 , 1);
    self.textView.y =CGRectGetMaxY(self.lineView.frame)+10;
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.textView.frame));
    
    if (CGRectGetMaxY(self.textView.frame)>kHeight-_totalKeyBoardHeight&&tx==textView) {
        self.scrollView.contentOffset  = CGPointMake(0, CGRectGetMaxY(self.textView.frame)-_totalKeyBoardHeight-kToolBarHeight);
    }

}

#pragma mark - 发布按钮点击事件
- (void)postAction:(UIButton *) button{
   
    NSString * title = self.titleView.text.length?self.titleView.text:@"标题无";
    NSString * message = self.textView.text.length?self.textView.text:@"内容无";

    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];

}
#pragma mark - 键盘监听
- (void)keyboardWillChange:(NSNotification *) notification{
    NSDictionary *dict = notification.userInfo;
    CGRect rect = [dict[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGRect toolBarRect = CGRectMake(0, rect.origin.y - kToolBarHeight, rect.size.width, kToolBarHeight);
    [UIView animateWithDuration:0.25 animations:^{
        self.toolBar.frame = toolBarRect;
    }];
    
    self.totalKeyBoardHeight = kToolBarHeight;
    if (rect.origin.y != kHeight) {
        self.totalKeyBoardHeight =kToolBarHeight + rect.size.height;
    }
    self.scrollView.frame = CGRectMake(0, 0, kWidth, kHeight - self.totalKeyBoardHeight);

}


- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
