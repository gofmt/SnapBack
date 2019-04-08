//From reprovision
//https://github.com/Matchstic/ReProvision/blob/7b595c699335940f68702bb204c5aa55b8b1896f/iOS/HTML/RPVWebViewController.m


#import "SettingsWebVC.h"

@interface SettingsWebVC ()

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation SettingsWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.webView.frame = self.view.bounds;
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:CGRectZero];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (instancetype)initWithDocument:(NSString*)document {
    self = [super init];
    
    if (self) {
        [self _configureForDocument:document];
    }
    
    return self;
}

- (void)_configureForDocument:(NSString*)document {
    NSURL *url = [NSURL fileURLWithPath:document];
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero];
    self.webView.navigationDelegate = self;
    [self.webView loadFileURL:url allowingReadAccessToURL:url];
    
    [self.view addSubview:self.webView];
}

// XXX: As we are going to be presented by Preferences.framework, we have to implement a couple of shims.
- (void)setRootController:(id)controller {}
- (void)setParentController:(id)controller {}
- (void)setSpecifier:(id)specifier {
    if ([specifier propertyForKey:@"key"]) {
        // Load openSourceLicenses.html

        NSString *htmlFile = [specifier propertyForKey:@"key"];
        NSString *qualifiedHTMLFile = [[NSBundle mainBundle] pathForResource:htmlFile ofType:@"html"];
        
        NSLog(@"loading for %@", qualifiedHTMLFile);
        
        [self _configureForDocument:qualifiedHTMLFile];
    }
}

// WKWebView navigation delegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [[self navigationItem] setTitle:self.webView.title];
}

@end
