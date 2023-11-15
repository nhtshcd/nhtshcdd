import 'dart:io' show File;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nhts/Database/Databasehelper.dart';
import 'package:nhts/Model/UIModel.dart';
import 'package:nhts/Plugins/TxnExecutor.dart';
import 'package:nhts/ResponseModel/farmerdownloadmodel.dart';
import 'package:nhts/Utils/MandatoryDatas.dart';
import 'package:nhts/Utils/dynamicfields.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../Utils/secure_storage.dart';
import '../login.dart';
import 'farmRegistration.dart';

class FarmerRegistration extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FarmerRegistration();
}

class _FarmerRegistration extends State<FarmerRegistration> {
  final Map<String, String> genderList = {
    'option1': "Male",
    'option2': "Female",
  };
  final Map<String, String> housingList = {
    'option1': "Yes",
    'option2': "No",
  };

  TextEditingController farmerNameController = new TextEditingController();
  TextEditingController ageController = new TextEditingController();
  TextEditingController nationalIDController = new TextEditingController();
  TextEditingController phoneNumberController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController numberOfMembersController = new TextEditingController();
  TextEditingController schoolChildrenController = new TextEditingController();
  TextEditingController childrenController = new TextEditingController();
  TextEditingController adultController = new TextEditingController();
  TextEditingController higherEducationController = new TextEditingController();
  TextEditingController villageNameController = new TextEditingController();
  TextEditingController companyNameController = new TextEditingController();
  TextEditingController certificateController = new TextEditingController();
  TextEditingController pINController = new TextEditingController();

  String farmerTraceCode = "";

  String selectedValue = 'option1',
      selectedGender = "1",
      selectedHousing = "option2",
      selectedHouseValue = "0";
  String selectedDate = "", formatDate = "";
  String ruexit = 'Are you sure want to cancel?';
  String exit = 'Cancel';
  String no = 'No', yes = 'Yes';
  String slcCountry = "",
      slcVillage = "",
      slcCounty = "",
      slcSubCounty = "",
      slcWard = "",
      slcEducation = "",
      slcFarmerCategory = "",
      slcFarmerType = "",
     slcFarmOwnerShip="";
  String valCropCategory = "",
      valCropHSCode = "",
      valCropName = "",
      valCountry = "",
      valVillage = "",
      valEducation = "",
      valFarmerCategory = "",
      valFarmerType = "",
     valFarmOwnerShip="";
  String valSubCounty = "",
      valCounty = "",
      valWard = "",
      valHousingOwner = "",
      valAssetOwner = "",
      valHighestEduLev = "";
  String servicePointId = "",
      seasonCode = "",
      agentId = '',
      latitude = "",
      longitude = "";
  String slcVariety="",valVariety="";
  String farmerPhotoPath = "", nationalPhotoPath = "", nationalIDMsgNo = "";
  String click = "+";

  int curIdLim = 0, resId = 0, curIdLimited = 0, farmerId = 0;

  File? farmerImageFile, nationalIdImageFile;

  List<UImodel> cropCategoryUIModel = [];
  List<UImodel> cropNameUIModel = [];
  List<UImodel2> varietyUIModel = [];
  List<UImodel> countryUIModel = [];
  List<UImodel> countyUIModel = [];
  List<UImodel> subCountyUIModel = [];
  List<UImodel> wardUIModel = [];
  List<UImodel> villageUIModel = [];
  List<UImodel> housingOwnerUIModel = [];
  List<UImodel> assetOwnerUIModel = [];
  List<UImodel> highestEduUIModel = [];
  List<UImodel> farmerCategoryUIModel = [];
  List<UImodel> farmerTypeUIModel = [];
  List<UImodel> farmOwnerShipUIModel = [];

  List<String> valCropCategoryList = [];
  List<String> valCropNameList = [];
  List<String> valVarietyList = [];
  List<String> valHousingOwnerList = [];
  List<String> valAssetOwnerList = [];
  List<String> valHighestEduList = [];
  List<FarmerData> farmerData = [];
  List<ClassName> villageNameDetailList = [];

  List<DropdownMenuItem> cropCategoryDropdown = [];
  List<DropdownMenuItem> cropNameDropdown = [];
  List<DropdownMenuItem> countryDropdown = [];
  List<DropdownMenuItem> countyDropdown = [];
  List<DropdownMenuItem> subCountryDropdown = [];
  List<DropdownMenuItem> villageDropdown = [];
  List<DropdownMenuItem> wardDropdown = [];
  List<DropdownMenuItem> housingOwnerDropdown = [];
  List<DropdownMenuItem> assetOwnerDropdown = [];
  List<DropdownMenuItem> highestEduDropdown = [];
  List<DropdownMenuItem> farmerCategoryDropdown = [];
  List<DropdownMenuItem> farmOwnerShipDropdown = [];
  List<DropdownMenuItem> farmerTypeDropdown = [];
  List<DropdownMenuItem> varietyDropdown = [];

  bool countryLoaded = false,
      countyLoaded = false,
      subCountyLoaded = false,
      wardLoaded = false,
      villageLoaded = false;
  bool cropNameLoaded = false;
  bool cropVarietyLoad = false;
  bool cropCodeLoaded = false;
  bool newVillage = false;
  bool individualType = true;

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
    farmerNameController = new TextEditingController();
    ageController = new TextEditingController();
    nationalIDController = new TextEditingController();
    phoneNumberController = new TextEditingController();
    numberOfMembersController = new TextEditingController();
    adultController = new TextEditingController();
    childrenController = new TextEditingController();
    emailController = new TextEditingController();
    higherEducationController = new TextEditingController();
    schoolChildrenController = new TextEditingController();

    initValue();
    getLocation();
    getClientData();
    farmerIdGeneration();
  }

  getClientData() async {
    List<Map> agents = await db.RawQuery('SELECT * FROM agentMaster');
    seasonCode = agents[0]['currentSeasonCode'];
    servicePointId = agents[0]['servicePointId'];
    agentId = agents[0]['agentId'];
  }

  void farmerIdGeneration() async {
    List<Map> agents = await db.RawQuery('SELECT * FROM agentMaster');

    String temp = agents[0]['curIdSeqF'];
    int curId = int.parse(agents[0]['curIdSeqF']);
    resId = int.parse(agents[0]['resIdSeqF']);
    curIdLim = int.parse(agents[0]['curIdLimitF']); //45
    int newIdGen = 0;
    int incGenId = curId + 1;
    curIdLimited = 0;
    int MAX_Limit = 0;
    print("$incGenId  $curIdLim");
    if (incGenId <= curIdLim) {
      newIdGen = incGenId;
      farmerId = newIdGen;
      print("$incGenId  $curIdLim");
    } else {
      if (resId != 0) {
        newIdGen = resId + 1;
        curId = newIdGen;
        curIdLimited = resId + MAX_Limit;
        resId = 0;
        farmerId = newIdGen;
      } else {
        farmerId = newIdGen;
      }
    }
    setState(() {
      farmerTraceCode = farmerId.toString();
    });
  }

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
    });
  }

  Future<void> initValue() async {
    List cropCategoryList =
        await db.RawQuery('select fname,fcode from cropList');

    cropCategoryUIModel = [];
    cropCategoryDropdown = [];
    cropCategoryDropdown.clear();
    for (int i = 0; i < cropCategoryList.length; i++) {
      String propertyValue = cropCategoryList[i]["fname"].toString();
      String diSpSeq = cropCategoryList[i]["fcode"].toString();

      var uiModel = new UImodel(propertyValue, diSpSeq);
      cropCategoryUIModel.add(uiModel);
      setState(() {
        cropCategoryDropdown.add(DropdownMenuItem(
          child: Text(propertyValue),
          value: propertyValue,
        ));
      });
    }

    List countryList = await db.RawQuery('select distinct* from countryList');

    countryUIModel = [];
    countryDropdown = [];
    countryDropdown.clear();
    for (int i = 0; i < countryList.length; i++) {
      String propertyValue = countryList[i]["countryName"].toString();
      String diSpSeq = countryList[i]["countryCode"].toString();

      var uiModel = new UImodel(propertyValue, diSpSeq);
      countryUIModel.add(uiModel);
      setState(() {
        countryDropdown.add(DropdownMenuItem(
          child: Text(propertyValue),
          value: propertyValue,
        ));
      });
    }

    List assetOwnerList = await db.RawQuery(
        'select distinct * from animalCatalog where catalog_code =\'2\'');

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
        'select distinct * from animalCatalog where catalog_code =\'3\'');

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

    List highestEducationLevList = await db.RawQuery(
        'select distinct * from animalCatalog where catalog_code =\'1\'');

    print("highestEducationLevList" + highestEducationLevList.toString());
    highestEduUIModel = [];
    highestEduDropdown = [];
    highestEduDropdown.clear();
    for (int i = 0; i < highestEducationLevList.length; i++) {
      String propertyValue =
          highestEducationLevList[i]["property_value"].toString();
      String diSpSeq = highestEducationLevList[i]["DISP_SEQ"].toString();

      var uiModel = new UImodel(propertyValue, diSpSeq);
      highestEduUIModel.add(uiModel);
      setState(() {
        highestEduDropdown.add(DropdownMenuItem(
          child: Text(propertyValue),
          value: propertyValue,
        ));
      });
    }

    //phoneNumber_nationalId
    List phoneNationalIDList = await db.RawQuery(
        'select distinct phoneNo,idProofVal from farmer_master');
    print("phoneNationalIDList" + phoneNationalIDList.toString());
    farmerData.clear();
    for (int i = 0; i < phoneNationalIDList.length; i++) {
      String phoneNo = phoneNationalIDList[i]["phoneNo"].toString();
      String nationalID = phoneNationalIDList[i]["idProofVal"].toString();

      var farmerDetail = new FarmerData(phoneNo, nationalID);
      farmerData.add(farmerDetail);
    }




    List farmerCategoryList = [
      {"property_value": "Organic", "DISP_SEQ": "0"},
      {"property_value": "Transition", "DISP_SEQ": "1"},
      {"property_value": "Conventional", "DISP_SEQ": "2"}
    ];

    farmerCategoryUIModel = [];
    farmerCategoryDropdown = [];
    farmerCategoryDropdown.clear();
    for (int i = 0; i < farmerCategoryList.length; i++) {
      String propertyValue = farmerCategoryList[i]["property_value"].toString();
      String diSpSeq = farmerCategoryList[i]["DISP_SEQ"].toString();


      var uiModel = new UImodel(propertyValue, diSpSeq);
      farmerCategoryUIModel.add(uiModel);
      setState(() {
        farmerCategoryDropdown.add(DropdownMenuItem(
          child: Text(propertyValue),
          value: propertyValue,
        ));
      });
    }

    List farmOwnerShipList = [
      {"property_value": "Own", "DISP_SEQ": "0"},
      {"property_value": "Contracted", "DISP_SEQ": "1"}
    ];

    farmOwnerShipUIModel = [];
    farmOwnerShipDropdown = [];
    farmOwnerShipDropdown.clear();
    for (int i = 0; i < farmOwnerShipList.length; i++) {
      String propertyValue = farmOwnerShipList[i]["property_value"].toString();
      String diSpSeq = farmOwnerShipList[i]["DISP_SEQ"].toString();

      var uiModel = new UImodel(propertyValue, diSpSeq);
      farmOwnerShipUIModel.add(uiModel);
      setState(() {
        farmOwnerShipDropdown.add(DropdownMenuItem(
          child: Text(propertyValue),
          value: propertyValue,
        ));
      });
    }

    List farmerTypeList = [
      {"property_value": "Individual", "DISP_SEQ": "0"},
      {"property_value": "Company  ", "DISP_SEQ": "1"}
    ];

    farmerTypeUIModel = [];
    farmerTypeDropdown = [];
    farmerTypeDropdown.clear();
    for (int i = 0; i < farmerTypeList.length; i++) {
      String propertyValue = farmerTypeList[i]["property_value"].toString();
      String diSpSeq = farmerTypeList[i]["DISP_SEQ"].toString();

      var uiModel = new UImodel(propertyValue, diSpSeq);
      farmerTypeUIModel.add(uiModel);
      setState(() {
        farmerTypeDropdown.add(DropdownMenuItem(
          child: Text(propertyValue),
          value: propertyValue,
        ));
      });
    }
  }

  villageNameCheck(String wardCode) async {
    List villageNameList = await db.RawQuery(
        'select villCode,villName from villageList where gpCode =\'' +
            wardCode +
            '\'');
    villageNameDetailList.clear();
    for (int i = 0; i < villageNameList.length; i++) {
      String villageID = villageNameList[i]["villCode"].toString();
      String villageName = villageNameList[i]["villName"].toString();

      var villageNameDetail = new ClassName(villageName, villageID, "");
      villageNameDetailList.add(villageNameDetail);
    }
  }

  /* void uiUpdate() {
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        cropCodeLoaded = true;
      });
    });
  }*/

  Future<void> getVariety(String varietyCode) async {
    String varietyQry =
        'select distinct gradeCode,grade,ppCode as hsCode from procurementGrade where vCode in (\'' +
            varietyCode +
            '\')';
    print("varietyQry_varietyQry" + varietyQry.toString());

    List varietyList = await db.RawQuery(varietyQry);

    varietyUIModel = [];
    varietyDropdown = [];
    varietyDropdown.clear();
    for (int i = 0; i < varietyList.length; i++) {
      String propertyValue = varietyList[i]["grade"].toString();
      String diSpSeq = varietyList[i]["gradeCode"].toString();
      String hsCode = varietyList[i]["hsCode"].toString();

      var uiModel =  UImodel2(propertyValue, diSpSeq,hsCode);
      varietyUIModel.add(uiModel);
      setState(() {
        varietyDropdown.add(DropdownMenuItem(
          child: Text(propertyValue),
          value: propertyValue,
        ));
      });
    }

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        if (varietyList.isNotEmpty) {
          cropVarietyLoad = true;
          valVarietyList.clear();
        }
      });
    });
  }

  Future<void> cropName(String cropCode) async {
    String cropQry =
        'select distinct vCode,vName ,days from varietyList where prodId in (\'' +
            cropCode +
            '\')';

    print("cropQry_cropQry" + cropQry.toString());

    // String cropQry = 'select distinct vCode,vName ,days from varietyList';

    List cropNameList = await db.RawQuery(cropQry);

    print("cropNameList" + cropNameList.toString());

    cropNameUIModel = [];
    cropNameDropdown = [];
    cropNameDropdown.clear();
    for (int i = 0; i < cropNameList.length; i++) {
      String propertyValue = cropNameList[i]["vName"].toString();
      String diSpSeq = cropNameList[i]["vCode"].toString();

      var uiModel =  UImodel(propertyValue, diSpSeq);
      cropNameUIModel.add(uiModel);
      setState(() {
        cropNameDropdown.add(DropdownMenuItem(
          child: Text(propertyValue),
          value: propertyValue,
        ));
      });
    }

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        if (cropNameList.isNotEmpty) {
          cropNameLoaded = true;
          valCropNameList.clear();
        }
      });
    });
  }

  Future<void> countySearch(String countryCode) async {
    List subCountyList = await db.RawQuery(
        'select distinct * from stateList where countryCode =\'' +
            countryCode +
            '\'');

    countyDropdown = [];
    countyUIModel = [];
    countyDropdown.clear();
    for (int i = 0; i < subCountyList.length; i++) {
      String propertyValue = subCountyList[i]["stateName"].toString();
      String diSpSeq = subCountyList[i]["stateCode"].toString();

      var uiModel = new UImodel(propertyValue, diSpSeq);
      countyUIModel.add(uiModel);
      setState(() {
        countyDropdown.add(DropdownMenuItem(
          child: Text(propertyValue),
          value: propertyValue,
        ));
      });
    }

    setState(() {
      if (subCountyList.isNotEmpty) {
        countryLoaded = true;
      }
    });
  }

  Future<void> subCounty(String stateCode) async {
    List subCountyList = await db.RawQuery(
        'select distinct * from districtList where stateCode =\'' +
            stateCode +
            '\'');

    subCountyUIModel = [];
    subCountryDropdown = [];
    subCountryDropdown.clear();
    for (int i = 0; i < subCountyList.length; i++) {
      String propertyValue = subCountyList[i]["districtName"].toString();
      String diSpSeq = subCountyList[i]["districtCode"].toString();

      var uiModel = new UImodel(propertyValue, diSpSeq);
      subCountyUIModel.add(uiModel);
      setState(() {
        subCountryDropdown.add(DropdownMenuItem(
          child: Text(propertyValue),
          value: propertyValue,
        ));
      });
    }
    setState(() {
      if (subCountyList.isNotEmpty) {
        subCountyLoaded = true;
      }
    });
  }

  Future<void> village(cityCode) async {
    List villageList = await db.RawQuery(
        'select distinct * from villageList where gpCode =\'' +
            cityCode +
            '\' and villName!=""');
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

    setState(() {
      if (villageList.isNotEmpty) {
        villageLoaded = true;
      }
    });
  }

  Future<void> ward(String districtCode) async {
    List wardList = await db.RawQuery(
        'select distinct * from cityList where districtCode =\'' +
            districtCode +
            '\'');

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

    setState(() {
      if (wardList.isNotEmpty) {
        wardLoaded = true;
      }
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
          title: Text('Farmer Registration',
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
        .add(txt_label_mandatory("Farmer Category", Colors.black, 15.0, false));
    listings.add(singlesearchDropdown(
      itemlist: farmerCategoryDropdown,
      selecteditem: slcFarmerCategory,
      hint: "Select Farmer Category",
      onChanged: (value) {
        setState(() {
          slcFarmerCategory = value!;
          for (int i = 0; i < farmerCategoryUIModel.length; i++) {
            if (value == farmerCategoryUIModel[i].name) {
              valFarmerCategory = farmerCategoryUIModel[i].value;
            }
          }
        });
      },
    ));

    listings
        .add(txt_label_mandatory("Farm OwnerShip", Colors.black, 15.0, false));
    listings.add(singlesearchDropdown(
      itemlist: farmOwnerShipDropdown,
      selecteditem: slcFarmOwnerShip,
      hint: "Select Farm OwnerShip",
      onChanged: (value) {
        setState(() {
          slcFarmOwnerShip = value!;
          for (int i = 0; i < farmOwnerShipUIModel.length; i++) {
            if (value == farmOwnerShipUIModel[i].name) {
              valFarmOwnerShip = farmOwnerShipUIModel[i].value;
            }
          }
        });
      },
    ));

    listings.add(txt_label_mandatory(
        "Farmer Registration Type", Colors.black, 15.0, false));
    listings.add(singlesearchDropdown(
      itemlist: farmerTypeDropdown,
      selecteditem: slcFarmerType,
      hint: "Select Farmer Registration Type ",
      onChanged: (value) {
        setState(() {
          slcFarmerType = value!;
          companyNameController.text = "";
          certificateController.text = "";
          pINController.text = "";
          selectedDate = "";
          ageController.text = "";
          nationalIDController.text = "";

          for (int i = 0; i < farmerTypeUIModel.length; i++) {
            if (value == farmerTypeUIModel[i].name) {
              valFarmerType = farmerTypeUIModel[i].value;
              if (valFarmerType == "1") {
                selectedValue = '';
                selectedGender = "";
                individualType = false;
              } else {
                selectedValue = 'option1';
                selectedGender = "1";
                individualType = true;
              }
            }
          }
        });
      },
    ));

    listings.add(txt_label("KRA PIN", Colors.black, 14.0, false));
    listings.add(
        txtFieldAlphanumericWithoutSymbol("KRA PIN", pINController, true, 11));

    if (valFarmerType == '1') {
      listings
          .add(txt_label_mandatory("Company Name", Colors.black, 14.0, false));
      listings.add(
          txtfield_dynamic("Company Name", companyNameController, true, 30));

      listings.add(txt_label_mandatory(
          "Registration Certificate", Colors.black, 14.0, false));
      listings.add(txtfield_dynamic(
          "Registration Certificate", certificateController, true, 30));
    }

    listings.add(txt_label_mandatory("Farmer Name", Colors.black, 14.0, false));
    listings
        .add(txtfield_dynamic("Farmer Name", farmerNameController, true, 30));

    listings.add(txt_label("Farmer Trace Code", Colors.black, 14.0, false));
    listings.add(cardlable_dynamic(farmerTraceCode.toString()));
    if (valFarmerType == '0') {
      listings.add(txt_label_mandatory('Gender', Colors.black, 14.0, false));
    } else {
      listings.add(txt_label('Gender', Colors.black, 14.0, false));
    }
    listings.add(radio_dynamic(
        map: genderList,
        selectedKey: selectedValue,
        onChange: (value) {
          setState(() {
            selectedValue = value;
            if (value == "option1") {
              selectedValue = "option1";
              selectedGender = "1";
            } else {
              selectedValue = "option2";
              selectedGender = "0";
            }
          });
        }));

    listings.add(individualType
        ? txt_label_mandatory("Date of Birth", Colors.black, 14.0, false)
        : Container());
    listings.add(!individualType
        ? txt_label("Date of Birth", Colors.black, 14.0, false)
        : Container());
    listings.add(selectDate(
        context1: context,
        slctdate: selectedDate,
        onConfirm: (date) => setState(
              () {
                selectedDate = DateFormat('dd-MM-yyyy').format(date);
                formatDate = DateFormat('yyyy-MM-dd').format(date);
                calculateAge(date);
              },
            )));

    listings.add(individualType
        ? txt_label_mandatory("Age", Colors.black, 14.0, false)
        : Container());
    listings.add(!individualType
        ? txt_label("Age", Colors.black, 14.0, false)
        : Container());
    listings.add(
        txtFieldOnlyIntegerWithoutLeadingZero("Age", ageController, false, 4));

    listings.add(individualType
        ? txt_label(
            "National ID / Passport", Colors.black, 14.0, false)
        : Container());
    listings.add(!individualType
        ? txt_label("National ID / Passport", Colors.black, 14.0, false)
        : Container());
    listings.add(txtfield_digits_integer(
        "National ID / Passport", nationalIDController, true, 10));

    listings
        .add(txt_label_mandatory("Phone Number", Colors.black, 14.0, false));
    listings.add(txtfield_digits_integer(
        "Phone Number", phoneNumberController, true, 10));
    /*  listings
        .add(txt_label_mandatory("Crop Category", Colors.black, 15.0, false));
    listings.add(multisearchDropdownHint(
      itemlist: cropCategoryDropdown,
      selectedlist: valCropCategoryList,
      hint: "Select the Option",
      onChanged: (item) {
        setState(() {
          cropNameLoaded = false;
          cropCodeLoaded = false;
          valCropNameList.clear();
          valCropCategory = "";
          String values = '';
          String cropValue = "";
          String quotation = "'";
          for (int i = 0; i < cropCategoryUIModel.length; i++) {
            for (int j = 0; j < item.length; j++) {
              String name = item[j].toString();
              if (name == cropCategoryUIModel[i].name) {
                String value = cropCategoryUIModel[i].value;
                if (item.length == 0) {
                  values = value;
                  cropValue = value;
                } else {
                  values = values + ',' + value;
                  print("values_values" + values);
                  cropValue = values + quotation + ',' + quotation + value;
                  print("cropValue_cropValue" + cropValue.toString());
                }

                valCropCategory = values;
                cropName(cropValue);
              }
            }
          }
        });
      },
    ));*/
    listings
        .add(txt_label_mandatory("Crop Category", Colors.black, 15.0, false));
    listings.add(multisearchDropdownHint(
      itemlist: cropCategoryDropdown,
      selectedlist: valCropCategoryList,
      hint: "Select Crop Category",
      onChanged: (item) {
        setState(() {
          valCropCategoryList = item;
          cropNameLoaded = false;
          valCropNameList.clear();
          valCropName = "";
          valCropHSCode = "";
          valVarietyList.clear();
          valVariety="";
          cropVarietyLoad=false;
          String values = '';
          String cropValue = "";
          String quotation = "'";
          for (int i = 0; i < cropCategoryUIModel.length; i++) {
            for (int j = 0; j < item.length; j++) {
              String name = item[j].toString();
              if (name == cropCategoryUIModel[i].name) {
                String value = cropCategoryUIModel[i].value;

                if (values == "") {
                  values = value;
                  cropValue = value;
                } else {
                  values = values + ',' + value;
                  cropValue = cropValue + quotation + ',' + quotation + value;
                }

                valCropCategory = values;
                // valCropHSCode = valCropCategory;
              }
            }
          }
          cropName(cropValue);
        });
      },
    ));

    listings.add(cropNameLoaded
        ? txt_label_mandatory("Crop Name", Colors.black, 15.0, false)
        : Container());
    listings.add(cropNameLoaded
        ? multisearchDropdownHint(
            itemlist: cropNameDropdown,
            selectedlist: valCropNameList,
            hint: "Select Crop Name",
            onChanged: (item) {
              setState(() {
                valCropHSCode = "";
                valVarietyList.clear();
                valVariety="";
                cropVarietyLoad=false;
                valCropNameList = item;
                String values = '';
                String cropNameValue = "";
                String quotation = "'";
                for (int i = 0; i < cropNameUIModel.length; i++) {
                  for (int j = 0; j < item.length; j++) {
                    String name = item[j].toString();
                    if (name == cropNameUIModel[i].name) {
                      String value = cropNameUIModel[i].value;
                      if (values == "") {
                        values = value;
                        cropNameValue=value;
                      } else {
                        values = values + ',' + value;
                        cropNameValue = cropNameValue + quotation + ',' + quotation + value;
                      }
                      valCropName = values;
                    }
                  }}
                getVariety(cropNameValue);
              });
            },
          )
        : Container());


    listings.add(cropVarietyLoad
        ? txt_label_mandatory("Crop Variety", Colors.black, 15.0, false)
        : Container());
    listings.add(cropVarietyLoad
        ? multisearchDropdownHint(
      itemlist: varietyDropdown,
      selectedlist: valVarietyList,
      hint: "Select Crop Variety",
      onChanged: (item) {
        setState(() {
          valVarietyList = item;
          String values = '';
          String cropVarietyValue = "";
          valVariety="";
          valCropHSCode="";
          for (int i = 0; i < varietyUIModel.length; i++) {
            for (int j = 0; j < item.length; j++) {
              String name = item[j].toString();
              if (name == varietyUIModel[i].name) {
                String value = varietyUIModel[i].value;
                String value1 = varietyUIModel[i].value2;
                if (values == "") {
                  values = value;
                } else {
                  values = values + ',' + value;
                }
                valVariety = values;

                if (cropVarietyValue == "") {
                  cropVarietyValue = value1;
                } else {
                  cropVarietyValue = cropVarietyValue + ',' + value1;
                }
                valCropHSCode = cropVarietyValue;
              }
            }
          }
        });
      },
    )
        : Container());


    listings.add(txt_label("Crop HS Code", Colors.black, 14.0, false));
    listings.add(cardlable_dynamic(valCropHSCode.toString()));

    listings.add(txt_label_mandatory("Country", Colors.black, 15.0, false));
    listings.add(singlesearchDropdown(
      itemlist: countryDropdown,
      selecteditem: slcCountry,
      hint: "Select Country",
      onChanged: (value) {
        setState(() {
          slcCountry = value!;
          countryLoaded = false;
          subCountyLoaded = false;
          wardLoaded = false;
          villageLoaded = false;
          slcWard = "";
          slcSubCounty = "";
          slcCounty = "";
          slcVillage = "";
          newVillage = false;
          villageNameController.text = "";
          click = "+";

          for (int i = 0; i < countryUIModel.length; i++) {
            if (value == countryUIModel[i].name) {
              valCountry = countryUIModel[i].value;
              countySearch(valCountry);
            }
          }
        });
      },
    ));

    listings.add(countryLoaded
        ? txt_label_mandatory("County", Colors.black, 15.0, false)
        : Container());
    listings.add(countryLoaded
        ? singlesearchDropdown(
            itemlist: countyDropdown,
            selecteditem: slcCounty,
            hint: "Select County",
            onChanged: (value) {
              setState(() {
                slcCounty = value!;
                subCountyLoaded = false;
                wardLoaded = false;
                villageLoaded = false;
                slcWard = "";
                slcVillage = "";
                slcSubCounty = "";
                newVillage = false;
                villageNameController.text = "";
                click = "+";

                for (int i = 0; i < countyUIModel.length; i++) {
                  if (value == countyUIModel[i].name) {
                    valCounty = countyUIModel[i].value;
                    subCounty(valCounty);
                  }
                }
              });
            },
          )
        : Container());

    listings.add(subCountyLoaded
        ? txt_label_mandatory("Sub County", Colors.black, 15.0, false)
        : Container());
    listings.add(subCountyLoaded
        ? singlesearchDropdown(
            itemlist: subCountryDropdown,
            selecteditem: slcSubCounty,
            hint: "Select Sub County",
            onChanged: (value) {
              setState(() {
                slcSubCounty = value!;
                wardLoaded = false;
                villageLoaded = false;
                slcWard = "";
                slcVillage = "";
                newVillage = false;
                villageNameController.text = "";
                click = "+";

                for (int i = 0; i < subCountyUIModel.length; i++) {
                  if (value == subCountyUIModel[i].name) {
                    valSubCounty = subCountyUIModel[i].value;
                    ward(valSubCounty);
                  }
                }
              });
            },
          )
        : Container());

    listings.add(wardLoaded
        ? txt_label_mandatory("Ward", Colors.black, 15.0, false)
        : Container());
    listings.add(wardLoaded
        ? singlesearchDropdown(
            itemlist: wardDropdown,
            selecteditem: slcWard,
            hint: "Select Ward",
            onChanged: (value) {
              setState(() {
                slcWard = value!;
                villageLoaded = false;
                slcVillage = "";
                newVillage = false;
                villageNameController.text = "";
                click = "+";
                for (int i = 0; i < wardUIModel.length; i++) {
                  if (value == wardUIModel[i].name) {
                    valWard = wardUIModel[i].value;
                    village(valWard);
                    villageNameCheck(valWard);
                  }
                }
              });
            },
          )
        : Container());

/*    listings.add(villageLoaded
        ? txt_label_mandatory("Village", Colors.black, 15.0, false)
        : Container());
    listings.add(villageLoaded
        ? singlesearchDropdown(
            itemlist: villageDropdown,
            selecteditem: slcVillage,
            hint: "Select Village",
            onChanged: (value) {
              setState(() {
                slcVillage = value!;
                for (int i = 0; i < villageUIModel.length; i++) {
                  if (value == villageUIModel[i].name) {
                    valVillage = villageUIModel[i].value;
                  }
                }
              });
            },
            onClear: () {
              slcVillage = "";
              valVillage = "";
            })
        : Container());*/

    listings.add(wardLoaded
        ? txt_label_mandatory("Village", Colors.black, 14.0, false)
        : Container());
    listings.add(wardLoaded
        ? parallelWidget(
            function: () {
              if (click == "+") {
                setState(() {
                  click = "X";
                  newVillage = true;
                  slcVillage = "";
                  valVillage = "";
                });
              } else if (click == "X") {
                setState(() {
                  click = "+";
                  newVillage = false;
                  villageNameController.text = "";
                });
              }
            },
            select: newVillage,
            label: click,
            itemlist: villageDropdown,
            selecteditem: slcVillage,
            hint: "Select Village",
            onChanged: (value) {
              setState(() {
                slcVillage = value!;
                villageNameController.text = "";
                for (int i = 0; i < villageUIModel.length; i++) {
                  if (value == villageUIModel[i].name) {
                    valVillage = villageUIModel[i].value;
                  }
                }
              });
            },
            labelText: "Village",
            txtcontroller: villageNameController,
            focus: true,
            length: 50)
        : Container());

    listings.add(txt_label("Farmer Photo", Colors.black, 14.0, false));
    listings.add(img_picker(
        label: "Farmer Photo",
        onPressed: getFarmerImage,
        filename: farmerImageFile,
        ondelete: ondeleteFarmerImage));

    listings
        .add(txt_label("Photo of the National ID", Colors.black, 14.0, false));
    listings.add(img_picker(
        label: "Photo of the National ID \*",
        onPressed: ImageDialog,
        filename: nationalIdImageFile,
        ondelete: ondeleteNationalIDImage));

    listings.add(txt_label("Email", Colors.black, 14.0, false));
    listings.add(txtfield_dynamic("Email", emailController, true, 50));

    // listings
    //     .add(txt_label("Socio-Economic Information", Colors.green, 18.0, true));

    // listings.add(txt_label("No of Family Members", Colors.black, 14.0, false));
    // listings.add(txtfield_digits_integer(
    //     "No of Family Members", numberOfMembersController, true, 10));

    // listings.add(txt_label("Adult (Above 18 Yrs)", Colors.black, 14.0, false));
    // listings.add(txtfield_digits_integer(
    //     "Adult (Above 18 Yrs)", adultController, true, 10));

    // listings.add(txt_label(
    //     "Number of School Going Children", Colors.black, 14.0, false));
    // listings.add(txtfield_digits_integer(
    //     "Number of School Going Children", schoolChildrenController, true, 10));

    // listings
    //     .add(txt_label("Children (Below 18 Yrs)", Colors.black, 14.0, false));
    // listings.add(txtfield_digits_integer(
    //     "Children (Below 18 Yrs)", childrenController, true, 10));

    // listings.add(
    //     txt_label("Highest Level of Education", Colors.black, 14.0, false));
    //
    // listings.add(singlesearchDropdown(
    //   itemlist: highestEduDropdown,
    //   selecteditem: slcEducation,
    //   hint: "Select Education ",
    //   onChanged: (value) {
    //     setState(() {
    //       slcEducation = value!;
    //       for (int i = 0; i < highestEduUIModel.length; i++) {
    //         if (value == highestEduUIModel[i].name) {
    //           valEducation = highestEduUIModel[i].value;
    //         }
    //       }
    //     });
    //   },
    // ));
    // listings.add(txt_label("Asset Ownership", Colors.black, 15.0, false));
    // listings.add(multisearchDropdownHint(
    //   itemlist: assetOwnerDropdown,
    //   selectedlist: valAssetOwnerList,
    //   hint: "Select Asset Ownership",
    //   onChanged: (item) {
    //     setState(() {
    //       valAssetOwnerList = item;
    //       String values = '';
    //       /*  for (int i = 0; i < item.length; i++) {
    //         String value = assetOwnerUIModel[i].value;
    //         if (i == 0)
    //           values = value;
    //         else
    //           values = values + ',' + value;
    //         valAssetOwner = values;
    //       }*/
    //       for (int i = 0; i < assetOwnerUIModel.length; i++) {
    //         for (int j = 0; j < item.length; j++) {
    //           String name = item[j].toString();
    //           if (name == assetOwnerUIModel[i].name) {
    //             String value = assetOwnerUIModel[i].value;
    //             if (values == "") {
    //               values = value;
    //             } else {
    //               values = values + ',' + value;
    //             }
    //             valAssetOwner = values;
    //           }
    //         }
    //       }
    //     });
    //   },
    // ));

    // listings.add(txt_label('Do You Own House(s)', Colors.black, 14.0, false));
    // listings.add(radio_dynamic(
    //     map: housingList,
    //     selectedKey: selectedHousing,
    //     onChange: (value) {
    //       setState(() {
    //         selectedHousing = value;
    //         if (value == "option2") {
    //           selectedHousing = "option2";
    //           selectedHouseValue = "0";
    //           valHousingOwnerList.clear();
    //         } else {
    //           selectedHousing = "option1";
    //           selectedHouseValue = "1";
    //         }
    //       });
    //     }));

    listings.add(selectedHouseValue == "1"
        ? txt_label("Housing Ownership", Colors.black, 15.0, false)
        : Container());
    listings.add(selectedHouseValue == "1"
        ? multisearchDropdownHint(
            itemlist: housingOwnerDropdown,
            selectedlist: valHousingOwnerList,
            hint: "Select Housing Ownership",
            onChanged: (item) {
              setState(() {
                valHousingOwnerList = item;
                String values = '';
                /*  for (int i = 0; i < item.length; i++) {
                  String value = housingOwnerUIModel[i].value;
                  if (i == 0)
                    values = value;
                  else
                    values = values + ',' + value;
                  valHousingOwner = values;
                }*/

                for (int i = 0; i < housingOwnerUIModel.length; i++) {
                  for (int j = 0; j < item.length; j++) {
                    String name = item[j].toString();
                    if (name == housingOwnerUIModel[i].name) {
                      String value = housingOwnerUIModel[i].value;
                      if (values == "") {
                        values = value;
                      } else {
                        values = values + ',' + value;
                      }
                      valHousingOwner = values;
                    }
                  }
                }
              });
            },
          )
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

  void calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    ageController.text = age.toString();
  }

  Future getFarmerImage() async {
    var image = await ImagePicker.platform
        .pickImage(source: ImageSource.camera, imageQuality: 20);
    setState(() {
      farmerImageFile = File(image!.path);
    });
  }

  Future getNationalIDImage() async {
    var image = await ImagePicker.platform
        .pickImage(source: ImageSource.camera, imageQuality: 20);
    setState(() {
      nationalIdImageFile = File(image!.path);
    });
    final now = new DateTime.now();
    nationalIDMsgNo = DateFormat('yyyyMMddHHmmss').format(now);
  }

  void ondeleteFarmerImage() {
    if (farmerImageFile != null) {
      setState(() {
        farmerImageFile = null;
      });
    }
  }

  void ondeleteNationalIDImage() {
    if (nationalIdImageFile != null) {
      setState(() {
        nationalIdImageFile = null;
      });
    }
  }

  void btnSubmit() {
    if (farmerImageFile != null) {
      farmerPhotoPath = farmerImageFile!.path;
    }

    if (nationalIdImageFile != null) {
      nationalPhotoPath = nationalIdImageFile!.path;
    }
    if(slcFarmerCategory.isEmpty){
      alertPopup(context, "Farmer Category should not be empty");
    }
   else if (slcFarmOwnerShip.isEmpty) {
      alertPopup(context, "Farm OwnerShip should not be empty");
    } else if (slcFarmerType.isEmpty) {
      alertPopup(context, "Farmer Registration Type should not be empty");
    }
   // else if (pINController.text.isEmpty) {
   //    alertPopup(context, "KRA PIN shou  ld not be empty");
   //  }
   else {
      //validationKRA();
      farmerTypeValidation();
    }
  }

  void validationKRA() {
    bool validEndLetter = false;
    bool validNumber = false;
    String endLetter = "";

    RegExp _isLetterRegExp = RegExp(r'[A-Z]', caseSensitive: true);
    RegExp letterOnly = RegExp(r'^-?[0-9]+$');
    bool isLetter(String letter) => _isLetterRegExp.hasMatch(letter);
    bool isLetterOnly(String letter) => letterOnly.hasMatch(letter);

    String startLetter =
        pINController.text.characters.characterAt(0).toString();
    if (pINController.text.length > 10) {
      endLetter = pINController.text.characters.characterAt(10).toString();
      validEndLetter = isLetter(endLetter);
    }

    if (pINController.text.length > 1 && pINController.text.length > 10) {
      String kraPinSubString = pINController.text.toString();
      kraPinSubString =
          kraPinSubString.substring(1, kraPinSubString.length - 1);
      validNumber = isLetterOnly(kraPinSubString);
      print("kraPinSubString" + kraPinSubString.toString());

      //validNumber = kraPinSubString is int;
      //print("validNumber")
    }
    if (valFarmerType == '0') {
      if (startLetter != "A") {
        alertPopup(context, "KRA PIN should start with A");
      } else if (pINController.text.length < 11) {
        alertPopup(context, "KRA PIN Length should be 11");
      } else if (!validEndLetter) {
        alertPopup(context, "KRA PIN should end with upper-case letter");
      } else if (!validNumber) {
        alertPopup(context,
            "In KRA PIN expect for first and last digit, others should be numeric");
      } else {
        farmerTypeValidation();
      }
    } else if (valFarmerType == '1') {
      if (startLetter != "P") {
        alertPopup(context, "KRA PIN should start with P");
      } else if (pINController.text.length < 11) {
        alertPopup(context, "KRA PIN Length should be 11");
      } else if (!validEndLetter) {
        alertPopup(context, "KRA PIN should end with upper-case letter");
      } else if (!validNumber) {
        alertPopup(context,
            "In KRA PIN expect for first and last digit, others should be numeric");
      } else {
        farmerTypeValidation();
      }
    }
  }

  void farmerTypeValidation() {
    if (valFarmerType == '1') {
      if (companyNameController.text.isEmpty) {
        alertPopup(context, "Company Name should not be empty");
      } else if (certificateController.text.isEmpty) {
        alertPopup(context, "Registration Certificate should not be empty");
      } else {
        farmerCategoryValidation();
      }
    } else {
      farmerCategoryValidation();
    }
  }

  void farmerCategoryValidation() {
    int getAge = 0;
    if (ageController.text.isNotEmpty) {
      int age = int.parse(ageController.text);
      setState(() {
        getAge = age;
      });
    }
    if (farmerNameController.text.isEmpty) {
      alertPopup(context, "Farmer Name should not be empty");
    } else if (selectedDate.isEmpty && valFarmerType == "0") {
      alertPopup(context, "Date of Birth should not be empty");
    } else if (ageController.text.isEmpty && valFarmerType == "0") {
      alertPopup(context, "Age should not be empty");
    } else if (getAge < 18 && selectedDate.isNotEmpty) {
      alertPopup(context, "Age should not be less than 18");
    } else {
      validateNationalId();
    }
  }

  void validateNationalId() {
    bool nationalIDExist = false;
    for (int a = 0; a < farmerData.length; a++) {
      print("farmerDatanationalID" + farmerData[a].nationalID.toString());
      print("farmerDataphoneNo" + farmerData[a].phoneNo.toString());
      if (nationalIDController.text.isNotEmpty) {
        if (farmerNameController.text.isNotEmpty) {
          if (farmerData[a].nationalID == nationalIDController.text) {
            nationalIDExist = true;
          }
        }
      }
    }
    if (nationalIDExist) {
      alertPopup(context, "National ID already exists");
    } else if (phoneNumberController.text.isEmpty) {
      alertPopup(context, "Phone Number should not be empty");
    } else {
      validatePhoneNumber();
    }
  }

  void validatePhoneNumber() {
    bool phoneExist = false;
    for (int a = 0; a < farmerData.length; a++) {
      print("farmerDatanationalID" + farmerData[a].nationalID.toString());
      if (phoneNumberController.text.isNotEmpty) {
        if (farmerData[a].phoneNo == phoneNumberController.text) {
          phoneExist = true;
        }
      }
    }

    if (phoneExist) {
      alertPopup(context, "Phone Number already exists");
    } else {
      farmerValidation();
    }
  }

  void farmerValidation() {
    if (valCropCategory.isEmpty) {
      alertPopup(context, "Crop Category should not be empty");
    } else if (valCropName.isEmpty) {
      alertPopup(context, "Crop Name should not be empty");
    }

    else if(valVariety.isEmpty){
      alertPopup(context, "Crop Variety should not be empty");
    }
    else if (slcCountry.isEmpty) {
      alertPopup(context, "Country should not be empty");
    } else if (slcCounty.isEmpty) {
      alertPopup(context, "County should not be empty");
    } else if (slcSubCounty.isEmpty) {
      alertPopup(context, "Sub County should not be empty");
    } else if (slcWard.isEmpty) {
      alertPopup(context, "Ward should not be empty");
    } else {
      villageValidation();
    }
  }

  bool equalsIgnoreCase(String string1, String string2) {
    return string1.toLowerCase() == string2.toLowerCase();
  }

  void villageNameValidation() {
    bool villageNameExist = false;
    for (int a = 0; a < villageNameDetailList.length; a++) {
      if (equalsIgnoreCase(
          villageNameDetailList[a].name!, villageNameController.text)) {
        setState(() {
          villageNameExist = true;
        });
      }
    }
    if (villageNameExist) {
      alertPopup(context, "Village Name already exists");
    } else {
      nationalIDValidation();
    }
  }

  void villageValidation() async {
    if (newVillage) {
      if (villageNameController.text.isEmpty) {
        alertPopup(context, "Village should not be empty");
      } else {
        villageNameValidation();
      }
    } else {
      if (slcVillage.isEmpty) {
        alertPopup(context, "Village should not be empty");
      } else {
        nationalIDValidation();
      }
    }
  }

  void nationalIDValidation() async {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailController.text);
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern.toString());
/*
    if (nationalIdImageFile == null) {
      alertPopup(context, "National ID Photo should not be empty");
    } else*/
    if (emailController.text.isNotEmpty) {
      if (!emailValid) {
        alertPopup(context, "Enter Valid Email");
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
            farmerRegistration();
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

  Future<void> farmerRegistration() async {
    var db = DatabaseHelper();
    final now = new DateTime.now();
    String txntime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String msgNo = DateFormat('yyyyMMddHHmmss').format(now);

    String? agentid = await SecureStorage().readSecureData("agentId");
    String? agentToken =await SecureStorage().readSecureData("agentToken");
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
            farmerTraceCode +
            '\')';

    int txnsucc = await db.RawInsert(insqry);
    print(txnsucc);

    AppDatas datas = new AppDatas();
    await db.saveCustTransaction(txntime, datas.txnFarmerRegistration,
        farmerTraceCode.toString(), '', '', '');
    print("valHighestEduLev" + valHighestEduLev);

    if (newVillage) {
      var currentTime = new DateTime.now();
      var formatter = new DateFormat('HHmmss');
      String formatValue = formatter.format(currentTime);
      valVillage = formatValue;
      slcVillage = villageNameController.text;
    }

    int saveFarmer = await db.saveFarmerRegistration(
        farmerNameController.text,
        farmerTraceCode,
        selectedGender,
        ageController.text,
        phoneNumberController.text,
        valCropName,
        valCountry,
        valCounty,
        valSubCounty,
        valWard,
        valVillage,
        farmerPhotoPath,
        nationalPhotoPath,
        nationalIDMsgNo,
        emailController.text,
        numberOfMembersController.text,
        adultController.text,
        schoolChildrenController.text,
        childrenController.text,
        valEducation,
        valAssetOwner,
       // selectedHouseValue,
        '',
        valHousingOwner,
        "1",
        msgNo,
        longitude,
        latitude,
        nationalIDController.text,
        valCropCategory,
        "",
        "",
        valFarmerCategory,
        slcVillage,
        companyNameController.text,
        // ctName as company name
        certificateController.text,
        //objective as registration certificate
        pINController.text,
        // trader as KPA PIN
        valFarmerType,
        selectedDate,
        valVariety,
       valFarmOwnerShip); // police_station as farmOwnership

    print("selectedGender" + selectedGender);
    print("valEducation" + valEducation);
    print("valAssetOwner" + valAssetOwner);

    db.UpdateTableValue(
        'farmer', 'isSynched', '0', 'farmerId', farmerTraceCode.toString());

    if (curIdLimited != 0) {
      db.UpdateTableValue(
          'agentMaster', 'curIdSeqF', farmerId.toString(), 'agentId', agentId);
      db.UpdateTableValue(
          'agentMaster', 'resIdSeqF', resId.toString(), 'agentId', agentId);
      db.UpdateTableValue('agentMaster', 'curIdLimitF', curIdLimited.toString(),
          'agentId', agentId);
    } else {
      print("curIdLimited_nZero");
      db.UpdateTableValue(
          'agentMaster', 'curIdSeqF', farmerId.toString(), 'agentId', agentId);
    }

    TxnExecutor txnExecutor = new TxnExecutor();
    txnExecutor.CheckCustTrasactionTable();

    Alert(
      context: context,
      type: AlertType.info,
      title: "Transaction Successful",
      desc: "Farmer Registration done Successfully",
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

  ImageDialog() {
    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black87,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      animationDuration: Duration(milliseconds: 400),
    );

    Alert(
        context: context,
        style: alertStyle,
        title: "Pick Image",
        desc: "Choose",
        buttons: [
          DialogButton(
            child: Text(
              "Gallery",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () {
              setState(() {
                getImageFromGallery();
                Navigator.pop(context);
              });
            },
            color: Colors.deepOrange,
          ),
          DialogButton(
            child: Text(
              "Camera",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () {
              getImageFromCamera();
              Navigator.pop(context);
            },
            color: Colors.green,
          )
        ]).show();
  }

  Future getImageFromCamera() async {
    var image = await ImagePicker.platform
        .pickImage(source: ImageSource.camera, imageQuality: 30);
    setState(() {
      nationalIdImageFile = File(image!.path);
    });
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.platform
        .pickImage(source: ImageSource.gallery, imageQuality: 30);
    setState(() {
      setState(() {
        nationalIdImageFile = File(image!.path);
      });
    });
  }
}

class FarmerData {
  String? phoneNo;
  String? nationalID;

  FarmerData(this.phoneNo, this.nationalID);
}
