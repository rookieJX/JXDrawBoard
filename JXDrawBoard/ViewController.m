//
//  ViewController.m
//  JXDrawBoard
//
//  Created by yuezuo on 16/5/5.
//  Copyright © 2016年 yuezuo. All rights reserved.
//

#import "ViewController.h"
#import "JXDrawView.h"

@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet JXDrawView *drawView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

// 清除
- (IBAction)clear:(UIBarButtonItem *)sender {
    [self.drawView clear];
}
// 撤销
- (IBAction)revoke:(UIBarButtonItem *)sender {
    [self.drawView revokePath];
}

// 擦除
- (IBAction)eraser:(UIBarButtonItem *)sender {
    self.drawView.lineColor = self.drawView.backgroundColor;
}

// 图片
- (IBAction)picture:(UIBarButtonItem *)sender {

    // 图片选择
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];

    // 设置代理
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
    
}
// 保存
- (IBAction)save:(UIBarButtonItem *)sender {
    
    // 开启图片上下文
    UIGraphicsBeginImageContextWithOptions(self.drawView.bounds.size, NO, 0);
    
    // 开启上下文
    CGContextRef ctd = UIGraphicsGetCurrentContext();
    
    // 渲染
    [self.drawView.layer renderInContext:ctd];
    
    // 获取图片
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭
    UIGraphicsEndImageContext();
    
    // 保存画板的内容放入相册
    // image:写入的图片
    // completionTarget图片保存监听者
    // 注意：以后写入相册方法中，想要监听图片有没有保存完成，保存完成的方法不能随意乱写
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}


- (IBAction)changeLineWidth:(UISlider *)sender {
    self.drawView.lineWidth = sender.value;
}
- (IBAction)changeColor:(UIButton *)sender {
    
    self.drawView.lineColor = sender.backgroundColor;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage * image = info[UIImagePickerControllerOriginalImage];
    self.drawView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}
// 监听保存完成，必须实现这个方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"保存图片成功");
}
@end
