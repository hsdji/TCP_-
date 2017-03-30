//
//  ViewController.m
//  sockect_serve
//
//  Created by 小飞 on 17/3/30.
//  Copyright © 2017年 小飞. All rights reserved.
//
/**    socket */
#import "ViewController.h"
#import <sys/socket.h>
#import <arpa/inet.h>
#import <netinet/in.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self service];
}

- (void)service{
// 注册一个错误代码
    int  error = 0;//错误代码?=====> 连接不成功
    int fw = socket(AF_INET, SOCK_STREAM, 0);
    BOOL sucess = (fw != -1);//返回正数  代表成功
    if (sucess){
        //用bing()进行绑定
        struct sockaddr_in addr;
        addr.sin_family = AF_INET;
        addr.sin_port = htons(6789);
        addr.sin_len = sizeof(addr);
        addr.sin_addr.s_addr = INADDR_ANY;//接受到的地址  换成客户端的地址的话是可以操作的  代表任意常量  设置地址参数   多个地址参数  任意打开6789端口的ip都可以进行服务器的访问
//        测试的话  手机连接电脑的ip
//        判断是否绑定成功
        error = bind(fw, (const struct sockaddr *)&addr, sizeof(addr));
//        看不懂的更老师单独交流
        sucess = (error == 0);
        
    }
    
    if (sucess){
        if (sucess)
        {
            NSLog(@"绑定成功");
//            开始进行监听  1. 监听对象   2. 延时时间
            listen(fw, 5);
            sucess = (error == 0);
        }
        if (sucess)
        {
            NSLog(@"监听");
            while (true){
//                开始接受服务端的数据   为什么要用到死循环  因为要保持长连接
//                我们 sockect里面传输的是SOCK_STREAM（TCP）协议
//                定义一个结构体  接受客户端的数据
                struct sockaddr_in peeraddr;
                int peer;
                socklen_t addrLenth = sizeof(peeraddr);
                peer = accept(fw, (struct sockaddr *)&peeraddr, &addrLenth);
                sucess = (peer != -1);
                if (sucess)
                {
                    NSLog(@"接受成功");
//                    做缓存处理
                    char butffer[1024];
                    ssize_t count;
//                    我们一直在监听 处理数据之处理了一次  第二次数据来了
                    size_t len = sizeof(butffer);
                    do {
                        count = recv(peer, butffer, len, 0);
                        NSString *str = [NSString stringWithCString:butffer encoding:NSUTF8StringEncoding];
                        NSLog(@"%@",str);
                    } while (strcmp(butffer, "exit") != 0);//什么条件下结束循环
//                    服务器的结束监听（需要在客户端操作）
                   //如果在这里关闭socket  意味着监听结束   意味着场连接关闭
                }
            }
        }
    }
     close(fw);//在所有操作完成之后  关闭
}

@end
