//
//  MShowGroupAllSet.m
//  QQImagePicker
//
//  Created by mark on 15/9/11.
//  Copyright (c) 2015年 mark. All rights reserved.
//

#import "MShowGroupAllSet.h"
#import "MImaLibTool.h"
#import "MImaCell.h"
#import "LWImageBrowser.h"

//设置可添加图片最多个数!!!
#define kMaxImageCount 9
typedef void(^SelectBlock)(NSMutableArray *);

@interface MShowGroupAllSet ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *arrData;
@property (nonatomic, copy) SelectBlock selectBlock;
@property(nonatomic,assign)NSInteger maxCount;
@end

@implementation MShowGroupAllSet

- (id)initWithGroup:(ALAssetsGroup *)group selectedArr:(NSMutableArray *)arrSelected maxCount:(NSInteger)maxCount selectBlock:(void(^)(NSMutableArray *))selectBlock{

    if (self = [super init]) {
        self.title = [group valueForProperty:ALAssetsGroupPropertyName];
        _arrData = [[MImaLibTool shareMImaLibTool] getAllAssetsWithGroup:group];
        _arrSelected = arrSelected;
        _imgViewArray = [[NSMutableArray alloc]init];
        _selectBlock = selectBlock;
        _maxCount = maxCount;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UICollectionViewFlowLayout *flowOut = [[UICollectionViewFlowLayout alloc] init];
    flowOut.sectionInset = UIEdgeInsetsZero;
    flowOut.minimumInteritemSpacing = 5;
    flowOut.minimumLineSpacing = 5;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - NavigationBarH) collectionViewLayout:flowOut];
   _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    
    [_collectionView registerNib:[UINib nibWithNibName:MImaCellClassName bundle:nil] forCellWithReuseIdentifier:MImaCellClassName];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(actionRightBar)];
     self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    
    [self changeTitle];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self changeTitle];
    [_collectionView reloadData];
}


#pragma mark - 改变标题
- (void)changeTitle{
   self.title = [NSString stringWithFormat:@"%ld/%ld",(long)self.arrSelected.count, _maxCount];
}

- (void)actionRightBar {
    
    if (_selectBlock) {
        _selectBlock(_arrSelected);
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.arrData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    MImaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MImaCellClassName forIndexPath:indexPath];
     ALAsset * set = self.arrData[indexPath.row];
    cell.aLAssetModel = set;
    if ([[MImaLibTool shareMImaLibTool] imaInArrImasWithArr:self.arrSelected set:set] ){
        [cell setSelectImg: YES];
    } else{
        [cell setSelectImg: NO];
    }
    weakObj;
    cell.selcetBlock = ^(ALAsset * img) {
        
        for (ALAsset *set in weakSelf.arrSelected) {
            if ([set.defaultRepresentation.filename isEqualToString:img.defaultRepresentation.filename] ) {
                [weakSelf.arrSelected removeObject:set];//表示是取消选择
                 [weakSelf changeTitle];
                return NO;//返回NO 表示未已经到达最大数
            }
        }
            if (weakSelf.arrSelected.count <  _maxCount){//没满上限就添加
                [weakSelf.arrSelected addObject:img];
            }else{//满了上限 就不添加，提示
                [weakSelf.view makeToast:[NSString stringWithFormat:@"只能选择%ld张图片",_maxCount]];
                 [weakSelf changeTitle];
                return YES;//选择数达到最大，将刚点击的那一项取消选择
            }
          [weakSelf changeTitle];
        return NO;//返回NO 表示未已经到达最大数
    };
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //点击放大查看
    
    MImaCell *cell = (MImaCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    LWImageBrowserModel* broModel = [[LWImageBrowserModel alloc]  initWithplaceholder:[self getBigIamgeWithALAsset:self.arrData[indexPath.row]] thumbnailURL:nil HDURL:nil  containerView:cell.contentView positionInContainer:cell.contentView.frame index:0];
    
    LWImageBrowser* browser = [[LWImageBrowser alloc]
                               initWithImageBrowserModels:@[broModel]
                               currentIndex:indexPath.row];
    browser.isScalingToHide = NO;
    browser.isShowPageControl = NO;
    browser.isShowSaveImgBtn = NO;
    [browser show];
}

- (UIImage*)getBigIamgeWithALAsset:(ALAsset*)set{
    //压缩
    // 需传入方向和缩放比例，否则方向和尺寸都不对
    UIImage *img = [UIImage imageWithCGImage:set.defaultRepresentation.fullResolutionImage
                                       scale:set.defaultRepresentation.scale
                                 orientation:(UIImageOrientation)set.defaultRepresentation.orientation];
    NSData *imageData = UIImageJPEGRepresentation(img, 1.0);
    
    return [UIImage imageWithData:imageData];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    float wid = CGRectGetWidth(self.collectionView.bounds);
    return CGSizeMake((wid-3*5)/4, (wid-3*5)/4);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)photoViwerWilldealloc:(NSInteger)selecedImageViewIndex{
    NSLog(@"最后一张观看的图片的index是:%zd",selecedImageViewIndex);
}
@end
