//
//  SocketManager.h
//  TCPSocketServer-Demo
//
//  Created by lfc on 2019/10/15.
//  Copyright © 2019 lfc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GCDAsyncSocket;
@interface SocketManager : NSObject

@property (strong, nonatomic)GCDAsyncSocket * mySocket;
+ (SocketManager *)sharedSocketManager;
@end
