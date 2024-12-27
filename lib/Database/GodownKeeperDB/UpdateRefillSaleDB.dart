import 'dart:convert';
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
  String colStockGetItemRemark = "ItemRemark";
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
            $colupdateFlag TEXT NOT NULL
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

  Future<void> updateRefillSaleFlagToComplete(List<int> itemIds, String deliveryBoyId,String delDate) async {
    Database db = await initDatabase();

    // Loop through each itemId and update the updateFlag to 'completed' for each deliveryBoyId and ItemId combination
    for (int itemId in itemIds) {
      await db.update(
        tableUpdateRefillSale,
        {
          colupdateFlag: 'completed',  // Set the update flag to 'completed'
        },
        where: '$colitemID = ? AND $coldelBoyId = ? AND $coldate = ?', // Use both ItemId and deliveryBoyId to uniquely identify each row
        whereArgs: [itemId, deliveryBoyId,delDate],
      );
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
            'ItemRemark': item.remark ?? '',
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