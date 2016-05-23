//
//  ViewController.m
//  PostWithCookie
//
//  Created by Nikolay Berlioz on 16.05.16.
//  Copyright © 2016 Nikolay Berlioz. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

@interface ViewController ()

- (IBAction)sendRequestAction:(NSButton *)sender;
- (IBAction)acceptAction:(NSButton *)sender;
@property (weak) IBOutlet NSTextField *parthnerField;

@property (strong, nonatomic) NSArray *coockies;
@property (strong, nonatomic) NSString *tradeofferId;

@property (strong, nonatomic) NSString *sessionid;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSError *error = nil;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"JSONData" ofType:@"txt"];
    
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    
    NSArray *jsonArray = [NSJSONSerialization
                     JSONObjectWithData:jsonData
                     options:NSJSONReadingAllowFragments
                     error:&error];
    
    
    for (NSDictionary *dict in jsonArray)
    {
        NSMutableDictionary *prop = [[NSMutableDictionary alloc] init];
        
        [prop setObject:[dict objectForKey:@"domain"] forKey:NSHTTPCookieDomain];
        [prop setObject:[dict objectForKey:@"session"] forKey:NSHTTPCookieDiscard];
        [prop setObject:[dict objectForKey:@"path"] forKey:NSHTTPCookiePath];
        [prop setObject:[dict objectForKey:@"name"] forKey:NSHTTPCookieName];
        [prop setObject:[dict objectForKey:@"value"] forKey:NSHTTPCookieValue];
        [prop setObject:[dict objectForKey:@"hostOnly"] forKey:NSHTTPCookieOriginURL];
        [prop setObject:[dict objectForKey:@"secure"] forKey:NSHTTPCookieSecure];
        
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:prop];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        
        if ([[dict objectForKey:@"name"] isEqualToString:@"sessionid"])
        {
            self.sessionid = [dict objectForKey:@"value"];
        }
    }
    
    self.tradeofferId = @"1263595976";
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

//======================  Second Method  =============================
- (void) acceptTrade
{
    NSString *urlString = [NSString stringWithFormat:@"https://steamcommunity.com/tradeoffer/%@/accept", self.tradeofferId];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:self.sessionid,        @"sessionid",
                                                                          self.tradeofferId,     @"tradeofferid",
                                                                          @"1",                  @"serverid",
                                                                          self.parthnerField,    @"partner",
                                                                          @"",                   @"captcha", nil];
    
    NSArray *cookiesArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSDictionary *cookieHeaders = [NSHTTPCookie requestHeaderFieldsWithCookies: cookiesArray];
    
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.HTTPCookieAcceptPolicy = NSHTTPCookieAcceptPolicyAlways;
    sessionConfig.HTTPCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:sessionConfig];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];

    [sessionManager.requestSerializer setValue:@"*/*" forHTTPHeaderField:@"Accept"];
    [sessionManager.requestSerializer setValue:@"gzip, deflate" forHTTPHeaderField:@"Acept-Encoding"];
    [sessionManager.requestSerializer setValue:@"ru-RU,ru;q=0.8,en-US;q=0.6,en;q=0.4" forHTTPHeaderField:@"Acept-Language"];
    [sessionManager.requestSerializer setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
    [sessionManager.requestSerializer setValue:@"104" forHTTPHeaderField:@"Content-Length"];
    [sessionManager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [sessionManager.requestSerializer setValue:@"1" forHTTPHeaderField:@"DNT"];
    [sessionManager.requestSerializer setValue:@"steamcommunity.com" forHTTPHeaderField:@"Host"];
    [sessionManager.requestSerializer setValue:@"https://steamcommunity.com" forHTTPHeaderField:@"Origin"];
    [sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"https://steamcommunity.com/tradeoffer/%@", self.tradeofferId] forHTTPHeaderField:@"Referer"];
    [sessionManager.requestSerializer setValue:@"steamcommunity.com" forHTTPHeaderField:@"Host"];
    [sessionManager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    [sessionManager.requestSerializer setValue:[cookieHeaders objectForKey: @"Cookie" ] forHTTPHeaderField:@"Cookie"];

    [sessionManager POST:urlString
              parameters:parameters
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     
                     NSLog(@"responseObject = %@", [NSString stringWithUTF8String:[responseObject bytes]]);
                     
                     
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     
                     
                     NSLog(@"error = %@", error);
                     
                 }];
}

//======================  First Method  =============================

- (IBAction)sendRequestAction:(NSButton *)sender
{
    NSString *urlString = [NSString stringWithFormat:@"https://steamcommunity.com/tradeoffer/%@/", self.tradeofferId];
    
    NSArray *cookiesArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSDictionary *cookieHeaders = [NSHTTPCookie requestHeaderFieldsWithCookies: cookiesArray];
    
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.HTTPCookieAcceptPolicy = NSHTTPCookieAcceptPolicyAlways;
    sessionConfig.HTTPCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:sessionConfig];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [sessionManager.requestSerializer setValue:@"*/*" forHTTPHeaderField:@"Accept"];
    [sessionManager.requestSerializer setValue:@"gzip, deflate" forHTTPHeaderField:@"Acept-Encoding"];
    [sessionManager.requestSerializer setValue:@"ru-RU,ru;q=0.8,en-US;q=0.6,en;q=0.4" forHTTPHeaderField:@"Acept-Language"];
    [sessionManager.requestSerializer setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
    [sessionManager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [sessionManager.requestSerializer setValue:@"1" forHTTPHeaderField:@"DNT"];
    [sessionManager.requestSerializer setValue:@"steamcommunity.com" forHTTPHeaderField:@"Host"];
    [sessionManager.requestSerializer setValue:@"https://steamcommunity.com" forHTTPHeaderField:@"Origin"];
    [sessionManager.requestSerializer setValue:@"steamcommunity.com" forHTTPHeaderField:@"Host"];
    [sessionManager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    [sessionManager.requestSerializer setValue:[cookieHeaders objectForKey: @"Cookie" ] forHTTPHeaderField:@"Cookie"];
     
    //NSLog(@"%@", sessionManager.requestSerializer.HTTPRequestHeaders);
    
    [sessionManager POST:urlString
              parameters:nil
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     
                     NSLog(@"responseObject = %@", [NSString stringWithUTF8String:[responseObject bytes]]);
                     NSLog(@"First request done!");
                     
                     //[self performSelector:@selector(acceptTrade) withObject:nil afterDelay:2];
                     
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     
                     
                     NSLog(@"error = %@", error);
                     
                 }];
}

- (IBAction)acceptAction:(NSButton *)sender
{
    [self acceptTrade];
}


@end
