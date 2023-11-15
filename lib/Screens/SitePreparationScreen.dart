import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
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

class SitePreparationScreen extends StatefulWidget {
  @override
  _SitePreparationScreenState createState() => _SitePreparationScreenState();
}

class _SitePreparationScreenState extends State<SitePreparationScreen> {
  String servicePointId = "",
      seasonCode = "",
      agentId = '',
      latitude = "",
      longitude = "";
  String slcFarmer = "", slcFarm = "", slcCrop = "";
  String valFarmer = "", valFarm = "", valCrop = "";
  String slcWard = "", slcVillage = "", valWard = "", valVillage = "";
  String valBlock = "", slcBlock = "";
  String selectedEnvironment = "option2",
      selectedSoil = "option2",
      selectedSocialRisk = 'option2',
      selectedWater = "option2";
  String valEnvironment = "0",
      valSoilAnalysis = "0",
      valSocialRisk = '0',
      valWaterAnalysis = "0";
  String environmentPhotoPath = "",
      soilAnalysisPhotoPath = "",
      waterAnalysisPhotoPath = "",
      socialRiskPhotoPath = "";
  String ruexit = 'Are you sure want to cancel?';
  String cancel = 'Cancel';
  String no = 'No', yes = 'Yes';
  String exporterVariety = '';

  List<DropdownMenuItem> farmerDropdownItem = [];
  List<DropdownMenuItem> farmDropdownItem = [];
  List<DropdownMenuItem> cropDropdownItem = [];
  List<DropdownMenuItem> wardDropdown = [];
  List<DropdownMenuItem> villageDropdown = [];
  List<DropdownMenuItem> blockDropdown = [];

  List<DropdownModelFarmer> farmeritems = [];
  DropdownModelFarmer? slctFarmers;

  List<DropdownModel> farmitems = [];
  DropdownModel? slctFarms;

  List<DropdownModel> blockItems = [];
  DropdownModel? selectBlock;

  List<UImodel3> farmerUIModel = [];
  List<UImodel> farmUIModel = [];
  List<UImodel> cropUIModel = [];
  List<UImodel> wardUIModel = [];
  List<UImodel> villageUIModel = [];
  List<UImodel> blockUIModel = [];

  bool farmLoaded = false;
  bool cropLoaded = false;
  bool wardLoaded = false;
  bool farmerLoaded = false;
  bool uploadEnvImage = false;
  bool uploadRiskImage = false;
  bool uploadSoilImage = false;
  bool uploadWaterImage = false;
  bool blockLoaded = false;
  String envFileName = "",
      riskFileName = "",
      waterFileName = "",
      soilFileName = "";

  File? environmentFile, soilAnalysisFile, waterAnalysisFile, socialRiskFile;

  final Map<String, String> environmentalList = {
    'option1': "Yes",
    'option2': "No",
  };
  final Map<String, String> socialRiskList = {
    'option1': "Yes",
    'option2': "No",
  };
  final Map<String, String> soilList = {
    'option1': "Yes",
    'option2': "No",
  };
  final Map<String, String> waterAnalysisList = {
    'option1': "Yes",
    'option2': "No",
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getClientData();
    getLocation();
    ward();
  }

  getClientData() async {
    List<Map> agents = await db.RawQuery('SELECT * FROM agentMaster');
    seasonCode = agents[0]['currentSeasonCode'];
    servicePointId = agents[0]['servicePointId'];
    agentId = agents[0]['agentId'];
    exporterVariety = agents[0]['variety'];
  }

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    latitude = position.latitude.toString();
    longitude = position.longitude.toString();
  }

  Future<void> village(String cityCode) async {
    List villageList = await db.RawQuery(
        'select distinct fm.villageId as villCode ,fm.[villageName] as villName from [farmer_master] fm inner join [farm] fc on fm.[farmerId] = fc.farmerId inner join [villageList] vl on fm.villageId = vl.[villCode] inner join blockDetails bL on fm.farmerId=bL.farmerId where gpCode=\'' +
            cityCode +
            '\' ');
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

  Future<void> ward() async {
    List wardList = await db.RawQuery(
        //'select distinct vl.[gpCode] as cityCode,ct.[cityName] as cityName from [farmer_master] fm inner join [farm] fc on fm.[farmerId] = fc.farmerId inner join [villageList] vl on fm.villageId = vl.[villCode] inner join [cityList] ct on vl.[gpCode] = ct.[cityCode]');
        'select distinct vl.[gpCode] as cityCode,ct.[cityName] as cityName from [farmer_master] fm inner join [farm] fc on fm.[farmerId] = fc.farmerId inner join [villageList] vl on fm.villageId = vl.[villCode] inner join [cityList] ct on vl.[gpCode] = ct.[cityCode] inner join blockDetails bL on fm.farmerId=bL.farmerId');

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
    String qryFarmerList =
        'select distinct fm.farmerId,fm.fName,fm.farmerCode,fm.idProofVal,fm.trader from farmer_master as fm inner join farm as f on fm.farmerId = f.farmerId  inner join villageList as v on v.villCode=fm.villageId inner join blockDetails bL on fm.farmerId=bL.farmerId where fm.villageId= \'' +
            villageCode +
            '\'';
    List farmersList = await db.RawQuery(qryFarmerList);
    //print("qryFarmerList" + qryFarmerList);
    //print("farmersList" + farmersList.toString());

    farmerUIModel = [];
    farmerDropdownItem = [];
    farmeritems.clear();

    for (int i = 0; i < farmersList.length; i++) {
      String propertyValue = farmersList[i]["fName"].toString();
      String dispSEQ = farmersList[i]["farmerId"].toString();
      String idProofVal = farmersList[i]["idProofVal"].toString();
      String kraPin = farmersList[i]["trader"].toString();

      var uimodel = new UImodel3(
          propertyValue + " - " + dispSEQ, dispSEQ, idProofVal, kraPin);
      farmerUIModel.add(uimodel);
      setState(() {
        farmeritems.add(DropdownModelFarmer(
            propertyValue + " - " + dispSEQ, dispSEQ, idProofVal, kraPin));
        //prooflist.add(property_value);
      });
    }
  }

  farmSearch(String farmerCode) async {
    String qryFarmList =
        'select distinct f.farmIDT,f.farmName from farm as f inner join blockDetails bL on f.farmIDT=bL.farmId where f.farmerId = \'' +
            valFarmer +
            '\' ';
    //print("qryFarmList" + qryFarmList.toString());
    List farmList = await db.RawQuery(qryFarmList);

    farmUIModel = [];
    farmDropdownItem = [];
    farmitems.clear();

    for (int i = 0; i < farmList.length; i++) {
      String propertyValue = farmList[i]["farmName"].toString();
      String dispSEQ = farmList[i]["farmIDT"].toString();
      var uimodel = new UImodel(propertyValue, dispSEQ);

      farmUIModel.add(uimodel);
      setState(() {
        farmitems.add(DropdownModel(
          propertyValue,
          dispSEQ,
        ));
        //prooflist.add(property_value);
      });
    }

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        farmLoaded = true;
        slcFarm = "";
      });
    });
  }

  void blockSearch(String farmId) async {
    String qryBlock =
        'select distinct blockId,blockName from blockDetails where farmId = \'' +
            farmId +
            '\' and farmerId=\'' +
            valFarmer +
            '\' ';
    //print("qryBlock" + qryBlock);
    List blockNameList = await db.RawQuery(qryBlock);
    blockUIModel = [];
    blockDropdown.clear();
    blockItems.clear();
    for (int i = 0; i < blockNameList.length; i++) {
      String blockID = blockNameList[i]["blockId"].toString();
      String blockName = blockNameList[i]["blockName"].toString();

      var uiModel = new UImodel(blockName, blockID);
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

  crop(String farmCode) async {
    String myString = exporterVariety;
    List<String> stringList = myString.split(",");

    String values = '';
    String quotation = "'";

    for (int j = 0; j < stringList.length; j++) {
      String getValue = stringList[j];
     // print('getValue' + getValue.toString());
      if (values == '') {
        values = getValue;
      } else {
        values = values + quotation + ',' + quotation + getValue;
      }
    }
    String qryCropList =
        'select distinct vCode, vName from varietyList  where vCode in (\'' +
            values +
            '\')';

   // print("qryCropList_qryCropList" + qryCropList.toString());

    List cropList = await db.RawQuery(qryCropList);
    //print("cropList_cropList" + cropList.toString());

    cropUIModel = [];
    cropDropdownItem = [];
    cropDropdownItem.clear();

    for (int i = 0; i < cropList.length; i++) {
      String propertyValue = cropList[i]["vName"].toString();
      String dispSEQ = cropList[i]["vCode"].toString();
      var uimodel = new UImodel(propertyValue, dispSEQ);

      cropUIModel.add(uimodel);
      setState(() {
        cropDropdownItem.add(DropdownMenuItem(
          child: Text(propertyValue),
          value: propertyValue,
        ));
      });
    }

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        cropLoaded = true;
        slcCrop = "";
      });
    });
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              _onBackPressed();
            },
          ),
          title: Text('Site Selection',
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
          slcCrop = "";
          slctFarmers = null;
          slctFarms = null;
          farmDropdownItem = [];
          farmerDropdownItem = [];
          villageDropdown = [];
          farmLoaded = false;
          blockLoaded = false;
          blockItems = [];
          selectBlock = null;
          slcBlock = "";
          valBlock = "";
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
          valFarm = "";
          slcFarmer = "";
          slctFarmers = null;
          slctFarms = null;
          slcCrop = "";
          farmDropdownItem = [];
          farmerDropdownItem = [];
          farmLoaded = false;
          blockLoaded = false;
          blockItems = [];
          selectBlock = null;
          slcBlock = "";
          valBlock = "";
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
        txt_label_mandatory("Select the Farmer", Colors.black, 14.0, false));

    listings.add(farmerDropDownWithModel(
      itemlist: farmeritems,
      selecteditem: slctFarmers,
      hint: "Select Farmer",
      onChanged: (value) {
        setState(() {
          slctFarmers = value!;
          slcFarm = "";
          slcCrop = "";
          valFarm = "";
          farmDropdownItem = [];
          farmLoaded = false;
          slctFarms = null;
          slctFarms = null;
          blockLoaded = false;
          blockItems = [];
          selectBlock = null;
          slcBlock = "";
          valBlock = "";
          valFarmer = slctFarmers!.value;
          slcFarmer = slctFarmers!.name;
          farmSearch(valFarmer);
        });
      },
    ));

    listings.add(farmLoaded
        ? txt_label_mandatory("Select the Farm", Colors.black, 14.0, false)
        : Container());

    listings.add(farmLoaded
        ? DropDownWithModel(
            itemlist: farmitems,
            selecteditem: slctFarms,
            hint: "Select Farm",
            onChanged: (value) {
              setState(() {
                slctFarms = value!;
                slcCrop = "";
                valFarm = "";
                blockLoaded = false;
                blockItems = [];
                selectBlock = null;
                slcBlock = "";
                valBlock = "";
                //toast(slctFarms!.value);
                valFarm = slctFarms!.value;
                slcFarm = slctFarms!.name;
                print('selectedvalue ' + slctFarms!.value);
                crop(valFarm);
                blockSearch(valFarm);
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

    listings.add(valFarm.isNotEmpty
        ? txt_label_mandatory("Farm ID", Colors.black, 14.0, false)
        : Container());
    listings.add(valFarm.isNotEmpty
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
              });
            },
          )
        : Container());

    listings.add(/*cropLoaded
        ?*/
        txt_label_mandatory(
            "Previous Crop", Colors.black, 14.0, false) /* : Container()*/);
    listings.add(/*cropLoaded
        ?*/
        singlesearchDropdown(
            itemlist: cropDropdownItem,
            selecteditem: slcCrop,
            hint: "Select Previous Crop",
            onChanged: (value) {
              setState(() {
                slcCrop = value!;
                for (int i = 0; i < cropUIModel.length; i++) {
                  if (value == cropUIModel[i].name) {
                    valCrop = cropUIModel[i].value;
                  }
                }
              });
            },
            onClear: () {
              setState(() {
                slcCrop = "";
              });
            }) /*: Container()*/);

    listings.add(txt_label_mandatory(
        'Environmental Assessment', Colors.black, 14.0, false));
    listings.add(radio_dynamic(
        map: environmentalList,
        selectedKey: selectedEnvironment,
        onChange: (value) {
          setState(() {
            selectedEnvironment = value;
            if (value == "option2") {
              valEnvironment = "0";
              onDeleteFile('Environmental');
            } else {
              valEnvironment = "1";
            }
          });
        }));

    listings.add(valEnvironment == "1"
        ? txt_label_mandatory(
            "Environmental Assessment Report ", Colors.black, 14.0, false)
        : Container());
    listings.add(valEnvironment == "1"
        ? fileUpload(
            label: "Environmental Assessment Report \*",
            onPressed: () {
              getImageFile('Environmental');
            },
            filename: environmentFile,
            ondelete: () {
              onDeleteFile('Environmental');
            },
            uploadFileName: envFileName)
        : Container());

    listings.add(txt_label_mandatory(
        'Social Risk Assessment', Colors.black, 14.0, false));
    listings.add(radio_dynamic(
        map: socialRiskList,
        selectedKey: selectedSocialRisk,
        onChange: (value) {
          setState(() {
            selectedSocialRisk = value;
            if (value == "option2") {
              valSocialRisk = "0";
              onDeleteFile('SocialRisk');
            } else {
              valSocialRisk = "1";
            }
          });
        }));

    listings.add(valSocialRisk == "1"
        ? txt_label_mandatory(
            "Social Risk Assessment Report ", Colors.black, 14.0, false)
        : Container());
    listings.add(valSocialRisk == "1"
        ? fileUpload(
            label: "Social Risk Assessment Report \*",
            onPressed: () {
              getImageFile('SocialRisk');
            },
            filename: socialRiskFile,
            ondelete: () {
              onDeleteFile('SocialRisk');
            },
            uploadFileName: riskFileName)
        : Container());

    listings
        .add(txt_label_mandatory('Soil Analysis ', Colors.black, 14.0, false));
    listings.add(radio_dynamic(
        map: soilList,
        selectedKey: selectedSoil,
        onChange: (value) {
          setState(() {
            selectedSoil = value;
            if (value == "option2") {
              valSoilAnalysis = "0";
              onDeleteFile('Soil');
            } else {
              valSoilAnalysis = "1";
            }
          });
        }));

    listings.add(valSoilAnalysis == "1"
        ? txt_label_mandatory(
            "Soil Analysis Report ", Colors.black, 14.0, false)
        : Container());
    listings.add(valSoilAnalysis == "1"
        ? fileUpload(
            label: "Soil Analysis Report \*",
            onPressed: () {
              getImageFile('Soil');
            },
            filename: soilAnalysisFile,
            ondelete: () {
              onDeleteFile('Soil');
            },
            uploadFileName: soilFileName)
        : Container());

    listings
        .add(txt_label_mandatory('Water Analysis', Colors.black, 14.0, false));
    listings.add(radio_dynamic(
        map: waterAnalysisList,
        selectedKey: selectedWater,
        onChange: (value) {
          setState(() {
            selectedWater = value;
            if (value == "option2") {
              valWaterAnalysis = "0";
              onDeleteFile('Water');
            } else {
              valWaterAnalysis = "1";
            }
          });
        }));

    listings.add(valWaterAnalysis == "1"
        ? txt_label_mandatory(
            "Water Analysis Report ", Colors.black, 14.0, false)
        : Container());
    listings.add(valWaterAnalysis == "1"
        ? fileUpload(
            label: "Water Analysis Report \*",
            onPressed: () {
              getImageFile('Water');
            },
            filename: waterAnalysisFile,
            ondelete: () {
              onDeleteFile('Water');
            },
            uploadFileName: waterFileName)
        : Container());

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

/*  Future getImageFile(String label) async {
    var image = await ImagePicker.platform
        .pickImage(source: ImageSource.camera, imageQuality: 15);

    if (label == "Environmental") {
      setState(() {
        environmentFile = File(image!.path);
      });
    }
    if (label == 'SocialRisk') {
      setState(() {
        socialRiskFile = File(image!.path);
      });
    }
    if (label == 'Water') {
      setState(() {
        waterAnalysisFile = File(image!.path);
      });
    }
    if (label == "Soil") {
      setState(() {
        soilAnalysisFile = File(image!.path);
      });
    }
  }*/

  Future getImageFile(String label) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom,allowedExtensions: ['jpg',
      'png','pdf']);
    var path2 = result!.files.single.path;
    File file = File(path2 ?? "");
    PlatformFile platformFile = result.files.first;
    String getFileName = result.files.first.name;
    String fileType = "";

    print("getFileName_getFileName" + getFileName.toString());
    print("file size:"+platformFile.size.toString());

    if (platformFile.extension != null) {
      fileType = platformFile.extension!;
      print("fileType_fileType" + fileType.toString());

    }

    double restrictedFileSize = 2000000;

    if (label == "Environmental") {
      if(double.parse(platformFile.size.toString()) <= restrictedFileSize){
        setState(() {
          environmentFile = file;
        });
        envFileName = getFileName;
      }else{
        errordialog(context, "information", "Selected Document should be less than or equal to 2MB");
        setState(() {
          environmentFile=null;
          envFileName="";
        });
      }

    }

    if (label == 'SocialRisk') {
      if(double.parse(platformFile.size.toString()) <= restrictedFileSize){
        setState(() {
          socialRiskFile = file;
        });
        riskFileName = getFileName;
      }else{
        errordialog(context, "information", "Selected Document should be less than or equal to 2MB");
        setState(() {
          socialRiskFile=null;
          riskFileName="";
        });
      }
    }

    if (label == 'Water') {
      if(double.parse(platformFile.size.toString()) <= restrictedFileSize){
        setState(() {
          waterAnalysisFile = file;
        });
        waterFileName = getFileName;
      }else{
        errordialog(context, "information", "Selected Document should be less than or equal to 2MB");
        setState(() {
          waterAnalysisFile=null;
          waterFileName="";
        });
      }

    }

    if (label == "Soil") {
      if(double.parse(platformFile.size.toString()) <= restrictedFileSize){
        setState(() {
          soilAnalysisFile = file;
        });
        soilFileName = getFileName;
      }else{
        errordialog(context, "information", "Selected Document should be less than or equal to 2MB");
        setState(() {
          soilAnalysisFile=null;
          soilFileName="";
        });
      }
    }
  }

  void onDeleteFile(String label) {
    if (label == 'Environmental') {
      setState(() {
        environmentFile = null;
      });
    }
    if (label == 'SocialRisk') {
      if (socialRiskFile != null) {
        setState(() {
          socialRiskFile = null;
        });
      }
    }
    if (label == 'Water') {
      if (waterAnalysisFile != null) {
        setState(() {
          waterAnalysisFile = null;
        });
      }
    }
    if (label == "Soil") {
      if (soilAnalysisFile != null) {
        setState(() {
          soilAnalysisFile = null;
        });
      }
    }
  }

  void btnSubmit() {
    if (environmentFile != null) {
      environmentPhotoPath = environmentFile!.path;
    }

    if (socialRiskFile != null) {
      socialRiskPhotoPath = socialRiskFile!.path;
    }

    if (soilAnalysisFile != null) {
      soilAnalysisPhotoPath = soilAnalysisFile!.path;
    }

    if (waterAnalysisFile != null) {
      waterAnalysisPhotoPath = waterAnalysisFile!.path;
    }
    if (slcWard.isEmpty) {
      alertPopup(context, "Ward should not be empty");
    } else if (slcVillage.isEmpty) {
      alertPopup(context, "Village should not be empty");
    } else if (slcFarmer.isEmpty) {
      alertPopup(context, "Farmer should not be empty");
    } else if (slcFarm.isEmpty) {
      alertPopup(context, "Farm should not be empty");
    } else if (slcBlock.isEmpty) {
      alertPopup(context, "Block Should not be empty");
    } else if (slcCrop.isEmpty) {
      alertPopup(context, "Crop should not be empty");
    } else {
      environment();
    }
  }

  void environment() async {
    if (valEnvironment == "1") {
      if (environmentFile == null) {
        alertPopup(
            context, "Environmental Assessment Report should not be empty");
      } else {
        socialRisk();
      }
    } else {
      socialRisk();
    }
  }

  void socialRisk() async {
    if (valSocialRisk == "1") {
      if (socialRiskFile == null) {
        alertPopup(
            context, "Social Risk Assessment Report should not be empty");
      } else {
        soilAnalysis();
      }
    } else {
      soilAnalysis();
    }
  }

  void soilAnalysis() async {
    if (valSoilAnalysis == "1") {
      if (soilAnalysisFile == null) {
        alertPopup(context, "Soil Analysis Report should not be empty");
      } else {
        waterAnalysis();
      }
    } else {
      waterAnalysis();
    }
  }

  void waterAnalysis() async {
    if (valWaterAnalysis == "1") {
      if (waterAnalysisFile == null) {
        alertPopup(context, "Water Analysis Report should not be empty");
      } else {
        confirmation();
      }
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
            sitePreparation();
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

  Future<void> sitePreparation() async {
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
        txntime, datas.txnSitePreparation, revNo.toString(), '', '', '');

    int sitePreparation = await db.sitePreparation(
        revNo.toString(),
        txntime,
        "1",
        valFarmer,
        valFarm,
        valCrop,
        valEnvironment,
        environmentPhotoPath,
        valSocialRisk,
        socialRiskPhotoPath,
        valSoilAnalysis,
        soilAnalysisPhotoPath,
        valWaterAnalysis,
        waterAnalysisPhotoPath,
        valBlock);

    print(sitePreparation);

    await db.UpdateTableValue(
        'sitePreparation', 'isSynched', '0', 'recNo', revNo.toString());

    TxnExecutor txnExecutor = new TxnExecutor();
    txnExecutor.CheckCustTrasactionTable();

    Alert(
      context: context,
      type: AlertType.info,
      title: "Transaction Successful",
      desc: "Site Selection done Successfully",
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
