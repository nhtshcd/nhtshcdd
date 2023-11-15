import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nhts/Database/Databasehelper.dart';
import 'package:nhts/Model/UIModel.dart';
import 'package:nhts/Plugins/TxnExecutor.dart';
import 'package:nhts/Screens/geoplottingfarm.dart';
import 'package:nhts/Utils/MandatoryDatas.dart';
import 'package:nhts/Utils/dynamicfields.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


import '../Utils/secure_storage.dart';
import '../login.dart';

class FarmRegistration extends StatefulWidget {
  @override
  _FarmRegistration createState() => _FarmRegistration();
}

class _FarmRegistration extends State<FarmRegistration> {
  final Map<String, String> addressList = {
    'option1': "Yes",
    'option2': "No",
  };

  File? imageFileFarm, imageDocumentFarm;

  List<DropdownMenuItem> farmerDropdownItem = [];
  List<DropdownMenuItem> villageDropdownItem = [];
  List<DropdownMenuItem> landOwnerShipDropdownItem = [];
  List<DropdownMenuItem> topographyDropdownItem = [];
  List<DropdownMenuItem> gradientDropdownItem = [];
  List<DropdownMenuItem> countryDropdown = [];
  List<DropdownMenuItem> countyDropdown = [];
  List<DropdownMenuItem> subCountryDropdown = [];
  List<DropdownMenuItem> villageLocationDropdown = [];
  List<DropdownMenuItem> wardDropdown = [];

  List<UImodel3> farmerUIModel = [];
  List<UImodel> villageUIModel = [];
  List<UImodel> landOwnerShipUIModel = [];
  List<UImodel> topographyUIModel = [];
  List<UImodel> gradientUIModel = [];

  List<UImodel> countryUIModel = [];
  List<UImodel> countyUIModel = [];
  List<UImodel> subCountyUIModel = [];
  List<UImodel> wardUIModel = [];
  List<UImodel> villageLocationUIModel = [];
  List<DropdownModelFarmer> farmeritems = [];

/*  DropdownModel? slctFarmers;*/
  DropdownModelFarmer? slctFarmers;

  String slcFarmer = "",
      slcVillage = "",
      slcLandOwnerShip = "",
      slcTopography = "",
      slcGradient = "";
  String valFarmer = "",
      valVillage = "",
      valLandOwnerShip = "",
      valTopography = "",
      valGradient = "";
  String farmId = "", totalLand = "";
  String servicePointId = "",
      seasonCode = "",
      agentId = '',
      latitude = "",
      longitude = "";
  String CountValue = "";
  String selectedOption = 'option2', selectedAddressValue = "0";
  String farmPhotoPath = "", documentsPhotoPath = "";
  String ruexit = 'Are you sure want to cancel?';
  String exit = 'Cancel';
  String no = 'No', yes = 'Yes';
  String slcCountry = "",
      slcLocationVillage = "",
      slcCounty = "",
      slcSubCounty = "",
      slcWard = "";
  String valCountry = "",
      valLocationVillage = "",
      valSubCounty = "",
      valCounty = "",
      valWard = "";
/*  String add = "+", cancel = "✕";*/
  String click = "+";
  String farmCount = "";

  bool farmerIDAdded = false;
  bool farmerLoaded = false;
  bool farmValueAdded = false;
  bool farmIDLoaded = false;
  bool newVillage = false;
  bool areaPlotted = false;
  List<ClassName> farmDetailList = [];
  List<ClassName> villageNameDetailList = [];
  int fCount = 0;

  TextEditingController farmNameController = new TextEditingController();
  TextEditingController villageNameController = new TextEditingController();
  TextEditingController proposedPlantingController =
      new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController landRegistrationController =
      new TextEditingController();
  TextEditingController totalLandController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initValues();
    getLocation();
    getClientData();
    countrySearch();

    /*totalLandController.addListener(() {
      if (totalLandController.text.isNotEmpty) {
        double getArea = double.parse(totalLandController.text);
        if (getArea > 0.00) {
          areaPlotted = true;
          Geoploattingfarmlist.clear();
        } else {
          setState(() {
            areaPlotted = false;
          });
        }
      }
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
          title: Text('Add Farm',
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

  getClientData() async {
    List<Map> agents = await db.RawQuery('SELECT * FROM agentMaster');
    seasonCode = agents[0]['currentSeasonCode'];
    servicePointId = agents[0]['servicePointId'];
    agentId = agents[0]['agentId'];
  }

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    latitude = position.latitude.toString();
    longitude = position.longitude.toString();
  }

  Future<void> initValues() async {
    String qryVillagelist =
        'Select distinct v.villCode,v.villName from villageList as v inner join farmer_master as f on f.villageId =v.villCode and villName!=""';

    print("qryVillagelist_qryVillagelist" + qryVillagelist.toString());
    List villagesList = await db.RawQuery(qryVillagelist);

    villageUIModel = [];
    villageDropdownItem = [];
    villageDropdownItem.clear();

    for (int i = 0; i < villagesList.length; i++) {
      String villageName = villagesList[i]["villName"].toString();
      String villageCode = villagesList[i]["villCode"].toString();
      var uimodel = new UImodel(villageName, villageCode);
      villageUIModel.add(uimodel);
      setState(() {
        villageDropdownItem.add(DropdownMenuItem(
          child: Text(villageName),
          value: villageName,
        ));
      });
    }

    String qryLandOwnerShip =
        'select * from animalCatalog where catalog_code = \'' + "57" + '\'';
    List landOwnerShipLst = await db.RawQuery(qryLandOwnerShip);

    landOwnerShipDropdownItem = [];
    landOwnerShipUIModel = [];
    landOwnerShipDropdownItem.clear();

    for (int i = 0; i < landOwnerShipLst.length; i++) {
      String propertyValue = landOwnerShipLst[i]["property_value"].toString();
      String dispSEQ = landOwnerShipLst[i]["DISP_SEQ"].toString();
      var uimodel = new UImodel(propertyValue, dispSEQ);
      landOwnerShipUIModel.add(uimodel);
      setState(() {
        landOwnerShipDropdownItem.add(DropdownMenuItem(
          child: Text(propertyValue),
          value: propertyValue,
        ));
      });
    }

    String qryTopography =
        'select * from animalCatalog where catalog_code = \'39\'';
    List topographyList = await db.RawQuery(qryTopography);

    topographyDropdownItem = [];
    topographyUIModel = [];
    topographyDropdownItem.clear();

    for (int i = 0; i < topographyList.length; i++) {
      String propertyValue = topographyList[i]["property_value"].toString();
      String dispSEQ = topographyList[i]["DISP_SEQ"].toString();
      var uimodel = new UImodel(propertyValue, dispSEQ);
      topographyUIModel.add(uimodel);
      setState(() {
        topographyDropdownItem.add(DropdownMenuItem(
          child: Text(propertyValue),
          value: propertyValue,
        ));
      });
    }

    String qryGradient =
        'select * from animalCatalog where catalog_code = \'56\'';
    List gradientlist = await db.RawQuery(qryGradient);

    gradientDropdownItem = [];
    gradientDropdownItem.clear();
    gradientUIModel = [];

    for (int i = 0; i < gradientlist.length; i++) {
      String propertyValue = gradientlist[i]["property_value"].toString();
      String dispSEQ = gradientlist[i]["DISP_SEQ"].toString();
      var uimodel = new UImodel(propertyValue, dispSEQ);
      gradientUIModel.add(uimodel);
      setState(() {
        gradientDropdownItem.add(DropdownMenuItem(
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

  farmerSearch(String villageCode) async {
    String qryFarmerList =
        'select distinct farmerId,fName,idProofVal,trader from farmer_master where villageId = \'' +
            villageCode +
            '\'';

    List farmersList = await db.RawQuery(qryFarmerList);

    farmerUIModel = [];
    farmeritems.clear();

    for (int i = 0; i < farmersList.length; i++) {
      String property_value = farmersList[i]["fName"].toString();
      String DISP_SEQ = farmersList[i]["farmerId"].toString();
      String idProofVal = farmersList[i]["idProofVal"].toString();
      String kraPin = farmersList[i]["trader"].toString();

      var uimodel = new UImodel3(
          property_value + " - " + DISP_SEQ, DISP_SEQ, idProofVal, kraPin);
      farmerUIModel.add(uimodel);
      setState(() {
        farmeritems.add(DropdownModelFarmer(
            property_value + " - " + DISP_SEQ, DISP_SEQ, idProofVal, kraPin));
        //prooflist.add(property_value);
      });
    }
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        slcFarmer = "";
        farmerLoaded = true;
      });
    });
  }

  /* getDetail(String farmerCode) async {
    String farmNameQry =
        'select distinct farmIDT,farmName,farmerId,farmRegNo from farm  where farmerId= \'' +
            farmerCode +
            '\'';

    print("farmNameQry_farmNameQry" + farmNameQry.toString());

    List farmNameList = await db.RawQuery(farmNameQry);
    print("farmNameList" + farmNameList.toString());
    farmDetailList.clear();
    for (int i = 0; i < farmNameList.length; i++) {
      String farmName = farmNameList[i]["farmName"].toString();
      String farmIDT = farmNameList[i]["farmIDT"].toString();
      String farmRegNo = farmNameList[i]["farmRegNo"].toString();

      setState(() {
        var farmList = new ClassName(farmName, farmIDT, farmRegNo);
        farmDetailList.add(farmList);
      });
    }
  }*/

  getFarmCount(String farmerId) async {
    String countQry =
        'select MAX(CAST(farmCount AS Int)) as farmCount from farm where farmerId=\'' +
            farmerId +
            '\'';

    print("countQry_countQry" + countQry.toString());

    List farmCountList = await db.RawQuery(countQry);
    print("farmCountList_farmCountList" + farmCountList.toString());

    try {
      if (farmCountList.length > 0) {
        String Count = farmCountList[0]["farmCount"].toString();
        print("Count_Count" + Count.toString());
        CountValue = Count;
      }
    } catch (e) {}
  }

  farmIDGenerated(String farmerId) async {
    String farmQry =
        'select  cn.[countryCode],cn.[countryName],s.stateName,s.[stateCode],dist.[districtName],dist.[districtCode],c.[cityCode],c.[cityName],v.[villCode],v.[villName] from farmer_master fm '
                'inner join villageList v on fm.[villageId] = v.[villCode] '
                'inner join cityList c on c.[cityCode]=v.[gpCode]'
                'inner join districtList dist on dist.[districtCode]=c.[districtCode]'
                'inner join stateList s on s.[stateCode]=dist.[stateCode] '
                'inner join countryList cn  on cn.[countryCode]=s.[countryCode] '
                'where fm.[farmerId]=\'' +
            farmerId +
            '\'';

    List farmIDGenerationList = await db.RawQuery(farmQry);
    print("farmIDGenerationList" + farmIDGenerationList.toString());
    for (int i = 0; i < farmIDGenerationList.length; i++) {
      String stateCode = farmIDGenerationList[i]["stateCode"].toString();
      String districtCode = farmIDGenerationList[i]["districtCode"].toString();
      String cityCode = farmIDGenerationList[i]["cityCode"].toString();
      String countryCode = farmIDGenerationList[i]["countryCode"].toString();
      String villageCode = farmIDGenerationList[i]["villCode"].toString();
      String countryName = farmIDGenerationList[i]["countryName"].toString();
      String stateName = farmIDGenerationList[i]["stateName"].toString();
      String cityName = farmIDGenerationList[i]["cityName"].toString();
      String districtName = farmIDGenerationList[i]["districtName"].toString();
      String villageName = farmIDGenerationList[i]["villName"].toString();

      setState(() {
        slcCountry = countryName;
        valCountry = countryCode;
        slcCounty = stateName;
        valCounty = stateCode;
        slcSubCounty = districtName;
        valSubCounty = districtCode;
        slcWard = cityName;
        valWard = cityCode;
        slcLocationVillage = villageName;
        valLocationVillage = villageCode;
      });
    }
    getFarmID();
  }

  getFarmID() async {
    print("CountValue_CountValue" + CountValue.toString());
    try {
      if (CountValue.length > 0) {
        int convertCount = int.parse(CountValue);
        int farmMAxCount = 0;
        String value = "";
        try {
          setState(() {
            farmMAxCount = convertCount + 1;
            value = farmMAxCount.toString();
            fCount = farmMAxCount;
          });
        } catch (e) {
          farmMAxCount = farmMAxCount + 1;
          value = farmMAxCount.toString();
          fCount = farmMAxCount;
        }
        while (value.length < 3) {
          value = '0' + value;
          farmCount = value;
        }
      } else {
        farmCount = "001";
        fCount = 1;
      }
    } catch (e) {
      farmCount = "001";
      fCount = 1;
    }

    print("_while_farmCount" + farmCount.toString());
    setState(() {
      String space = "_";
      farmId = valCounty +
          space +
          valSubCounty +
          space +
          valWard +
          space +
          valFarmer +
          space +
          farmCount;
      farmIDLoaded = true;
    });

    print("farmID_farmID" + farmId);
  }

  Future<void> countrySearch() async {
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
  }

  Future<void> village(cityCode) async {
    List villageList = await db.RawQuery(
        'select distinct * from villageList where gpCode =\'' +
            cityCode +
            '\' and villName!=""');
    villageLocationUIModel = [];
    villageLocationDropdown = [];
    villageLocationDropdown.clear();
    for (int i = 0; i < villageList.length; i++) {
      String propertyValue = villageList[i]["villName"].toString();
      String diSpSeq = villageList[i]["villCode"].toString();

      var uiModel = new UImodel(propertyValue, diSpSeq);
      villageLocationUIModel.add(uiModel);
      setState(() {
        villageLocationDropdown.add(DropdownMenuItem(
          child: Text(propertyValue),
          value: propertyValue,
        ));
      });
    }
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
  }

  List<Widget> getListings(BuildContext context) {
    List<Widget> listings = [];
    if (!farmerIDAdded) {
      listings.add(txt_label_mandatory("Village", Colors.black, 14.0, false));
      listings.add(singlesearchDropdown(
        itemlist: villageDropdownItem,
        selecteditem: slcVillage,
        hint: "Select Village",
        onChanged: (value) {
          try {
            setState(() {
              slcVillage = value!;
              slcFarmer = "";
              farmerLoaded = false;
              slctFarmers = null;
              for (int i = 0; i < villageUIModel.length; i++) {
                if (value == villageUIModel[i].name) {
                  valVillage = villageUIModel[i].value;
                  farmerSearch(valVillage);
                }
              }
            });
          } catch (e) {
            print(e.toString());
          }
        },
      ));

      listings.add(farmerLoaded
          ? txt_label_mandatory("Farmer", Colors.black, 14.0, false)
          : Container());
      /* listings.add(farmerLoaded
          ? singlesearchDropdown(
              itemlist: farmerDropdownItem,
              selecteditem: slcFarmer,
              hint: "Select Farmer",
              onChanged: (value) {
                setState(() {
                  slcFarmer = value!;
                  farmId = "";
                  for (int i = 0; i < farmerUIModel.length; i++) {
                    if (value == farmerUIModel[i].name) {
                      valFarmer = farmerUIModel[i].value;
                      getDetail(valFarmer);
                      getFarmCount(valFarmer);
                    }
                  }
                });
              },
              onClear: () {
                setState(() {
                  farmId = "";
                  slcFarmer = "";
                });
              })
          : Container());  */

      listings.add(farmerLoaded
          ? farmerDropDownWithModel(
              itemlist: farmeritems,
              selecteditem: slctFarmers,
              hint: "Select Farmer",
              onChanged: (value) {
                setState(() {
                  slctFarmers = value!;
                  farmId = "";
                  valFarmer = slctFarmers!.value;
                  slcFarmer = slctFarmers!.name;

                  getFarmCount(valFarmer);
                });
              },
              onClear: () {
                setState(() {
                  farmId = "";
                  slcFarmer = "";
                });
              })
          : Container());

      listings.add(btn_dynamic(
          label: "Submit",
          bgcolor: Colors.green,
          txtcolor: Colors.white,
          fontsize: 18.0,
          centerRight: Alignment.centerRight,
          margin: 10.0,
          btnSubmit: () async {
            setState(() {
              if (slcVillage.length > 0) {
                if (slcFarmer.length > 0) {
                  farmerIDAdded = true;
                } else {
                  farmerIDAdded = false;
                  alertPopup(context, "Farmer should not be empty");
                }
              } else {
                alertPopup(context, "Village should not be empty");
              }
            });
          }));
    }

    if (farmerIDAdded) {
      listings.add(
          txt_label_mandatory("Farm Information", Colors.green, 18.0, true));

      listings.add(txt_label_mandatory("Farm Name", Colors.black, 16.0, false));
      listings.add(txtfield_dynamic("Farm Name", farmNameController, true, 50));

      listings.add(farmIDLoaded
          ? txt_label_mandatory("Farm ID", Colors.black, 16.0, false)
          : Container());
      listings.add(
          farmIDLoaded ? cardlable_dynamic(farmId.toString()) : Container());

      listings.add(txt_label_mandatory(
          "Total Land Holding (Acre)", Colors.black, 16.0, false));
      listings.add(txtfieldAllowFourDecimal(
              "Total Land Holding (Acre)", totalLandController, false));

      listings.add(btn_dynamic(
          label: "Area",
          bgcolor: Colors.green,
          txtcolor: Colors.white,
          fontsize: 18.0,
          centerRight: Alignment.centerRight,
          margin: 10.0,
          btnSubmit: () async {
            farmValueAdded = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => geoploattingFarm(1)));
            areaPlotted = true;
            if (farmValueAdded) {
              setState(() {
                String totalAcre = Farmdata!.Acre;
                double num1 = double.parse((totalAcre));
                String total = num1.toStringAsFixed(3).toString();
                totalLandController.text = total;
           /*     if (totalLandController.text.isNotEmpty) {
                  double getArea = double.parse(totalLandController.text);
                  areaPlotted = true;
                 if (getArea > 0.00) {
                    areaPlotted = true;
                  } else {
                    setState(() {
                      areaPlotted = false;
                      Geoploattingfarmlist.clear();
                    });
                  }
                }*/
              });
            }
          }));

      listings.add(txt_label_mandatory(
          "Proposed Planting Area (Acre)", Colors.black, 16.0, false));
      listings.add(txtfieldAllowFourDecimal(
          "Proposed Planting Area (Acre)", proposedPlantingController, true));

      listings.add(txt_label("Land Ownership", Colors.black, 14.0, false));
      listings.add(singlesearchDropdown(
          itemlist: landOwnerShipDropdownItem,
          selecteditem: slcLandOwnerShip,
          hint: "Select Land Ownership",
          onChanged: (value) {
            setState(() {
              slcLandOwnerShip = value!;
              for (int i = 0; i < landOwnerShipUIModel.length; i++) {
                if (value == landOwnerShipUIModel[i].name) {
                  valLandOwnerShip = landOwnerShipUIModel[i].value;
                }
              }
            });
          },
          onClear: () {
            setState(() {
              slcLandOwnerShip = "";
            });
          }));

      listings.add(txt_label_mandatory(
          "Is Address same as Farmer?", Colors.black, 16.0, false));
      listings.add(radio_dynamic(
          map: addressList,
          selectedKey: selectedOption,
          onChange: (value) {
            setState(() {
              selectedOption = value;
              if (value == "option2") {
                selectedOption = "option2";
                selectedAddressValue = "0";
                slcCountry = "";
                slcCounty = "";
                slcSubCounty = "";
                slcWard = "";
                slcLocationVillage = "";
                countrySearch();
                farmIDLoaded = false;
                farmId = "";
                newVillage = false;
                villageNameController.text = "";
                click = "+";
              } else {
                selectedOption = "option1";
                selectedAddressValue = "1";
                farmIDGenerated(valFarmer);
                countryDropdown = [];
                countyDropdown = [];
                subCountryDropdown = [];
                wardDropdown = [];
                villageLocationDropdown = [];
              }
            });
          }));

      listings.add(txt_label_mandatory("Country", Colors.black, 15.0, false));
      listings.add(singlesearchDropdown(
        itemlist: countryDropdown,
        selecteditem: slcCountry,
        hint: "Select Country",
        onChanged: (value) {
          setState(() {
            slcCountry = value!;
            slcWard = "";
            slcSubCounty = "";
            slcCounty = "";
            slcLocationVillage = "";
            newVillage = false;
            villageNameController.text = "";
            click = "+";
            farmId = "";
            farmIDLoaded = false;

            for (int i = 0; i < countryUIModel.length; i++) {
              if (value == countryUIModel[i].name) {
                valCountry = countryUIModel[i].value;
                countySearch(valCountry);
              }
            }
          });
        },
      ));

      listings.add(txt_label_mandatory("County", Colors.black, 15.0, false));
      listings.add(singlesearchDropdown(
        itemlist: countyDropdown,
        selecteditem: slcCounty,
        hint: "Select County",
        onChanged: (value) {
          setState(() {
            slcCounty = value!;
            slcWard = "";
            slcLocationVillage = "";
            slcSubCounty = "";
            newVillage = false;
            villageNameController.text = "";
            click = "+";
            farmId = "";
            farmIDLoaded = false;

            for (int i = 0; i < countyUIModel.length; i++) {
              if (value == countyUIModel[i].name) {
                valCounty = countyUIModel[i].value;
                subCounty(valCounty);
              }
            }
          });
        },
      ));

      listings
          .add(txt_label_mandatory("Sub County", Colors.black, 15.0, false));
      listings.add(singlesearchDropdown(
        itemlist: subCountryDropdown,
        selecteditem: slcSubCounty,
        hint: "Select Sub County",
        onChanged: (value) {
          setState(() {
            slcSubCounty = value!;
            slcWard = "";
            slcLocationVillage = "";
            newVillage = false;
            villageNameController.text = "";
            click = "+";
            farmId = "";
            farmIDLoaded = false;

            for (int i = 0; i < subCountyUIModel.length; i++) {
              if (value == subCountyUIModel[i].name) {
                valSubCounty = subCountyUIModel[i].value;
                ward(valSubCounty);
              }
            }
          });
        },
      ));

      listings.add(txt_label_mandatory("Ward", Colors.black, 15.0, false));
      listings.add(singlesearchDropdown(
        itemlist: wardDropdown,
        selecteditem: slcWard,
        hint: "Select Ward",
        onChanged: (value) {
          setState(() {
            slcWard = value!;
            slcLocationVillage = "";
            newVillage = false;
            villageNameController.text = "";
            click = "+";
            farmId = "";
            farmIDLoaded = false;
            for (int i = 0; i < wardUIModel.length; i++) {
              if (value == wardUIModel[i].name) {
                valWard = wardUIModel[i].value;
                village(valWard);
                villageNameCheck(valWard);
                getFarmID();
              }
            }
          });
        },
      ));

      /*listings.add(txt_label_mandatory("Village", Colors.black, 15.0, false));
      listings.add(singlesearchDropdown(
        itemlist: villageLocationDropdown,
        selecteditem: slcLocationVillage,
        hint: "Select Village",
        onChanged: (value) {
          setState(() {
            slcLocationVillage = value!;
            for (int i = 0; i < villageLocationUIModel.length; i++) {
              if (value == villageLocationUIModel[i].name) {
                valLocationVillage = villageLocationUIModel[i].value;
                getFarmID();
              }
            }
          });
        },
      ));*/

      listings.add(txt_label_mandatory("Village", Colors.black, 14.0, false));
      listings.add(selectedAddressValue == "0"
          ? parallelWidget(
              function: () {
                if (click == "+") {
                  setState(() {
                    click = "X";
                    newVillage = true;
                    slcLocationVillage = "";
                    valLocationVillage = "";
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
              itemlist: villageLocationDropdown,
              selecteditem: slcLocationVillage,
              hint: "Select Village",
              onChanged: (value) {
                setState(() {
                  slcLocationVillage = value!;
                  slcFarmer = "";
                  farmerLoaded = false;
                  villageNameController.text = "";
                  for (int i = 0; i < villageLocationUIModel.length; i++) {
                    if (value == villageLocationUIModel[i].name) {
                      valLocationVillage = villageLocationUIModel[i].value;
                      farmerSearch(valLocationVillage);
                    }
                  }
                });
              },
              labelText: "Village",
              txtcontroller: villageNameController,
              focus: true,
              length: 50)
          // else condition : same for village farmer
          : singlesearchDropdown(
              itemlist: villageLocationDropdown,
              selecteditem: slcLocationVillage,
              hint: "Select Village",
              onChanged: (value) {
                setState(() {
                  slcLocationVillage = value!;
                  for (int i = 0; i < villageLocationUIModel.length; i++) {
                    if (value == villageLocationUIModel[i].name) {
                      valLocationVillage = villageLocationUIModel[i].value;
                    }
                  }
                });
              },
            ));

      listings.add(txt_label("Farm Photo ", Colors.black, 14.0, false));
      listings.add(img_picker(
          label: "Photo \*",
          onPressed: getImageFrm,
          filename: imageFileFarm,
          ondelete: onDeleteFrm));

      listings.add(txt_label(
          "Land Registration Number", Colors.black, 16.0, false));
      listings.add(txtfield_dynamic(
          "Land Registration Number", landRegistrationController, true, 50));

      listings.add(txt_label("Land Topography", Colors.black, 14.0, false));
      listings.add(singlesearchDropdown(
          itemlist: topographyDropdownItem,
          selecteditem: slcTopography,
          hint: "Select Land Topography",
          onChanged: (value) {
            setState(() {
              slcTopography = value!;
              for (int i = 0; i < topographyUIModel.length; i++) {
                if (value == topographyUIModel[i].name) {
                  valTopography = topographyUIModel[i].value;
                }
              }
            });
          },
          onClear: () {
            setState(() {
              slcTopography = "";
            });
          }));

      listings.add(txt_label("Land Gradient", Colors.black, 14.0, false));
      listings.add(singlesearchDropdown(
          itemlist: gradientDropdownItem,
          selecteditem: slcGradient,
          hint: "Select Land Gradient",
          onChanged: (value) {
            setState(() {
              slcGradient = value!;
              for (int i = 0; i < gradientUIModel.length; i++) {
                if (value == gradientUIModel[i].name) {
                  valGradient = gradientUIModel[i].value;
                }
              }
            });
          },
          onClear: () {
            setState(() {
              slcGradient = "";
            });
          }));

      listings.add(txt_label(
          "Land Registration Documents Upload", Colors.black, 14.0, false));
      listings.add(img_picker(
          label: "Land Registration Documents Upload \*",
          onPressed: getDocumentFrm,
          filename: imageDocumentFarm,
          ondelete: onDeleteDocument));

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
    }

    return listings;
  }

  Future getImageFrm() async {
    var image = await ImagePicker.platform
        .pickImage(source: ImageSource.camera, imageQuality: 20);
    setState(() {
      imageFileFarm = File(image!.path);
    });
  }

  Future getDocumentFrm() async {
    var image = await ImagePicker.platform
        .pickImage(source: ImageSource.camera, imageQuality: 20);
    setState(() {
      imageDocumentFarm = File(image!.path);
      printWrapped('fPhoto--' +imageDocumentFarm.toString());

    });
  }

  void onDeleteDocument() {
    if (imageDocumentFarm != null) {
      setState(() {
        imageDocumentFarm = null;
      });
    }
  }

  void onDeleteFrm() {
    if (imageFileFarm != null) {
      setState(() {
        imageFileFarm = null;
      });
    }
  }

/*
  void farmNameValidation() {
    bool farmNameExist = false;

    for (int a = 0; a < farmDetailList.length; a++) {
      if (farmDetailList[a].name == farmNameController.text) {
        farmNameExist = true;
      }
    }
    if (farmNameExist) {
      alertPopup(context, "Farm Name already exists for this Farmer");
    } else {
      totalLandValidation();
    }
  }
*/

  void btnSubmit() {
    if (imageFileFarm != null) {
      farmPhotoPath = imageFileFarm!.path;
    }
    if (imageDocumentFarm != null) {
      documentsPhotoPath = imageDocumentFarm!.path;
    }

    print("areaPlotted_areaPlotted"+areaPlotted.toString());
    if (farmNameController.text.length == 0) {
      alertPopup(context, "Farm Name should not be empty");
    }
    else if(!areaPlotted){
      alertPopup(context, "Please plot the area for Total Land Holding (Acre)");
    }
    else {
      // farmNameValidation();
      totalLandValidation();
    }
  }

  void totalLandValidation() async {
    var proposedLand;
    var totLand;
    int totalLandValue = 0;

    if (totalLandController.text.length > 0) {
      totLand = num.parse(totalLandController.text);
    }
    if (proposedPlantingController.text.length > 0) {
      proposedLand = num.parse(proposedPlantingController.text);
    }
    if (totalLandController.text.length == 0) {
      alertPopup(context, "Total Land Holding (Acre) should not be empty");
    }
    else if (totLand < 0 || totLand == 0) {
      alertPopup(
          context, "Total Land Holding (Acre) should be Greater than Zero");
    }
    else if (proposedPlantingController.text.length == 0) {
      alertPopup(context, "Proposed Planting Area (Acre) should not be empty");
    }
    else if (proposedLand < 0 || proposedLand == 0) {
      alertPopup(
          context, "Proposed Planting Area (Acre) should be Greater than Zero");
    }
    else if (proposedLand > totLand) {
      alertPopup(context,
          "Proposed Planting Area (Acre) should not be Greater than Total Land Holding (Acre)");
    }
    else {
      addressValidation();
    }
  }

  void addressValidation() async {
    if (selectedAddressValue == "0") {
      if (slcCountry.length == 0) {
        alertPopup(context, "Country should not be empty");
      } else if (slcCounty.length == 0) {
        alertPopup(context, "County should not empty");
      } else if (slcSubCounty.length == 0) {
        alertPopup(context, "Sub County should not be empty");
      } else if (slcWard.length == 0) {
        alertPopup(context, "Ward should not be empty");
      } else {
        villageValidation();
      }
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
      alertPopup(context, "Village Name already exists for the Ward");
    } else {
      validation();
    }
  }

  void villageValidation() async {
    if (newVillage && selectedAddressValue == "0") {
      if (villageNameController.text.length == 0) {
        alertPopup(context, "Village should not be empty");
      } else {
        villageNameValidation();
      }
    } else {
      if (slcLocationVillage.length == 0) {
        alertPopup(context, "Village should not be empty");
      } else {
        validation();
      }
    }
  }

  void validation() async {
    bool landRegNoExist = false;

    for (int a = 0; a < farmDetailList.length; a++) {
      if (farmDetailList[a].farmRegNo == landRegistrationController.text) {
        landRegNoExist = true;
      }
    }
    if (landRegistrationController.text.length != 0 && landRegNoExist) {
      alertPopup(context, "Land Registration Number already exists");
    } else {
      confirmation();
      print("farmRegistration");
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
            farmRegistration();
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

  Future<void> farmRegistration() async {
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
        txntime, datas.txnFarmRegistration, revNo.toString(), '', '', '');

    if (newVillage) {
      var currentTime = new DateTime.now();
      var formatter = new DateFormat('HHmmss');
      String formatValue = formatter.format(currentTime);
      valLocationVillage = formatValue;
      slcLocationVillage = villageNameController.text;
    }

    int farm = await db.saveFarmRegistration(
        farmNameController.text,
        farmId,
        valFarmer,
        totalLandController.text,
        proposedPlantingController.text,
        valLandOwnerShip,
        valGradient,
        valTopography,
        farmPhotoPath,
        selectedAddressValue,
        addressController.text,
        documentsPhotoPath,
        landRegistrationController.text,
        "1",
        revNo.toString(),
        longitude,
        latitude,
        msgNo,
        fCount.toString(),
        valCountry,
        valCounty,
        valSubCounty,
        valWard,
        valLocationVillage,
        slcLocationVillage);
    print(farm);

    if (Geoploattingfarmlist.length > 0) {
      for (int i = 0; i < Geoploattingfarmlist.length; i++) {
        print("geoplatinglistFarm" + Geoploattingfarmlist.toString());
        int savefarmgpslocation = await db.saveFarmGPSLocationExists(
          Geoploattingfarmlist[i].Latitude,
          Geoploattingfarmlist[i].Longitude,
          valFarmer,
          farmId,
          Geoploattingfarmlist[i].orderofGps.toString(),
          revNo.toString(),
        );
        print("savefarmgpslocation" + revNo.toString());
      }
    }

    await db.UpdateTableValue(
        'farm', 'isSynched', '0', 'recptId', revNo.toString());

    TxnExecutor txnExecutor = new TxnExecutor();
    txnExecutor.CheckCustTrasactionTable();

    Alert(
      context: context,
      type: AlertType.info,
      title: "Transaction Successful",
      desc: "Farm Registration done Successfully",
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

    Geoploattingfarmlist
        .clear(); // clear the plotting list once transaction done
  }
}

class ClassName {
  String? name;
  String? id;
  String farmRegNo;

  ClassName(this.name, this.id, this.farmRegNo);
}
