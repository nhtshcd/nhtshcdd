import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:nhts/Database/Databasehelper.dart';
import 'package:nhts/Model/UIModel.dart';
import 'package:nhts/Plugins/TxnExecutor.dart';
import 'package:nhts/Utils/MandatoryDatas.dart';
import 'package:nhts/Utils/dynamicfields.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../Utils/secure_storage.dart';
import '../login.dart';
import '../main.dart';
import 'qrcode.dart';

class Sorting extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Sorting();
}

class _Sorting extends State<Sorting> {
  TextEditingController rejectedqtyController = new TextEditingController();
  TextEditingController sortedqtyController = new TextEditingController();
  TextEditingController truckTypeController = new TextEditingController();
  TextEditingController truckNumberController = new TextEditingController();
  TextEditingController driverNameController = new TextEditingController();
  TextEditingController driverContactController = new TextEditingController();
  String farmerTraceCode = "";

  String ruexit = 'Are you sure want to cancel?';
  String exit = 'Cancel';
  String no = 'No', yes = 'Yes';
  String aggentId = "";
  String deliveryNote = "";
  String cropName = "", varietyName = "";

  String valFarmer = "",
      proposedLand = "",
      valFarm = "",
      plantingid = "",
      valblock = "";

  String plantingWeek = "",
      expectedWeekHarvest = "",
      expectedHarvestDate = "",
      expectedQuantity = "0",
      plantingID = "";

  var weekOfYear;
  bool dateSelected = false;
  bool afterPlantingDate = false;

  String blockArea = "", selectedDate = "", formatDate = "";
  String CountyCode = "";
  String CountyName = "";

  String slcFarmer = "",
      farmerName = "",
      slcFarm = "",
      slcblock = "",
      slccolectioncentre = "",
      slcHarequip = "",
      slcPackingunit = "";

  var quantityharvested = "";

  String harvestDate = "", pCode = "", pName = "", vCode = "", vName = "";
  String blockStateName = "", blockStateCode = "";

  double hrvqty = 0;
  double totalquantity = 0;

  String valPackingunit = "", valHarequip = "", valcolectioncentre = "";

  String valHighestEduLev = "";
  String exporterName = "";
  String servicePointId = "",
      seasonCode = "",
      agentId = '',
      latitude = "",
      longitude = "";
  String plantingDate = "";
  String rejQtydec = "", sorQtydec = "";
  String slcWard = "", slcVillage = "", valWard = "", valVillage = "";
  String slcPlanting = "", valPlanting = "";

  int curIdLim = 0, resId = 0, curIdLimited = 0, farmerId = 0;
  int noOfDays = 0;

  File? farmerImageFile, nationalIdImageFile;

  List<UImodel3> farmerUIModel = [];
  List<UImodel2> farmUIModel = [];
  List<UImodel> blockUIModel = [];

  //List<UImodel> villageUIModel = [];
  List<UImodel> housingOwnerUIModel = [];
  List<UImodel> assetOwnerUIModel = [];
  List<UImodel> collectioncentreUIModel = [];
  List<UImodel> wardUIModel = [];
  List<UImodel> villageUIModel = [];
  List<UImodel> plantingUIModel = [];

  List<String> valCropCategoryList = [];
  List<String> valCropNameList = [];
  List<String> valHousingOwnerList = [];
  List<String> valAssetOwnerList = [];
  List<String> valHighestEduList = [];
  List<String> collectioncentreList = [];

  List<DropdownModelFarmer> farmerDropdown = [];
  List<DropdownModel> farmDropdown = [];
  List<DropdownModel> blockDropdown = [];
  List<DropdownModel> plantingItems = [];
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
  List<DropdownMenuItem> plantingDropdown = [];

  List<UImodel> truckListUIModel = [];
  final List<DropdownMenuItem> truckDropdownItem = [];
  String slctTruckTyp = "", valTruckTyp = "" ,truckTypeName ='';


  DropdownModelFarmer? farmerSelect;
  DropdownModel? blockSelect;
  DropdownModel? farmSelect;
  DropdownModel? plantingSelect;

  bool countryLoaded = false,
      countyLoaded = false,
      subCountyLoaded = false,
      wardLoaded = false,
      villageLoaded = false;
  bool cropNameLoaded = false;
  bool farmLoaded = false;
  bool blockLoaded = false;
  bool qrGenerator = false;
  bool plantingLoaded = false;

  String uom="";

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

    getLocation();
    getClientData();
    ward();
    loadtruck();

    driverContactController.addListener(() {
      driverNote();
    });
    truckNumberController.addListener(() {
      driverNote();
    });
    driverNameController.addListener(() {
      driverNote();
    });
    // truckTypeController.addListener(() {
    //   driverNote();
    // });
    sortedqtyController.addListener(() {
      driverNote();
    });
  }

  getClientData() async {
    List<Map> agents = await db.RawQuery('SELECT * FROM agentMaster');
    seasonCode = agents[0]['currentSeasonCode'];
    servicePointId = agents[0]['servicePointId'];
    agentId = agents[0]['agentId'];
    exporterName = agents[0]['exporterName'];
  }

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
    });
  }

  void driverNote() {
    String truckNumber = truckNumberController.text;
    String truckType = truckTypeName;
    String driverName = driverNameController.text;
    String driverContact = driverContactController.text;
    if (truckNumber.isNotEmpty &&
        driverName.isNotEmpty &&
        driverContact.isNotEmpty &&
        truckType.isNotEmpty) {
      String space = '/';
      setState(() {
        deliveryNote = "Sorted Quantity (Kg) :" +
            " " +
            sortedqtyController.text.toString() +
            "\n" +
            "Truck Type  :" +
            " " +
            truckType +
            "\n" +
            "Number Plate :" +
            " " +
            truckNumber +
            " " +
            "\n" +
            "Driver Name  :" +
            " " +
            driverName +
            "\n" +
            "Driver Contact  :" +
            " " +
            driverContact +
            "\n";
      });
    }
  }

  Future<void> village(String cityCode) async {
    List villageList = await db.RawQuery(
        'select distinct fm.villageId as villCode ,fm.[villageName] as villName from [farmer_master] fm inner join [villagewarehouse] vl on fm.[farmerId] = vl.farmerId inner join [villageList] vl on fm.villageId = vl.[villCode] where vl.[gpCode]=\'' +
            cityCode +
            '\' and vl.stockType=0');
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

  loadtruck() async {
    String qryInslist =
        'select * from animalCatalog where catalog_code =\'' + "91" + '\'';
    List insList = await db.RawQuery(qryInslist);

    truckListUIModel = [];
    truckDropdownItem.clear();
    for (int i = 0; i < insList.length; i++) {
      String property_value = insList[i]["property_value"].toString();
      String DISP_SEQ = insList[i]["DISP_SEQ"].toString();
      var uimodel = UImodel(property_value, DISP_SEQ);
      truckListUIModel.add(uimodel);
      setState(() {
        truckDropdownItem.add(DropdownMenuItem(
          child: Text(property_value),
          value: property_value,
        ));
      });
    }
  }

  Future<void> ward() async {
    List wardList = await db.RawQuery(
        'select distinct vl.[gpCode] as cityCode,ct.[cityName] as cityName from [farmer_master] fm inner join [villagewarehouse] vl on fm.[farmerId] = vl.farmerId inner join [villageList] vl on fm.villageId = vl.[villCode] inner join [cityList] ct on vl.[gpCode] = ct.[cityCode] and vl.stockType=0');

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

  void farmerSearch(String villageCode) async {
    print("villageCode" + villageCode);
    List farmerList = await db.RawQuery(
        'select distinct v.farmerId, v.farmerName,f.idProofVal,f.trader from villageWarehouse as v inner join farmer_master as f on f.farmerId =v.farmerId  where f.villageId= \'' +
            villageCode +
            '\'  and v.stockType=0');

    print("farmerList_farmerList" + farmerList.toString());

    farmerUIModel = [];
    farmerDropdown = [];
    farmerDropdown.clear();
    for (int i = 0; i < farmerList.length; i++) {
      String propertyValue = farmerList[i]["farmerName"].toString();
      String diSpSeq = farmerList[i]["farmerId"].toString();
      String idProofVal = farmerList[i]["idProofVal"].toString();
      String kraPin = farmerList[i]["trader"].toString();

      var uiModel = new UImodel3(
          propertyValue + " - " + diSpSeq, diSpSeq, idProofVal, kraPin);
      farmerUIModel.add(uiModel);
      setState(() {
        farmerDropdown.add(DropdownModelFarmer(
            propertyValue + " - " + diSpSeq, diSpSeq, idProofVal, kraPin));
      });
    }
  }

  void farmSearch(String farmerId) async {
    String farmName =
        'select distinct farmId,farmName,farmerId,farmerName from villageWarehouse where farmerId=\'' +
            farmerId +
            '\' and stockType=0';
    List farmList = await db.RawQuery(farmName);
    farmUIModel = [];
    farmDropdown = [];
    farmDropdown.clear();
    for (int i = 0; i < farmList.length; i++) {
      String farmName = farmList[i]["farmName"].toString();
      String farmIDT = farmList[i]["farmId"].toString();
      String farmerName = farmList[i]["farmerName"].toString();
      var uiModel = new UImodel2(farmName, farmIDT, farmerName);
      farmUIModel.add(uiModel);
      setState(() {
        farmDropdown.add(DropdownModel(
          farmName,
          farmIDT,
        ));
      });
    }

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        if (farmList.isNotEmpty) {
          farmLoaded = true;
          slcFarm = "";
        }
      });
    });
  }

  void getCropVariety(String plantingID) async {
    String getProductQry =
        'select distinct v.hsCode, fc.cropVariety,fc.cropgrade, g.grade as gradeName,v.vName as varietyName from farmCrop as fc inner join varietyList v on v.vCode= fc.cropVariety  inner join procurementGrade g on gradeCode=fc.cropgrade where fc.farmcrpIDT=\'' +
            plantingID +
            '\'';
    print("getProductQry_getProductQry" + getProductQry.toString());


    List cropVarietyList = await db.RawQuery(getProductQry);

    if (cropVarietyList.isNotEmpty) {
      String variety = cropVarietyList[0]["gradeName"].toString();
      String crop = cropVarietyList[0]["varietyName"].toString();
      String cropCode = cropVarietyList[0]["cropVariety"].toString();
      String varietyCode = cropVarietyList[0]["cropgrade"].toString();
      uom = cropVarietyList[0]["hsCode"].toString();

      setState(() {
        cropName = crop;
        varietyName = variety;
      });
    }
  }

  void blockidsearch(String farmCode) async {
    String blockidList =
        'select distinct blockId,blockName from villageWarehouse where farmId=\'' +
            farmCode +
            '\' and stockType=0;';
    print("qrrFarm_qrrFarm" + blockidList);
    List blockList = await db.RawQuery(blockidList);
    blockUIModel = [];
    blockDropdown = [];
    blockDropdown.clear();
    for (int i = 0; i < blockList.length; i++) {
      String blockId = blockList[i]["blockId"].toString();
      String blockName = blockList[i]["blockName"].toString();

      var uiModel = new UImodel(blockName, blockId);
      blockUIModel.add(uiModel);
      setState(() {
        blockDropdown.add(DropdownModel(
          blockName,
          blockId,
        ));
      });
    }

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        if (blockList.isNotEmpty) {
          blockLoaded = true;
          slcblock = "";
        }
      });
    });
  }


  void plantingIdSearch(String blockID) async {
    String plantingQry =
        'select distinct plantingId from villageWarehouse where blockId=\'' +
            blockID +
            '\'and stockType=0;';
    print("plantingList" + plantingQry);
    List plantingIDList = await db.RawQuery(plantingQry);
    plantingUIModel = [];
    plantingItems = [];
    for (int i = 0; i < plantingIDList.length; i++) {
      String plantingID = plantingIDList[i]["plantingId"].toString();

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

  void statecode(String farmId) async {
    print("farmId_farmId" + farmId.toString());
    String statecodeList =
        'select state from farm where farmIDT=\'' + farmId + '\';';
    List codeList = await db.RawQuery(statecodeList);

    print("codeList_codeList" + codeList.toString());

    setState(() {
      if (codeList.isNotEmpty) {
        for (int i = 0; i < codeList.length; i++) {
          CountyCode = codeList[i]["state"].toString();
        }
      }
    });

    print("CountyCodeCountyCode" + CountyCode.toString());

    statename(CountyCode);
  }

  void statename(String CountyCode) async {
    print("statename");
    String statenameList =
        'select stateName from stateList where stateCode=\'' +
            CountyCode +
            '\';';
    List NameList = await db.RawQuery(statenameList);

    setState(() {
      if (NameList.isNotEmpty) {
        for (int i = 0; i < NameList.length; i++) {
          CountyName = NameList[i]["stateName"].toString();
        }
      }
    });

    print("CountyNameCountyName" + CountyName.toString());
  }

  void sortingvalues(String plantingId) async {
    String agentId = 'select * from agentMaster';

    List agentList = await db.RawQuery(agentId);

    for (int i = 0; i < agentList.length; i++) {
      setState(() {
        aggentId = agentList[i]["exporterId"].toString();
      });
    }

    String sortingvaluesList =
        'select pCode,pName,vCode,vName,lastHarDate,actWt,harvestWt,countyCode,countyName  from villageWarehouse where plantingId=\'' +
            plantingId +
            '\' and stockType=0';
    print("qrrFarm_qrrFarm" + sortingvaluesList);
    List sortingList = await db.RawQuery(sortingvaluesList);

    for (int i = 0; i < sortingList.length; i++) {
      setState(() {
        harvestDate = sortingList[i]["lastHarDate"].toString();
        quantityharvested = sortingList[i]["harvestWt"].toString();
        pCode = sortingList[i]["pCode"].toString();
        pName = sortingList[i]["pName"].toString();
        vCode = sortingList[i]["vCode"].toString();
        vName = sortingList[i]["vName"].toString();
        blockStateName = sortingList[i]["countyName"].toString();
        blockStateCode = sortingList[i]["countyCode"].toString();
      });

      //countyCode = sortingList[i]["countyCode"].toString();
      //countyName = sortingList[i]["countyName"].toString();
    }
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
          title: Text('Sorting',
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
          farmerSelect = null;
          farmSelect = null;
          farmDropdown = [];
          blockDropdown = [];
          farmerDropdown = [];
          villageDropdown = [];
          farmLoaded = false;
          blockLoaded = false;
          slcblock = "";
          blockSelect = null;
          plantingid = "";
          valFarm = "";
          quantityharvested = "";
          valblock = "";
          quantityharvested = "";
          harvestDate = "";
          plantingLoaded = false;
          plantingItems = [];
          slcPlanting = "";
          valPlanting = "";
          plantingSelect = null;
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
          farmerSelect = null;
          farmSelect = null;
          farmDropdown = [];
          blockDropdown = [];
          farmerDropdown = [];
          farmLoaded = false;
          blockLoaded = false;
          slcblock = "";
          valFarm = "";
          cropName = "";
          varietyName = "";
          blockSelect = null;
          plantingid = "";
          quantityharvested = "";
          valblock = "";
          quantityharvested = "";
          harvestDate = "";
          plantingLoaded = false;
          plantingItems = [];
          slcPlanting = "";
          valPlanting = "";
          plantingSelect = null;
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
    listings.add(farmerDropDownWithModel(
      itemlist: farmerDropdown,
      selecteditem: farmerSelect,
      hint: "Select Farmer",
      onChanged: (value) {
        setState(() {
          farmerSelect = value!;
          farmLoaded = false;
          slcFarm = "";
          farmSelect = null;
          blockLoaded = false;
          slcblock = "";
          blockSelect = null;
          plantingid = "";
          valFarm = "";
          valblock = "";
          cropName = "";
          varietyName = "";
          quantityharvested = "";
          harvestDate = "";
          plantingLoaded = false;
          plantingItems = [];
          slcPlanting = "";
          valPlanting = "";
          quantityharvested = "";
          plantingSelect = null;
          slcFarmer = farmerSelect!.name;
          valFarmer = farmerSelect!.value;
          farmSearch(valFarmer);
        });
      },
    ));

    listings.add(farmLoaded
        ? txt_label_mandatory("Select the Farm", Colors.black, 15.0, false)
        : Container());
/*    listings.add(farmLoaded
        ? singlesearchDropdown(
            itemlist: farmDropdown,
            selecteditem: slcFarm,
            hint: "Select Farm",
            onChanged: (value) {
              setState(() {
                slcFarm = value!;
                slcblock = "";
                valblock = "";
                plantingid = "";
                blockLoaded = false;
                quantityharvested = "";
                harvestDate = "";

                for (int i = 0; i < farmUIModel.length; i++) {
                  if (value == farmUIModel[i].name) {
                    valFarm = farmUIModel[i].value;
                    blockidsearch(valFarm);
                    statecode(valFarm);
                  }
                }
              });
            },
          )
        : Container());*/

    listings.add(farmLoaded
        ? DropDownWithModel(
            itemlist: farmDropdown,
            selecteditem: farmSelect,
            hint: "Select Farm",
            onChanged: (value) {
              setState(() {
                farmSelect = value!;
                slcblock = "";
                blockSelect = null;
                valblock = "";
                plantingid = "";
                cropName = "";
                varietyName = "";
                blockLoaded = false;
                quantityharvested = "";
                valFarm = "";
                harvestDate = "";
                quantityharvested = "";
                plantingLoaded = false;
                plantingItems = [];
                slcPlanting = "";
                valPlanting = "";
                plantingSelect = null;
                slcFarm = farmSelect!.name;
                valFarm = farmSelect!.value;

                for (int i = 0; i < farmUIModel.length; i++) {
                  if (valFarm == farmUIModel[i].value) {
                    farmerName = farmUIModel[i].value2;
                  }
                }

                blockidsearch(valFarm);
                statecode(valFarm);

                /* for (int i = 0; i < farmUIModel.length; i++) {
            if (value == farmUIModel[i].name) {
              valFarm = farmUIModel[i].value;
              blockidsearch(valFarm);
              statecode(valFarm);
            }
          }*/
              });
            },
          )
        : Container());

    listings.add(valFarm.isNotEmpty
        ? txt_label_mandatory("Farm ID", Colors.black, 14.0, false)
        : Container());
    listings.add(valFarm.isNotEmpty
        ? cardlable_dynamic(valFarm.toString())
        : Container());

    listings.add(blockLoaded
        ? txt_label_mandatory("Block Name", Colors.black, 15.0, false)
        : Container());

    listings.add(blockLoaded
        ? DropDownWithModel(
            itemlist: blockDropdown,
            selecteditem: blockSelect,
            hint: "Select Block Name",
            onChanged: (value) {
              setState(() {
                blockSelect = value!;
                slcblock = blockSelect!.name;
                valblock = blockSelect!.value;
                cropName = "";
                varietyName = "";
                quantityharvested = "";
                plantingLoaded = false;
                plantingItems = [];
                slcPlanting = "";
                valPlanting = "";
                plantingSelect = null;
                plantingIdSearch(valblock);

                /* for (int i = 0; i < blockUIModel.length; i++) {
                  if (valblock == blockUIModel[i].value) {
                    plantingid = blockUIModel[i].value2;
                    getCropVariety(valblock);
                  }
                }*/
              });
            },
          )
        : Container());
    listings.add(blockLoaded
        ? txt_label("Block ID", Colors.black, 14.0, false)
        : Container());
    listings.add(
        blockLoaded ? cardlable_dynamic(valblock.toString()) : Container());

    /* listings.add(blockLoaded
        ? txt_label("Crop-Planting ID", Colors.black, 14.0, false)
        : Container());
    listings.add(
        blockLoaded ? cardlable_dynamic(plantingid.toString()) : Container());*/

    listings.add(plantingLoaded
        ? txt_label_mandatory("Planting ID", Colors.black, 14.0, false)
        : Container());
    listings.add(plantingLoaded
        ? DropDownWithModel(
            itemlist: plantingItems,
            selecteditem: plantingSelect,
            hint: "Select Planting ID",
            onChanged: (value) {
              setState(() {
                plantingSelect = value!;
                valPlanting = "";
                cropName = "";
                varietyName = "";
                plantingDate = "";
                quantityharvested = "";
                valPlanting = plantingSelect!.value;
                slcPlanting = plantingSelect!.name;
                plantingid = valPlanting;
                getCropVariety(valPlanting);
                sortingvalues(valPlanting);
              });
            },
          )
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

    listings.add(txt_label("Date Harvested", Colors.black, 14.0, false));
    listings.add(cardlable_dynamic(harvestDate.toString()));

    listings
        .add(txt_label("Harvested Quantity(Kg)", Colors.black, 14.0, false));
    listings.add(cardlable_dynamic(quantityharvested.toString()));

    listings.add(txt_label_mandatory(
        "Rejected Quantity(Kg)", Colors.black, 14.0, false));
    listings.add(txtfield_digits(
        "Rejected Quantity(Kg)", rejectedqtyController, true, 50));

    listings.add(
        txt_label_mandatory("Sorted Quantity(Kg)", Colors.black, 14.0, false));
    listings.add(
        txtfield_digits("Sorted Quantity(Kg)", sortedqtyController, true, 50));

    listings.add(txt_label_mandatory("Truck Type", Colors.black, 16.0, false));
    listings.add(singlesearchDropdown(
      itemlist: truckDropdownItem,
      selecteditem: slctTruckTyp,
      hint: "Select Truck type",
      onChanged: (value) {
        setState(() {
          slctTruckTyp = value!;
          for (int i = 0; i < truckListUIModel.length; i++) {
            if (value == truckListUIModel[i].name) {
              valTruckTyp = truckListUIModel[i].value;
              truckTypeName = truckListUIModel[i].name;


            }
          }
          driverNote();
        });
      },
    ));
    listings
        .add(txt_label_mandatory("Number Plate", Colors.black, 16.0, false));
    listings
        .add(txtfield_dynamic("Number Plate", truckNumberController, true, 20));

    listings.add(txt_label_mandatory("Driver Name", Colors.black, 16.0, false));
    listings
        .add(txtfield_dynamic("Driver Name", driverNameController, true, 20));

    listings
        .add(txt_label_mandatory("Driver Contact", Colors.black, 16.0, false));
    listings.add(txtfield_digits_integer(
        "Driver Contact", driverContactController, true, 20));

    listings
        .add(txt_label_mandatory("Delivery Note", Colors.black, 16.0, false));
    listings.add(cardlable_dynamicLarge(deliveryNote.toString()));

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
    if (quantityharvested.isNotEmpty &&
        rejectedqtyController.text.isNotEmpty &&
        sortedqtyController.text.isNotEmpty) {
      print("Working");
      double rejqty;
      double srtqty;
      //double hrvqty;
      rejqty = double.parse(rejectedqtyController.text);
      srtqty = double.parse(sortedqtyController.text);
      totalquantity = rejqty + srtqty;
      hrvqty = double.parse(quantityharvested);
    }

    //print("total quantity" + totalquantity.toString());
    if (slcWard.isEmpty) {
      alertPopup(context, "Ward should not be empty");
    } else if (slcVillage.isEmpty) {
      alertPopup(context, "Village should not be empty");
    } else if (slcFarmer.isEmpty) {
      alertPopup(context, "Farmer Name should not be empty");
    } else if (slcFarm.isEmpty) {
      alertPopup(context, "Farm Name should not be empty");
    } else if (slcblock.isEmpty) {
      alertPopup(context, "Block Name should not be empty");
    } else if (slcPlanting.isEmpty) {
      alertPopup(context, "Planting ID should not be empty");
    } else if (rejectedqtyController.text.isEmpty) {
      alertPopup(context, "Rejected Quantity(Kg) should not be empty");
    } else if (sortedqtyController.text.isEmpty) {
      alertPopup(context, "Sorted Quantity(Kg) should not be empty");
    } else if (sortedqtyController.text == "0") {
      alertPopup(context, "Sorted Quantity(Kg) should not be 0");
    } else if (totalquantity > hrvqty) {
      alertPopup(context,
          "Total Quantity(Kg) should not exceed Harvested quantity(Kg)");
    } else if (truckTypeName.isEmpty) {
      alertPopup(context, "Truck Type should not be empty");
    } else if (truckNumberController.text.isEmpty) {
      alertPopup(context, "Number Plate should not be empty");
    } else if (driverNameController.text.isEmpty) {
      alertPopup(context, "Driver Name should not be empty");
    } else if (driverContactController.text.isEmpty) {
      alertPopup(context, "Driver Contact should not be empty");
    } else {
      confirmation();
    }
  }

  void confirmation() {
    double convert = double.parse(rejectedqtyController.text);
    rejQtydec = convert.toStringAsFixed(2);

    double convertt = double.parse(sortedqtyController.text);
    sorQtydec = convertt.toStringAsFixed(2);

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
            Sorting();
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

  Future<void> Sorting() async {
    print("CountyCode_CountyCode" + CountyCode.toString());
    print("CountyName_CountyName" + CountyName.toString());

    var db = DatabaseHelper();
    final now = new DateTime.now();
    String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String sortedDate = DateFormat('yyyy-MM-dd').format(now);
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);
    String? agentid =await SecureStorage().readSecureData("agentId");
    String? agentToken =await SecureStorage().readSecureData("agentToken");
    //print('txnHeader ' + agentid + "" + agentToken);
    //  Random rnd = new Random();

    String revNo = DateFormat('yyyyMMddHHmmssms').format(now);

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
        txntime, appDatas.txn_sorting, revNo.toString(), '', '', '');

    int savesorting = await db.saveSorting(
      sortedDate,
      valFarmer,
      valFarm,
      rejQtydec,
      sorQtydec,
      revNo.toString(),
      "1",
      seasonCode,
      valblock,
      plantingid,
      harvestDate,
      hrvqty.toString(),
      valTruckTyp,
      truckNumberController.text.toString(),
      driverNameController.text.toString(),
      driverContactController.text.toString(),
      CountyCode,
      CountyName,
    );

    print("db inserted");

    db.UpdateTableValue('sorter', 'isSynched', '0', 'recNo', revNo.toString());

    TxnExecutor txnExecutor = new TxnExecutor();
    txnExecutor.CheckCustTrasactionTable();
    String Qrvalue = CountyCode +
        "~" +
        CountyName +
        "~" +
        valblock +
        "~" +
        slcblock +
        "~" +
        pCode +
        "~" +
        pName +
        "~" +
        vCode +
        "~" +
        vName +
        "~" +
        sorQtydec +
        "~" +
        valFarmer +
        "~" +
        farmerName +
        "~" +
        valFarm +
        "~" +
        slcFarm +
        "~" +
        "1" +
        "~" +
        aggentId +
        "~" +
        sortedDate +
        "~" +
        plantingid +
        "~" +
        revNo.toString();

    Alert(
      context: context,
      type: AlertType.info,
      title: "Transaction Successful",
      desc: "Sorting done Successfully",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            /* Navigator.pop(context);
            Navigator.pop(context);*/

            List<PrintModel> printLists = [];
            List<String> arrOfStr = Qrvalue.split("~");
            String productName = arrOfStr[5];
            String blockid = arrOfStr[2];
            String variety = arrOfStr[7];
            String quantity = arrOfStr[8];
            String FarmerName = arrOfStr[10];
            String plantingID = arrOfStr[16];
            printLists.add(PrintModel("Farmer Name", FarmerName));
            printLists.add(PrintModel("Block ID", blockid));
            printLists.add(PrintModel("Planting ID", plantingID));
            printLists.add(PrintModel("Crop Name", productName));
            printLists.add(PrintModel("Variety", variety));
            printLists.add(PrintModel("Sorted Qty(Kg)", quantity));
            printLists.add(PrintModel("Exporter Name", exporterName));
            printLists.add(PrintModel("Date and Time", txntime));
            printLists.add(PrintModel("QR Unique Id", revNo.toString()));

            List<MultiplePrintModel> multipleprintLists = [];
            multipleprintLists.add(MultiplePrintModel(printLists, Qrvalue));


            var printList=[];

            String FarmerNameQ ='';

            for(int i = 0 ;i <printLists.length ; i++){
              FarmerNameQ = printLists[i].value ;
              printList.add(FarmerNameQ);
            }

            String removeBraces= printList.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(',', '/');


            print('printList $removeBraces');


            for (int i= 0 ; i< multipleprintLists.length ;i ++){
              int saveQr = await db.saveQRDetails(
                  '$revNo',
                  '1',
                  txntime.split(' ')[0],
                   multipleprintLists[i].qrString.toString(),
                  removeBraces,
                  productName,
                  plantingID
                  );
            }

            String qrDet =



            qrGenerator = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        QrReader(multipleprintLists, 'Sorting' ,'')));


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
}
