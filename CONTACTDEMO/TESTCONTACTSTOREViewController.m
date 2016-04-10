//
//  TESTCONTACTSTOREViewController.m
//  CONTACTDEMO
//

#import "TESTCONTACTSTOREViewController.h"
#import <Contacts/Contacts.h>

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface TESTCONTACTSTOREViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) CNContactStore * contactStore;
@property (nonatomic, strong) CNContactFetchRequest * contactRequest;
@property (nonatomic, strong) NSArray * requestContactKey;
@property (nonatomic, strong) NSMutableArray * contactArr;

@property (nonatomic, strong) UITableView * contactTableView;

@end

//https://developer.apple.com/library/ios/documentation/Contacts/Reference/Contacts_Framework/

@implementation TESTCONTACTSTOREViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.contactTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.contactTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.contactTableView.delegate = self;
    self.contactTableView.dataSource = self;
    self.contactTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.contactTableView];
    
    // Do any additional setup after loading the view.
    [self getContactAuthrization];
}

- (void)getContactAuthrization {
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    switch (status) {
        case CNAuthorizationStatusAuthorized: {
            [self requestContacts];
        }
            break;
        case CNAuthorizationStatusDenied: {
            [self.contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    [self requestContacts];
                }
                else {
                    NSLog(@"%@", error.localizedDescription);
                }
            }];
        }
            break;
        case CNAuthorizationStatusNotDetermined: {
            [self.contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    [self requestContacts];
                }
                else {
                    NSLog(@"%@", error.localizedDescription);
                }
            }];
        }
            break;
        case CNAuthorizationStatusRestricted:
            break;
        default:
            break;
    }
}

- (void)requestContacts {
    BOOL success = [self.contactStore enumerateContactsWithFetchRequest:self.contactRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        if (*stop != YES) {
            [self.contactArr addObject:contact];
        }
    }];
    if (success) {
        [self.contactTableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CNContactStore *)contactStore {
    if (_contactStore == nil) {
        _contactStore = [[CNContactStore alloc] init];
    }
    return _contactStore;
}

- (CNContactFetchRequest *)contactRequest {
    if (_contactRequest == nil) {
        _contactRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:self.requestContactKey];
        _contactRequest.predicate = nil;
        // * @discussion Use only predicates from CNContact+Predicates.h. Compound predicates are not supported. Set to nil to match all contacts.

    }
    return _contactRequest;
}

- (NSMutableArray *)contactArr {
    if (_contactArr == nil) {
        _contactArr = [NSMutableArray array];
    }
    return _contactArr;
}

- (NSArray *)requestContactKey {
    if (_requestContactKey == nil) {
        _requestContactKey =  @[CNContactBirthdayKey,
                                CNContactDatesKey,
                                CNContactDepartmentNameKey,
                                CNContactEmailAddressesKey,
                                CNContactFamilyNameKey,
                                CNContactGivenNameKey,
                                CNContactIdentifierKey,
                                CNContactImageDataAvailableKey,
                                CNContactImageDataKey,
                                CNContactInstantMessageAddressesKey,
                                CNContactJobTitleKey,
                                CNContactMiddleNameKey,
                                CNContactNamePrefixKey,
                                CNContactNameSuffixKey,
                                CNContactNicknameKey,
                                CNContactNonGregorianBirthdayKey,
                                CNContactNoteKey,
                                CNContactOrganizationNameKey,
                                CNContactPhoneNumbersKey,
                                CNContactPhoneticFamilyNameKey,
                                CNContactPhoneticGivenNameKey,
                                CNContactPhoneticMiddleNameKey,
                                CNContactPostalAddressesKey,
                                CNContactPreviousFamilyNameKey,
                                CNContactRelationsKey,
                                CNContactSocialProfilesKey,
                                CNContactThumbnailImageDataKey,
                                CNContactTypeKey,
                                CNContactUrlAddressesKey];
    }
    return _requestContactKey;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contactArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    CNContact * contact = (CNContact *)self.contactArr[row];
    static NSString * identifier = @"TESTCONTACTIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    CNLabeledValue * cnValue = contact.phoneNumbers.count > 0 ? contact.phoneNumbers[0] : nil;
    CNPhoneNumber * phoneNumber = (CNPhoneNumber *)cnValue.value;
    NSString * phoneStr = phoneNumber.stringValue;
    
    cnValue = contact.postalAddresses.count > 0 ? contact.postalAddresses[0] : nil;
    CNPostalAddress * postAddress = (CNPostalAddress *)cnValue.value;
    NSString * tmpStr = postAddress.street;
    
    cell.textLabel.font = [UIFont systemFontOfSize:25.f weight:UIFontWeightLight];
    cell.textLabel.font = [UIFont systemFontOfSize:20.f weight:UIFontWeightLight];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", contact.givenName, contact.familyName];
    cell.detailTextLabel.text = phoneStr;
    [cell.textLabel sizeToFit];
    [cell.detailTextLabel sizeToFit];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
