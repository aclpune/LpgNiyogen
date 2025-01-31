import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../Screen/GodownKeeper/DeliveryBoyModel/DeliveryBoyInfoModel.dart';
import '../../Screen/GodownKeeper/DeliveryBoyModel/ItemData.dart';
import '../../Screen/GodownKeeper/DeliveryBoyModel/StockSubmitToManagerListModel.dart';
class UpdateRefillSale{
  static Database? _database;
  static const _databaseName = 'GKDatabase.db';
  static const _databaseVersion = 1;
  static String path = '';

  UpdateRefillSale.internal();

  int? rowLogId;
  String? userId;

  static final UpdateRefillSale instance = UpdateRefillSale.internal();

  factory UpdateRefillSale() => instance;

  Future<Database?> get database async {
    // If database exists, return database
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database;
  }

  initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    path = join(documentDirectory.path, _databaseName);
    var database = await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);

    SharedPreferences preferences = await SharedPreferences.getInstance();
    // userId = preferences.getString('userId').toString();
    return database;
  }
///stock add list
  static const tableUpdateRefillSale= 'UpdateRefillSale';
  String colID = "ID";
  String coldate = "date";
  String coldeliveryBoyName = "deliveryBoyName";
  String coldelBoyId = "delBoyId";
  String colvehicleNo = "vehicleNo";
  String colitemName = "itemName";
  String colitemID = "itemID";
  String colfilled = "filled";
  String colsv = "sv";
  String coltv = "tv";
  String colempty = "empty";
  String coldefective = "defective";
  String collessEmpty = "lessEmpty";
  String colremark = "remark";
  String colsvRemark = "svRemark";
  String colupdateFlag = "updateFlag";
  String colitemAddedDate = "itemAddedDate";

  ///Get list Del stock
  static const tableGetDelBoyStock = 'tableGetDelBoyStock';
  String colStockGetID = "ID";
  String colStockGetSaleGKId = "SaleGKId";
  String colStockGetDistributorId = "DistributorId";
  String colStockGetDeliveryDate = "DeliveryDate";
  String colStockGetDMId = "DMId";
  String colStockGetVehicleId = "VehicleId";
  String colStockGetDailySaleStatus = "DailySaleStatus";
  String colStockGetStaffNo = "StaffNo";
  String colStockGetStaffName = "StaffName";
  String colStockGetVehicleNo = "VehicleNo";
  String colStockGetStatusStr = "StatusStr";
  String colStockGetAddedOn = "AddedOn";
  String colStockGetAddedByNo = "AddedByNo";
  String colStockGetAddedByName = "AddedByName";
  String colStockGetAddedBy = "AddedBy";
  String colStockGetAction = "Action";
  String colSaleGKItemId = "SaleGKItemId";
  String colStockGetItemId = "ItemId";
  String colStockGetItemName = "ItemName";
  String colStockGetFilledSaleQty = "FilledSaleQty";
  String colStockGetSVQty = "SVQty";
  String colStockGetTVQty = "TVQty";
  String colStockGetEmptyRetQty = "EmptyRetQty";
  String colStockGetDeffQty = "DeffQty";
  String colStockGetLessEmptyQty = "LessEmptyQty";
  String colStockGetItemRemark = "Remark";
  String colStockGetClosingFilled = "ClosingFilled";
  String colStockGetClosingEmpty = "ClosingEmpty";
  String colStockGetClosingDef = "ClosingDef";
  String colStockGetSVConsStr = "SVConsStr";
  String colFlagColumnUpdate  = "FlagColumnUpdate";
  String colFlagColumnEdit  = "FlagColumnEdit";

  ///stock add list
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE IF NOT EXISTS $tableUpdateRefillSale (
            $colID INTEGER PRIMARY KEY,
            $coldate TEXT NOT NULL ,
            $coldeliveryBoyName TEXT NOT NULL ,
            $coldelBoyId TEXT NOT NULL ,
            $colvehicleNo TEXT NOT NULL ,
            $colitemName TEXT NOT NULL ,
            $colitemID TEXT NOT NULL ,
            $colfilled TEXT NOT NULL ,
            $colsv TEXT NOT NULL ,
            $coltv TEXT NOT NULL,
            $colempty TEXT NOT NULL ,
            $coldefective TEXT NOT NULL ,
            $collessEmpty TEXT NOT NULL ,
            $colremark TEXT NOT NULL ,
            $colsvRemark TEXT NOT NULL ,
            $colupdateFlag TEXT NOT NULL,
            $colitemAddedDate TEXT NOT NULL
          )
          ''');

    await db.execute('''
          CREATE TABLE IF NOT EXISTS $tableGetDelBoyStock (
        $colStockGetID INTEGER PRIMARY KEY,         
        $colStockGetSaleGKId INTEGER NOT NULL,                             
        $colStockGetDistributorId INTEGER NOT NULL,                        
        $colStockGetDeliveryDate TEXT NOT NULL,                            
        $colStockGetDMId INTEGER NOT NULL,                                 
        $colStockGetVehicleId INTEGER NOT NULL,                                                              
        $colStockGetDailySaleStatus INTEGER NOT NULL,                     
        $colStockGetStaffNo TEXT NOT NULL,                                
        $colStockGetStaffName TEXT NOT NULL,                               
        $colStockGetVehicleNo TEXT NOT NULL,                               
        $colStockGetStatusStr TEXT NOT NULL,                              
        $colStockGetAddedOn TEXT NOT NULL,                                 
        $colStockGetAddedByNo TEXT NOT NULL,                              
        $colStockGetAddedByName TEXT NOT NULL,                             
        $colStockGetAddedBy INTEGER NOT NULL,                              
        $colStockGetAction TEXT NOT NULL,                                  
        $colSaleGKItemId INTEGER NOT NULL,                              
        $colStockGetItemId INTEGER NOT NULL,                              
        $colStockGetItemName TEXT NOT NULL,                                
        $colStockGetFilledSaleQty INTEGER NOT NULL,                       
        $colStockGetSVQty INTEGER NOT NULL,                              
        $colStockGetTVQty INTEGER NOT NULL,                              
        $colStockGetEmptyRetQty INTEGER NOT NULL,                         
        $colStockGetDeffQty INTEGER NOT NULL,                             
        $colStockGetLessEmptyQty INTEGER NOT NULL,                        
        $colStockGetItemRemark TEXT NOT NULL,                             
        $colStockGetClosingFilled INTEGER NOT NULL,                       
        $colStockGetClosingEmpty INTEGER NOT NULL,                        
        $colStockGetClosingDef INTEGER NOT NULL,                          
        $colStockGetSVConsStr TEXT NOT NULL, 
        $colFlagColumnUpdate TEXT NOT NULL, 
        $colFlagColumnEdit TEXT NOT NULL
          )
          ''');
  }

  Future<void> insertUpdateRefillSale(List<ItemData> updateRefillSale) async {
    Database db = await initDatabase();

    for (int i = 0; i < updateRefillSale.length; i++) {
      try {
        ItemData item = updateRefillSale[i];

        // Convert the ItemData object into a Map using toMap()
        Map<String, dynamic> row = item.toMap();

        // Insert the row into the database with conflict resolution
        var result = await db.insert(
          tableUpdateRefillSale,
          row,
          conflictAlgorithm: ConflictAlgorithm.replace,  // Adjust conflict resolution as needed
        );

        debugPrint("####db_insertUpdateRefillSale- $result");
      } catch (e) {
        debugPrint("####db_insertUpdateRefillSaleException- $e");
      }
    }
  }

  // Future<void> insertUpdateRefillSale(List<ItemData> updateRefillSale) async {
  //   Database db = await initDatabase();
  //
  //   for (int i = 0; i < updateRefillSale.length; i++) {
  //     try {
  //       ItemData item = updateRefillSale[i];
  //       Map<String, dynamic> row = item.toMap();
  //
  //       // Check if the item ID already exists in the database
  //       var existingItem = await db.query(
  //         tableUpdateRefillSale,
  //         where: 'itemId = ?',
  //         whereArgs: [item.itemID],  // Assuming `item.id` is the primary key or unique identifier
  //       );
  //
  //       // If the item already exists, skip the insertion
  //       if (existingItem.isEmpty) {
  //         var result = await db.insert(
  //           tableUpdateRefillSale,
  //           row,
  //           conflictAlgorithm: ConflictAlgorithm.ignore,  // Ignore conflict if item already exists
  //         );
  //         debugPrint("####db_insertUpdateRefillSale- $result");
  //       } else {
  //         debugPrint("####Item already exists, skipping insertion for item ID: ${item.itemID}");
  //       }
  //     } catch (e) {
  //       debugPrint("####db_insertUpdateRefillSaleException- $e");
  //     }
  //   }
  // }

  Future<List<ItemData>> getUpdateRefillSaleData() async {
    // Fetch data from the database
    var areaWiseEKYCDetailResult = await getUpdateRefillSaleData1();
    List<ItemData> itemList = [];
    // Convert each item into an ItemData object
    for (var item in areaWiseEKYCDetailResult) {
      itemList.add(ItemData.fromJson(item));
    }
    return itemList;
  }

  Future<void> deleteRowByColID(int id) async {
    try {
      Database db = await initDatabase();

      // Delete the row with the specified colID
      int result = await db.delete(
        tableUpdateRefillSale,
        where: '$colID = ?', // Use colID to identify the specific row
        whereArgs: [id],
      );

      if (result > 0) {
        debugPrint("Row with colID $id deleted successfully.");
      } else {
        debugPrint("No row found with colID $id.");
      }
    } catch (e) {
      debugPrint("Error deleting row with colID $id: $e");
    }
  }
  Future<void> deleteRowByDelBoyIdAndItemId(String delBoyId, String itemId) async {
    try {
      Database db = await initDatabase();

      // Delete the row matching both delBoyId and itemId
      int result = await db.delete(
        tableUpdateRefillSale,
        where: '$coldelBoyId = ? AND $colitemID = ?', // Use AND to match both conditions
        whereArgs: [delBoyId, itemId],
      );
      if (result > 0) {
        debugPrint("Row with delBoyId $delBoyId and itemId $itemId deleted successfully.");
      } else {
        debugPrint("No row found with delBoyId $delBoyId and itemId $itemId.");
      }
    } catch (e) {
      debugPrint("Error deleting row with delBoyId $delBoyId and itemId $itemId: $e");
    }
  }

  // Future<void> updateRowByColID(int id, ItemData data) async {
  //   final db = await database; // Assuming `database` is the SQLite instance
  //
  //   // Prepare the update query
  //   await db?.update(
  //     'UpdateRefillSale', // Table name
  //     {
  //       'date': data.date,
  //       'deliveryBoyName': data.deliveryBoyName,
  //       'delBoyId': data.delBoyId,
  //       'vehicleNo': data.vehicleNo,
  //       'itemName': data.itemName,
  //       'itemID': data.itemID,
  //       'filled': data.filled,
  //       'sv': data.sv,
  //       'tv': data.tv,
  //       'empty': data.empty,
  //       'defective': data.defective,
  //       'lessEmpty': data.lessEmpty,
  //       'remark': data.remark,
  //       'svRemark': data.svRemark,
  //       'updateFlag': data.updateFlag,
  //     },
  //     where: 'ID = ?',
  //     whereArgs: [id], // Pass the `ID` as a parameter
  //   );
  // }
  Future<bool> updateRowByColID(int id, ItemData data) async {
    final db = await database;

    // Check for existing item
    final existingItem = await db?.query(
      'UpdateRefillSale',
      where: 'itemID = ? AND delBoyId = ? AND ID != ?',
      whereArgs: [data.itemID, data.delBoyId, id],
    );

    if (existingItem != null && existingItem.isNotEmpty) {
      // Conflict: Return false
      return false;
    }

    // Proceed with update
    final count = await db?.update(
      'UpdateRefillSale',
      {
        'date': data.date,
        'deliveryBoyName': data.deliveryBoyName,
        'delBoyId': data.delBoyId,
        'vehicleNo': data.vehicleNo,
        'itemName': data.itemName,
        'itemID': data.itemID,
        'filled': data.filled,
        'sv': data.sv,
        'tv': data.tv,
        'empty': data.empty,
        'defective': data.defective,
        'lessEmpty': data.lessEmpty,
        'remark': data.remark,
        'svRemark': data.svRemark,
        'updateFlag': data.updateFlag,
      },
      where: 'ID = ?',
      whereArgs: [id],
    );

    // Return true if at least one row was updated
    return count != null && count > 0;
  }


  Future<bool> checkIfItemExists(String itemId, String deliveryBoyId,String date) async {
    Database db = await initDatabase();

    // Query to check if an item with the same itemID and deliveryBoyId exists
    List<Map<String, dynamic>> result = await db.query(
      tableUpdateRefillSale,
      where: '$colitemID = ? AND $coldelBoyId = ? AND $colupdateFlag = ?',
      whereArgs: [itemId, deliveryBoyId,'pending'],
    );

    // If the result is not empty, the item exists
    return result.isNotEmpty;
  }

  Future<List<Map<String, Object?>>> getUpdateRefillSaleData1() async {
    Database db = await initDatabase();
    return await db.query(tableUpdateRefillSale);
  }

  Future<List<Map<String, Object?>>> getUpdateRefillSaleData2(String deliveryBoyId,String delDate) async {
    Database db = await initDatabase();
    // Fetch data where the updateFlag is "pending" and the delivery boy ID matches
    return await db.query(
      tableUpdateRefillSale,
      where: '$colupdateFlag = ? AND $coldelBoyId = ? AND $coldate = ?',
      whereArgs: ['pending', deliveryBoyId,delDate],
    );
  }

  // Future<void> updateRefillSaleFlagToComplete(List<int> itemIds, String deliveryBoyId,String delDate) async {
  //   Database db = await initDatabase();
  //
  //   // Loop through each itemId and update the updateFlag to 'completed' for each deliveryBoyId and ItemId combination
  //   for (int itemId in itemIds) {
  //     await db.update(
  //       tableUpdateRefillSale,
  //       {
  //         colupdateFlag: 'completed',  // Set the update flag to 'completed'
  //       },
  //       where: '$colitemID = ? AND $coldelBoyId = ? AND $coldate = ?', // Use both ItemId and deliveryBoyId to uniquely identify each row
  //       whereArgs: [itemId, deliveryBoyId,delDate],
  //     );
  //   }
  // }
  Future<void> updateRefillSaleFlagToComplete(List<int> itemIds, String deliveryBoyId, String delDate) async {
    try {
      Database db = await initDatabase();

      // Construct the placeholder string for the itemIds
      String itemIdPlaceholders = List.filled(itemIds.length, '?').join(',');

      // Prepare the arguments for the WHERE clause
      List<Object?> whereArgs = [...itemIds, deliveryBoyId, delDate];

      // Update all rows with the specified itemIds, deliveryBoyId, and date
      int updateResult = await db.update(
        tableUpdateRefillSale,
        {
          colupdateFlag: 'completed', // Set the update flag to 'completed'
        },
        where: '$colitemID IN ($itemIdPlaceholders) AND $coldelBoyId = ? AND $coldate = ?',
        whereArgs: whereArgs,
      );

      debugPrint("$updateResult rows updated to 'completed'.");

      // Delete the rows that were updated
      int deleteResult = await db.delete(
        tableUpdateRefillSale,
        where: '$colitemID IN ($itemIdPlaceholders) AND $coldelBoyId = ? AND $coldate = ?',
        whereArgs: whereArgs,
      );

      debugPrint("$deleteResult rows deleted after update.");
    } catch (e) {
      debugPrint("Error updating and deleting refill sale records: $e");
    }
  }

  Future<void> deleteCompletedRefillSales() async {
    try {
      Database db = await initDatabase();

      // Delete rows where updateFlag is 'completed'
      int result = await db.delete(
        tableUpdateRefillSale,
        where: '$colupdateFlag = ?',
        whereArgs: ['completed'],
      );

      if (result > 0) {
        debugPrint("Successfully deleted $result rows with updateFlag 'completed'.");
      } else {
        debugPrint("No rows found with updateFlag 'completed'.");
      }
    } catch (e) {
      debugPrint("Error deleting rows with updateFlag 'completed': $e");
    }
  }

  // Future<void> insertDataToDatabase(
  //     List<StockSubmitToManagerListModel> getStockSubmitToManagerListModel) async {
  //   Database db = await initDatabase();
  //   db.delete('tableGetDelBoyStockCombined');  // Clear the table before inserting new data
  //
  //   for (int i = 0; i < getStockSubmitToManagerListModel.length; i++) {
  //     var result;
  //     try {
  //       StockSubmitToManagerListModel dataModel = getStockSubmitToManagerListModel[i];
  //
  //       // Loop through ItemList and insert each item with its corresponding stock info
  //       for (var item in dataModel.itemList!) {
  //         var itemData = {
  //           'SaleGKId': dataModel.saleGKId,
  //           'DistributorId': dataModel.distributorId,
  //           'DeliveryDate': dataModel.deliveryDate,
  //           'DMId': dataModel.dMId,
  //           'VehicleId': dataModel.vehicleId,
  //           'Remark': dataModel.remark,
  //           'DailySaleStatus': dataModel.dailySaleStatus,
  //           'StaffNo': dataModel.staffNo,
  //           'StaffName': dataModel.staffName,
  //           'VehicleNo': dataModel.vehicleNo,
  //           'StatusStr': dataModel.statusStr ?? '',
  //           'AddedOn': dataModel.addedOn,
  //           'AddedByNo': dataModel.addedByNo ?? '',
  //           'AddedByName': dataModel.addedByName ?? '',
  //           'AddedBy': dataModel.addedBy,
  //           'Action': dataModel.action ?? '',
  //
  //           // ItemList specific data
  //           'ItemId': item.itemId,
  //           'ItemName': item.itemName,
  //           'FilledSaleQty': item.filledSaleQty,
  //           'SVQty': item.sVQty,
  //           'TVQty': item.tVQty,
  //           'EmptyRetQty': item.emptyRetQty,
  //           'DeffQty': item.deffQty,
  //           'LessEmptyQty': item.lessEmptyQty,
  //           'ItemRemark': item.remark ?? '',
  //           'ClosingFilled': item.closingFilled,
  //           'ClosingEmpty': item.closingEmpty,
  //           'ClosingDef': item.closingDef,
  //           'SVConsStr': item.sVConsStr ?? ''
  //         };
  //
  //         result = await db.insert(
  //             'tableGetDelBoyStock', itemData,
  //             conflictAlgorithm: ConflictAlgorithm.replace);
  //         debugPrint("Insert result: $result");
  //       }
  //     } catch (e) {
  //       debugPrint("Error: $e");
  //     }
  //   }
  // }


  Future<void> insertDataToDatabase(
      List<StockSubmitToManagerListModel> getStockSubmitToManagerListModel,String flagColumnUpdate,
      String flagColumnEdit) async {

    Database db = await initDatabase();
    db.delete('tableGetDelBoyStock');  // Clear the table before inserting new data

    for (int i = 0; i < getStockSubmitToManagerListModel.length; i++) {
      try {
        StockSubmitToManagerListModel dataModel = getStockSubmitToManagerListModel[i];

        // Loop through ItemList and insert each item with its corresponding stock info
        for (var item in dataModel.itemList!) {
          var itemData = {
            'SaleGKId': dataModel.saleGKId,
            'DistributorId': dataModel.distributorId,
            'DeliveryDate': dataModel.deliveryDate,
            'DMId': dataModel.dMId,
            'VehicleId': dataModel.vehicleId,
            'DailySaleStatus': dataModel.dailySaleStatus,
            'StaffNo': dataModel.staffNo,
            'StaffName': dataModel.staffName,
            'VehicleNo': dataModel.vehicleNo ?? '',
            'StatusStr': dataModel.statusStr ?? '',
            'AddedOn': dataModel.addedOn,
            'AddedByNo': dataModel.addedByNo ?? '',
            'AddedByName': dataModel.addedByName ?? '',
            'AddedBy': dataModel.addedBy,
            'Action': dataModel.action ?? '',

            // ItemList specific data
            'SaleGKItemId' : item.SaleGKItemId,
            'ItemId': item.itemId,
            'ItemName': item.itemName,
            'FilledSaleQty': item.filledSaleQty,
            'SVQty': item.sVQty,
            'TVQty': item.tVQty,
            'EmptyRetQty': item.emptyRetQty,
            'DeffQty': item.deffQty,
            'LessEmptyQty': item.lessEmptyQty,
            'Remark': item.remark ?? '',
            'ClosingFilled': item.closingFilled,
            'ClosingEmpty': item.closingEmpty,
            'ClosingDef': item.closingDef,
            'SVConsStr': item.sVConsStr ?? '',
            'FlagColumnUpdate': flagColumnUpdate,  // Flag 1 is a string
            'FlagColumnEdit': flagColumnEdit
    };

         // Check if the record already exists
          var existingRecord = await db.query(
            'tableGetDelBoyStock',
            where: 'SaleGKId = ? AND DistributorId = ? AND SaleGKItemId = ?',
            whereArgs: [dataModel.saleGKId, dataModel.distributorId, item.SaleGKItemId],
          );

          if (existingRecord.isEmpty) {
            // No existing record, proceed to insert
            var result = await db.insert(
              'tableGetDelBoyStock',
              itemData,
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
            debugPrint("Insert result: $result");
          } else {
            debugPrint("Record already exists, skipping insert.");
          }
        }
      } catch (e) {
        debugPrint("Error: $e");
      }
    }
  }

  Future<List<StockSubmitToManagerListModel>> getDataFromDatabase() async {
    Database db = await initDatabase();  // Assuming `initDatabase()` initializes the database.

    // Fetch data from the database
    List<Map<String, dynamic>> result = await db.query('tableGetDelBoyStock');

    // Map the fetched data to a list of StockSubmitToManagerListModel
    List<StockSubmitToManagerListModel> stockList = [];
    Map<int, StockSubmitToManagerListModel> tempMap = {};  // Temporary map to handle data with the same SaleGKId and DistributorId

    for (var row in result) {
      // Check if the StockSubmitToManagerListModel already exists in the map
      int saleGKId = row['SaleGKId'];
      int distributorId = row['DistributorId'];

      if (tempMap.containsKey(saleGKId) && tempMap[saleGKId]?.distributorId == distributorId) {
        // If the StockSubmitToManagerListModel already exists, we just add the item
        tempMap[saleGKId]?.itemList?.add(ItemList.fromJson(row));
      } else {
        // If it's a new entry, create a new StockSubmitToManagerListModel
        StockSubmitToManagerListModel stockData = StockSubmitToManagerListModel(
          saleGKId: row['SaleGKId'],
          distributorId: row['DistributorId'],
          deliveryDate: row['DeliveryDate'],
          dMId: row['DMId'],
          vehicleId: row['VehicleId'],
          dailySaleStatus: row['DailySaleStatus'],
          staffNo: row['StaffNo'],
          staffName: row['StaffName'],
          vehicleNo: row['VehicleNo'],
          statusStr: row['StatusStr'],
          addedOn: row['AddedOn'],
          addedByNo: row['AddedByNo'],
          addedByName: row['AddedByName'],
          itemList: [ItemList.fromJson(row)], // Add this item to the list
          addedBy: row['AddedBy'],
          action: row['Action'],
        );

        // Add the new StockSubmitToManagerListModel to the map
        tempMap[saleGKId] = stockData;
      }
    }

    // Convert the map values to a list
    stockList = tempMap.values.toList();

    return stockList;
  }

  Future<List<StockSubmitToManagerListModel>> getDeliveryMenDataForEdit(int saleGKIds, int DMIds) async {
    Database db = await initDatabase();  // Assuming `initDatabase()` initializes the database.

    // Fetch data from the database with filters for SaleGKId and DMId
    List<Map<String, dynamic>> result = await db.query(
      'tableGetDelBoyStock', // Table name
      where: 'SaleGKId = ? AND DMId = ?', // WHERE clause for the query
      whereArgs: [saleGKIds, DMIds], // Values for the WHERE clause
    );

    // Map the fetched data to a list of StockSubmitToManagerListModel
    List<StockSubmitToManagerListModel> stockList = [];
    Map<int, StockSubmitToManagerListModel> tempMap = {};  // Temporary map to handle data with the same SaleGKId and DistributorId

    for (var row in result) {
      int saleGKId = saleGKIds;
      int distributorId = row['DistributorId']; // Retrieve DistributorId from the result
      int DMId = DMIds;

      if (tempMap.containsKey(saleGKId) && tempMap[saleGKId]?.distributorId == distributorId && tempMap[saleGKId]?.dMId == DMId) {
        // If the StockSubmitToManagerListModel already exists, we just add the item
        tempMap[saleGKId]?.itemList?.add(ItemList.fromJson(row));
      } else {
        // If it's a new entry, create a new StockSubmitToManagerListModel
        StockSubmitToManagerListModel stockData = StockSubmitToManagerListModel(
          saleGKId: row['SaleGKId'],
          distributorId: row['DistributorId'],
          deliveryDate: row['DeliveryDate'],
          dMId: row['DMId'],
          vehicleId: row['VehicleId'],
          dailySaleStatus: row['DailySaleStatus'],
          staffNo: row['StaffNo'],
          staffName: row['StaffName'],
          vehicleNo: row['VehicleNo'],
          statusStr: row['StatusStr'],
          addedOn: row['AddedOn'],
          addedByNo: row['AddedByNo'],
          addedByName: row['AddedByName'],
          itemList: [ItemList.fromJson(row)], // Add this item to the list
          addedBy: row['AddedBy'],
          action: row['Action'],
        );

        // Add the new StockSubmitToManagerListModel to the map
        tempMap[saleGKId] = stockData;
      }
    }

    // Convert the map values to a list
    stockList = tempMap.values.toList();

    return stockList;
  }

  Future<void> updateItemInDatabase({
    required int itemId,
    required int saleGKId,
    required int distributorId,
    required String itemName,
    required int filled,
    required int sv,
    required int tv,
    required int wmpty,
    required int defective,
    required int lessEmpty,
    required String remark,
    required String svList,
  }) async {
    Database db = await initDatabase(); // Assuming `initDatabase()` initializes the database.

    // Define the update query
    int count = await db.update(
      'tableGetDelBoyStock', // Table name
      {
        'FilledSaleQty':filled,
        'SVQty': sv,
        'TVQty': tv,
        'EmptyRetQty': wmpty,
        'DeffQty': defective,
        'LessEmptyQty': lessEmpty,
        'ItemName': itemName, // Update the item name// Update the item name
        'Remark': remark, // Update the item name// Update the item name
        'SVConsStr': svList, // Update the item name// Update the item name
      },
      where: 'ItemId = ? AND SaleGKId = ? AND DistributorId = ?', // WHERE clause
      whereArgs: [itemId, saleGKId, distributorId], // Arguments for the WHERE clause
    );

    if (count > 0) {
      print('Item updated successfully');
    } else {
      print('No item was updated. Please check the provided details.');
    }
  }
  Future<void> deleteItemFromDatabase({
    required int itemId,
    required int saleGKId,
    required int distributorId,
  }) async {
    Database db = await initDatabase(); // Assuming `initDatabase()` initializes the database.

    // Define the delete query
    int count = await db.delete(
      'tableGetDelBoyStock', // Table name
      where: 'ItemId = ? AND SaleGKId = ? AND DistributorId = ?', // WHERE clause
      whereArgs: [itemId, saleGKId, distributorId], // Arguments for the WHERE clause
    );

    if (count > 0) {
      print('Item deleted successfully');
    } else {
      print('No item was deleted. Please check the provided details.');
    }
  }

  Future<void> updateFlagToComplete(String dmId, String saleGKId) async {
    // Get the database instance
    Database db = await initDatabase();

    try {
      // Update both FlagColumnUpdate and FlagColumnEdit for the given DMId, SaleGKId, and DeliveryDate
      int updatedRows = await db.update(
        'tableGetDelBoyStock',
        {
          'FlagColumnUpdate': 'Completed',  // Set FlagColumnUpdate to "complete"
          'FlagColumnEdit': 'NotEdited',    // Set FlagColumnEdit to "notedit"
        },
        where: '$colStockGetDMId = ? AND $colStockGetSaleGKId = ?', // Filter by DMId, SaleGKId, and DeliveryDate
        whereArgs: [dmId, saleGKId], // The values for the placeholders
      );

      // Check if any rows were updated
      if (updatedRows > 0) {
        debugPrint("Successfully updated flags.");
      } else {
        debugPrint("No records were updated.");
      }
    } catch (e) {
      debugPrint("Error while updating flags: $e");
    }
  }

}