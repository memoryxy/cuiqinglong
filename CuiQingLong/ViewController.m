//
//  ViewController.m
//  CuiQingLong
//
//  Created by wjf on 2022/6/14.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UITextView *label;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) NSArray *allWeibos;
@property (nonatomic, strong) NSDictionary *current;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0x11/255.0 green:0x11/255.0 blue:0x11/255.0 alpha:1];
    
    NSString *fileName = @"cql";
    NSString *mockDataString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [mockDataString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    self.allWeibos = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:&error];

    //    NSLog(@"%ld, %@", dic.count, error);


    self.time = [UILabel new];
    [self.view addSubview:self.time];
    self.time.frame = CGRectMake(24, 50, self.view.bounds.size.width-40, 10);
    self.time.font = [UIFont systemFontOfSize:10 weight:UIFontWeightThin];
    self.time.textColor = [UIColor colorWithRed:0x88/255.0 green:0x88/255.0 blue:0x88/255.0 alpha:1];

    UITextView *label = [UITextView new];
    [self.view addSubview:label];
    label.frame = CGRectMake(20, 60, self.view.bounds.size.width-40, self.view.bounds.size.height-120);
    self.label = label;
    self.label.attributedText = [self next];
    //    self.label.userInteractionEnabled = NO;
    self.label.backgroundColor = [UIColor colorWithRed:0x11/255.0 green:0x11/255.0 blue:0x11/255.0 alpha:1];

    self.time.text = [self nextTime];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.label addGestureRecognizer:tap];

    }

    - (NSParagraphStyle *)paragraphStyle {
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];
    return paragraphStyle;
    }

    - (NSAttributedString *)formated:(NSString *)text {
    text = [text stringByReplacingOccurrencesOfString:@"收起全文d" withString:@""];
    NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] initWithString:text];
    [attributeText addAttribute:NSParagraphStyleAttributeName
                          value:[self paragraphStyle]
                          range:NSMakeRange(0, text.length)];
    [attributeText addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:20]
                          range:NSMakeRange(0, text.length)];
    [attributeText addAttribute:NSForegroundColorAttributeName
                          value:[UIColor colorWithRed:0xdd/255.0 green:0xdd/255.0 blue:0xdd/255.0 alpha:1]
                          range:NSMakeRange(0, text.length)];
    return attributeText;
    }


    - (NSDictionary *)findAWeibo {
    int x = ABS(random())%self.allWeibos.count;
    self.current = [self.allWeibos objectAtIndex:x];
    return self.current;
    }

    - (NSAttributedString *)next {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    NSDictionary *aWeibo = [self findAWeibo];
    self.label.contentOffset = CGPointMake(0, 0);
    return [self formated:aWeibo[@"发布内容"]];
    }

    - (NSString *)nextTime {
    return [NSString stringWithFormat:@"%@, like %@, repost %@, comment %@", self.current[@"发布时间"], self.current[@"点赞数"], self.current[@"转发数"], self.current[@"评论数"]];
    }

    - (void)tap {
    self.label.attributedText = [self next];
    self.time.text = [self nextTime];
    }


@end
