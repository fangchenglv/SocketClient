//
//  ViewController.m
//  TCPSocketClient-Demo
//
//  Created by lfc on 2019/10/15.
//  Copyright © 2019 lfc. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"
#import "SocketManager.h"
//遵守协议
@interface ViewController ()<GCDAsyncSocketDelegate>

@property (weak, nonatomic) IBOutlet UITextView *sendTextView;
@property (weak, nonatomic) IBOutlet UITextField *ipTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;
@property (weak, nonatomic) IBOutlet UIButton *connectBtn;

@property (weak, nonatomic) IBOutlet UITextView *recieveTextView;
@property (strong, nonatomic)GCDAsyncSocket * clientSocket;
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

//连接到服务器
- (IBAction)connectSocketAction:(UIButton *)sender {
    self.clientSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError * error = nil;
    
    [self.clientSocket connectToHost:self.ipTextField.text onPort:[self.portTextField.text integerValue] error:&error];
}

//发送消息
- (IBAction)sendMessageAction:(UIButton *)sender {

    [self.clientSocket writeData:[self.sendTextView.text dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}

//接收消息
- (IBAction)recieveMessageAction:(UIButton *)sender {

    [self.clientSocket readDataWithTimeout:-1 tag:0];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark- GCDAsyncSocketDelegate
//代理
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    self.connectBtn.enabled = NO;
    
    SocketManager * socketManager = [SocketManager sharedSocketManager];
    socketManager.mySocket = sock;
}


//断开连接
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"连接断开了");
    self.connectBtn.enabled = YES;
}

//读数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString * receive = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    self.recieveTextView.text = [NSString stringWithFormat:@"%@\n%@",self.recieveTextView.text,receive];
}
@end
