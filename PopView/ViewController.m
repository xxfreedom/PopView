//
//  ViewController.m
//  PopView
//
//  Created by sy on 14-10-17.
//  Copyright (c) 2014年 SY. All rights reserved.
//

#import "ViewController.h"
#import "ActionManger.h"
#import "AlertManager.h"
@interface ViewController ()
{
    UITextField *_text;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dialogOpen:(id)sender {
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"cAlert" message:@"this is cAlert" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action_yes=[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"action:%@",action.title);
    }];
    UIAlertAction *action_no=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"action:%@",action.title);
    }];
    [alertController addAction:action_yes];
    [alertController addAction:action_no];
    [self presentViewController:alertController animated:YES completion:^{
        ;
    }];
}

- (IBAction)cAlertOpen:(id)sender {
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"cAlert" message:@"this is cAlert" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action=[ActionManger createYESAcitionWithhandler:^(UIAlertAction *action) {
        NSLog(@"action:%@",action.title);
        NSLog(@"text:%@",_text.text);
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder=@"请输入";
        _text=textField;
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:^{
        ;
    }];
}

- (IBAction)pAlertOpen:(id)sender {
   
    __block  UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"pAlert" message:@"this is pAlert" preferredStyle:UIAlertControllerStyleAlert];
   
    [self presentViewController:alertController animated:YES completion:^{
        [self performSelector:@selector(dismisspAlert:) withObject:alertController afterDelay:3.0];
    }];
}

- (IBAction)SYCAlertOpen:(id)sender {
    SYCAlert *alert=[AlertManager createAlertWithTitle:@"提示" AndMessage:@"这是一个测试"];
    SYAlertAction *action=[SYAlertAction actionWithTitle:@"确定" handler:^(SYAlertAction *action) {
        NSLog(@"确定");
    }];
    SYAlertAction *action_NO=[SYAlertAction actionWithTitle:@"取消" handler:^(SYAlertAction *action) {
        NSLog(@"取消");
    }];
    SYAlertAction *action_Forbid=[SYAlertAction actionWithTitle:@"不要再问我" handler:^(SYAlertAction *action) {
        NSLog(@"不要再问我");
    }];
    [alert addAlertAction:action];
    [alert addAlertAction:action_NO];
    [alert addAlertAction:action_Forbid];
    [alert showInKeyWindow];
}

- (IBAction)SYPAlertOpen:(id)sender {
    SYPAlert *palert=[AlertManager createPAlertWithTitle:@"加载中..."];
    [palert showInView:self.view];
    
    [palert performSelector:@selector(dismiss) withObject:nil afterDelay:3.0];
}

- (IBAction)SYTalertOpen:(id)sender {
    [AlertManager showTalertWithTitle:@"这是一个测试" CloseTime:2.0];
}
-(void)dismisspAlert:(UIAlertController *)pAlert
{
    [pAlert dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}
@end
