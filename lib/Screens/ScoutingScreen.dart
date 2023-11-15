import 'dart:convert';
import 'dart:io' show File;
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:gallery_saver/gallery_saver.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nhts/Database/Databasehelper.dart';
//import 'package:nhts/Model/FormatConvertClass.dart';
import 'package:nhts/Model/UIModel.dart';
//import 'package:nhts/Model/weatherInformationModel.dart';
import 'package:nhts/Plugins/TxnExecutor.dart';
import 'package:nhts/Utils/MandatoryDatas.dart';
import 'package:nhts/Utils/dynamicfields.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:signature/signature.dart';

import '../Utils/secure_storage.dart';
import '../login.dart';

class ScoutingScreen extends StatefulWidget {
  @override
  _ScoutingScreenState createState() => _ScoutingScreenState();
}

class _ScoutingScreenState extends State<ScoutingScreen> {
  /* final _sign = GlobalKey<SignatureState>();
  var signData;
  final _sign1 = GlobalKey<SignatureState>();
  var sign1Data;
  SignatureController _sign;
  SignatureController _sign1;*/

  ByteData _img = ByteData(0);
  ByteData _img1 = ByteData(0);
  final SignatureController _sign = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
  );
  final SignatureController _sign1 = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
  );
  Uint8List? signImg;
  Uint8List? sign1Img;
  String encoded = "";
  String encoded1 = "";
  String valuenamee = "";
  String valuee = "";

  String selectedDate = "";
  String formatSelectedDate = "";
  String slcDate = "";
  String formatDate = "";
  String slcFarmer = "";
  String slcFarm = "";
  String slcCrop = "";
  String slcVariety = "";
  String slcIrrType = "";
  String slcIrrMet = "";
  String valFarmer = "";
  String valFarm = "";
  String valCrop = "";
  String valVariety = "";
  String valPest = "";
  String valInst = "";
  String valDisc = "";
  String valWeed = "";
  String pestName = "";
  String instName = "";
  String disName = "";
  String weedName = "";
  String valIrrTyp = "";
  String valIrrMet = "";
  String autoPopulateBlockId = "";
  String plantingDate = "";
  String autoPopulatePlantingId = "";
  String cropPlanted = "", cropVariety = "";
  String imageByte = "";
  String scoutDate = "";
  String Lat = "", Lng = "";
  String audioBase64 = "",
      voice = "",
      audioPath = "",
      image64 = "",
      signatureOwnerBase64 = "",
      signatureInspectorBase64 = "";
  String temp = "", windSpeed = "", humidity = "", rain = "";
  String servicePointId = "", seasonCode = "";
  String slcWard = "", slcVillage = "", valWard = "", valVillage = "";
  bool isRecord = false, listAdded = false, pestLoaded = false;
  bool disLoaded = false, weedLoaded = false;
  bool irrTypLoaded = false, ittMetLoaded = false;
  var duration;
  final player = AudioPlayer();
  TextEditingController numberPlantsAreaController = TextEditingController();
  TextEditingController numberPlantsPestController = TextEditingController();
  TextEditingController solutionController = TextEditingController();
  TextEditingController areaIrrigationController = TextEditingController();
  TextEditingController observationController = TextEditingController();
  TextEditingController recommendationController = TextEditingController();
  TextEditingController cmnRecommendationController = TextEditingController();
  TextEditingController waterUsedController = TextEditingController();
  List<int> multiSearchPestList = [];
  List<DropdownMenuItem> farmerDropdownItem = [];
  List<DropdownMenuItem> farmDropdownItem = [];
  List<DropdownMenuItem> cropDropdownItem = [];
  final List<DropdownMenuItem> instDropdownItem = [];
  final List<DropdownMenuItem> disDropdownItem = [];
  final List<DropdownMenuItem> weedDropdownItem = [];
  final List<DropdownMenuItem> irrTypeDropdownItem = [];
  final List<DropdownMenuItem> sprayingDropdownItem = [];
  final List<DropdownMenuItem> irrMetDropdownItem = [];
  final List<DropdownMenuItem> sourceOfWaterDropdownItem = [];
  List<DropdownMenuItem> plantingDropdown = [];
  List<DropdownMenuItem> wardDropdown = [];
  List<DropdownMenuItem> villageDropdown = [];
  List<UImodel3> farmerListUIModel = [];
  List<UImodel> farmListUIModel = [];
  List<UImodel> cropListUIModel = [];
  List<UImodel> varietyListUIModel = [];
  List<UImodel> pestListUIModel = [];
  List<UImodel> productListUIModel = [];
  List<UImodel> unitListUIModel = [];
  List<UImodel> instListUIModel = [];
  List<UImodel> disListUIModel = [];
  List<UImodel> weedListUIModel = [];
  List<UImodel> irrTypeListUIModel = [];
  List<UImodel> sprayingListUIModel = [];
  List<UImodel> irrMetListUIModel = [];
  List<UImodel> sourceOfWaterListUIModel = [];
  List<UImodel> wardUIModel = [];
  List<UImodel> villageUIModel = [];
  List<UImodel> plantingUIModel = [];
  List<String>? selectedPest = [];
  List<String>? selectedInst = [];
  List<String>? selectedDisc = [];
  List<String>? selectedWeedV = [];
  List<String>? selectedIrrTyp = [];
  List<String>? selectedIrrMet = [];
  List<Map> agents = [];
  File? imageFile;
  var signatureOwner, signatureInspector;
  Image? inspectorFile, ownerFile;

  bool signClicked = false;
  bool sign1Clicked = false;
  bool varietyLoaded = false;
  bool farmLoaded = false;
  bool farmerLoaded = false;
  bool cropLoaded = false;
  bool farmerChange = false;
  bool imageLoaded = false;
  bool dropdownCloseButton = false;
  bool afterPlantingDate = false;
  bool plantingLoaded = false;

  List<DropdownMenuItem> villageitems = [];

  List<DropdownModelFarmer> farmeritems = [];
  DropdownModelFarmer? slctFarmers;

  List<DropdownModel> farmitems = [];
  DropdownModel? slctFarms;

  List<DropdownModel> blockitems = [];
  DropdownModel? slctBlocks;

  List<DropdownModel> plantingItems = [];
  DropdownModel? selectPlanting;

  List<UImodel> villageListUIModel = [];
  String slctVillage = "",
      slct_farmer = "",
      slctFarm = "",
      slctCrop = "",
      slctVariety = "",
      FarmermsgNo = "",
      FarmmsgNo = "",
      slcSourceOfWater = "",
      slcSprayingNeeded = "",
      valSpraying = "",
      valSourceOfWater = "";
  String slcPlanting = "", valPlanting = "";
  final Map<String, String> insetsSel = {
    'option1': "Yes",
    'option2': "No",
  };
  String selectedInset = "option2";
  String selectedInsetValue = "0";
  TextEditingController numberInsectController = TextEditingController();
  final Map<String, String> diseaseSel = {
    'option1': "Yes",
    'option2': "No",
  };
  String selectedDis = "option2";
  String selectedDisValue = "0";
  TextEditingController perInfectionController = TextEditingController();

  final Map<String, String> weedsSel = {
    'option1': "Yes",
    'option2': "No",
  };
  String selectedWeed = "option2";
  String selectedWeedValue = "0";
  TextEditingController weedsPreController = TextEditingController();

  String uom="";

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
                }),
            title: Text(
              'Scouting',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700),
            ),
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.green,
            brightness: Brightness.light,
          ),
          body: Container(
              child: Column(children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(10.0),
                children: _getListings(
                    context), // <<<<< Note this change for the return type
              ),
              flex: 8,
            ),
          ])),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    return (await Alert(
          context: context,
          type: AlertType.warning,
          title: "Cancel",
          desc: "Are you sure want to cancel?",
          buttons: [
            DialogButton(
              child: Text(
                "Yes",
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
                "No",
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
    //villageLoad();
    ward();
    loadDisease();
    loadInsects();
    loadWeed();
    sourceOfWater();
    //
    loadIrrMet();
    loadIrrType();
    loadSprayingType();
    getLocation();
  }

  getClientData() async {
    agents = await db.RawQuery('SELECT * FROM agentMaster');
    seasonCode = agents[0]['currentSeasonCode'];
    servicePointId = agents[0]['servicePointId'];
  }

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    print("latitude :" +
        position.latitude.toString() +
        " longitude: " +
        position.longitude.toString());

    Lat = position.latitude.toString();
    Lng = position.longitude.toString();
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

      var uiModel = UImodel(propertyValue, diSpSeq);
      villageUIModel.add(uiModel);
      setState(() {
        villageDropdown.add(DropdownMenuItem(
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

      var uiModel = UImodel(propertyValue, diSpSeq);
      wardUIModel.add(uiModel);
      setState(() {
        wardDropdown.add(DropdownMenuItem(
          child: Text(propertyValue),
          value: propertyValue,
        ));
      });
    }
  }

  farmerSearch(String villageCode) async {
    String qry_farmerlist =
        'select distinct fm.farmerId,fm.fName,fm.farmerCode,fm.idProofVal,fm.trader from farmer_master as fm inner join farm as f on fm.farmerId = f.farmerId inner join farmCrop as fc on fc.farmcodeRef = f.farmIDT where fm.villageId= \'' +
            villageCode +
            '\'';
    print("qry_farmerlist_qry_farmerlist" + qry_farmerlist.toString());
    List farmerslist = await db.RawQuery(qry_farmerlist);

    farmeritems.clear();
    farmerListUIModel = [];

    for (int i = 0; i < farmerslist.length; i++) {
      String property_value = farmerslist[i]["fName"].toString();
      String DISP_SEQ = farmerslist[i]["farmerId"].toString();
      String idProofVal = farmerslist[i]["idProofVal"].toString();
      String kraPin = farmerslist[i]["trader"].toString();
      print("kraPin_kraPin" + kraPin.toString());
      var uimodel = UImodel3(
          property_value + " - " + DISP_SEQ, DISP_SEQ, idProofVal, kraPin);
      farmerListUIModel.add(uimodel);
      setState(() {
        farmeritems.add(DropdownModelFarmer(
            property_value + " - " + DISP_SEQ, DISP_SEQ, idProofVal, kraPin));
        //prooflist.add(property_value);
      });
    }
  }

  loadfarm(String farmer) async {
    String qry_farm =
        'select distinct f.farmIDT,f.farmName, f.totLand  from farm as f inner join farmCrop as fc on fc.farmcodeRef = f.farmIDT where f.farmerId = \'' +
            farmer +
            '\'';
    List farmlist = await db.RawQuery(qry_farm);
    print(farmlist.toString());
    farmDropdownItem = [];
    farmitems.clear();
    farmListUIModel = [];

    if (farmlist.length > 0) {
      for (int i = 0; i < farmlist.length; i++) {
        String property_value = farmlist[i]["farmName"].toString();
        String DISP_SEQ = farmlist[i]["farmIDT"].toString();
        var uimodel = UImodel(property_value, DISP_SEQ);
        farmListUIModel.add(uimodel);
        setState(() {
          farmitems.add(DropdownModel(
            property_value,
            DISP_SEQ,
          ));
          //prooflist.add(property_value);
        });
      }
    }
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        if (farmlist.length > 0) {
          if (slcFarmer == "") {
            slcFarm = '';
            farmLoaded = false;
          } else {
            farmLoaded = true;
          }
        }
      });
    });
  }

  loadCrop(String farmCode) async {
    String cropquery =
        'select distinct blockId,blockName from  farmCrop  where farmCodeRef=\'' +
            farmCode +
            '\';';
    print("cropquery" + cropquery.toString());

    List croplist = await db.RawQuery(cropquery);
    print("croplist_croplist" + croplist.toString());

    blockitems.clear();
    cropListUIModel = [];
    blockitems = [];

    if (croplist.length > 0) {
      for (int i = 0; i < croplist.length; i++) {
        String property_value = croplist[i]["blockName"].toString();
        String DISP_SEQ = croplist[i]["blockId"].toString();
        var uimodel3 = UImodel(property_value, DISP_SEQ);
        cropListUIModel.add(uimodel3);
        setState(() {
          blockitems.add(DropdownModel(
            property_value,
            DISP_SEQ,
          ));
          //prooflist.add(property_value);
        });
      }
    }
    Future.delayed(Duration(milliseconds: 100), () {
      if (croplist.isNotEmpty) {
        setState(() {
          slcCrop = "";
          cropLoaded = true;
        });
      }
    });
  }

  loadInsects() async {
    String qryInslist =
        'select * from animalCatalog where catalog_code =\'' + "10" + '\'';
    List insList = await db.RawQuery(qryInslist);

    instListUIModel = [];
    instDropdownItem.clear();
    for (int i = 0; i < insList.length; i++) {
      String property_value = insList[i]["property_value"].toString();
      String DISP_SEQ = insList[i]["DISP_SEQ"].toString();
      var uimodel = UImodel(property_value, DISP_SEQ);
      instListUIModel.add(uimodel);
      setState(() {
        instDropdownItem.add(DropdownMenuItem(
          child: Text(property_value),
          value: property_value,
        ));
      });
    }
  }

  loadDisease() async {
    disLoaded = false;
    String qryInslist =
        'select * from animalCatalog where catalog_code =\'' + "11" + '\'';
    List insList = await db.RawQuery(qryInslist);

    disListUIModel = [];
    disDropdownItem.clear();
    for (int i = 0; i < insList.length; i++) {
      String property_value = insList[i]["property_value"].toString();
      String DISP_SEQ = insList[i]["DISP_SEQ"].toString();
      var uimodel = UImodel(property_value, DISP_SEQ);
      disListUIModel.add(uimodel);
      setState(() {
        disDropdownItem.add(DropdownMenuItem(
          child: Text(property_value),
          value: property_value,
        ));
      });
    }
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        disLoaded = true;
      });
    });
  }

  sourceOfWater() async {
    String qrySource =
        'select * from animalCatalog where catalog_code =\'' + "83" + '\'';
    List sourceList = await db.RawQuery(qrySource);
    print("sourceList_sourceList" + sourceList.toString());

    sourceOfWaterListUIModel = [];
    sourceOfWaterDropdownItem.clear();
    for (int i = 0; i < sourceList.length; i++) {
      String property_value = sourceList[i]["property_value"].toString();
      String DISP_SEQ = sourceList[i]["DISP_SEQ"].toString();
      var uimodel = UImodel(property_value, DISP_SEQ);
      sourceOfWaterListUIModel.add(uimodel);
      setState(() {
        sourceOfWaterDropdownItem.add(DropdownMenuItem(
          child: Text(property_value),
          value: property_value,
        ));
      });
    }
  }

  loadWeed() async {
    weedLoaded = false;
    String qryInslist =
        'select * from animalCatalog where catalog_code =\'' + "12" + '\'';
    List insList = await db.RawQuery(qryInslist);

    weedListUIModel = [];
    weedDropdownItem.clear();
    for (int i = 0; i < insList.length; i++) {
      String property_value = insList[i]["property_value"].toString();
      String DISP_SEQ = insList[i]["DISP_SEQ"].toString();
      var uimodel = UImodel(property_value, DISP_SEQ);
      weedListUIModel.add(uimodel);
      setState(() {
        weedDropdownItem.add(DropdownMenuItem(
          child: Text(property_value),
          value: property_value,
        ));
      });
    }
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        weedLoaded = true;
      });
    });
  }

  loadSprayingType() async {

    String qryInslist =
        'select * from animalCatalog where catalog_code =\'' + "88" + '\'';
    List insList = await db.RawQuery(qryInslist);

    sprayingListUIModel = [];
    sprayingDropdownItem.clear();
    for (int i = 0; i < insList.length; i++) {
      String property_value = insList[i]["property_value"].toString();
      String DISP_SEQ = insList[i]["DISP_SEQ"].toString();
      var uimodel = UImodel(property_value, DISP_SEQ);
      sprayingListUIModel.add(uimodel);
      setState(() {
        sprayingDropdownItem.add(DropdownMenuItem(
          child: Text(property_value),
          value: property_value,
        ));
      });
    }
  }

  loadIrrType() async {
    String qryInslist =
        'select * from animalCatalog where catalog_code =\'' + "54" + '\'';
    List insList = await db.RawQuery(qryInslist);

    irrTypeListUIModel = [];
    irrTypeDropdownItem.clear();
    for (int i = 0; i < insList.length; i++) {
      String property_value = insList[i]["property_value"].toString();
      String DISP_SEQ = insList[i]["DISP_SEQ"].toString();
      var uimodel = UImodel(property_value, DISP_SEQ);
      irrTypeListUIModel.add(uimodel);
      setState(() {
        irrTypeDropdownItem.add(DropdownMenuItem(
          child: Text(property_value),
          value: property_value,
        ));
      });
    }
  }

  loadIrrMet() async {
    String qryInslist =
        'select * from animalCatalog where catalog_code =\'' + "9" + '\'';
    List insList = await db.RawQuery(qryInslist);

    irrMetListUIModel = [];
    irrMetDropdownItem.clear();
    for (int i = 0; i < insList.length; i++) {
      String property_value = insList[i]["property_value"].toString();
      String DISP_SEQ = insList[i]["DISP_SEQ"].toString();
      var uimodel = UImodel(property_value, DISP_SEQ);
      irrMetListUIModel.add(uimodel);
      setState(() {
        irrMetDropdownItem.add(DropdownMenuItem(
          child: Text(property_value),
          value: property_value,
        ));
      });
    }
  }

  void getCropVariety(String plantingID) async {
    String getProductQry =
        'select distinct v.hsCode, g.grade as gradeName,v.vName as varietyName,c.fname as cropName,fc.cropCode,fc.cropVariety,fc.dateOfSown,fc.scoutDate from farmCrop as fc inner join cropList  c on c.fcode=fc.cropCode inner join varietyList v on v.vCode= cropVariety  inner join procurementGrade g on gradeCode=cropgrade where fc.farmcrpIDT=\'' +
            plantingID +
            '\'';
    print("getProductQry_getProductQry" + getProductQry.toString());

    List cropVarietyList = await db.RawQuery(getProductQry);

    for (int i = 0; i < cropVarietyList.length; i++) {
      String variety = cropVarietyList[i]["gradeName"].toString();
      String crop = cropVarietyList[i]["varietyName"].toString();
      String getDate = cropVarietyList[i]["dateOfSown"].toString();
       scoutDate = cropVarietyList[i]["scoutDate"].toString();
       uom = cropVarietyList[i]["hsCode"].toString();

      setState(() {
        cropVariety = variety;
        cropPlanted = crop;
        plantingDate = getDate;
      });
    }
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

  List<Widget> _getListings(BuildContext context) {
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
          slctFarmers = null;
          slcFarm = "";
          slctFarms = null;
          valFarm = "";
          slcCrop = "";
          slctBlocks = null;
          farmerDropdownItem = [];
          cropDropdownItem = [];
          farmDropdownItem = [];
          villageDropdown = [];
          blockitems = [];
          farmLoaded = false;
          cropLoaded = false;
          plantingLoaded = false;
          plantingItems = [];
          slcPlanting = "";
          valPlanting = "";
          selectPlanting = null;
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
          slcCrop = "";
          slctBlocks = null;
          slctFarmers = null;
          slctFarms = null;
          valFarm = "";
          farmerDropdownItem = [];
          cropDropdownItem = [];
          farmDropdownItem = [];
          blockitems = [];
          farmLoaded = false;
          cropLoaded = false;
          plantingLoaded = false;
          plantingItems = [];
          slcPlanting = "";
          valPlanting = "";
          selectPlanting = null;
          for (int i = 0; i < villageUIModel.length; i++) {
            if (value == villageUIModel[i].name) {
              valVillage = villageUIModel[i].value;
              farmerSearch(valVillage);
            }
          }
        });
      },
    ));

    listings.add(txt_label_mandatory("Farmer Name", Colors.black, 14.0, false));
    /* listings.add(singlesearchDropdown(
      itemlist: farmerDropdownItem,
      selecteditem: slcFarmer,
      hint: "Select Farmer",
      onChanged: (value) {
        setState(() {
          slcFarmer = value!;
          farmLoaded = false;
          slcFarm = "";
          cropLoaded = false;
          slcCrop = "";
          autoPopulatePlantingId = "";
          autoPopulateBlockId = "";
          cropPlanted = "";
          cropVariety = "";
          for (int i = 0; i < farmerListUIModel.length; i++) {
            if (value == farmerListUIModel[i].name) {
              valFarmer = farmerListUIModel[i].value;
            }
          }
          final now = new DateTime.now();
          FarmermsgNo = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
          loadfarm();
        });
      },
    ));  */

    listings.add(farmerDropDownWithModel(
      itemlist: farmeritems,
      selecteditem: slctFarmers,
      hint: "Select Farmer",
      onChanged: (value) {
        setState(() {
          slctFarmers = value!;
          farmLoaded = false;
          slcFarm = "";
          slctFarms = null;
          cropLoaded = false;
          slcCrop = "";
          autoPopulatePlantingId = "";
          autoPopulateBlockId = "";
          cropPlanted = "";
          cropVariety = "";
          valFarm = "";
          slctFarms = null;
          slctBlocks = null;
          blockitems = [];
          plantingLoaded = false;
          plantingItems = [];
          slcPlanting = "";
          valPlanting = "";
          selectPlanting = null;
          //toast(slctFarmers!.value);
          valFarmer = slctFarmers!.value;
          slcFarmer = slctFarmers!.name;
          final now = DateTime.now();
          FarmermsgNo = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
          loadfarm(valFarmer);
        });
        print('selectedvalue ' + slctFarmers!.value);
      },
    ));

    listings.add(farmLoaded
        ? txt_label_mandatory("Farm", Colors.black, 14.0, false)
        : Container());

    /*  listings.add(farmLoaded
        ? singlesearchDropdown(
            itemlist: farmDropdownItem,
            selecteditem: slcFarm,
            hint: "Select Farm",
            onChanged: (value) {
              setState(() {
                slcFarm = value!;
                slcCrop = '';
                cropLoaded = false;
                varietyLoaded = false;
                slctVariety = '';
                autoPopulateBlockId = "";
                autoPopulatePlantingId = "";
                cropPlanted = "";
                cropVariety = "";

                for (int i = 0; i < farmListUIModel.length; i++) {
                  if (value == farmListUIModel[i].name) {
                    valFarm = farmListUIModel[i].value;
                    loadCrop(valFarm);
                  }
                }

                final now = new DateTime.now();
                FarmmsgNo = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

                //dropdownCloseButton = false;
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
                slcCrop = '';
                cropLoaded = false;
                varietyLoaded = false;
                slctVariety = '';
                autoPopulateBlockId = "";
                autoPopulatePlantingId = "";
                cropPlanted = "";
                cropVariety = "";
                slctBlocks = null;
                blockitems = [];
                valFarm = "";
                valFarm = slctFarms!.value;
                slcFarm = slctFarms!.name;
                plantingLoaded = false;
                plantingItems = [];
                slcPlanting = "";
                valPlanting = "";
                selectPlanting = null;
                loadCrop(valFarm);

                final now = DateTime.now();
                FarmmsgNo = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
              });
            },
          )
        : Container());

    listings.add(valFarm.length > 0
        ? txt_label_mandatory("Farm ID", Colors.black, 14.0, false)
        : Container());
    listings.add(valFarm.length > 0
        ? cardlable_dynamic(valFarm.toString())
        : Container());

    listings.add(cropLoaded
        ? txt_label_mandatory("Block Name", Colors.black, 14.0, false)
        : Container());
    /* listings.add(cropLoaded
        ? singlesearchDropdown(
            itemlist: cropDropdownItem,
            selecteditem: slcCrop,
            hint: "Select Block Name",
            onChanged: (value) {
              setState(() {
                slcCrop = value!;
                varietyLoaded = false;
                slctVariety = '';
                autoPopulateBlockId = "";
                autoPopulatePlantingId = "";
                cropPlanted = "";
                cropVariety = "";

                for (int i = 0; i < cropListUIModel.length; i++) {
                  if (cropListUIModel[i].name == slcCrop) {
                    valCrop = cropListUIModel[i].value;
                    setState(() {
                      autoPopulateBlockId = cropListUIModel[i].value;
                      plantingDate = cropListUIModel[i].value2;
                      autoPopulatePlantingId = cropListUIModel[i].value3;
                      getCropVariety(autoPopulateBlockId);
                    });
                    //loadvarietylist();
                  }
                }
                print("value1    - "+autoPopulateBlockId);
                print("value2    - "+plantingDate);
                print("value3    - "+autoPopulatePlantingId);
                // dropdownCloseButton = false;
              });
            },
            onClear: () {
              setState(() {
                slcCrop = '';
                varietyLoaded = false;
                slcVariety = '';
                autoPopulateBlockId = "";
                autoPopulatePlantingId = "";
              });
            })
        : Container()); */

    listings.add(cropLoaded
        ? DropDownWithModel(
            itemlist: blockitems,
            selecteditem: slctBlocks,
            hint: "Select Block",
            onChanged: (value) {
              setState(() {
                slctBlocks = value;
                varietyLoaded = false;
                slctVariety = '';
                autoPopulateBlockId = "";
                autoPopulatePlantingId = "";
                cropPlanted = "";
                cropVariety = "";
                plantingLoaded = false;
                plantingItems = [];
                slcPlanting = "";
                valPlanting = "";
                selectPlanting = null;

                //toast(slctFarms!.value);
                valCrop = slctBlocks!.value;
                slcCrop = slctBlocks!.name;
                autoPopulateBlockId = valCrop;

                plantingIdSearch(valCrop);
                /*  for (int i = 0; i < cropListUIModel.length; i++) {
                  if (cropListUIModel[i].value == valCrop) {
                    setState(() {
                      autoPopulateBlockId = cropListUIModel[i].value;
                      plantingDate = cropListUIModel[i].value2;
                      autoPopulatePlantingId = cropListUIModel[i].value3;
                      getCropVariety(autoPopulateBlockId);
                    });
                    //loadvarietylist();
                  }
                }*/
              });
            },
          )
        : Container());

    listings.add(cropLoaded
        ? txt_label_mandatory("Block ID", Colors.black, 14.0, false)
        : Container());

    listings.add(cropLoaded
        ? cardlable_dynamic(autoPopulateBlockId.toString())
        : Container());

    /*  listings.add(cropLoaded
        ? txt_label_mandatory("Crop-Planting ID", Colors.black, 14.0, false)
        : Container());
    listings.add(cropLoaded
        ? cardlable_dynamic(autoPopulatePlantingId.toString())
        : Container());*/

    listings.add(plantingLoaded
        ? txt_label_mandatory("Planting ID", Colors.black, 14.0, false)
        : Container());
    listings.add(plantingLoaded
        ? DropDownWithModel(
            itemlist: plantingItems,
            selecteditem: selectPlanting,
            hint: "Select Planting ID",
            onChanged: (value) {
              setState(() {
                selectPlanting = value!;
                cropPlanted = "";
                cropVariety = "";
                plantingDate = "";
                valPlanting = selectPlanting!.value;
                slcPlanting = selectPlanting!.name;
                autoPopulatePlantingId = valPlanting;
                getCropVariety(valPlanting);
              });
            },
          )
        : Container());

    listings.add(plantingLoaded
        ? txt_label_mandatory("Crop Planted", Colors.black, 14.0, false)
        : Container());
    listings.add(plantingLoaded
        ? cardlable_dynamic(cropPlanted.toString())
        : Container());

    listings.add(plantingLoaded
        ? txt_label_mandatory("Crop Variety ($uom)", Colors.black, 14.0, false)
        : Container());
    listings.add(plantingLoaded
        ? cardlable_dynamic(cropVariety.toString())
        : Container());

    listings.add(
        txt_label_mandatory("Date of Scouting", Colors.black, 14.0, false));
    listings.add(selectDate(
        context1: context,
        slctdate: slcDate,
        onConfirm: (date) => setState(
              () {
                slcDate = DateFormat('dd-MM-yyyy').format(date);
                formatDate = DateFormat('yyyy-MM-dd').format(date);
                scoutingDateComparison(date);
              },
            )));

    listings
        .add(txt_label_mandatory("Spraying Required?", Colors.black, 14.0, false));
    listings.add(singlesearchDropdown(
      itemlist: sprayingDropdownItem,
      selecteditem: slcSprayingNeeded,
      hint: "Select Spraying Required?",
      onChanged: (value) {
        setState(() {
          slcSprayingNeeded = value!;
          for (int i = 0; i < sprayingListUIModel.length; i++) {
            if (value == sprayingListUIModel[i].name) {
              valSpraying = sprayingListUIModel[i].value;
            }
          }
        });
      },
    ));

    listings.add( txt_label_mandatory("Recommendation", Colors.black, 14.0, false));
    listings.add( txtFieldLargeDynamic(
        "Recommendation", cmnRecommendationController, true, 100));

    listings.add(
        txt_label_mandatory("Insects Observed?", Colors.black, 14.0, false));
    listings.add(radio_dynamic(
        map: insetsSel,
        selectedKey: selectedInset,
        onChange: (value) {
          setState(() {
            if (value == "option2") {
              selectedInset = "option2";
              selectedInsetValue = "0";
              numberInsectController.clear();
              selectedInst = [];
              valInst = '';
              instName = '';
            } else {
              selectedInset = "option1";
              selectedInsetValue = "1";
            }
          });
        }));
    if (selectedInsetValue == "1") {
      listings.add(
          txt_label("Name of Insect(s) Observed", Colors.black, 14.0, false));
      listings.add(multisearchDropdownHint(
          hint: "Select Name of Insect(s) ",
          itemlist: instDropdownItem,
          selectedlist: selectedInst,
          onChanged: (item) {
            setState(() {
              selectedInst = item;
              for (int i = 0; i < item.length; i++) {
                String value = instListUIModel[i].value;
                String valuename = instListUIModel[i].name;

                if (valInst.length > 0) {
                  valInst = valInst + "," + value;
                  instName = instName + "," + valuename;
                } else {
                  valInst = valInst + value;
                  instName = instName + valuename;
                }
              }
            });
          }));

      listings.add(txt_label_mandatory(
          "% Thresholds of Insect Pest Infestation",
          Colors.black,
          14.0,
          false));
      listings.add(txtfield_digits("% Thresholds of Insect Pest Infestation",
          numberInsectController, true, 50));
    }
    listings.add(
        txt_label_mandatory("Disease Observed?", Colors.black, 14.0, false));
    listings.add(radio_dynamic(
        map: diseaseSel,
        selectedKey: selectedDis,
        onChange: (value) {
          setState(() {
            if (value == "option2") {
              selectedDis = "option2";
              selectedDisValue = "0";
              perInfectionController.clear();
              selectedDisc = [];
              valDisc = '';
              disName = '';
            } else {
              selectedDis = "option1";
              selectedDisValue = "1";
            }
          });
        }));
    if (selectedDisValue == "1") {
      listings.add(
          txt_label_mandatory("Name of Disease", Colors.black, 14.0, false));
      listings.add(disLoaded
          ? multisearchDropdownHint(
              hint: "Select Name of Disease",
              itemlist: disDropdownItem,
              selectedlist: selectedDisc,
              onChanged: (item) {
                setState(() {
                  selectedDisc = item;

                  String values = '';

                  for (int i = 0; i < disListUIModel.length; i++) {
                    for (int j = 0; j < item.length; j++) {
                      String name = item[j].toString();
                      if (name == disListUIModel[i].name) {
                        String value = disListUIModel[i].value;
                        if (values == "") {
                          values = value;
                        } else {
                          values = values + ',' + value;
                        }
                        valDisc = values;
                      }
                    }
                  }

                  /* for (int i = 0; i < item.length; i++) {
                     valuee = disListUIModel[i].value;
                     valuenamee = disListUIModel[i].name;


                  }

                  if (item.length > 0) {
                    valDisc = valDisc + "," + valuee;
                    disName = disName + "," + valuenamee;
                  } else {
                    valDisc = valDisc + valuee;
                    disName = disName + valuenamee;
                  } */
                });
                //print("Disease"+selectedDisc.toString());
                print("Value" + valDisc);
                //print("Name"+disName);
              })
          : Container());

      listings
          .add(txt_label_mandatory("% Infection", Colors.black, 14.0, false));
      listings.add(
          txtfield_digits("% Infection", perInfectionController, true, 50));
    }
    listings
        .add(txt_label_mandatory("Weeds Observed?", Colors.black, 14.0, false));
    listings.add(radio_dynamic(
        map: weedsSel,
        selectedKey: selectedWeed,
        onChange: (value) {
          setState(() {
            if (value == "option2") {
              selectedWeed = "option2";
              selectedWeedValue = "0";
              weedsPreController.clear();
              recommendationController.clear();
              selectedWeedV = [];
              valWeed = '';
              weedName = '';
            } else {
              selectedWeed = "option1";
              selectedWeedValue = "1";
            }
          });
        }));

    listings.add(selectedWeedValue == "1"
        ? txt_label_mandatory("Name of Weeds", Colors.black, 14.0, false)
        : Container());
    listings.add(selectedWeedValue == "1"
        ? multisearchDropdownHint(
            hint: "Select Name of Weeds",
            itemlist: weedDropdownItem,
            selectedlist: selectedWeedV,
            onChanged: (item) {
              setState(() {
                selectedWeedV = item;
                for (int i = 0; i < item.length; i++) {
                  String value = weedListUIModel[i].value;
                  String valuename = weedListUIModel[i].name;

                  if (valWeed.length > 0) {
                    valWeed = valWeed + "," + value;
                    weedName = weedName + "," + valuename;
                  } else {
                    valWeed = valWeed + value;
                    weedName = weedName + valuename;
                  }
                }
              });
            })
        : Container());

    listings.add(selectedWeedValue == "1"
        ? txt_label("Weeds Presence %", Colors.black, 14.0, false)
        : Container());

    listings.add(selectedWeedValue == "1"
        ? txtfield_digits("Weeds Presence %", weedsPreController, true, 50)
        : Container());

    listings.add(selectedWeedValue == "1"
        ? txt_label("Recommendation for Weed", Colors.black, 14.0, false)
        : Container());
    listings.add(selectedWeedValue == "1"
        ? txtFieldLargeDynamic(
            "Recommendation for Weed", recommendationController, true, 100)
        : Container());

    listings
        .add(txt_label_mandatory("Source of Water", Colors.black, 14.0, false));
    listings.add(singlesearchDropdown(
      itemlist: sourceOfWaterDropdownItem,
      selecteditem: slcSourceOfWater,
      hint: "Select Source of Water",
      onChanged: (value) {
        setState(() {
          slcSourceOfWater = value!;
          for (int i = 0; i < sourceOfWaterListUIModel.length; i++) {
            if (value == sourceOfWaterListUIModel[i].name) {
              valSourceOfWater = sourceOfWaterListUIModel[i].value;
            }
          }
        });
      },
    ));

    listings.add(
        txt_label_mandatory("Amount of Water Used (m3)", Colors.black, 14.0, false));
    listings.add(txtfieldAllowTwoDecimal(
        "Amount of Water Used (m3)", waterUsedController, true, 30));
    /*  listings.add(singlesearchDropdown(
      itemlist: irrTypeDropdownItem,
      selecteditem: slcIrrType,
      hint: "Select Irrigation Type",
      onChanged: (value) {
        setState(() {
          slcIrrType = value!;
          for (int i = 0; i < irrTypeListUIModel.length; i++) {
            if (value == irrTypeListUIModel[i].name) {
              valIrrTyp = irrTypeListUIModel[i].value;
            }
          }
        });
      },
    ));*/

    listings.add(
        txt_label_mandatory("Irrigation Method", Colors.black, 14.0, false));
    listings.add(singlesearchDropdown(
      itemlist: irrMetDropdownItem,
      selecteditem: slcIrrMet,
      hint: "Select Irrigation Method",
      onChanged: (value) {
        setState(() {
          slcIrrMet = value!;
          for (int i = 0; i < irrMetListUIModel.length; i++) {
            if (value == irrMetListUIModel[i].name) {
              valIrrMet = irrMetListUIModel[i].value;
            }
          }
        });
      },
    ));

    listings
        .add(txt_label_mandatory("Area Irrigated (acres)", Colors.black, 14.0, false));
    listings.add(txtfieldAllowTwoDecimal(
        "Area Irrigated (acres)", areaIrrigationController, true, 20));

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
                  style: TextStyle(color: Colors.white, fontSize: 18),
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
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                onPressed: () {
                  btnSubmit();
                },
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    ));

    return listings;
  }

  void scoutingDateComparison(DateTime scoutingDate) async {
    print("plantingDate_plantingDate" + plantingDate.toString());
    if (plantingDate != "") {
      String dateValue = plantingDate;
      String trimmedDate = dateValue.substring(0, 10);
      /*    String delimiter = '00:00:00.0';
      int lastIndex = link.indexOf(delimiter);
      String trimmedDate = link.substring(0, lastIndex);

      print("trimmedDate" + trimmedDate.toString());*/

      DateTime convertSowingDate = scoutingDate;
      print("convertSowingDate" + convertSowingDate.toString());

      String startDate = trimmedDate;
      List<String> splitStartDate = startDate.split('-');

      String strYearq = splitStartDate[0];
      String strMonthq = splitStartDate[1];
      String strDateq = splitStartDate[2];

      int strYear = int.parse(strYearq);
      int strMonths = int.parse(strMonthq);
      int strDate = int.parse(strDateq);

      DateTime convertPlantingDate = DateTime(strYear, strMonths, strDate);

      print("convertPlantingDate" + convertPlantingDate.toString());

      DateTime valEnd = convertSowingDate;
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

  void btnSubmit() async {
    signatureInspectorBase64 = encoded;
    signatureOwnerBase64 = encoded1;

    if (slcWard.length == 0) {
      alertPopup(context, "Ward should not be empty");
    } else if (slcVillage.length == 0) {
      alertPopup(context, "Village should not be empty");
    } else if (slcFarmer == "" && slcFarmer.length == 0) {
      alertPopup(context, "Farmer should not be empty");
    } else if (slcFarm == "" && slcFarm.length == 0) {
      alertPopup(context, "Farm should not be empty");
    } else if (slcCrop == "" && slcCrop.length == 0) {
      alertPopup(context, "Block Name should not be empty");
    } else if (slcPlanting.isEmpty) {
      alertPopup(context, "Planting ID should not be empty");
    } else if (formatDate == "") {
      alertPopup(context, "Date should not be empty");
    } else if (valSpraying == "") {
      alertPopup(context, "Is Spraying needed should not be empty");
    }else if (cmnRecommendationController.text.isEmpty) {
      alertPopup(context, "Recommendation should not be empty");
    }
    else {
      if (afterPlantingDate) {
        alertPopup(
            context, "Scouting Date should be greater than Planting Date");
      } else {
        insectsValidation();
      }
    }
  }

  void insectsValidation() {
    if (selectedInsetValue == "1") {
      if (numberInsectController.text.length == 0) {
        alertPopup(
            context, "Enter the % Thresholds of Insect Pest Infestation");
      } else {
        diseaseObserved();
      }
    } else {
      diseaseObserved();
    }
  }

  void diseaseObserved() {
    if (selectedDisValue == "1") {
      if (valDisc.length == 0) {
        alertPopup(context, "Select the Name of Disease");
      } else if (perInfectionController.text.length == 0) {
        alertPopup(context, "Enter the % Infection");
      } else {
        weedObserved();
      }
    } else {
      weedObserved();
    }
  }

  void weedObserved() {
    if (selectedWeedValue == "1") {
      if (valWeed.length == 0) {
        alertPopup(context, "Select the Name Of Weeds");
      } else if (slcSourceOfWater.length == 0) {
        alertPopup(context, "Select Source of Water");
      } else {
        validation();
      }
    } else {
      validation();
    }
  }

  void validation() {
    if (slcSourceOfWater.length == 0) {
      alertPopup(context, "Source of Water should not be empty");
    }
    /* else if (slcIrrType.length == 0) {
      alertPopup(context, "Irrigation Type should not be empty");
    } */
    else if (waterUsedController.text.length == 0) {
      alertPopup(context, "Amount of Water Used (m3) should not be empty");
    } else if (slcIrrMet.length == 0) {
      alertPopup(context, "Irrigation Method should not be empty");
    } else if (areaIrrigationController.text.length == 0) {
      alertPopup(context, "Area Irrigated (acres) should not be empty");
    } else {
      confirmationPopup();
    }
  }

  void confirmationPopup() {
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
            saveScouting();
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

  Future<void> saveScouting() async {
    var db = DatabaseHelper();
    final now = DateTime.now();
    String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);

    String? agentid =await SecureStorage().readSecureData("agentId");
    String? agentToken =await SecureStorage().readSecureData("agentToken");
    Random rnd = Random();
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

    if(scoutDate.isNotEmpty && scoutDate !=null && scoutDate !='null'){
      var difference =DateTime.parse(formatDate.trim()) .difference(DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.parse(scoutDate.trim())))).inDays;
      if(difference >=0){
        db.UpdateTableValue(
            'farmCrop', 'commonRec', cmnRecommendationController.text, 'farmcrpIDT', autoPopulatePlantingId);
        db.UpdateTableValue(
            'farmCrop', 'scoutDate', formatDate, 'farmcrpIDT', autoPopulatePlantingId);
      }else{
      }
    }else{
      db.UpdateTableValue(
          'farmCrop', 'commonRec', cmnRecommendationController.text, 'farmcrpIDT', autoPopulatePlantingId);
      db.UpdateTableValue(
          'farmCrop', 'scoutDate', formatDate, 'farmcrpIDT', autoPopulatePlantingId);
    }

    AppDatas datas = AppDatas();
    await db.saveCustTransaction(
        txntime, datas.txnScouting, revNo.toString(), '', '', '');

    if (imageFile != null) {
      List<int> imageBytes = imageFile!.readAsBytesSync();
      image64 = base64Encode(imageBytes);
    }

    int scouting = await db.saveScouting(
        cmnRecommendationController.text,
        formatDate,
        valFarmer,
        valFarm,
        valCrop,
        autoPopulatePlantingId,
        selectedInsetValue,
        valInst,
        numberInsectController.text,
        selectedDisValue,
        valDisc,
        perInfectionController.text,
        selectedWeedValue,
        valWeed,
        weedsPreController.text,
        recommendationController.text,
        waterUsedController.text, //valIrrTyp
        valIrrMet,
        areaIrrigationController.text,
        msgNo,
        Lat,
        Lng,
        revNo.toString(),
        "1",
        valSourceOfWater,valSpraying);
    print(scouting);



    int issync = await db.UpdateTableValue(
        'scouting', 'isSynched', '0', 'recNo', revNo.toString());

    print("issync" + issync.toString());




    TxnExecutor txnExecutor = TxnExecutor();
    txnExecutor.CheckCustTrasactionTable();

    Alert(
      context: context,
      type: AlertType.info,
      title: "Transaction Successful",
      desc: "Scouting done Successfully",
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
}
