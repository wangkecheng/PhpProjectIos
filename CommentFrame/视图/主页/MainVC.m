//  MainVC.m
//  CommentFrame
//
//  Created by warron on 2017/12/7.
//  Copyright © 2017年 warron. All rights reserved.
//

#import "MainVC.h"
#import "MImaLibTool.h"
#import "MShowAllGroup.h"
#import <AssetsLibrary/ALAsset.h>
#import "LWImageBrowserModel.h"
#import "LWImageBrowser.h"
@interface MainVC ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong)UIImagePickerController *imaPicker;
//选择的图片数据
@property(nonatomic,strong) NSMutableArray *arrSelected;
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftBarButtonItemWithTitle:@"登出" action:@selector(loginOut)];
    
    _arrSelected = [[NSMutableArray alloc]init];
    _imaPicker = [[UIImagePickerController alloc] init];
    _imaPicker.delegate = self;
}

-(void)loginOut{
    [CacheTool showLoginVC:self];
}
- (IBAction)uploadImage:(id)sender {
    weakObj;
    SRActionSheet *actionSheet =  [SRActionSheet sr_actionSheetViewWithTitle:nil cancelTitle:nil destructiveTitle:nil otherTitles:@[@"拍照上传", @"从相册中选择",@"取消"] otherImages:@[IMG(@"ic_xiangji.png"),IMG(@"ic_xiangche.png")] selectSheetBlock:^(SRActionSheet *actionSheet, NSInteger index) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (index == 0) {//拍照
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                strongSelf.imaPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                strongSelf.imaPicker.delegate = self;
                [strongSelf.navigationController presentViewController:strongSelf.imaPicker animated:NO completion:nil];
            }
        }
        else if(index == 1){//从相册中选择图片
            
            [[MImaLibTool shareMImaLibTool] getAllGroupWithArrObj:^(NSArray *arrObj) {
                if (arrObj && arrObj.count > 0) {
                    MShowAllGroup *VC = [[MShowAllGroup alloc] initWithArrGroup:arrObj arrSelected:_arrSelected selectBlock:^(NSMutableArray * imgArr) {
                        [strongSelf finishSelectImg:imgArr];
                    }];
                    HDMainNavC *nav = [[HDMainNavC alloc]initWithRootViewController:VC];
                    [strongSelf presentViewController:nav animated:YES completion:nil];
                }
            }];
        }
    }];
    actionSheet.otherActionItemAlignment = SROtherActionItemAlignmentCenter;
    [actionSheet show];
}
#pragma mark - 拍照获得数据
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *theImage = nil;
    [picker dismissViewControllerAnimated:NO completion:nil];
    strongObj;
    if ([picker allowsEditing]){ // 判断，图片是否允许修改
        //获取用户编辑之后的图像
        theImage = [info objectForKey:UIImagePickerControllerEditedImage];
    } else {
        // 照片的元数据参数
        theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    [_headBtn setImage:theImage forState:0];
    [self upload:nil];
    
    if (theImage) {
        //保存图片到相册中
        MImaLibTool *imgLibTool = [MImaLibTool shareMImaLibTool];
        [imgLibTool.lib writeImageToSavedPhotosAlbum:[theImage CGImage] orientation:(ALAssetOrientation)[theImage imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
            if (!error) {
                //获取图片路径
                [imgLibTool.lib assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                    if (asset) {
                        [strongSelf.arrSelected addObject:asset];
                        [strongSelf finishSelectImg:strongSelf.arrSelected];
                    }
                } failureBlock:nil];
            }
        }];
    }
}
- (IBAction)upload:(id)sender {
    HDModel *m = [HDModel model];
    m.keyId = [CacheTool getUserModel].keyId;
   
    [[BaseServer baseServer] uploadImages:@[_headBtn.imageView.image,[UIImage imageNamed:@"c4_ic_zuo"],[UIImage imageNamed:@"pic1"],[UIImage imageNamed:@"c4_ic_zuo"],[UIImage imageNamed:@"c4_ic_zuo"],[UIImage imageNamed:@"pic1"],[UIImage imageNamed:@"c4_ic_zuo"],[UIImage imageNamed:@"pic1"],[UIImage imageNamed:@"c4_ic_zuo"]] path:@"uploadimgs.php" param: m isShowHud:YES success:^(id result) {
        
    } failed:^(NSError *error) {
        
    }];//这里用对象操作是因为里边有个进度条
}

- (void)finishSelectImg:(NSMutableArray *)imgArr{
    
    [_headBtn setImage:[self getBigIamgeWithALAsset:[imgArr firstObject]] forState:0];
}

//获得大图
- (UIImage*)getBigIamgeWithALAsset:(ALAsset*)set{
    //压缩 需传入方向和缩放比例，否则方向和尺寸都不对
    UIImage *img = [UIImage imageWithCGImage:set.defaultRepresentation.fullResolutionImage scale:set.defaultRepresentation.scale
                                 orientation:(UIImageOrientation)set.defaultRepresentation.orientation];
    NSData *imageData = UIImageJPEGRepresentation(img, 0.5);
    return [UIImage imageWithData:imageData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
