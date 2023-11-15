import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:nhts/Database/Databasehelper.dart';
import 'package:nhts/Model/UIModel.dart';
import 'package:nhts/Plugins/TxnExecutor.dart';
import 'package:nhts/Utils/MandatoryDatas.dart';
import 'package:nhts/Utils/dynamicfields.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:week_of_year/week_of_year.dart';

import '../Utils/secure_storage.dart';
import '../login.dart';
import 'geoplottingfarm.dart';

class PlantingScreen extends StatefulWidget {
  @override
  _PlantingScreenState createState() => _PlantingScreenState();
}

class _PlantingScreenState extends State<PlantingScreen> {
  String ruexit = 'Are you sure want to cancel?';
  String cancel = 'Cancel', no = 'No', yes = 'Yes';
  String slcFarmer = "",
      slcFarm = "",
      slcPlanted = "",
      slcVariety = "",
      slcSeedType = "",
      slcBorderType = "",
      slcFieldType = "",
      slcUOM = "",
      slcMode = "",
      slcVillage = "",
      slcSeedTreatment = "",
      slcFertilizer = "",
      slcFertilizerType = "";

  String expQtydec = "0.00";
  String valFarmer = "",
      valFarm = "",
      valPlanted = "",
      valVariety = "",
      valSeedType = "",
      valBorderType = "",
      valfieldType = "",
      valUOM = "",
      valMode = "",
      valVillage = "",
      valSeedTreatment = "",
      valFertilizer = "",
      valFertilizerType = "";
  String blockArea = "", selectedDate = "", formatDate = "";
  String seedUsedOption = "",
      fertilizerUsedOption = "",
      seedUsedValue = "",
      fertilizerUsedValue = "",
      blockId = "",
      blockName = "",
      prosLand = "",
      cropCode = "",
      blockLand = "";

  String servicePointId = "",
      seasonCode = "",
      agentId = '',
      latitude = "",
      longitude = "",
      exporterVariety = '',
      exporterGrade = '';
  String plantingWeek = "",
      expectedWeekHarvest = "",
      expectedHarvestDate = "",
      expectedQuantity = "0.00",
      plantingID = "",
      yieldAcre = "";
  int noOfDays = 0;
  String cropCount = "";
  String farmCount = "";
  String countValue = "";
  String slcBlock = "";
  String valBlock = "";
  int fCount = 0;
  int cCount = 0;
  var weekYear;
  var yieldArea = 0.0;
  double overallArea = 0.0;
  double blockAreaValue = 0.0;
  double getPlantingArea = 0.0;
  bool selectedValue = false;
  bool gradeLoaded = false;
  bool farmLoaded = false;
  bool blockLoaded = false;
  bool farmerLoaded = false;
  bool blockIDAdded = false;
  bool areaPlotted = false;

  List<DropdownMenuItem> farmerDropdown = [];
  List<DropdownMenuItem> farmDropdown = [];
  List<DropdownMenuItem> plantedDropdown = [];
  List<DropdownMenuItem> varietyDropdown = [];
  List<DropdownMenuItem> seedTypeDropdown = [];
  List<DropdownMenuItem> seedTreatmentDropdown = [];
  List<DropdownMenuItem> fertilizerUsedDropdown = [];
  List<DropdownMenuItem> typeFertilizerDropdown = [];
  List<DropdownMenuItem> borderCropTypeDropdown = [];
  List<DropdownMenuItem> fieldTypeDropdown = [];
  List<DropdownMenuItem> UOMDropdown = [];
  List<DropdownMenuItem> modeApplicationDropdown = [];
  List<DropdownMenuItem> blockDropdown = [];

  List<DropdownModelFarmer> farmeritems = [];
  DropdownModelFarmer? slctFarmers;

  List<DropdownModel> farmitems = [];
  DropdownModel? slctFarms;

  List<DropdownModel> blockItems = [];
  DropdownModel? selectBlock;

  List<UImodel3> farmerUIModel = [];
  List<UImodel> villageUIModel = [];
  List<UImodel2> farmUIModel = [];
  List<UImodel2> plantedUIModel = [];
  List<UImodel3> varietyUIModel = [];
  List<UImodel> seedTypeUIModel = [];
  List<UImodel2> blockUIModel = [];
  List<UImodel> borderCropTypeUIModel = [];
  List<UImodel> fieldTypeUIModel = [];
  List<UImodel> seedTreatementUIModel = [];
  List<UImodel> UOMUIModel = [];
  List<UImodel> modeApplicationUIModel = [];
  List<UImodel> fertilizerUsedUIModel = [];
  List<UImodel> typeFertilizerUIModel = [];

  TextEditingController blockTextEditController = new TextEditingController();
  TextEditingController blockAreaTextEditController =
      new TextEditingController();
  TextEditingController seedLotNumberTextEditController =
      new TextEditingController();
  TextEditingController seedPlantedTextEditController =
      new TextEditingController();
  TextEditingController seedQuantityTextEditController =
      new TextEditingController();
  TextEditingController fertilizerLotTextEditController =
      new TextEditingController();
  TextEditingController fertilizerQuantityTextEditController =
      new TextEditingController();

  bool areaPlottingAdded = false;
  List<BlockDetail> blockDetail = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getClientData();
    farmer();
    initValue();
    getLocation();

    /*  blockTextEditController.addListener(() {
      setState(() {
        blockName = blockTextEditController.text;
      });
      if (blockName.length > 0) {
        blockIDGenerated();
      }
    });*/

    blockAreaTextEditController.addListener(() {
      if (blockAreaTextEditController.text.length > 0) {
        setState(() {
          var blockAreaValue = num.parse(blockAreaTextEditController.text);
          var acre = yieldArea * blockAreaValue;
          expectedQuantity = acre.toString();
          double convert = double.parse(expectedQuantity);
          expQtydec = convert.toStringAsFixed(2);
        });
      }
    });
  }

  getClientData() async {
    List<Map> agents = await db.RawQuery('SELECT * FROM agentMaster');
    seasonCode = agents[0]['currentSeasonCode'];
    servicePointId = agents[0]['servicePointId'];
    agentId = agents[0]['agentId'];
    exporterVariety = agents[0]['variety'];
    exporterGrade = agents[0]['gCode'];
    plantedSearch(exporterVariety);
  }

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    latitude = position.latitude.toString();
    longitude = position.longitude.toString();

    print("latitude_planting" + latitude.toString());
    print("longitude_planting" + longitude.toString());
  }

/*  blockIDGenerated() async {
    final now = new DateTime.now();
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
    String name = "BLK";
    setState(() {
      blockId = name + msgNo;
    });
  }*/

  getCropCount(String farmID, String blockID) async {
    String countQry =
        'select MAX(CAST(cropCount AS Int)) as cropCount from farmCrop where farmCodeRef=\'' +
            farmID +
            '\' and blockId=\'' +
            blockID +
            '\'';
    print("countQry_countQry" + countQry.toString());

    List cropCountList = await db.RawQuery(countQry);
    print("farmCountList" + cropCountList.toString());
    try {
      if (cropCountList.length > 0) {
        String Count = cropCountList[0]["cropCount"].toString();
        countValue = Count;
      }
    } catch (e) {}
    getCount();
  }

  getCount() async {
    try {
      if (countValue.length > 0) {
        int convertCount = int.parse(countValue);
        setState(() {
          int cropMAxCount = 0;
          String value = "";
          try {
            cropMAxCount = convertCount + 1;
            value = cropMAxCount.toString();
            cCount = cropMAxCount;
          } catch (e) {
            cropMAxCount = cropMAxCount + 1;
            value = cropMAxCount.toString();
            cCount = cropMAxCount;
          }
          while (value.length < 3) {
            value = '0' + value;
            cropCount = value;
          }
        });
      } else {
        cropCount = "001";
        cCount = 1;
      }
    } catch (e) {
      cropCount = "001";
      cCount = 1;
    }

    PlantingIDGenerated(valBlock, cropCount);
  }

  /* getFarmCount(String farmerID) async {
    String countQry =
        'select MAX(CAST(farmCount AS Int)) as farmCount from farm where farmerId =\'' +
            farmerID +
            '\'';

    List farmCountList = await db.RawQuery(countQry);
    print("farmCountList_farmCountList" + farmCountList.toString());
    if (farmCountList.length > 0) {
      String Count = farmCountList[0]["farmCount"].toString();

      int convertCount = int.parse(Count);
      setState(() {
        int farmMAxCount = 0;
        String value = "";
        try {
          if (Count.length == 0) {
            farmMAxCount = farmMAxCount + 1;
            value = farmMAxCount.toString();
            fCount = farmMAxCount;
          } else {
            farmMAxCount = convertCount + 1;
            value = farmMAxCount.toString();
            fCount = farmMAxCount;
          }
        } catch (e) {
          farmMAxCount = convertCount + 1;
          value = farmMAxCount.toString();
          fCount = farmMAxCount;
        }
        while (value.length < 3) {
          value = '0' + value;
          farmCount = value;
        }
      });
    } else {
      farmCount = "001";
    }
  }*/

  /*block_PlantingIDGenerated(String farmID) async {
    */ /*  String farmQry =
        'select distinct fm.farmerId,s.[stateCode],dist.[districtCode],c.[cityCode] from farmer_master fm inner join villageList v on fm.[villageId] = v.[villCode] inner join cityList c on c.[cityCode]=v.[gpCode] inner join districtList dist on dist.[districtCode]=c.[districtCode] inner join stateList s on s.[stateCode]=dist.[stateCode] inner join farm f on f.[farmerId]=fm.[farmerId] where fm.[farmerId]=\'' +
            farmerId +
            '\'';*/
  /*

    String farmQry =
        'select state,district,city,farmerId ,farmIDT from farm where farmIDT=\'' +
            farmID +
            '\'';

    List farmIDGenerationList = await db.RawQuery(farmQry);
    print("farmIDGenerationList" + farmIDGenerationList.toString());

    for (int i = 0; i < farmIDGenerationList.length; i++) {
      String stateCode = farmIDGenerationList[i]["state"].toString();
      String districtCode = farmIDGenerationList[i]["district"].toString();
      String cityCode = farmIDGenerationList[i]["city"].toString();
      String farmerID = farmIDGenerationList[i]["farmerId"].toString();

      setState(() {
        String space = "_";
        blockId = stateCode +
            space +
            districtCode +
            space +
            cityCode +
            space +
            farmerID +
            space +
            farmCount.toString() +
            space +
            cropCount.toString();

        plantingID = stateCode +
            space +
            districtCode +
            space +
            cityCode +
            space +
            farmerID +
            space +
            farmCount +
            space +
            cropCount +
            space +
            cropCount;
      });
    }
  }
*/

  PlantingIDGenerated(String blockId, String count) async {
    setState(() {
      String space = "_";
      //  blockId = farmID + space + cropCount.toString();
      plantingID = blockId + space + count;
      blockIDAdded = true;
    });

    print("blockId_blockId" + blockId.toString());
    print("plantingID_plantingID" + plantingID.toString());
  }

  Future<void> farmer() async {
    List farmerList = await db.RawQuery(
        'select distinct fa.farmerId,fa.fName,fa.idProofVal,fa.trader from farmer_master as fa inner join farm as fr on fr.farmerId=fa.farmerId inner join blockDetails bL on fa.farmerId=bL.farmerId');
    print("farmerList_farmerList" + farmerList.toString());

    farmerUIModel = [];
    farmerDropdown = [];
    farmeritems.clear();
    for (int i = 0; i < farmerList.length; i++) {
      String propertyValue = farmerList[i]["fName"].toString();
      String diSpSeq = farmerList[i]["farmerId"].toString();
      String idProofVal = farmerList[i]["idProofVal"].toString();
      String kraPin = farmerList[i]["trader"].toString();

      var uiModel = new UImodel3(
          propertyValue + " - " + diSpSeq, diSpSeq, idProofVal, kraPin);
      farmerUIModel.add(uiModel);
      setState(() {
        farmeritems.add(DropdownModelFarmer(
            propertyValue + " - " + diSpSeq, diSpSeq, idProofVal, kraPin));
        //prooflist.add(property_value);
      });
    }
  }

  Future<void> initValue() async {
    List seedTypeList = await db.RawQuery(
        'select * from animalCatalog where catalog_code =\'4\'');

    seedTypeUIModel = [];
    seedTypeDropdown = [];
    seedTypeDropdown.clear();
    for (int i = 0; i < seedTypeList.length; i++) {
      String propertyValue = seedTypeList[i]["property_value"].toString();
      String diSpSeq = seedTypeList[i]["DISP_SEQ"].toString();

      var uiModel = new UImodel(propertyValue, diSpSeq);
      seedTypeUIModel.add(uiModel);
      setState(() {
        seedTypeDropdown.add(DropdownMenuItem(
          child: Text(propertyValue),
          value: propertyValue,
        ));
      });
    }

    List seedTreatmentList = [
      {"property_value": "No", "DISP_SEQ": "0"},
      {"property_value": "Yes", "DISP_SEQ": "1"}
    ];

    seedTreatementUIModel = [];
    seedTreatmentDropdown = [];
    seedTreatmentDropdown.clear();
    for (int i = 0; i < seedTreatmentList.length; i++) {
      String propertyValue = seedTreatmentList[i]["property_value"].toString();
      String diSpSeq = seedTreatmentList[i]["DISP_SEQ"].toString();

      var uiModel = new UImodel(propertyValue, diSpSeq);
      seedTreatementUIModel.add(uiModel);
      setState(() {
        seedTreatmentDropdown.add(DropdownMenuItem(
          child: Text(propertyValue),
          value: propertyValue,
        ));
      });
    }

    List borderCropList = await db.RawQuery(
        'select * from animalCatalog where catalog_code =\'5\'');

    borderCropTypeUIModel = [];
    borderCropTypeDropdown = [];
    borderCropTypeDropdown.clear();
    for (int i = 0; i < borderCropList.length; i++) {
      String propertyValue = borderCropList[i]["property_value"].toString();
      String diSpSeq = borderCropList[i]["DISP_SEQ"].toString();

      var uiModel = new UImodel(propertyValue, diSpSeq);
      borderCropTypeUIModel.add(uiModel);
      setState(() {
        borderCropTypeDropdown.add(DropdownMenuItem(
          child: Text(propertyValue),
          value: propertyValue,
        ));
      });
    }

    List fieldTypeList = await db.RawQuery(
        'select * from animalCatalog where catalog_code =\'89\'');

    fieldTypeUIModel = [];
    fieldTypeDropdown = [];
    fieldTypeDropdown.clear();
    for (int i = 0; i < fieldTypeList.length; i++) {
      String propertyValue = fieldTypeList[i]["property_value"].toString();
      String diSpSeq = fieldTypeList[i]["DISP_SEQ"].toString();

      var uiModel = new UImodel(propertyValue, diSpSeq);
      fieldTypeUIModel.add(uiModel);
      setState(() {
        fieldTypeDropdown.add(DropdownMenuItem(
          child: Text(propertyValue),
          value: propertyValue,
        ));
      });
    }

    /*List fertilizerUsedList = await db.RawQuery(
        'select * from animalCatalog where catalog_code =\'7\'');*/

    List fertilizerUsedList = [
      {"property_value": "No", "DISP_SEQ": "0"},
      {"property_value": "Yes", "DISP_SEQ": "1"}
    ];

    fertilizerUsedDropdown = [];
    fertilizerUsedUIModel = [];
    fertilizerUsedDropdown.clear();
    for (int i = 0; i < fertilizerUsedList.length; i++) {
      String propertyValue = fertilizerUsedList[i]["property_value"].toString();
      String diSpSeq = fertilizerUsedList[i]["DISP_SEQ"].toString();

      var uiModel = new UImodel(propertyValue, diSpSeq);
      fertilizerUsedUIModel.add(uiModel);
      setState(() {
        fertilizerUsedDropdown.add(DropdownMenuItem(
          child: Text(propertyValue),
          value: propertyValue,
        ));
      });
    }

    List fertilizerTypeList = await db.RawQuery(
        'select * from animalCatalog where catalog_code =\'8\'');

    typeFertilizerDropdown = [];
    typeFertilizerUIModel = [];
    typeFertilizerDropdown.clear();
    for (int i = 0; i < fertilizerTypeList.length; i++) {
      String propertyValue = fertilizerTypeList[i]["property_value"].toString();
      String diSpSeq = fertilizerTypeList[i]["DISP_SEQ"].toString();
      var uiModel = new UImodel(propertyValue, diSpSeq);
      typeFertilizerUIModel.add(uiModel);
      setState(() {
        typeFertilizerDropdown.add(DropdownMenuItem(
          child: Text(propertyValue),
          value: propertyValue,
        ));
      });
    }

    List UOMList = await db.RawQuery(
        'select * from animalCatalog where catalog_code =\'76\'');

    UOMUIModel = [];
    UOMDropdown = [];
    UOMDropdown.clear();
    for (int i = 0; i < UOMList.length; i++) {
      String propertyValue = UOMList[i]["property_value"].toString();
      String diSpSeq = UOMList[i]["DISP_SEQ"].toString();

      var uiModel = new UImodel(propertyValue, diSpSeq);
      UOMUIModel.add(uiModel);
      setState(() {
        UOMDropdown.add(DropdownMenuItem(
          child: Text(propertyValue),
          value: propertyValue,
        ));
      });
    }

    List modeApplicationList = await db.RawQuery(
        'select * from animalCatalog where catalog_code =\'78\'');

    modeApplicationUIModel = [];
    modeApplicationDropdown = [];
    modeApplicationDropdown.clear();
    for (int i = 0; i < modeApplicationList.length; i++) {
      String propertyValue =
          modeApplicationList[i]["property_value"].toString();
      String diSpSeq = modeApplicationList[i]["DISP_SEQ"].toString();

      var uiModel = new UImodel(propertyValue, diSpSeq);
      modeApplicationUIModel.add(uiModel);
      setState(() {
        modeApplicationDropdown.add(DropdownMenuItem(
          child: Text(propertyValue),
          value: propertyValue,
        ));
      });
    }
  }

/*
  void getBlockName(String farmCode) async {
    String blockNameQry =
        'select distinct fmcrp.farmcrpIDT,fmcrp.blockName,fmcrp.blockId from farmCrop as fmcrp where fmcrp.[farmCodeRef]=\'' +
            farmCode +
            '\';';

    List blockNameList = await db.RawQuery(blockNameQry);
    print("blockNameList" + blockNameList.toString());
    blockDetail.clear();
    for (int i = 0; i < blockNameList.length; i++) {
      String block_Name = blockNameList[i]["blockName"].toString();
      String blockID = blockNameList[i]["blockId"].toString();

      setState(() {
        var blockList = new BlockDetail(block_Name, blockID);
        blockDetail.add(blockList);
      });
    }
  }
*/

  void farmSearch(String farmerId) async {
    String qrrFarm =
        'select distinct f.farmIDT,f.farmName,f.farmerId,f.prodLand  from farm f inner join blockDetails bL on f.farmIDT=bL.farmId  where f.farmerId = \'' +
            farmerId +
            '\'';
    print("qrrFarm_qrrFarm" + qrrFarm);
    List farmList = await db.RawQuery(qrrFarm);
    farmUIModel = [];
    farmDropdown = [];
    farmitems.clear();
    for (int i = 0; i < farmList.length; i++) {
      String farmIDT = farmList[i]["farmIDT"].toString();
      String farmName = farmList[i]["farmName"].toString();
      String land = farmList[i]["prodLand"].toString();
      var uiModel = new UImodel2(farmName, farmIDT, land);
      farmUIModel.add(uiModel);
      setState(() {
        farmitems.add(DropdownModel(
          farmName,
          farmIDT,
        ));
        //prooflist.add(property_value);
      });
    }
    if (farmList.length > 0) {
      farmLoaded = true;
    }
  }

  void blockSearch(String farmId) async {
    String qryBlock =
        'select distinct blockId,blockName,blockArea from blockDetails where farmId = \'' +
            farmId +
            '\' and farmerId=\'' +
            valFarmer +
            '\'';
    print("qryBlock" + qryBlock);
    List blockNameList = await db.RawQuery(qryBlock);
    blockUIModel = [];
    blockDropdown.clear();
    blockItems.clear();
    for (int i = 0; i < blockNameList.length; i++) {
      String blockID = blockNameList[i]["blockId"].toString();
      String blockName = blockNameList[i]["blockName"].toString();
      String blockArea = blockNameList[i]["blockArea"].toString();
      var uiModel = new UImodel2(blockName, blockID, blockArea);
      blockUIModel.add(uiModel);
      setState(() {
        blockItems.add(DropdownModel(
          blockName,
          blockID,
        ));
      });
    }
    if (blockNameList.isNotEmpty) {
      setState(() {
        blockLoaded = true;
      });
    }
  }

  void getArea(String blockID) async {
    String qryArea =
        'select distinct bL.blockId,bL.blockName,bL.blockArea as blockArea,sum(fc.blockArea) as plantingArea from blockDetails bL inner join  farmCrop fc  where fc.blockId=bL.blockId  and bL.blockId=\'' +
            blockID +
            '\'';
    print("qryArea" + qryArea.toString());
    List blockAreaList = await db.RawQuery(qryArea);

    double bLArea = 0.0, pLArea = 0.0;

    try {
      if (blockAreaList.isNotEmpty) {
        print(" " + qryArea);
        for (int i = 0; i < blockAreaList.length; i++) {
          String blockArea = blockAreaList[i]["blockArea"].toString();
          String plantingArea = blockAreaList[i]["plantingArea"].toString();
          setState(() {
            bLArea = double.parse(blockArea);
            pLArea = double.parse(plantingArea);
            overallArea = pLArea;
            blockAreaValue = bLArea;
          });
        }
      } else {
        String qryArea =
            'select distinct blockId,blockName,blockArea from blockDetails where blockId=\'' +
                blockID +
                '\'';
        print("qrAreaElse" + qryArea.toString());
        List blockAreaList = await db.RawQuery(qryArea);
        for (int i = 0; i < blockAreaList.length; i++) {
          String blockArea = blockAreaList[i]["blockArea"].toString();
          setState(() {
            double area = double.parse(blockArea);
            blockAreaValue = area;
          });
        }
        print("blockAreaValue"+blockAreaValue.toString());
      }
    } catch (e) {
      String qryArea =
          'select distinct blockId,blockName,blockArea from blockDetails where blockId=\'' +
              blockID +
              '\'';
      print("qrAreaCatch" + qryArea.toString());
      List blockAreaList = await db.RawQuery(qryArea);
      for (int i = 0; i < blockAreaList.length; i++) {
        String blockArea = blockAreaList[i]["blockArea"].toString();
        setState(() {
          double area = double.parse(blockArea);
          blockAreaValue = area;
        });
      }
      print("blockAreaValue"+blockAreaValue.toString());
    }
  }

  void plantedSearch(String exportVariety) async {
    String myString = exportVariety;
    List<String> stringList = myString.split(",");

    String values = '';
    String quotation = "'";

    for (int j = 0; j < stringList.length; j++) {
      String getValue = stringList[j];
      print('getValue' + getValue.toString());
      if (values == '') {
        values = getValue;
      } else {
        values = values + quotation + ',' + quotation + getValue;
      }
    }
    print('values_values' + values.toString());

    String qryPlanted =
        'select distinct vCode,vName,prodId,days from varietyList  where vCode in (\'' +
            values +
            '\')';
    print('qryPlanted_qryPlanted' + qryPlanted.toString());
    List plantedList = await db.RawQuery(qryPlanted);

    plantedUIModel = [];
    plantedDropdown = [];
    plantedDropdown.clear();
    for (int i = 0; i < plantedList.length; i++) {
      String propertyValue = plantedList[i]["vName"].toString();
      String diSpSeq = plantedList[i]["vCode"].toString();
      String productId = plantedList[i]["prodId"].toString();
      print("productId_productId" + productId.toString());

      var uiModel = new UImodel2(propertyValue, diSpSeq, productId);
      plantedUIModel.add(uiModel);
      setState(() {
        plantedDropdown.add(DropdownMenuItem(
          child: Text(propertyValue),
          value: propertyValue,
        ));
      });
    }
  }

  void varietySearch(String varietyCode) async {
    String myString = exporterGrade;
    List<String> stringList = myString.split(",");

    String values = '';
    String quotation = "'";

    for (int j = 0; j < stringList.length; j++) {
      String getValue = stringList[j];
      print('getValue' + getValue.toString());
      if (values == '') {
        values = getValue;
      } else {
        values = values + quotation + ',' + quotation + getValue;
      }
    }

    String qryGrade =
        'select distinct gradeCode,grade,cropCycle,yieldAcre,vCode from procurementGrade where vCode =\'' +
            varietyCode +
            '\' and gradeCode in(\'' +
            values +
            '\')';
    print('qryGrade_qryGrade' + qryGrade.toString());

    List varietyList = await db.RawQuery(qryGrade);

    /*   List varietyList = await db.RawQuery(
        'select distinct gradeCode,grade,cropCycle,yieldAcre,vCode from procurementGrade where vCode =\'' +
            varietyCode +
            '\' and gradeCode=\'' +
            exporterGrade +
            '\'');*/
    print('exporterGrade' + exporterGrade);
    print('varietyCode' + varietyCode);

    varietyUIModel = [];
    varietyDropdown = [];
    varietyDropdown.clear();
    for (int i = 0; i < varietyList.length; i++) {
      String propertyValue = varietyList[i]["grade"].toString();
      String diSpSeq = varietyList[i]["gradeCode"].toString();
      String estDays = varietyList[i]["cropCycle"].toString();
      String acre = varietyList[i]["yieldAcre"].toString();
      print("yieldAcre_acre" + acre);

      var uiModel = new UImodel3(propertyValue, diSpSeq, estDays, acre);
      varietyUIModel.add(uiModel);
      setState(() {
        varietyDropdown.add(DropdownMenuItem(
          child: Text(propertyValue),
          value: propertyValue,
        ));
      });
    }
    /*  if (varietyList.length > 0) {
      setState(() {
        gradeLoaded = true;
      });
    }*/
  }

  void weekSearch(String selectedDate, int noOfDays) {
    print("weekofYearddd" + weekYear.toString());
    print("cropCycleggg" + noOfDays.toString());
    print("selectedDatefff" + selectedDate.toString());
    String startDate = selectedDate;
    List<String> splitStartDate = startDate.split('-');

    String strDateq = splitStartDate[0];
    String strMonthq = splitStartDate[1];
    String strYearq = splitStartDate[2];

    int strYear = int.parse(strYearq);
    int strMonths = int.parse(strMonthq);
    int strDate = int.parse(strDateq);

    DateTime convertStartDate = new DateTime(strYear, strMonths, strDate);
    int addDate = (convertStartDate.day + noOfDays);
    DateTime convertEndDate = new DateTime(strYear, strMonths, addDate);

    var expectedWeek = convertEndDate.weekOfYear;
    var expectedYear = convertEndDate.year;

    String convertWeek = expectedWeek.toString();
    String convertYear = expectedYear.toString();
    print("convertWeek_convertWeek" + convertWeek);
    print("convertYear_convertYear" + convertYear);

    if (slcVariety.length != 0) {
      expectedWeekHarvest = "Week" + " " + convertWeek + ", " + convertYear;
    } else if (slcVariety.length == 0) {
      expectedWeekHarvest = "";
    }

    // String formattedDate = DateFormat('yyyy-MM-dd').format(convertEndDate);

    /*   expectedHarvestDate = formattedDate;
    print("expectedHarvestDate_expectedHarvestDate" + expectedHarvestDate);


    int value =
        (convertEndDate.difference(convertStartDate).inHours / 24).round();

    int estWeek = ((value) / 7).ceil();
    setState(() {
      expectedWeekHarvest = estWeek.toString();
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              _onBackPressed();
            },
          ),
          title: Text('Planting',
              style: new TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700)),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.green,
          brightness: Brightness.light,
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(10.0),
                  children: getListings(context),
                ),
                flex: 8,
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Future<bool> _onBackPressed() async {
    return (await Alert(
          context: context,
          type: AlertType.warning,
          title: cancel,
          desc: ruexit,
          buttons: [
            DialogButton(
              child: Text(
                yes,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              width: 120,
            ),
            DialogButton(
              child: Text(
                no,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              width: 120,
            )
          ],
        ).show()) ??
        false;
  }

  List<Widget> getListings(BuildContext context) {
    List<Widget> listings = [];

/*    listings.add(
        txt_label_mandatory("Select the Village", Colors.black, 15.0, false));
    listings.add(singlesearchDropdown(
      itemlist: villageDropdown,
      selecteditem: slcVillage,
      hint: "Select the Option",
      onChanged: (value) {
        setState(() {
          slcVillage = value!;
          farmLoaded = false;
          farmerLoaded = false;
          for (int i = 0; i < villageUIModel.length; i++) {
            if (value == villageUIModel[i].name) {
              valVillage = villageUIModel[i].value;
              farmerSearch();
            }
          }
        });
      },
    ));*/

    listings.add(
        txt_label_mandatory("Select the Farmer", Colors.black, 15.0, false));
    /* listings.add(singlesearchDropdown(
      itemlist: farmerDropdown,
      selecteditem: slcFarmer,
      hint: "Select Farmer",
      onChanged: (value) {
        setState(() {
          slcFarmer = value!;
          farmLoaded = false;
          slcFarm = "";
          blockIDAdded = false;
          blockName = "";

          for (int i = 0; i < farmerUIModel.length; i++) {
            if (value == farmerUIModel[i].name) {
              valFarmer = farmerUIModel[i].value;
              farmSearch(valFarmer);
            }
          }
        });
      },
    )); */

    listings.add(farmerDropDownWithModel(
      itemlist: farmeritems,
      selecteditem: slctFarmers,
      hint: "Select Farmer",
      onChanged: (value) {
        setState(() {
          slctFarmers = value!;
          farmLoaded = false;
          slcFarm = "";
          blockIDAdded = false;
          blockName = "";
          slctFarms = null;
          selectBlock = null;
          blockItems = [];
          blockLoaded = false;
          valFarm = "";
          //toast(slctFarmers!.value);
          valFarmer = slctFarmers!.value;
          slcFarmer = slctFarmers!.name;
          farmSearch(valFarmer);
        });
        print('selectedvalue ' + slctFarmers!.value);
      },
    ));

    listings.add(farmLoaded
        ? txt_label_mandatory("Select the Farm", Colors.black, 15.0, false)
        : Container());
    /* listings.add(farmLoaded
        ? singlesearchDropdown(
            itemlist: farmDropdown,
            selecteditem: slcFarm,
            hint: "Select Farm",
            onChanged: (value) {
              setState(() {
                slcFarm = value!;
                blockIDAdded = false;
                blockName = "";
                for (int i = 0; i < farmUIModel.length; i++) {
                  if (value == farmUIModel[i].name) {
                    valFarm = farmUIModel[i].value;
                    prosLand = farmUIModel[i].value2;
                    getBlockName(valFarm);
                    getCropCount(valFarm);
                  }
                }
              });
            },
          )
        : Container());  */

    listings.add(farmLoaded
        ? DropDownWithModel(
            itemlist: farmitems,
            selecteditem: slctFarms,
            hint: "Select Farm",
            onChanged: (value) {
              setState(() {
                slctFarms = value!;
                blockIDAdded = false;
                selectBlock = null;
                blockItems = [];
                blockLoaded = false;

                blockName = "";
                valFarm = "";
                //toast(slctFarms!.value);
                valFarm = slctFarms!.value;
                slcFarm = slctFarms!.name;
                print('selectedvalue ' + slctFarms!.value);
                // getBlockName(valFarm);
                blockSearch(valFarm);
              });
            },
            onClear: () {
              setState(() {});
            })
        : Container());

    listings.add(valFarm.length > 0
        ? txt_label_mandatory("Farm ID", Colors.black, 14.0, false)
        : Container());
    listings.add(valFarm.length > 0
        ? cardlable_dynamic(valFarm.toString())
        : Container());

    listings.add(blockLoaded
        ? txt_label_mandatory("Select the Block", Colors.black, 15.0, false)
        : Container());

    listings.add(blockLoaded
        ? DropDownWithModel(
            itemlist: blockItems,
            selecteditem: selectBlock,
            hint: "Select Block",
            onChanged: (value) {
              setState(() {
                selectBlock = value!;
                valBlock = selectBlock!.value;
                slcBlock = selectBlock!.name;
                blockLand = "";
                overallArea = 0.0;
                getPlantingArea = 0.0;
                blockAreaValue = 0.0;
                getCropCount(valFarm, valBlock);
                getArea(valBlock);
                /* for (int i = 0; i < blockUIModel.length; i++) {
                  if (valBlock == blockUIModel[i].value) {
                    blockLand = blockUIModel[i].value2;
                  }
                }*/
              });
            },
          )
        : Container());

    /* listings.add(txt_label_mandatory("Block Name", Colors.black, 15.0, false));
    listings
        .add(txtfield_dynamic("Block Name", blockTextEditController, true, 20));
*/
/*    listings.add(
        txt_label_mandatory("Block Area (Acre)", Colors.black, 15.0, false));
    listings.add(areaPlotted
        ? txtfieldAllowFourDecimal(
            "Block Area (Acre)", blockAreaTextEditController, false)
        : txtfieldAllowFourDecimal(
            "Block Area (Acre)", blockAreaTextEditController, true));*/

    listings.add(
        txt_label_mandatory("Planting Area (Acre)", Colors.black, 15.0, false));
    listings.add(txtfieldAllowFourDecimal(
            "Planting Area (Acre)", blockAreaTextEditController, true));

  /*  listings.add(btn_dynamic(
        label: "Area",
        bgcolor: Colors.green,
        txtcolor: Colors.white,
        fontsize: 18.0,
        centerRight: Alignment.centerRight,
        margin: 10.0,
        btnSubmit: () async {
          areaPlottingAdded = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => geoploattingFarm(2)));
          areaPlotted = true;
          if (areaPlottingAdded) {
            setState(() {
              blockArea = Blockdata!.Acre;
              double num1 = double.parse((blockArea));
              String block = num1.toStringAsFixed(3).toString();
              blockAreaTextEditController.text = block;
            *//*  if (blockAreaTextEditController.text.isNotEmpty) {
                double getArea = double.parse(blockAreaTextEditController.text);

                if (getArea > 0.00) {
                  areaPlotted = true;
                } else {
                  setState(() {
                    areaPlotted = false;
                    GeoploattingBlockArealist.clear();
                  });
                }
              }*//*
            });
          }
        }));*/

    /*  listings.add(blockIDAdded
        ? txt_label_mandatory("Block ID", Colors.black, 14.0, false)
        : Container());
    listings.add(
        blockIDAdded ? cardlable_dynamic(blockId.toString()) : Container());*/

    listings
        .add(txt_label_mandatory("Crop Planted", Colors.black, 15.0, false));
    listings.add(singlesearchDropdown(
      itemlist: plantedDropdown,
      selecteditem: slcPlanted,
      hint: "Select Crop Planted",
      onChanged: (value) {
        setState(() {
          slcPlanted = value!;
          slcVariety = "";
          expQtydec = "0.00";

          expectedWeekHarvest = "";
          for (int i = 0; i < plantedUIModel.length; i++) {
            if (value == plantedUIModel[i].name) {
              valPlanted = plantedUIModel[i].value;
              cropCode = plantedUIModel[i].value2;
              print("cropCode_cropCode" + cropCode);
              varietySearch(valPlanted);
            }
          }
        });
      },
    ));

    listings
        .add(txt_label_mandatory("Crop Variety", Colors.black, 15.0, false));
    listings.add(singlesearchDropdown(
      itemlist: varietyDropdown,
      selecteditem: slcVariety,
      hint: "Select Crop Variety",
      onChanged: (value) {
        setState(() {
          slcVariety = value!;
          for (int i = 0; i < varietyUIModel.length; i++) {
            if (value == varietyUIModel[i].name) {
              valVariety = varietyUIModel[i].value;
              String cropCycle = varietyUIModel[i].value2;
              yieldArea = double.parse(varietyUIModel[i].value3);
              if (cropCycle.length > 0) {
                setState(() {
                  noOfDays = int.parse(cropCycle);
                });
              }
              setState(() {
                selectedValue = true;
                if (blockAreaTextEditController.text.length > 0 &&
                    slcVariety.length > 0) {
                  var blockAreaValue =
                      num.parse(blockAreaTextEditController.text);
                  var acre = yieldArea * blockAreaValue;
                  expectedQuantity = acre.toString();
                  double convert = double.parse(expectedQuantity);
                  expQtydec = convert.toStringAsFixed(2);
                }
              });
              weekSearch(selectedDate, noOfDays);
            }
          }
        });
      },
    ));

    /*if (blockAreaTextEditController.text.length > 0 && slcVariety.length > 0) {
      var blockAreaValue = num.parse(blockAreaTextEditController.text);
      var acre = yieldArea * blockAreaValue;
      expectedQuantity = acre.toString();
      double convert = double.parse(expectedQuantity);
      expQtydec = convert.toStringAsFixed(2);
    }*/



    listings
        .add(txt_label_mandatory("Planting Date", Colors.black, 14.0, false));
    listings.add(selectDate(
        context1: context,
        slctdate: selectedDate,
        onConfirm: (date) => setState(
              () {
                selectedDate = DateFormat('dd-MM-yyyy').format(date);
                formatDate = DateFormat('yyyy-MM-dd').format(date);

                weekYear = date.weekOfYear;
                var dateOfYear = date.year;
                var valYear = date.year - 1;
                var getDate = date.day;
                var getMonth = date.month;

                String convertDate = getDate.toString();
                String convertMonth = getMonth.toString();
                String getYear = "";

                if (weekYear >= 52 &&
                    convertMonth == "1" &&
                    convertDate == "1") {
                  getYear = valYear.toString();
                } else {
                  setState(() {
                    getYear = dateOfYear.toString();
                  });
                }

                setState(() {
                  selectedValue = true;
                });

                String getWeek = weekYear.toString();
                setState(() {
                  plantingWeek = "Week" + " " + getWeek + ", " + getYear;
                });

                weekSearch(selectedDate, noOfDays);
              },
            )));

    listings
        .add(txt_label_mandatory("Planting Materials", Colors.black, 15.0, false));
    listings.add(singlesearchDropdown(
      itemlist: seedTypeDropdown,
      selecteditem: slcSeedType,
      hint: "Select Planting Materials",
      onChanged: (value) {
        setState(() {
          slcSeedType = value!;
          for (int i = 0; i < seedTypeUIModel.length; i++) {
            if (value == seedTypeUIModel[i].name) {
              valSeedType = seedTypeUIModel[i].value;
            }
          }
        });
      },
    ));
    listings.add(
        txt_label_mandatory("Field Type", Colors.black, 15.0, false));
    listings.add(singlesearchDropdown(
      itemlist: fieldTypeDropdown,
      selecteditem: slcFieldType,
      hint: "Select Field Type",
      onChanged: (value) {
        setState(() {
          slcFieldType = value!;
          for (int i = 0; i < fieldTypeUIModel.length; i++) {
            if (value == fieldTypeUIModel[i].name) {
              valfieldType = fieldTypeUIModel[i].value;
            }
          }
        });
      },
    ));

    listings.add(txt_label(
        "Seed Lot number / Batch Identifier", Colors.black, 14.0, false));
    listings.add(txtFieldAlphanumericWithoutSymbol(
        "Seed Lot number / Batch Identifier",
        seedLotNumberTextEditController,
        true,
        20));

    listings.add(
        txt_label_mandatory("Border Crop Type", Colors.black, 15.0, false));
    listings.add(singlesearchDropdown(
      itemlist: borderCropTypeDropdown,
      selecteditem: slcBorderType,
      hint: "Select Border Crop",
      onChanged: (value) {
        setState(() {
          slcBorderType = value!;
          for (int i = 0; i < borderCropTypeUIModel.length; i++) {
            if (value == borderCropTypeUIModel[i].name) {
              valBorderType = borderCropTypeUIModel[i].value;
            }
          }
        });
      },
    ));

    listings.add(
        txt_label('Seed Treatment Chemical Used', Colors.black, 14.0, false));
    listings.add(singlesearchDropdown(
      itemlist: seedTreatmentDropdown,
      selecteditem: slcSeedTreatment,
      hint: "Select Seed Treatment",
      onChanged: (value) {
        setState(() {
          slcSeedTreatment = value!;
          valSeedTreatment = "";
          for (int i = 0; i < seedTreatementUIModel.length; i++) {
            if (value == seedTreatementUIModel[i].name) {
              valSeedTreatment = seedTreatementUIModel[i].value;
            }
          }
        });
      },
    ));

    listings.add(valSeedTreatment == "1"
        ? txt_label(
            "Seed Treatment Chemical Quantity(Kg)", Colors.black, 15.0, false)
        : Container());
    listings.add(valSeedTreatment == "1"
        ? txtfield_dynamic("Seed Treatment Chemical Quantity(Kg)",
            seedQuantityTextEditController, true, 60)
        : Container());

    listings.add(txt_label("Seed Quantity Planted", Colors.black, 14.0, false));
    listings.add(txtfield_digits_integer(
        "Seed Quantity Planted", seedPlantedTextEditController, true, 20));

    listings.add(selectedValue
        ? txt_label("Planting Week", Colors.black, 16.0, false)
        : Container());
    listings.add(selectedValue
        ? cardlable_dynamic(plantingWeek.toString())
        : Container());

    listings.add(txt_label('Fertilizer Used', Colors.black, 14.0, false));

    listings.add(singlesearchDropdown(
      itemlist: fertilizerUsedDropdown,
      selecteditem: slcFertilizer,
      hint: "Select Fertilizer",
      onChanged: (value) {
        setState(() {
          slcFertilizer = value!;
          slcMode = "";
          slcFertilizerType = "";
          slcUOM = "";
          fertilizerLotTextEditController.text = "";
          fertilizerQuantityTextEditController.text = "";
          valFertilizer = "";
          for (int i = 0; i < fertilizerUsedUIModel.length; i++) {
            if (value == fertilizerUsedUIModel[i].name) {
              valFertilizer = fertilizerUsedUIModel[i].value;
            }
          }
        });
      },
    ));

    listings.add(valFertilizer == "1"
        ? txt_label('Type of Fertilizer', Colors.black, 14.0, false)
        : Container());

    listings.add(valFertilizer == "1"
        ? singlesearchDropdown(
            itemlist: typeFertilizerDropdown,
            selecteditem: slcFertilizerType,
            hint: "Select Fertilizer Type",
            onChanged: (value) {
              setState(() {
                slcFertilizerType = value!;
                valFertilizerType = "";
                for (int i = 0; i < typeFertilizerUIModel.length; i++) {
                  if (value == typeFertilizerUIModel[i].name) {
                    valFertilizerType = typeFertilizerUIModel[i].value;
                  }
                }
              });
            },
          )
        : Container());

    listings.add(valFertilizer == "1"
        ? txt_label("Fertilizer Lot Number", Colors.black, 15.0, false)
        : Container());
    listings.add(valFertilizer == "1"
        ? txtfield_dynamic(
            "Fertilizer Lot Number", fertilizerLotTextEditController, true, 60)
        : Container());

    listings.add(valFertilizer == "1"
        ? txt_label(
            "Quantity of Fertilizer Used(Kg)", Colors.black, 15.0, false)
        : Container());
    listings.add(valFertilizer == "1"
        ? txtfield_dynamic("Quantity of Fertilizer Used",
            fertilizerQuantityTextEditController, true, 50)
        : Container());

    listings.add(valFertilizer == "1"
        ? txt_label("UOM", Colors.black, 15.0, false)
        : Container());
    listings.add(valFertilizer == "1"
        ? singlesearchDropdown(
            itemlist: UOMDropdown,
            selecteditem: slcUOM,
            hint: "Select UOM",
            onChanged: (value) {
              setState(() {
                slcUOM = value!;
                for (int i = 0; i < UOMUIModel.length; i++) {
                  if (value == UOMUIModel[i].name) {
                    valUOM = UOMUIModel[i].value;
                  }
                }
              });
            },
          )
        : Container());

    listings.add(valFertilizer == "1"
        ? txt_label("Mode of Application", Colors.black, 15.0, false)
        : Container());
    listings.add(valFertilizer == "1"
        ? singlesearchDropdown(
            itemlist: modeApplicationDropdown,
            selecteditem: slcMode,
            hint: "Select Mode",
            onChanged: (value) {
              setState(() {
                slcMode = value!;
                for (int i = 0; i < modeApplicationUIModel.length; i++) {
                  if (value == modeApplicationUIModel[i].name) {
                    valMode = modeApplicationUIModel[i].value;
                  }
                }
              });
            },
          )
        : Container());

    listings.add(selectedValue
        ? txt_label("Expected Week of Harvest", Colors.black, 16.0, false)
        : Container());
    listings.add(selectedValue
        ? cardlable_dynamic(expectedWeekHarvest.toString())
        : Container());

    listings.add(txt_label(
        "Expected Quantity of Harvest in Kgs", Colors.black, 16.0, false));
    listings.add(cardlable_dynamic(expQtydec.toString()));

    listings.add(Container(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(3),
              child: RaisedButton(
                child: Text(
                  'Cancel',
                  style: new TextStyle(color: Colors.white, fontSize: 16),
                ),
                onPressed: () {
                  _onBackPressed();
                },
                color: Colors.redAccent,
              ),
            ),
          ),

          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(3),
              child: RaisedButton(
                child: Text(
                  'Submit',
                  style: new TextStyle(color: Colors.white, fontSize: 16),
                ),
                onPressed: () {
                  btnSubmit();
                },
                color: Colors.green,
              ),
            ),
          ),
          //
        ],
      ),
    ));

    return listings;
  }

  void btnSubmit() {
    if (slcFarmer.length == 0) {
      alertPopup(context, "Farmer should not be empty");
    } else if (slcFarm.length == 0) {
      alertPopup(context, "Farm should not be empty");
    } else if (slcBlock.isEmpty) {
      alertPopup(context, "Block Name should not be empty");
    }
    else if(blockAreaTextEditController.text.isEmpty){
      alertPopup(context, "Planting Area (acre) should not be empty");
    }
    else {
      blockAreaValidation();
    }
  }

  /*void blockNameValidation() {
    bool blockNameExist = false;

    for (int a = 0; a < blockDetail.length; a++) {
      print("blockTextEditControllertext" + blockTextEditController.text);
      if (blockDetail[a].blockName == blockTextEditController.text) {
        blockNameExist = true;
      }
    }

    if (blockNameExist) {
      alertPopup(context, "Block Name already exists");
    } else if (blockAreaTextEditController.text.length == 0) {
      alertPopup(context, "Block Area (Acre) should not be empty");
    } else {
      blockAreaValidation();
    }
  }*/

  void blockAreaValidation() {
    if (blockAreaTextEditController.text.isNotEmpty) {
      double area = double.parse(blockAreaTextEditController.text);
      getPlantingArea = overallArea + area;

      if (area < 0 || area == 0) {
        alertPopup(context, "Planting Area(Acre) should be greater than zero");
      } else if (getPlantingArea > blockAreaValue) {
        alertPopup(context,
            "Planting Area(Acre) should not be greater than Block Area (Acre)");
      } else {
        validation();
      }
    } else {
      validation();
    }
  }

  void validation() {
    if (slcPlanted.length == 0) {
      alertPopup(context, "Crop Planted should not be empty");
    } else if (slcVariety.length == 0) {
      alertPopup(context, "Crop Variety should not be empty");
    }
    else if (selectedDate.length == 0) {
      alertPopup(context, "Planting Date should not be empty");
    }
    else if (slcSeedType.length == 0) {
      alertPopup(context, "Planting Materials should not be empty");
    } else if (slcFieldType.length == 0) {
      alertPopup(context, "Field Type should not be empty");
    }
    else if (slcBorderType.length == 0) {
      alertPopup(context, "Border Crop Type should not be empty");
    } else {
      confirmation();
    }
  }

  void confirmation() {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Confirmation",
      desc: "Are you sure you want to proceed ?",
      buttons: [
        DialogButton(
          child: Text(
            "Yes",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            savePlanting();
            Navigator.pop(context);
          },
          width: 120,
        ),
        DialogButton(
          child: Text(
            "No",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          width: 120,
        )
      ],
    ).show();
  }

  Future<void> savePlanting() async {
    var db = DatabaseHelper();
    final now = new DateTime.now();
    String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);

    String? agentid =await SecureStorage().readSecureData("agentId");
    String? agentToken =await SecureStorage().readSecureData("agentToken");
    print('txnHeader ' + agentid! + "" + agentToken!);
    Random rnd = new Random();
    int revNo = 100000 + rnd.nextInt(999999 - 100000);

    String insqry =
        'INSERT INTO "main"."txnHeader" ("isPrinted", "txnTime", "mode", "operType", "resentCount", "agentId", "agentToken", "msgNo", "servPointId", "txnRefId") VALUES ('
                '0,\'' +
            txntime +
            '\', '
                '\'02\', '
                '\'01\', '
                '\'0\',\'' +
            agentid +
            '\', \'' +
            agentToken +
            '\',\'' +
            msgNo +
            '\', \'' +
            servicePointId +
            '\',\'' +
            revNo.toString() +
            '\')';

    int txnsucc = await db.RawInsert(insqry);
    print(txnsucc);

    AppDatas datas = new AppDatas();
    await db.saveCustTransaction(
        txntime, datas.txnPlanting, revNo.toString(), '', '', '');

    /* String plantingName = "PL";

    plantingID = plantingName + msgNo;*/

    int existFarmer = await db.saveExistsFarmer(
        "1",
        revNo.toString(),
        valFarmer,
        latitude,
        longitude,
        msgNo,
        "",
        latitude,
        longitude,
        msgNo,
        "",
        "",
        "",
        "",
        valFarm,
        "",
        seasonCode,
        "",
        "",
        "",
        "",
        "",
        "",
        "");
    print(existFarmer);

    int farmCropExist = await db.saveFarmCropExists(
        valFarmer,
        valFarm,
        slcBlock, //  block name
        blockAreaTextEditController.text,
        valBlock, // block id
        cropCode,
        valPlanted,
        valVariety,
        valSeedType,
        formatDate,
        seedLotNumberTextEditController.text,
        valBorderType,
        valSeedTreatment,
        seedQuantityTextEditController.text,
        valfieldType, //otherSeedTreatment
        seedPlantedTextEditController.text,
        plantingWeek,
        valFertilizer,
        valFertilizerType,
        fertilizerLotTextEditController.text,
        fertilizerQuantityTextEditController.text,
        valUOM,
        expectedWeekHarvest,
        valMode,
        expQtydec,
        seasonCode,
        "1",
        revNo.toString(),
        "",
        plantingID,
        cCount.toString());

    print(farmCropExist);

    if (GeoploattingBlockArealist.length > 0) {
      for (int i = 0; i < GeoploattingBlockArealist.length; i++) {
        print("geoplatinglistCrop" + GeoploattingBlockArealist.toString());
        int saveblockAreagpslocation = await db.savefarmCropGPSLocationExists(
          GeoploattingBlockArealist[i].Latitude,
          GeoploattingBlockArealist[i].Longitude,
          valFarmer,
          valFarm,
          GeoploattingBlockArealist[i].orderofGps.toString(),
          cropCode,
          valPlanted,
          revNo.toString(),
        );
        print("savefarmgpslocation" + revNo.toString());
      }
    }

    await db.UpdateTableValue(
        'exists_farmer', 'isSynched', '0', 'recId', revNo.toString());

    TxnExecutor txnExecutor = new TxnExecutor();
    txnExecutor.CheckCustTrasactionTable();

    Alert(
      context: context,
      type: AlertType.info,
      title: "Transaction Successful",
      desc: "Planting done Successfully",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          width: 120,
        ),
      ],
      closeFunction: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    ).show();

    GeoploattingBlockArealist
        .clear(); // clear the plotting list once transaction done
  }
}

class BlockDetail {
  String? blockName;
  String? blockID;

  BlockDetail(this.blockName, this.blockID);
}
