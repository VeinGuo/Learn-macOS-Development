//
//  ViewController.m
//  TableView
//
//  Created by Vein on 2018/10/30.
//  Copyright © 2018 Vein. All rights reserved.
//

#import "ViewController.h"

#import "TableData.h"

@interface ViewController () <NSTableViewDataSource, NSTableViewDelegate>

@property (nonatomic, strong) NSArray<TableData *> *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDataSource];
}

- (void)setupDataSource {
    TableData *data1 = [[TableData alloc] initWithTitle:@"1" remark:@"test"];
    TableData *data2 = [[TableData alloc] initWithTitle:@"2" remark:@"test"];
    TableData *data3 = [[TableData alloc] initWithTitle:@"3" remark:@"test"];
    TableData *data4 = [[TableData alloc] initWithTitle:@"4" remark:@"test"];
    TableData *data5 = [[TableData alloc] initWithTitle:@"5" remark:@"test"];
    self.dataSource = @[data1, data2, data3, data4, data5];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.dataSource.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTableCellView *cell = [tableView makeViewWithIdentifier:@"column" owner:self];
    TableData *data = self.dataSource[row];
    cell.textField.stringValue = data.title;
    return cell;
}

@end
