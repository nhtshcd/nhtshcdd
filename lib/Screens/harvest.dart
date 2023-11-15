import 'dart:io' show File;
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
import 'package:week_of_year/date_week_extensions.dart';

import '../Utils/secure_storage.dart';
import '../login.dart';
import '../main.dart';

class Harvest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Harvest();
}

class _Harvest extends State<Harvest> {
  TextEditingController harvestedyieldsController = new TextEditingController();
  TextEditingController quantityharvestedController =
      new TextEditingController();
  TextEditingController noofstemsController = new TextEditingController();
  TextEditingController observationphiController = new TextEditingController();
  TextEditingController produceidController = new TextEditingController();
  TextEditingController noofunitsController = new TextEditingController();
  TextEditingController harvesternameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController noOfWeightController = new TextEditingController();

  String farmerTraceCode = "";

  String ruexit = 'Are you sure want to cancel?';
  String exit = 'Cancel';
  String no = 'No', yes = 'Yes';

  String valFarmer = "",
      proposedLand = "",
      valFarm = "",
      plantingid = "",
      valblock = "";

  String plantingWeek = "",
      expectedWeekHarvest = "",
      expectedHarvestDate = "",
      expectedQuantity = "",
      plantingID = "",
      cropCode = "",
      cropVariety = "";
  String harvestQtydec = "";
  String harvestYieldec = "";
  double harvestedQtyValue = 0.0;
  String expectedDayHarvest = "";
  double noOfWeight = 0.0;

  String harvestDay = "";
  String typeName = "", typeValue = "", stemsWeightValue = "";

  var weekOfYear;
  bool dateSelected = false;
  bool afterPlantingDate = false;
  bool selectedValue = false;

  String blockArea = "", selectedDate = "", formatDate = "";

  String slcFarmer = "",
      slcFarm = "",
      slcblock = "",
      slccolectioncentre = "",
      slcHarequip = "",
      slcPackingunit = "";

  String valPackingunit = "", valHarequip = "", valcolectioncentre = "";

  String valHighestEduLev = "";
  String servicePointId = "",
      seasonCode = "",
      agentId = '',
      latitude = "",
      longitude = "";
  String plantingDate = "";
  String slcWard = "", slcVillage = "", valWard = "", valVillage = "";
  String slcPlanting = "", valPlanting = "";

  String cropName = "", varietyName = "";
  String expctdDate = '';
  String dateOfEve = '';
  String recDate = '';

  int curIdLim = 0, resId = 0, curIdLimited = 0, farmerId = 0;
  int noOfDays = 0;

  File? farmerImageFile, nationalIdImageFile;

  List<UImodel3> farmerUIModel = [];
  List<UImodel2> farmUIModel = [];
  List<UImodel> blockUIModel = [];
  List<UImodel> wardUIModel = [];
  List<UImodel> villageUIModel = [];

  //List<UImodel> villageUIModel = [];
  List<UImodel> housingOwnerUIModel = [];
  List<UImodel> assetOwnerUIModel = [];
  List<UImodel> collectioncentreUIModel = [];
  List<UImodel> typeUIModel = [];
  List<UImodel> plantingUIModel = [];

  List<String> valCropCategoryList = [];
  List<String> valCropNameList = [];
  List<String> valHousingOwnerList = [];
  List<String> valAssetOwnerList = [];
  List<String> valHighestEduList = [];
  List<String> collectioncentreList = [];

  List<DropdownMenuItem> farmerDropdown = [];
  List<DropdownMenuItem> farmDropdown = [];
  List<DropdownMenuItem> blockDropdown = [];
  List<DropdownMenuItem> cropCategoryDropdown = [];
  List<DropdownMenuItem> cropNameDropdown = [];
  List<DropdownMenuItem> countryDropdown = [];
  List<DropdownMenuItem> countyDropdown = [];
  List<DropdownMenuItem> subCountryDropdown = [];
  List<DropdownMenuItem> villageDropdown = [];
  List<DropdownMenuItem> wardDropdown = [];
  List<DropdownMenuItem> housingOwnerDropdown = [];
  List<DropdownMenuItem> assetOwnerDropdown = [];
  List<DropdownMenuItem> collectioncentreDropdown = [];
  List<DropdownMenuItem> highestEduDropdown = [];
  List<DropdownMenuItem> typeDropdown = [];
  List<DropdownMenuItem> plantingDropdown = [];

  List<DropdownModelFarmer> farmeritems = [];
  DropdownModelFarmer? slctFarmers;

  List<DropdownModel> farmitems = [];
  DropdownModel? slctFarms;

  List<DropdownModel> blockitems = [];
  DropdownModel? slctBlocks;

  List<DropdownModel> plantingItems = [];
  DropdownModel? slctPlanting;

  bool countryLoaded = false,
      countyLoaded = false,
      subCountyLoaded = false,
      wardLoaded = false,
      villageLoaded = false;
  bool cropNameLoaded = false;
  bool farmLoaded = false;
  bool blockLoaded = false;
  bool plantingLoaded = false;

  String uom = "";

  Future<bool> _onBackPressed() async {
    return (await Alert(
          context: context,
          type: AlertType.warning,
          title: exit,
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initValue();
    getLocation();
    getClientData();
    ward();
    typeFunction();
    //New
    //farmerTraceCode = farmerId.toString();

    quantityharvestedController.addListener(() {
      setState(() {
        if (quantityharvestedController.text.length > 0) {
          var qty = quantityharvestedController.text;
          double num1 = double.parse((qty));
          harvestedQtyValue = num1;

          double convert = double.parse(quantityharvestedController.text);
          harvestQtydec = convert.toStringAsFixed(2);
        }
      });
    });

    noOfWeightController.addListener(() {
      setState(() {
        if (noOfWeightController.text.length > 0) {
          var weight = noOfWeightController.text;
          double num1 = double.parse((weight));
          noOfWeight = num1;
        }
      });
    });

    harvestedyieldsController.addListener(() {
      setState(() {
        if (harvestedyieldsController.text.length > 0) {
          double convertt = double.parse(harvestedyieldsController.text);
          harvestYieldec = convertt.toStringAsFixed(2);
        }
      });
    });
  }

  getClientData() async {
    List<Map> agents = await db.RawQuery('SELECT * FROM agentMaster');
    seasonCode = agents[0]['currentSeasonCode'];
    servicePointId = agents[0]['servicePointId'];
    agentId = agents[0]['agentId'];
  }

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
    });
  }

  Future<void> village(String cityCode) async {
    List villageList = await db.RawQuery(
        'select distinct fm.villageId as villCode ,fm.[villageName] as villName from [farmer_master] fm inner join [farmCrop] fc on fm.[farmerId] = fc.farmerId inner join [villageList] vl on fm.villageId = vl.[villCode] where vl.[gpCode]=\'' +
            cityCode +
            '\'');
    villageUIModel = [];
    villageDropdown = [];
    villageDropdown.clear();
    for (int i = 0; i < villageList.length; i++) {
      String propertyValue = villageList[i]["villName"].toString();
      String diSpSeq = villageList[i]["villCode"].toString();

      var uiModel = new UImodel(propertyValue, diSpSeq);
      villageUIModel.add(uiModel);
      setState(() {
        villageDropdown.add(DropdownMenuItem(
          child: Text(propertyValue),
          value: propertyValue,
        ));
      });
    }
  }

  Future<void> typeFunction() async {
    List typeList = [
      {"property_value": "Count", "DISP_SEQ": "1"},
      {"property_value": "Weight", "DISP_SEQ": "0"}
    ];
    typeUIModel = [];
    typeDropdown = [];
    typeDropdown.clear();
    for (int i = 0; i < typeList.length; i++) {
      String propertyValue = typeList[i]["property_value"].toString();
      String diSpSeq = typeList[i]["DISP_SEQ"].toString();

      var uiModel = new UImodel(propertyValue, diSpSeq);
      typeUIModel.add(uiModel);
      setState(() {
        typeDropdown.add(DropdownMenuItem(
          child: Text(propertyValue),
          value: propertyValue,
        ));
      });
    }
  }

  Future<void> ward() async {
    List wardList = await db.RawQuery(
        'select distinct vl.[gpCode] as cityCode ,ct.[cityName] as cityName from [farmer_master] fm inner join [farmCrop] fc on fm.[farmerId] = fc.farmerId inner join [villageList] vl on fm.villageId = vl.[villCode] inner join [cityList] ct on vl.[gpCode] = ct.[cityCode]');

    wardUIModel = [];
    wardDropdown = [];
    wardDropdown.clear();
    for (int i = 0; i < wardList.length; i++) {
      String propertyValue = wardList[i]["cityName"].toString();
      String diSpSeq = wardList[i]["cityCode"].toString();

      var uiModel = new UImodel(propertyValue, diSpSeq);
      wardUIModel.add(uiModel);
      setState(() {
        wardDropdown.add(DropdownMenuItem(
          child: Text(propertyValue),
          value: propertyValue,
        ));
      });
    }
  }

  Future<void> initValue() async {
    List collectioncentreList = await db.RawQuery(
        'select * from animalCatalog where catalog_code =\'5\'');

    collectioncentreUIModel = [];
    collectioncentreDropdown = [];
    collectioncentreDropdown.clear();
    for (int i = 0; i < collectioncentreList.length; i++) {
      String propertyValue =
          collectioncentreList[i]["property_value"].toString();
      String diSpSeq = collectioncentreList[i]["DISP_SEQ"].toString();

      var uiModel = new UImodel(propertyValue, diSpSeq);
      collectioncentreUIModel.add(uiModel);
      setState(() {
        collectioncentreDropdown.add(DropdownMenuItem(
          child: Text(propertyValue),
          value: propertyValue,
        ));
      });
    }

    List assetOwnerList = await db.RawQuery(
        'select * from animalCatalog where catalog_code =\'81\'');

    assetOwnerUIModel = [];
    assetOwnerDropdown = [];
    assetOwnerDropdown.clear();
    for (int i = 0; i < assetOwnerList.length; i++) {
      String propertyValue = assetOwnerList[i]["property_value"].toString();
      String diSpSeq = assetOwnerList[i]["DISP_SEQ"].toString();

      var uiModel = new UImodel(propertyValue, diSpSeq);
      assetOwnerUIModel.add(uiModel);
      setState(() {
        assetOwnerDropdown.add(DropdownMenuItem(
          child: Text(propertyValue),
          value: propertyValue,
        ));
      });
    }

    List housingOwnerList = await db.RawQuery(
        'select * from animalCatalog where catalog_code =\'82\'');

    housingOwnerUIModel = [];
    housingOwnerDropdown = [];
    housingOwnerDropdown.clear();
    for (int i = 0; i < housingOwnerList.length; i++) {
      String propertyValue = housingOwnerList[i]["property_value"].toString();
      String diSpSeq = housingOwnerList[i]["DISP_SEQ"].toString();

      var uiModel = new UImodel(propertyValue, diSpSeq);
      housingOwnerUIModel.add(uiModel);
      setState(() {
        housingOwnerDropdown.add(DropdownMenuItem(
          child: Text(propertyValue),
          value: propertyValue,
        ));
      });
    }
  }

  void farmerSearch(String villageCode) async {
    List farmerList = await db.RawQuery(
        'select distinct fm.farmerId,fm.fName,fm.farmerCode, fm.idProofVal ,fm.trader from farmer_master as fm inner join farm as f on fm.farmerId = f.farmerId inner join farmCrop as fc on fc.farmcodeRef = f.farmIDT where fm.villageId= \'' +
            villageCode +
            '\'');
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

  void farmSearch(String farmerId) async {
    String qryFarm =
        'select distinct f.farmIDT,f.farmName, f.prodLand  from farm as f inner join farmCrop as fc on fc.farmcodeRef = f.farmIDT where f.farmerId = \'' +
            valFarmer +
            '\'';
    print("qrrFarm_qrrFarm" + qryFarm);
    List farmList = await db.RawQuery(qryFarm);
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

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        if (farmList.length > 0) {
          farmLoaded = true;
          slcFarm = "";
        }
      });
    });
  }

  void blockidsearch(String farmCode) async {
    String blockidList =
        'select distinct blockId,blockName from farmCrop where farmCodeRef=\'' +
            farmCode +
            '\';';
    print("qrrFarm_qrrFarm" + blockidList);
    List blockList = await db.RawQuery(blockidList);
    blockUIModel = [];
    blockDropdown = [];
    blockitems.clear();
    for (int i = 0; i < blockList.length; i++) {
      String blockId = blockList[i]["blockId"].toString();
      String blockName = blockList[i]["blockName"].toString();
      print("cropgrade" + cropVariety.toString());

      var uiModel = new UImodel(blockName, blockId);
      blockUIModel.add(uiModel);
      setState(() {
        blockitems.add(DropdownModel(
          blockName,
          blockId,
        ));
        //prooflist.add(property_value);
      });
    }

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        if (blockList.length > 0) {
          blockLoaded = true;
          slcblock = "";
        }
      });
    });
  }

  void plantingIdSearch(String blockID) async {
    String plantingQry =
        'select farmcrpIDT from farmCrop where blockId=\'' + blockID + '\';';
    print("plantingList" + plantingQry);
    List plantingIDList = await db.RawQuery(plantingQry);
    plantingUIModel = [];
    plantingItems = [];
    for (int i = 0; i < plantingIDList.length; i++) {
      String plantingID = plantingIDList[i]["farmcrpIDT"].toString();

      var uiModel = UImodel(plantingID, plantingID);
      plantingUIModel.add(uiModel);
      setState(() {
        plantingItems.add(DropdownModel(
          plantingID,
          plantingID,
        ));
      });
    }

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        if (plantingIDList.isNotEmpty) {
          plantingLoaded = true;
        }
      });
    });
  }

  void getCropVariety(String plantingID) async {
    String getProductQry =
        'select distinct v.hsCode, fc.seedLotNo,Max(fc.expWeek) as dateOfEve , fc.dateOfSown,fc.cropVariety,fc.cropgrade, g.grade as gradeName,v.vName as varietyName from farmCrop as fc inner join varietyList v on v.vCode= fc.cropVariety  inner join procurementGrade g on gradeCode=fc.cropgrade where fc.farmcrpIDT=\'' +
            plantingID +
            '\'';
    print("getProductQry_getProductQry" + getProductQry.toString());

    List cropVarietyList = await db.RawQuery(getProductQry);

    if (cropVarietyList.length > 0) {
      String variety = cropVarietyList[0]["gradeName"].toString();
      String crop = cropVarietyList[0]["varietyName"].toString();
      String cropID = cropVarietyList[0]["cropVariety"].toString();
      String varietyID = cropVarietyList[0]["cropgrade"].toString();
      String getDate = cropVarietyList[0]["dateOfSown"].toString();
      expctdDate = cropVarietyList[0]["seedLotNo"].toString();
      dateOfEve = cropVarietyList[0]["dateOfEve"].toString();
      uom = cropVarietyList[0]["hsCode"].toString();

      print('expctdDate' + expctdDate);

      setState(() {
        cropName = crop;
        varietyName = variety;
        cropCode = cropID;
        cropVariety = varietyID;
        plantingDate = getDate;
      });
    }
  }

  void expectedYield(String plantingID) async {
    String expectedYieldQry =
        'select distinct fmcrp.blockId,fmcrp.production from farmCrop as fmcrp  where fmcrp.[farmcrpIDT]=\'' +
            plantingID +
            '\';';
    print("expectedYieldQry" + expectedYieldQry);
    List expectedYieldList = await db.RawQuery(expectedYieldQry);
    String expectedQTy = "";
    for (int i = 0; i < expectedYieldList.length; i++) {
      expectedQTy = expectedYieldList[i]["production"].toString();
    }
    setState(() {
      expectedQuantity = expectedQTy;
    });
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
          title: Text('Harvest',
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

  List<Widget> getListings(BuildContext context) {
    List<Widget> listings = [];

    listings
        .add(txt_label_mandatory("Select the Ward", Colors.black, 14.0, false));
    listings.add(singlesearchDropdown(
      itemlist: wardDropdown,
      selecteditem: slcWard,
      hint: "Select Ward",
      onChanged: (value) {
        setState(() {
          slcWard = value!;
          slcVillage = "";
          slcFarmer = "";
          slcFarm = "";
          valFarm = "";
          slcblock = "";
          cropName = "";
          varietyName = "";
          slctFarmers = null;
          slctBlocks = null;
          slctFarms = null;
          farmDropdown = [];
          blockDropdown = [];
          farmerDropdown = [];
          villageDropdown = [];
          farmLoaded = false;
          blockLoaded = false;
          expectedQuantity = "";
          plantingLoaded = false;
          plantingItems = [];
          slcPlanting = "";
          valPlanting = "";
          slctPlanting = null;
          expctdDate = '';
          recDate = '';
          selectedDate = '';
          formatDate = '';
          for (int i = 0; i < wardUIModel.length; i++) {
            if (value == wardUIModel[i].name) {
              valWard = wardUIModel[i].value;
              village(valWard);
            }
          }
        });
      },
    ));

    listings.add(
        txt_label_mandatory("Select the Village", Colors.black, 14.0, false));
    listings.add(singlesearchDropdown(
      itemlist: villageDropdown,
      selecteditem: slcVillage,
      hint: "Select Village",
      onChanged: (value) {
        setState(() {
          slcVillage = value!;
          slcFarm = "";
          slcFarmer = "";
          valFarm = "";
          slcblock = "";
          cropName = "";
          varietyName = "";
          slctFarmers = null;
          slctFarms = null;
          slctBlocks = null;
          farmDropdown = [];
          blockDropdown = [];
          farmerDropdown = [];
          farmLoaded = false;
          blockLoaded = false;
          expectedQuantity = "";
          plantingLoaded = false;
          plantingItems = [];
          slcPlanting = "";
          valPlanting = "";
          slctPlanting = null;
          expctdDate = '';
          recDate = '';
          selectedDate = '';
          formatDate = '';
          for (int i = 0; i < villageUIModel.length; i++) {
            if (value == villageUIModel[i].name) {
              valVillage = villageUIModel[i].value;
              farmerSearch(valVillage);
            }
          }
        });
      },
    ));

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
          blockLoaded = false;
          slcblock = "";
          plantingid = "";
          valblock = "";
          expectedQuantity = "";
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
          blockLoaded = false;
          slcblock = "";
          plantingid = "";
          valFarm = "";
          valblock = "";
          cropName = "";
          varietyName = "";
          expectedQuantity = "";
          slctFarms = null;
          slctBlocks = null;
          //toast(slctFarmers!.value);
          valFarmer = slctFarmers!.value;
          slcFarmer = slctFarmers!.name;
          plantingLoaded = false;
          plantingItems = [];
          slcPlanting = "";
          valPlanting = "";
          slctPlanting = null;
          expctdDate = '';
          recDate = '';
          selectedDate = '';
          formatDate = '';
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
                blockLoaded = false;
                slcblock = "";
                plantingid = "";
                valblock = "";
                expectedQuantity = "";
                for (int i = 0; i < farmUIModel.length; i++) {
                  if (value == farmUIModel[i].name) {
                    valFarm = farmUIModel[i].value;
                    blockidsearch(valFarm);
                  }
                }
              });
            },
          )
        : Container()); */

    listings.add(farmLoaded
        ? DropDownWithModel(
            itemlist: farmitems,
            selecteditem: slctFarms,
            hint: "Select Farm",
            onChanged: (value) {
              setState(() {
                slctFarms = value!;
                blockLoaded = false;
                slcblock = "";
                plantingid = "";
                valblock = "";
                cropName = "";
                varietyName = "";
                expectedQuantity = "";
                slctBlocks = null;
                valFarm = "";
                //toast(slctFarms!.value);
                valFarm = slctFarms!.value;
                slcFarm = slctFarms!.name;
                plantingLoaded = false;
                plantingItems = [];
                slcPlanting = "";
                valPlanting = "";
                slctPlanting = null;
                expctdDate = '';
                recDate = '';
                selectedDate = '';
                formatDate = '';
                print('selectedvalue ' + slctFarms!.value);
                blockidsearch(valFarm);
              });

              print("Name" + slcFarmer);
              print("Code" + valFarmer);
            },
            onClear: () {
              setState(() {
                slcFarm = "";
              });
            })
        : Container());

    listings.add(valFarm.length > 0
        ? txt_label_mandatory("Farm ID", Colors.black, 14.0, false)
        : Container());
    listings.add(valFarm.length > 0
        ? cardlable_dynamic(valFarm.toString())
        : Container());

    listings.add(blockLoaded
        ? txt_label_mandatory("Block Name", Colors.black, 15.0, false)
        : Container());

    /* listings.add(blockLoaded
        ? singlesearchDropdown(
            itemlist: blockDropdown,
            selecteditem: slcblock,
            hint: "Select Block Name",
            onChanged: (value) {
              setState(() {
                slcblock = value!;
                plantingid = "";
                valblock = "";
                expectedQuantity = "";
                for (int i = 0; i < blockUIModel.length; i++) {
                  if (value == blockUIModel[i].name) {
                    valblock = blockUIModel[i].value;
                    plantingid = blockUIModel[i].value2;
                    plantingDate = blockUIModel[i].value3;
                    cropCode = blockUIModel[i].value4;
                    cropVariety = blockUIModel[i].value5;
                    expectedYield(valblock);
                  }
                }
              });
            },
          )
        : Container());  */

    listings.add(blockLoaded
        ? DropDownWithModel(
            itemlist: blockitems,
            selecteditem: slctBlocks,
            hint: "Select Block",
            onChanged: (value) {
              setState(() {
                slctBlocks = value!;
                plantingid = "";
                expectedQuantity = "";
                cropName = "";
                varietyName = "";

                valblock = slctBlocks!.value;
                slcblock = slctBlocks!.name;
                plantingLoaded = false;
                plantingItems = [];
                slcPlanting = "";
                valPlanting = "";
                slctPlanting = null;
                expctdDate = '';
                recDate = '';
                selectedDate = '';
                formatDate = '';
                plantingIdSearch(valblock);

                /*   for (int i = 0; i < blockUIModel.length; i++) {
                  if (valblock == blockUIModel[i].value) {
                    plantingid = blockUIModel[i].value2;
                    plantingDate = blockUIModel[i].value3;
                    cropCode = blockUIModel[i].value4;
                    cropVariety = blockUIModel[i].value5;
                  }
                }*/
              });
            },
          )
        : Container());

    listings.add(blockLoaded
        ? txt_label_mandatory("Block ID", Colors.black, 14.0, false)
        : Container());
    listings.add(
        blockLoaded ? cardlable_dynamic(valblock.toString()) : Container());

/*    listings.add(blockLoaded
        ? txt_label_mandatory("Crop-Planting ID", Colors.black, 14.0, false)
        : Container());
    listings.add(
        blockLoaded ? cardlable_dynamic(plantingid.toString()) : Container());*/

    listings.add(plantingLoaded
        ? txt_label_mandatory("Planting ID", Colors.black, 14.0, false)
        : Container());
    listings.add(plantingLoaded
        ? DropDownWithModel(
            itemlist: plantingItems,
            selecteditem: slctPlanting,
            hint: "Select Planting ID",
            onChanged: (value) {
              setState(() {
                slctPlanting = value!;
                valPlanting = slctPlanting!.value;
                slcPlanting = slctPlanting!.name;
                plantingid = valPlanting;
                cropName = "";
                varietyName = "";
                plantingDate = "";
                expctdDate = '';
                recDate = '';
                selectedDate = '';
                formatDate = '';
                expectedYield(valPlanting);
                getCropVariety(valPlanting);
              });
            },
            onClear: () {
              setState(() {});
            })
        : Container());

    listings.add(plantingLoaded
        ? txt_label_mandatory("Crop Name", Colors.black, 14.0, false)
        : Container());
    listings.add(
        plantingLoaded ? cardlable_dynamic(cropName.toString()) : Container());

    listings.add(plantingLoaded
        ? txt_label_mandatory("Crop Variety ($uom)", Colors.black, 14.0, false)
        : Container());
    listings.add(plantingLoaded
        ? cardlable_dynamic(varietyName.toString())
        : Container());

    listings.add(txt_label_mandatory(
        "Expected Day of Harvest (EDH)", Colors.black, 14.0, false));

    listings.add(selectDate(
        context1: context,
        slctdate: selectedDate,
        onConfirm: (date) => setState(
              () {
                selectedDate = DateFormat('dd-MM-yyyy').format(date);
                formatDate = DateFormat('yyyy-MM-dd').format(date);
                sprayDateComparison(date);

                if (expctdDate.isNotEmpty) {
                  calculateDate(expctdDate, formatDate);
                }
              },
            )));

    listings.add(txt_label_mandatory("Type", Colors.black, 15.0, false));
    listings.add(singlesearchDropdown(
      itemlist: typeDropdown,
      selecteditem: typeName,
      hint: "Select Type",
      onChanged: (value) {
        setState(() {
          typeName = value!;
          typeValue = "";
          for (int i = 0; i < typeUIModel.length; i++) {
            if (value == typeUIModel[i].name) {
              typeValue = typeUIModel[i].value;
            }
          }
        });
      },
    ));

    if (typeValue == "1") {
      listings.add(
          txt_label_mandatory("Number of Stems", Colors.black, 14.0, false));
      listings.add(txtfield_digits_integer(
          "Number of Stems", noofstemsController, true, 50));
    } else if (typeValue == "0") {
      listings.add(txt_label_mandatory(
          "Number of Weight (Kgs)", Colors.black, 14.0, false));
      listings.add(txtfieldAllowTwoDecimal(
          "Number of Weight (Kgs)", noOfWeightController, true, 50));
    }

    listings.add(txt_label_mandatory(
        "Quantity Harvested(Kg)", Colors.black, 14.0, false));
    listings.add(txtfieldAllowTwoDecimal(
        "Quantity Harvested(Kg)", quantityharvestedController, true, 50));
    listings.add(
        txt_label_mandatory("Projected Yields(Kg)", Colors.black, 14.0, false));
/*    listings.add(txtfieldAllowTwoDecimal(
        "Harvested Yields(Kg)", harvestedyieldsController, true, 50));*/

    listings.add(txtfieldAllowTwoDecimal(
        "Projected Yields(Kg)", harvestedyieldsController, true, 50));

    listings.add(txt_label_mandatory(
        "Expected Yields in Volume per Variety(Kg)",
        Colors.black,
        14.0,
        false));
    listings.add(cardlable_dynamic(expectedQuantity.toString()));

    listings.add(
        txt_label_mandatory("Name of Harvester", Colors.black, 14.0, false));
    listings.add(txtfield_dynamic(
        "Name of Harvester", harvesternameController, true, 60));

    listings.add(
        txt_label_mandatory("Harvest Equipment", Colors.black, 15.0, false));
    listings.add(singlesearchDropdown(
      itemlist: assetOwnerDropdown,
      selecteditem: slcHarequip,
      hint: "Select Harvest Equipment",
      onChanged: (value) {
        setState(() {
          slcHarequip = value!;
          for (int i = 0; i < assetOwnerUIModel.length; i++) {
            if (value == assetOwnerUIModel[i].name) {
              valHarequip = assetOwnerUIModel[i].value;
            }
          }
        });
      },
    ));

    listings
        .add(txt_label_mandatory("Number of Units", Colors.black, 14.0, false));
    listings.add(
        txtfield_digits_integer("No of Units", noofunitsController, true, 50));

    listings
        .add(txt_label_mandatory("Packing Unit", Colors.black, 15.0, false));

    listings.add(singlesearchDropdown(
      itemlist: housingOwnerDropdown,
      selecteditem: slcPackingunit,
      hint: "Select Packing Unit",
      onChanged: (value) {
        setState(() {
          slcPackingunit = value!;
          for (int i = 0; i < housingOwnerUIModel.length; i++) {
            if (value == housingOwnerUIModel[i].name) {
              valPackingunit = housingOwnerUIModel[i].value;
            }
          }
        });
      },
    ));

    listings.add(txt_label("Observation of PHI", Colors.black, 14.0, false));
    listings.add(txtfield_dynamic(
        "Observation of PHI", observationphiController, true, 50));

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

  void harvestDaysValue(selectedDate, int numberOfDays) async {
    if (selectedDate != "") {
      String startDate = selectedDate;
      List<String> splitStartDate = startDate.split('-');
      String strDateq1 = splitStartDate[0];
      String strMonthq1 = splitStartDate[1];
      String strYearq1 = splitStartDate[2];

      int strYear1 = int.parse(strDateq1);
      int strMonths1 = int.parse(strMonthq1);
      int strDate1 = int.parse(strYearq1);

      DateTime convertHarvestDate =
          new DateTime(strYear1, strMonths1, strDate1);

      //DateTime convertHarvestDate = convertStartDate;

      int addDate = (convertHarvestDate.day + noOfDays);
      DateTime convertEndDate = new DateTime(strYear1, strMonths1, addDate);

      var expectedWeek = convertEndDate.weekOfYear;
      var expectedYear = convertEndDate.year;
      var expectedDay = convertEndDate.day;

      String week = expectedWeek.toString();
      String year = expectedYear.toString();
      String day = expectedDay.toString();

      expectedDayHarvest = day + " " + "Week" + " " + week + ", " + year;
    }
  }

  void sprayDateComparison(DateTime harvestDate) async {
    print("plantingDate_plantingDate" + plantingDate.toString());
    if (plantingDate != "") {
      String dateValue = plantingDate;
      String trimmedDate = dateValue.substring(0, 10);
      DateTime convertHarvestDate = harvestDate;
      print("convertSowingDate" + convertHarvestDate.toString());

      String startDate = trimmedDate;
      List<String> splitStartDate = startDate.split('-');

      String strYearq = splitStartDate[0];
      String strMonthq = splitStartDate[1];
      String strDateq = splitStartDate[2];

      int strYear = int.parse(strYearq);
      int strMonths = int.parse(strMonthq);
      int strDate = int.parse(strDateq);

      DateTime convertPlantingDate = new DateTime(strYear, strMonths, strDate);

      print("convertPlantingDate" + convertPlantingDate.toString());

      DateTime valEnd = convertHarvestDate;
      bool valDate = convertPlantingDate.isAfter(valEnd);
      if (valDate) {
        setState(() {
          afterPlantingDate = true;
        });
      } else {
        setState(() {
          afterPlantingDate = false;
        });
      }
    }
  }

  void btnSubmit() {
    if (slcWard.length == 0) {
      alertPopup(context, "Ward should not be empty");
    } else if (slcVillage.length == 0) {
      alertPopup(context, "Village should not be empty");
    } else if (slcFarmer.length == 0) {
      alertPopup(context, "Farmer Name should not be empty");
    } else if (slcFarm.length == 0) {
      alertPopup(context, "Farm Name should not be empty");
    } else if (slcblock.length == 0) {
      alertPopup(context, "Block Name should not be empty");
    } else if (slcPlanting.isEmpty) {
      alertPopup(context, "Planting ID should not be empty");
    } else if (selectedDate.length == 0) {
      alertPopup(context, "Expected Day of Harvest (EDH) should not be empty");
    } else {
      if (afterPlantingDate) {
        alertPopup(context,
            "Expected Day of Harvest (EDH) should be greater than Planting Date");
      } else {
        if (dateOfEve.isNotEmpty) {
          print('difference--- $dateOfEve');
          var difference = DateTime.parse(formatDate)
              .difference(DateTime.parse(dateOfEve))
              .inDays;
          print('difference--- $difference');
          if (difference < 0) {
            setState(() {
              selectedDate = '';
              formatDate = '';
            });
            alertPopup(context,
                "Harvest date should be set after the Date of event($dateOfEve)");
          }else{
            validation();
          }
        }else{
          validation();
        }
      }
    }
  }

  void validation() {
    bool validQty = true;
    if (quantityharvestedController.text.length > 0) {
      if (harvestedQtyValue <= 0) {
        validQty = false;
      } else if (quantityharvestedController.text.contains('.')) {
        List<String> value = quantityharvestedController.text.split(".");
        if (value[1].length > 0) {
          setState(() {
            validQty = true;
          });
        } else {
          validQty = false;
        }
      } else {
        validQty = true;
      }
    }

    bool validWeight = true;
    if (noOfWeightController.text.length > 0) {
      if (noOfWeight <= 0) {
        validWeight = false;
      } else if (noOfWeightController.text.contains('.')) {
        List<String> value = noOfWeightController.text.split(".");
        if (value[1].length > 0) {
          setState(() {
            validWeight = true;
          });
        } else {
          validWeight = false;
        }
      } else {
        validWeight = true;
      }
    }

    if (typeName.length == 0) {
      alertPopup(context, "Type should not be empty");
    } else if (typeValue == "1" && noofstemsController.text.length == 0) {
      alertPopup(context, "Number of Stems should not be empty");
    } else if (typeValue == "0" && noOfWeightController.text.length == 0) {
      alertPopup(context, "Number of Weight (Kgs) should not empty");
    } else if (!validWeight) {
      alertPopup(context, "Invalid Number of Weight (Kgs)");
    } else if (quantityharvestedController.text.length == 0) {
      alertPopup(context, "Quantity Harvested(Kg) should not be empty");
    } else if (!validQty) {
      alertPopup(context, "Invalid Quantity Harvested(Kg)");
    } else if (harvestedyieldsController.text.length == 0) {
      alertPopup(context, "Projected Yields(Kg) should not be empty");
    } else if (harvesternameController.text.length == 0) {
      alertPopup(context, "Name of Harvester Should not be empty");
    } else if (valHarequip.length == 0) {
      alertPopup(context, "Harvest Equipment should not be empty");
    } else if (noofunitsController.text.length == 0) {
      alertPopup(context, "Number of Units should not be empty");
    } else if (valPackingunit.length == 0) {
      alertPopup(context, "Packing Unit Should not be empty");
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
            Harvesting();
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

  Future<void> Harvesting() async {
    var db = DatabaseHelper();
    final now = new DateTime.now();
    String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
    String? agentid = await SecureStorage().readSecureData("agentId");
    String? agentToken = await SecureStorage().readSecureData("agentToken");
    //print('txnHeader ' + agentid + "" + agentToken);
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
            agentid! +
            '\', \'' +
            agentToken! +
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
        txntime, appDatas.txnHarvest, revNo.toString(), '', '', '');
    print("valHighestEduLev" + valHighestEduLev);

    if (typeValue == "1") {
      stemsWeightValue = noofstemsController.text.toString();
    } else if (typeValue == "0") {
      stemsWeightValue = noOfWeightController.text.toString();
    }
    String lastHarvestedDate = "";
    var currentNow = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(currentNow);

    try {
      lastHarvestedDate = formattedDate.toString();
    } catch (e) {
      lastHarvestedDate = "";
    }

    print("lastHarvestedDatehhh" + lastHarvestedDate.toString());

    int saveharvest = await db.saveHarvest(
        valFarmer,
        valFarm,
        valblock,
        plantingid,
        formatDate,
        stemsWeightValue,
        harvestQtydec,
        harvestYieldec,
        expectedQuantity,
        harvesternameController.text,
        valHarequip,
        noofunitsController.text,
        valPackingunit,
        valcolectioncentre,
        produceidController.text,
        observationphiController.text,
        seasonCode,
        revNo.toString(),
        "1",
        cropCode,
        cropVariety,
        slcblock,
        typeValue,
        lastHarvestedDate);

    db.UpdateTableValue(
        'cropHarvest', 'isSynched', '0', 'recNo', revNo.toString());

    TxnExecutor txnExecutor = new TxnExecutor();
    txnExecutor.CheckCustTrasactionTable();

    Alert(
      context: context,
      type: AlertType.info,
      title: "Transaction Successful",
      desc: "Harvesting done Successfully",
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
  }

  void calculateDate(String expctdDate, String formatedDate) {
    var parsedCurrentDate =
        DateFormat('yyyy-MM-dd').format(DateTime.parse(formatedDate));

    var expDate = DateTime.parse(expctdDate);
    var parsedExpectedDate = DateFormat('yyyy-MM-dd').format(expDate);

    var difference = DateTime.parse(parsedCurrentDate)
        .difference(DateTime.parse(parsedExpectedDate))
        .inDays;

    print('parsedCurrentDate' + parsedCurrentDate.toString());
    print('parsedExpectedDate' + parsedExpectedDate.toString());

    print('finaldifference' + difference.toString());

    if (difference < 0) {
      Alert(
        context: context,
        type: AlertType.info,
        title: "Alert",
        desc: "The Recommended Harvest date is ${expctdDate}",
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              setState(() {
                formatDate = '';
                selectedDate = '';
              });
              Navigator.pop(context);
            },
            width: 120,
          ),
        ],
        closeFunction: () {
          Navigator.pop(context);
        },
      ).show();
    }
  }
}
