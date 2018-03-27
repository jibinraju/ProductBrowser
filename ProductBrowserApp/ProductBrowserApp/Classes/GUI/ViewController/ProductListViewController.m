//
//  ViewController.m
//  ProductBrowserApp
//
//  Created by Jibin Raju on 12/01/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//

#import "ProductListViewController.h"
#import "ProductsFetcherService.h"
#import "CoreDataManager.h"
#import "Common_Utilities.h"
#import "Reachability.h"
#import "ProductListCellView.h"
#import "ProductInformation.h"
#import "ProductListHeaderView.h"
#import "ProductDetailViewController.h"

@interface ProductListViewController () <NSFetchedResultsControllerDelegate> {
    
    BOOL isDisplayedNetworkConnectionLossAlert;
    IBOutlet ProductListHeaderView* productListHeaderView;
}

@property (nonatomic, strong) NSTimer *refreshDataTimer;
@property (nonatomic, strong) Reachability *internetReachability;
@property (nonatomic, strong) ProductsFetcherService *productFetcherService;
//For more about fetchedResultsController ref : https://developer.apple.com/library/ios/documentation/CoreData/Reference/NSFetchedResultsController_Class/
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

/*
 * Trigger the web service call
 * @parameter : NO Arguments
 * @return type : void.
 */
- (void) invokeWebService;

/*
 * this function will trigger the webservice call in every 5 minutes if internet connection is avaliable
 * @parameter : NO Arguments
 * @return type : void.
 */
- (void) dataRefreshTimer;


/*
 * this function will subscribe reachibility notification and setup rest of things
 * @parameter : NO Arguments
 * @return type : void.
 */
- (void) reachabilityInitalizer;

/*
 * function will give current date and time in yyyy-MM-DD HH:MM:SS format
 * @parameter : NO Arguments
 * @return type : NSString, return the time stamp.
 */
- (NSString *) getCurrentTimestamp;
@end

@implementation ProductListViewController

- (void) dealloc {
    
    [_refreshDataTimer invalidate];
    [_internetReachability stopNotifier];
    [_productFetcherService cancel];
    self.fetchedResultsController = nil;
    self.internetReachability = nil;
    self.productFetcherService = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.internetReachability =nil;
}

- (void) loadView {
    
    [super loadView];
    
    [self invokeWebService];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    isDisplayedNetworkConnectionLossAlert = NO;
    
    [self dataRefreshTimer];
    [self reachabilityInitalizer];
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        DLog(@"Unresolved error %@, %@", error, [error userInfo]);
       
        UIAlertController *alertController = [Common_Utilities createOKCancelAlertWithTitle:@"Error"
                                                                withMessage:@"Failed to setup data layer connection; couldn't continue. press 'OK' to exit"
                                                                withAlterCancelActionBlock:^(UIAlertAction *action) {
            
                                                                }
                                                                withAlterOKActionBlock:^(UIAlertAction *action) {
            
                                                                    exit(-1); //notifying OS, Application exit due to some error. ('0' for successful exit)
                                                                }];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(ProductInformation *)sender {
    
    if ([segue.identifier isEqualToString:@"showProductDetail"]) {
        
        ((ProductDetailViewController *)segue.destinationViewController).productInformation =  sender;
    }
}

#pragma mark - private functions
- (NSFetchedResultsController *) fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        
        return _fetchedResultsController;
    }
    
    self.fetchedResultsController = [[CoreDataManager sharedInstance] createNewFetchedResultsControllerForProductInformation];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

- (void) invokeWebService {
    
    BOOL isInternetConnectionAvaliable = [Common_Utilities checkInternetIsAvaliable:^(UIAlertController *alertController) {
        
        if (isDisplayedNetworkConnectionLossAlert == NO) {
            
            [self presentViewController:alertController animated:YES completion:nil];
            isDisplayedNetworkConnectionLossAlert = YES;
        }
    }];
    
    if (isInternetConnectionAvaliable == YES) {
        
        self.productFetcherService = [[ProductsFetcherService alloc] init];
        [_productFetcherService getProductsWithCallBackBlock:^(id responseData, NSError *error) {
            
            if (error) {
                
                UIAlertController *alertController = [Common_Utilities createOKAlertControllerWithTitle:@"Error" withMessage:error.localizedDescription
                                                                                   withAlterActionBlock:^(UIAlertAction *action) {}];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            
            if ([responseData isKindOfClass:[NSArray class]]) {
             
                productListHeaderView.totalNumberOfItems = ((NSArray *)responseData).count;
                productListHeaderView.lastUpdatedTimeStamp = [self getCurrentTimestamp];
            }
        }];
    }
    else {
        
        [_refreshDataTimer invalidate];
        self.refreshDataTimer =nil;
    }
}

- (void) dataRefreshTimer {
    
    if (_refreshDataTimer == nil) {
   
        self.refreshDataTimer = [NSTimer scheduledTimerWithTimeInterval:300.0f target:self
                                                selector:@selector(invokeWebService) userInfo:nil repeats:YES];
    }
}

- (void) reachabilityInitalizer {
    
    /*
     Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the method reachabilityChanged will be called.
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification object:nil];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [_internetReachability startNotifier];
}

- (void) reachabilityChanged:(NSNotification *)notificationObj {
    
    Reachability* currentReachability = [notificationObj object];
    if([currentReachability isKindOfClass:[Reachability class]]) {
        
        NetworkStatus netStatus = [currentReachability currentReachabilityStatus];
        if (netStatus == ReachableViaWiFi || netStatus == ReachableViaWWAN) {
            
            isDisplayedNetworkConnectionLossAlert = NO;
            [self dataRefreshTimer];
            if (self.fetchedResultsController.fetchedObjects.count == 0) {
                
                [_refreshDataTimer fire];
            }
        }
    }
}

- (NSString *) getCurrentTimestamp {

    NSDateFormatter *timeStampFormatter = [[NSDateFormatter alloc] init];
    [timeStampFormatter setDateFormat:@"yyyy-mm-dd hh:mm:ss"];
    return [timeStampFormatter stringFromDate:[NSDate date]];
}

#pragma mark - NSFetchedResultsControllerDelegate implementation
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    [self.tableView reloadData];
}

#pragma mark - UITableview delegates implementation
/*
 * Implemeted required fucntions from table view delegate and data source 
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self.fetchedResultsController fetchedObjects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProductListCellView* productCell = (ProductListCellView*)[tableView dequeueReusableCellWithIdentifier:@"ProductListCellView" forIndexPath:indexPath];
    
    if (self.fetchedResultsController.fetchedObjects.count > indexPath.row) {
        
        ProductInformation *productInformation = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [productCell setProductionInformation:productInformation];
    }
    
    return productCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    productListHeaderView.totalNumberOfItems = [[self.fetchedResultsController fetchedObjects] count];
    return productListHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProductInformation *productInformation = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (productInformation) {
        
        [self performSegueWithIdentifier:@"showProductDetail" sender:productInformation];
    }
}


@end
