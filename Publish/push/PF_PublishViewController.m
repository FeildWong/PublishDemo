//
//  PF_PublishViewController.m
//  PushArtical
//
//  Created by Feild Wong on 2017/5/11.
//  Copyright © 2017年 Feild. All rights reserved.
//

#import "PF_PublishViewController.h"
#import "PF_AddContentTableViewCell.h"
#import "PF_ContentTableViewCell.h"
#import "PublishModelManager.h"
#import "PF_EditHeadView.h"

#import "PF_addMusicViewController.h"

#define AddCellIdentify @"AddCellIdentify"
#define ContentCellIdentify @"ContentCellIdentify"


@interface PF_PublishViewController ()<UITableViewDelegate,UITableViewDataSource,PF_AddContentCellDelegate,PF_ContentCellDelegate,PF_EditHeadDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)  PublishHeaderModel *headModel;

@end

@implementation PF_PublishViewController

- (id)initWithPhoto:(UIImage *)imageUrl
{
    self = [super init];
    [self configHeaderData:(NSString *)imageUrl];
    return self;
}

- (void)configHeaderData:(NSString *)imageUrl
{
    _headModel = [[PublishHeaderModel alloc] init];
    _headModel.faceImage = imageUrl;
    
    PublishContentModel * contentModel= [[PublishContentModel alloc] init];
    contentModel.imageUrl = imageUrl;
    
    [_dataModelArray addObject:contentModel];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑";
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];


}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self configTabelView];
}

- (void)configTabelView
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerNib:[UINib nibWithNibName:@"PF_AddContentTableViewCell" bundle:nil] forCellReuseIdentifier:AddCellIdentify];
    [_tableView registerNib:[UINib nibWithNibName:@"PF_ContentTableViewCell" bundle:nil] forCellReuseIdentifier:ContentCellIdentify];
    //添加头视图
    PF_EditHeadView *headView = [[PF_EditHeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width/2)];
    headView.delegate = self;
    [_tableView setTableHeaderView:headView];
    
    
    [_tableView setTableFooterView:[[UIView alloc] init]];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PublishBaseModel *model =[PublishModelManager getShowDataArray][indexPath.row];
    
    return model.cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [PublishModelManager getShowDataArray].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    id dataModel = [PublishModelManager getShowDataArray][indexPath.row];
    if ([dataModel isMemberOfClass:[PublishHeaderModel class]]) {
       PF_AddContentTableViewCell *addCell = [tableView dequeueReusableCellWithIdentifier:AddCellIdentify];
        addCell.delegate = self;
        addCell.headModelData = dataModel;
        cell = addCell;
    }else if([dataModel isMemberOfClass:[PublishContentModel class]]){
        PF_ContentTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:ContentCellIdentify];
        contentCell.dataModel = dataModel;
        contentCell.delegate = self;
        NSLog(@"%ld  ------ %@",(long)indexPath.row,[(PublishContentModel *)dataModel desText]);
        
        cell = contentCell;

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark -PublishDelegate

/**
 点击cell，刷新cell状态

 @param dataModel 数据模型
 */
- (void)refreshCellWithData:(PublishBaseModel *)dataModel
{
    NSUInteger cellIndex = [[PublishModelManager getShowDataArray] indexOfObject:dataModel];
    
    
    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:cellIndex inSection:0];
    
    [_tableView reloadRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationFade];

}

/**
 插入一条数据

 @param dataModel 插入的数据模型
 @param data 插入数据模型的位置
 */
- (void)addCellWithData:(PublishBaseModel *)dataModel afterData:(PublishBaseModel *)data
{
    NSUInteger cellIndex = [[PublishModelManager getShowDataArray] indexOfObject:data];
    
    NSLog(@"第%lu个添加一个 %@",cellIndex + 1,[(PublishContentModel *)dataModel desText]);
    
    [[PublishModelManager shareManager] addDataWithIndex:cellIndex + 1 data:dataModel];
    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:cellIndex + 1 inSection:0];
    NSIndexPath *cellIndexPath2 = [NSIndexPath indexPathForRow:cellIndex + 2 inSection:0];
    [_tableView insertRowsAtIndexPaths:@[cellIndexPath,cellIndexPath2] withRowAnimation:UITableViewRowAnimationFade];
//    [_tableView reloadData];
}

#pragma mark -  PF_ContentcellDelegate

- (void)deleteCellWithData:(PublishBaseModel *)dataModel
{
    NSUInteger cellIndex = [[PublishModelManager getShowDataArray] indexOfObject:dataModel];
    
    NSLog(@"第%lu个添加一个 %@",cellIndex + 1,[(PublishContentModel *)dataModel desText]);
    
    [[PublishModelManager shareManager] delateDataWithIndex:cellIndex];
    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:cellIndex inSection:0];
    NSIndexPath *cellIndexPath2 = [NSIndexPath indexPathForRow:cellIndex +1 inSection:0];
    [_tableView deleteRowsAtIndexPaths:@[cellIndexPath,cellIndexPath2] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark -  HeadChangeDelegate

/**
 改变背景音乐
 */
- (void)headAddMusic
{
    PF_addMusicViewController *musicVC = [[PF_addMusicViewController alloc] initWithFinishBlock:^(NSString *musicURLString) {
        NSLog(@"%@", musicURLString);
    }];
    
    [self.navigationController pushViewController:musicVC animated:YES];
}

/**
 改变标题
 */
- (void)headChangeTitle
{
    
}

/**
 改变背景图片
 */
- (void)headChangeBgImage
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
