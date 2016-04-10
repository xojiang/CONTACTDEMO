//
//  ViewController.m
//  CONTACTDEMO
//

#import "ViewController.h"
#import "TESTCONTACTSTOREViewController.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface ViewController () <CNContactPickerDelegate>

@property (nonatomic, strong) CNContactPickerViewController * contactPickerViewController;
@property (nonatomic, strong) CNContactPickerViewController * contactMutlPickerViewController;

@property (nonatomic, strong) NSArray * multContactArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"TEST";
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithTitle:@"Single"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(leftBtnClick)];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Mult"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(rightBtnClick)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    [self.navigationItem setRightBarButtonItem:rightItem];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton * moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2.f - 50, SCREEN_HEIGHT / 2.f - 50, 100.f, 100.f)];
    moreBtn.contentMode = UIViewContentModeCenter;
    [moreBtn setTitle:@"More" forState:UIControlStateNormal];
    [moreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:20.f weight:UIFontWeightLight];
    moreBtn.titleLabel.textColor = [UIColor blackColor];
    [moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moreBtn];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)leftBtnClick {
    [self presentViewController:self.contactPickerViewController animated:YES completion:nil];
}

- (void)rightBtnClick {
    [self presentViewController:self.contactMutlPickerViewController animated:YES completion:nil];
}

- (void)moreBtnClick {
    TESTCONTACTSTOREViewController * contactStoreViewController = [[TESTCONTACTSTOREViewController alloc] init];
    [self.navigationController pushViewController:contactStoreViewController animated:YES];
}

- (CNContactPickerViewController *)contactPickerViewController {
    if (_contactPickerViewController == nil) {
        _contactPickerViewController = [[CNContactPickerViewController alloc] init];
    }
    return _contactPickerViewController;
}

- (CNContactPickerViewController *)contactMutlPickerViewController {
    if (_contactMutlPickerViewController == nil) {
        _contactMutlPickerViewController = [[CNContactPickerViewController alloc] init];
        _contactMutlPickerViewController.delegate = self;
    }
    return _contactMutlPickerViewController;
}

#pragma mark - CNContactPickerDelegate

- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker {
    self.multContactArr = nil;
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {

}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    
}


- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContacts:(NSArray<CNContact*> *)contacts {
    self.multContactArr = contacts;
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperties:(NSArray<CNContactProperty*> *)contactProperties {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
