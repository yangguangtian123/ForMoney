//
//  LBBPhotoListVC.m
//  JLPhotoBrowser
//
//  Created by apple on 17/4/21.
//  Copyright © 2017年 BangGu. All rights reserved.
//

#import "LBBPhotoListVC.h"
#import "LBBPhotoListCollectionCell.h"
#import "LBBHeaderCollectionReusableView.h"
#import "JLPhotoBrowser.h"
#import "QBImagePickerController.h"
#import "LBBImage.h"
#import "LBBTimeTool.h"
#import "KxMovieViewController.h"


#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeigh [UIScreen mainScreen].bounds.size.height

#define MAXUploadNum 100  //每次最多上传几张



@interface LBBPhotoListVC ()<QBImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIAlertViewDelegate>{
    QBImagePickerController *QBimagePickerController;
    KxMovieViewController *kxVC;

    NSString *deletePath;
    

}
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;

@property (nonatomic,strong)NSMutableArray *imagesArr;



@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end


static NSString *cellId = @"LBBPhotoListCollectionCell";
static NSString *headerId = @"LBBHeaderCollectionReusableView";


@implementation LBBPhotoListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imagesArr = [[NSMutableArray alloc]init];
    
    [self.collectionView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellWithReuseIdentifier:cellId];
    [self.collectionView registerNib:[UINib nibWithNibName:headerId bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];

    
    
    
    
    [self getPicturesFromLocation];
    [self.collectionView reloadData];
    
    

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return self.imagesArr.count;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    LBBPhotoListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    NSString *imagePath = self.imagesArr[indexPath.row];
    
    cell.imageView.image = [UIImage imageWithContentsOfFile:imagePath];
    
    cell.imageView.userInteractionEnabled = YES;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [cell.imageView addGestureRecognizer:longPress];
    cell.imageView.tag =  10000+indexPath.row;
    
    
    return cell;
    


}

- (void)longPress:(UILongPressGestureRecognizer *)longPress{
    UIView *View = longPress.view;
    
    if(self.imagesArr.count > View.tag-10000){
        deletePath = self.imagesArr[View.tag - 10000];
    }
    
    
    if(longPress.state == UIGestureRecognizerStateBegan){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定删除这张图片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1000;
        [alert show];
        
        
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        LBBHeaderCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId forIndexPath:indexPath];
        
        [header.addPhotoButton addTarget:self action:@selector(addPhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        [header.deleAllPhotoButton addTarget:self action:@selector(deleAllPhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];

        
        
        return header;
    }
    return nil;
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 50);
}
- (void)deleAllPhotoButtonClick{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定删除所有图片?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    alert.tag = 8000;
    
    
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 8000 && buttonIndex == 1){
        //删除所有图片
        NSString *photosPath = [self getPath:@"image1"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if([fileManager fileExistsAtPath:photosPath]){
            //删除所有
            [fileManager removeItemAtPath:photosPath error:nil];
            
        }
        
        
        [self getPicturesFromLocation];
        [self.collectionView reloadData];
    }else if(alertView.tag == 1000 && buttonIndex == 1){
        [self deleteOnePicture:deletePath];
        [self.imagesArr removeObject:deletePath];
        [self.collectionView reloadData];
        
    }
    
    
    
    
    
}


- (void)addPhotoButtonClick{
  //从相册选取图片
    {
        
        
        
        if( [QBImagePickerController isAccessible]){
            
            ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
            
            NSLog(@"=========%ld",(long)author);
            //||(author == ALAuthorizationStatusNotDetermined)//不能加这一句,加上的话,第一次运行就不会询问你是否选择过权限
            
            
            if ((author == ALAuthorizationStatusRestricted) || (author == ALAuthorizationStatusDenied))
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"无法访问相册.请将'设置->隐私->照片'设置为打开状态." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
                return;
            }
            
            //从相册选取
            NSLog(@"跳转到选择照片界面");
            QBimagePickerController = [[QBImagePickerController alloc] init];
            QBimagePickerController.delegate = self;
            QBimagePickerController.allowsMultipleSelection = YES;
            //QBimagePickerController = 6;
            QBimagePickerController.maximumNumberOfSelection = MAXUploadNum;
            
            QBimagePickerController.title = @"相册";
            
            QBimagePickerController.showsCancelButton = NO;
            
            
            //这句代码太坑了,看着没什么用,但是,不写的话,从asset中取不出图片,因为asset生命周期结束了,所以必须保留assetSlibrary不让其销毁.
            self.assetsLibrary = QBimagePickerController.assetsLibrary;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:QBimagePickerController];
            
            [self.navigationController presentViewController:navigationController animated:YES completion:nil];
            
        }else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"不支持相册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [alertView show];
            
            return;
        }
        
        
        
    }
    
    
    
    
}

#pragma mark - QBImagePickerControllerDelegate

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{
    NSLog(@"*** imagePickerController:didSelectAsset:");
    NSLog(@"%@", asset);
    
    [self dismissImagePickerController];
}
- (void)dismissImagePickerController
{
    if (self.presentedViewController) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    } else {
        [self.navigationController popToViewController:self animated:YES];
    }
}



- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    NSLog(@"*** imagePickerController:didSelectAssets:");
    NSLog(@"%@", assets);
    
    
    
    //选择图片,写入本地
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
     
    for (ALAsset *result in assets) {
        CGImageRef  ref = [result thumbnail];
        LBBImage *lbbImage = [[LBBImage alloc]initWithCGImage:ref];
        lbbImage.imageUrl = result.defaultRepresentation.url;
        
        if (lbbImage!=nil)
        {
            [arr addObject:lbbImage];
        }
    }
    
    
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc]init];
    
    [arr enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
        
        
        if([image isKindOfClass:[LBBImage class]]){
            LBBImage *lbbImage = (LBBImage *)image;
            
            // = lbbImage.asset;
            [assetLibrary assetForURL:lbbImage.imageUrl resultBlock:^(ALAsset *asset) {
                
                NSLog(@"++++---++ %@ ++++++++ ", lbbImage.imageUrl );
                
                if(asset != nil) {
                    
                    //获取高清图
                    ALAssetRepresentation* representation = [asset defaultRepresentation];
                    UIImage *image2 = [UIImage imageWithCGImage:[representation fullScreenImage]];
                    NSData *data = UIImageJPEGRepresentation(image2, 1.0);
                    
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    NSString *filePath = [NSString stringWithString:[self getPath:@"image1"]];         //将图片存储到本地documents
                    if(![fileManager fileExistsAtPath:filePath]){
                        //不存在,则创建文件夹
                        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
                    }
                    NSString *picturePath = [NSString stringWithFormat:@"%@/%@%lu.png",filePath,[LBBTimeTool getTimeStr],(unsigned long)idx];
                    [fileManager createFileAtPath:picturePath contents:data attributes:nil];
                    NSLog(@"图片路径:: %@",picturePath);
                }
                
                if(idx == arr.count-1){
                    //存完了,展示
                    [self getPicturesFromLocation];
                    [self.collectionView reloadData];
                    
                    
                }
                
                
            } failureBlock:^(NSError *error) {
                
                NSLog(@"获取相册图片失败");
                
            }];
        }
        
        
    }];
    
    
    
    
    
    
    //[self disPlayImages:_willSendImageArray];
    [self dismissImagePickerController];
    
    

    
    
}


- (void)getPicturesFromLocation{
    //从本地给self.imageArr赋值
    
    NSString *picturesPath = [self getPath:@"image1"];
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    fileList = [fileManager contentsOfDirectoryAtPath:picturesPath error:&error];
    
    
   // NSLog(@"路径==%@,fileList = %@",picturesPath,fileList);

    [self.imagesArr removeAllObjects];
    
    for (NSString *imageName in fileList) {
        
        NSString *imagePath = [picturesPath stringByAppendingPathComponent:imageName];
        
        NSLog(@"图片路径==%@",imagePath);

//        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        
        
        if(imagePath){
            [self.imagesArr addObject:imagePath];
        }
    }
    
    
    
}

- (void)deleteOnePicture:(NSString *)imagePath{
//    NSString *picturesPath = [self getPath:@"image1"];
//    NSString *imagePath = [picturesPath stringByAppendingPathComponent:imageName];
    NSFileManager *fileManager = [NSFileManager defaultManager];

    if([fileManager fileExistsAtPath:imagePath]){
        [fileManager removeItemAtPath:imagePath error:nil];
    }
    

}



- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"*** imagePickerControllerDidCancel:");
    
    [self dismissImagePickerController];
}





- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //1.创建JLPhoto数组
    NSMutableArray *photos = [NSMutableArray array];
    
    
    
    
    for (int i=0; i<self.imagesArr.count; i++) {
        
        //UIImageView *child = self.imageViews[i];
        
        CGFloat width = ScreenWidth/4;
        
        UIImageView *child = [[UIImageView alloc]initWithFrame:CGRectMake((i%4)*width, (i/4)*(width+10), 80, 80)];
        
        UIImage *image = [UIImage imageWithContentsOfFile:self.imagesArr[i]];
        child.image = image;
        
        
        
        
        JLPhoto *photo = [[JLPhoto alloc] init];
        
        photo.image = image;
        //1.1设置原始imageView
        photo.sourceImageView = child;
        //1.2设置大图URL
       // photo.bigImgUrl = self.bigImgUrls[i];
        
        
        //1.3设置图片tag
        photo.tag = i;
        [photos addObject:photo];
        
    }
    
    

    
    
    
    //2. 创建图片浏览器
    JLPhotoBrowser *photoBrowser = [JLPhotoBrowser photoBrowser];
    
    // __weak typeof(self) weakSelf = self;
    
//    photoBrowser.browserButtonClick = ^{
//
//        
//    };
    
    
    //2.1 设置JLPhoto数组
    photoBrowser.photos = photos;
    //2.2 设置当前要显示图片的tag
    photoBrowser.currentIndex = (int)indexPath.row;
    //2.3 显示图片浏览器
    [photoBrowser show];

    
    
    
    
    
    
    
  

    
    
}

- (NSString *)getPath:(NSString *)title{
    
    
    if(title){
         NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *filePath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",title]];
       
        return filePath;
        
    }else{
        return nil;
    }
    
}






@end






