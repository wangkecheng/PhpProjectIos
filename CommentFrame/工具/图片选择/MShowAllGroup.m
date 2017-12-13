//
//  MShowAllGroup.m
//  QQImagePicker
//
//  Created by mark on 15/9/11.
//  Copyright (c) 2015年 mark. All rights reserved.
//

#import "MShowAllGroup.h"
#import "MGroupCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MImaLibTool.h"
typedef void(^SelectBlock)(NSMutableArray *);
@interface MShowAllGroup ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *arrGroup;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) SelectBlock selectBlock;

@end

@implementation MShowAllGroup

- (id)initWithArrGroup:(NSArray *)arrGroup arrSelected:(NSMutableArray *)arr selectBlock:(void(^)(NSMutableArray *))selectBlock{

    if (self = [super init]) {
         _maxCout = 1;
        _arrSeleted = arr;
        _arrGroup = arrGroup;
        _selectBlock = selectBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"照片";
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - NavigationBarH)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.rowHeight = 50;
    [self.view addSubview:self.tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:MGroupCellClassName bundle:nil] forCellReuseIdentifier:MGroupCellClassName];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(actionRightBar)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)actionRightBar {

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - tableDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _arrGroup.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:MGroupCellClassName];
    ALAssetsGroup *froup = self.arrGroup[indexPath.row];
    cell.lblInfo.text = [NSString stringWithFormat:@"%@(%ld)",[froup valueForProperty:ALAssetsGroupPropertyName],(long)[froup numberOfAssets]];
    cell.imavHead.image = [UIImage imageWithCGImage:froup.posterImage];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    MShowGroupAllSet *mvc = [[MShowGroupAllSet alloc] initWithGroup:_arrGroup[indexPath.row] selectedArr:_arrSeleted maxCount:_maxCout  selectBlock:_selectBlock];
    [self.navigationController pushViewController:mvc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
