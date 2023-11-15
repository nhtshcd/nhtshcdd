import 'package:cupertino_radio_choice/cupertino_radio_choice.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:nhts/Utils/MandatoryDatas.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:signature/signature.dart';
import 'package:file_picker/file_picker.dart';


AppDatas appData = AppDatas();

Widget txt_label(String label, Color color, double fontsize, bool headling) {
  Widget objWidget = Container(
    margin: EdgeInsets.only(top: 5),
    child: headling
        ? Container(
            color: color,
            padding: EdgeInsets.all(3),
            child: Text(
              label,
              style: TextStyle(fontSize: fontsize, color: Colors.white),
            ),
          )
        : Container(
            child: Text(
              label,
              style: TextStyle(
                fontSize: fontsize,
                color: color,
              ),
            ),
          ),
  );
  return objWidget;
}

Widget txt_label_icon(
    String label, Color color, double fontsize, bool mandatory) {
  Widget objWidget = Container(
    margin: EdgeInsets.only(top: 5),
    child: Row(
      children: [
        Container(
          padding: EdgeInsets.only(left: 5),
          child: Row(
            children: [
              Text(
                label,
                maxLines: 3,
                style: TextStyle(
                  fontSize: fontsize,
                  color: color,
                ),
              ),
              mandatory
                  ? Container(
                      padding: EdgeInsets.only(left: 3),
                      child: Text(
                        '*',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ],
    ),
  );
  return objWidget;
}

Widget txt_label_mandatory(
    String label, Color color, double fontsize, bool headling) {
  Widget objWidget = Container(
    margin: EdgeInsets.only(top: 5),
    child: headling
        ? Container(
            color: color,
            padding: EdgeInsets.all(3),
            child: Text(
              label,
              style: TextStyle(fontSize: fontsize, color: Colors.white),
            ),
          )
        : Container(
            child: Row(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: fontsize,
                    color: color,
                  ),
                ),
                Text(
                  '*',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
  );
  return objWidget;
}

Widget txtfield_digitswithoutdecimal(
    String label, TextEditingController txtcontroller, bool focus) {
  Widget objWidget = Container(
      child: Card(
    elevation: 2,
    color: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
      Radius.circular(5.0),
    )),
    child: Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: TextFormField(
        enabled: focus,
        keyboardType: TextInputType.number,
        style: TextStyle(color: Colors.black87),
        controller: txtcontroller,
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
            ),
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            hintStyle: TextStyle(
              color: Colors.black38,
            ),
            hintText: label,
            filled: false),
        validator: (String? value) {
          return value!.contains('@') ? 'Do not use the @ char.' : null;
        },
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
      ),
    ),
  ));
  return objWidget;
}

Widget cardlable_dynamicLarge(String? label) {
  Widget objWidget = Container(
    child: Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
        Radius.circular(5.0),
      )),
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 5, top: 3),
        height: 130,
        alignment: Alignment.centerLeft,
        child: Text(
          label ?? '-',
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
  return objWidget;
}

Widget cardlable_dynamic(String? label) {
  Widget objWidget = Container(
    child: Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
        Radius.circular(5.0),
      )),
      child: Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        height: 40,
        alignment: Alignment.centerLeft,
        child: Text(
          label ?? '-',
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
  return objWidget;
}

Widget txtfield_dynamic(
    String label, TextEditingController txtcontroller, bool focus, int length) {
  Widget objWidget = Container(
      child: Card(
    elevation: 2,
    color: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
      Radius.circular(5.0),
    )),
    child: Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: TextFormField(
          enabled: focus,
          style: TextStyle(color: Colors.black87),
          controller: txtcontroller,
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              hintStyle: TextStyle(
                color: Colors.black38,
              ),
              hintText: label,
              filled: false),
          validator: (String? value) {
            return value!.contains('@') ? 'Do not use the @ char.' : null;
          },
          inputFormatters: <TextInputFormatter>[
            LengthLimitingTextInputFormatter(length),
          ]),
    ),
  ));
  return objWidget;
}

Widget txtfield_dynamicWithoutSpace(
    String label, TextEditingController txtcontroller, bool focus, int length) {
  Widget objWidget = Container(
      child: Card(
    elevation: 2,
    color: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
      Radius.circular(5.0),
    )),
    child: Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: TextFormField(
          enabled: focus,
          style: TextStyle(color: Colors.black87),
          controller: txtcontroller,
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              hintStyle: TextStyle(
                color: Colors.black38,
              ),
              hintText: label,
              filled: false),
          validator: (String? value) {
            return value!.contains('@') ? 'Do not use the @ char.' : null;
          },
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
            LengthLimitingTextInputFormatter(length),
          ]),
    ),
  ));
  return objWidget;
}

Widget txtfield_digitss(
    String label, TextEditingController txtcontroller, bool focus) {
  Widget objWidget = Container(
      child: Card(
    elevation: 2,
    color: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
      Radius.circular(5.0),
    )),
    child: Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: TextFormField(
        enabled: focus,
        keyboardType: TextInputType.number,
        style: TextStyle(color: Colors.black87),
        controller: txtcontroller,
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: appData.appcolor),
            ),
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            hintStyle: TextStyle(
              color: Colors.black38,
            ),
            hintText: label,
            filled: false),
        /* validator: (String value) async {
              return value.contains('@') ? 'Do not use the @ char.' : null;
            }, */
      ),
    ),
  ));
  return objWidget;
}

Widget txtfield_digits(
    String label, TextEditingController txtcontroller, bool focus, int length) {
  Widget objWidget = Container(
      child: Card(
    elevation: 2,
    color: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
      Radius.circular(5.0),
    )),
    child: Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: TextFormField(
          enabled: focus,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          style: TextStyle(color: Colors.black87),
          controller: txtcontroller,
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              hintStyle: TextStyle(
                color: Colors.black38,
              ),
              hintText: label,
              filled: false),
          validator: (String? value) {
            return value!.contains('@') ? 'Do not use the @ char.' : null;
          },
          inputFormatters: <TextInputFormatter>[
            LengthLimitingTextInputFormatter(length),
          ]),
    ),
  ));
  return objWidget;
}

Widget txtfieldAllowTwoDecimal(
    String label, TextEditingController txtcontroller, bool focus, int length) {
  Widget objWidget = Container(
      child: Card(
    elevation: 2,
    color: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
      Radius.circular(5.0),
    )),
    child: Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: TextFormField(
          enabled: focus,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          style: TextStyle(color: Colors.black87),
          controller: txtcontroller,
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              hintStyle: TextStyle(
                color: Colors.black38,
              ),
              hintText: label,
              filled: false),
          validator: (String? value) {
            return value!.contains('@') ? 'Do not use the @ char.' : null;
          },
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})')),
            LengthLimitingTextInputFormatter(length),
          ]),
    ),
  ));
  return objWidget;
}

Widget txtfieldAllowFourDecimal(
    String label, TextEditingController txtcontroller, bool focus) {
  Widget objWidget = Container(
      child: Card(
    elevation: 2,
    color: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
      Radius.circular(5.0),
    )),
    child: Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: TextFormField(
          enabled: focus,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          style: TextStyle(color: Colors.black87),
          controller: txtcontroller,
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              hintStyle: TextStyle(
                color: Colors.black38,
              ),
              hintText: label,
              filled: false),
          validator: (String? value) {
            return value!.contains('@') ? 'Do not use the @ char.' : null;
          },
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,4})'))
          ]),
    ),
  ));
  return objWidget;
}

Widget btn_dynamic(
    {String? label,
    Color? bgcolor,
    Color? txtcolor,
    double? fontsize,
    Alignment? centerRight,
    double? margin,
    btnSubmit}) {
  Widget objWidget = Container(
    alignment: centerRight,
    margin: EdgeInsets.only(top: margin!),
    child: Wrap(children: <Widget>[
      MaterialButton(
        color: bgcolor,
        child:
            Text(label!, style: TextStyle(fontSize: fontsize, color: txtcolor)),
        onPressed: btnSubmit,
      ),
    ]),
  );
  return objWidget;
}

Widget datatable_dynamic({List<DataColumn>? columns, List<DataRow>? rows}) {
  Widget objWidget = Container(
    color: Colors.white,
    child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(columns: columns!, rows: rows!),
      ),
    ),
  );
  return objWidget;
}

Widget btn_dynamic_tag(
    {String? label,
    Color? bgcolor,
    Color? txtcolor,
    double? fontsize,
    Alignment? centerRight,
    double? margin,
    btnSubmit,
    tag}) {
  Widget objWidget = Hero(
      tag: tag,
      child: Container(
        alignment: centerRight,
        margin: EdgeInsets.only(top: margin!),
        child: Wrap(children: <Widget>[
          MaterialButton(
            color: bgcolor,
            child: Text(label!,
                style: TextStyle(fontSize: fontsize, color: txtcolor)),
            onPressed: btnSubmit,
          ),
        ]),
      ));
  return objWidget;
}

Widget chkbox_dynamic(
    {String? label, bool? checked, ValueChanged<bool?>? onChange}) {
  Widget objWidget = Container(
    child: Row(
      children: <Widget>[
        Checkbox(
            checkColor: Colors.white,
            activeColor: Colors.green,
            value: checked,
            onChanged: onChange),
        Text(
          label!,
          style: TextStyle(color: Colors.green),
        ),
      ],
    ),
  );
  return objWidget;
}

Widget selectYear(
    {BuildContext? context1, Function(DateTime)? onConfirm, String? slctyear}) {
  Widget objWidget = Column(
    children: <Widget>[
      Container(
          child: InkWell(
        onTap: () {
          DatePicker.showDatePicker(
            context1!,
            showTitleActions: true,
            minTime: DateTime(1900),
            maxTime: DateTime.now(),
            theme: DatePickerTheme(
                headerColor: Colors.green,
                backgroundColor: Colors.white,
                itemStyle: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                cancelStyle: TextStyle(color: Colors.white, fontSize: 16),
                doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
            onChanged: (date) {
              print('change $date in time zone ' +
                  date.timeZoneOffset.inHours.toString());
            },
            onConfirm: onConfirm,
            locale: LocaleType.en,
          );
        },
        child: Row(
          children: <Widget>[
            Icon(Icons.calendar_today),
            Container(
              margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
              child: Text(
                slctyear!,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      )),
      Divider(
        thickness: 1.0,
        height: 2.0,
        color: Colors.green,
      )
    ],
  );
  return objWidget;
}

Widget selectDate(
    {BuildContext? context1, Function(DateTime)? onConfirm, String? slctdate}) {
  Widget objWidget = Column(
    children: <Widget>[
      Container(
          child: InkWell(
        onTap: () {
          DatePicker.showDatePicker(context1!,
              showTitleActions: true,
              minTime: DateTime(1900),
              theme: DatePickerTheme(
                  headerColor: Colors.green,
                  backgroundColor: Colors.white,
                  itemStyle: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                  cancelStyle: TextStyle(color: Colors.white, fontSize: 16),
                  doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
              onChanged: (date) {
            print('change $date in time zone ' +
                date.timeZoneOffset.inHours.toString());
          },
              onConfirm: onConfirm,
              currentTime: DateTime.now(),
              locale: LocaleType.en);
        },
        child: Row(
          children: <Widget>[
            Icon(Icons.calendar_today),
            Container(
              margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
              child: Text(
                slctdate!,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      )),
      Divider(
        thickness: 1.0,
        height: 2.0,
        color: Colors.green,
      )
    ],
  );
  return objWidget;
}

Widget img_picker({String? label, Function()? onPressed, filename, ondelete}) {
  Widget objWidget = Container(
      child: Row(
    children: <Widget>[
      Container(
        margin: EdgeInsets.only(top: 10),
        child: FloatingActionButton(
          heroTag: null,
          backgroundColor: Colors.green,
          onPressed: onPressed,
          tooltip: 'Pick Image',
          child: Icon(
            Icons.add_a_photo,
            color: Colors.white,
          ),
        ),
      ),
      VerticalDivider(width: 10.0),
      Center(
        child: filename == null
            ? Text('')
            : Container(
                height: 200.0,
                width: 200.0,
                child: Image.file(
                  filename,
                )),
      ),
      VerticalDivider(width: 10.0),
      Container(
        child: filename == null
            ? Text('')
            : Column(children: <Widget>[
                MaterialButton(
                  color: Colors.red,
                  child: Icon(
                    Icons.delete_forever,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    ondelete();
                  },
                ),
              ]),
      )
    ],
  ));
  return objWidget;
}

Widget img_picker2(
    String label, Function() onPressed, filename, imagepreviewbtn(), ondelete) {
  Widget objWidget = Container(
      child: Row(
    children: <Widget>[
      Container(
        margin: EdgeInsets.only(top: 10),
        child: FloatingActionButton(
          heroTag: null,
          backgroundColor: Colors.green,
          onPressed: onPressed,
          tooltip: 'Pick Image',
          child: Icon(
            Icons.add_a_photo,
            color: Colors.white,
          ),
        ),
      ),
      VerticalDivider(width: 10.0),
      Center(
        child: filename == null
            ? Text('')
            : InkWell(
                onTap: () async {
                  imagepreviewbtn();
                }, // Handle your callback
                child: Container(
                    height: 200.0,
                    width: 200.0,
                    child: Image.file(
                      filename,
                    )),
              ),
      ),
      VerticalDivider(width: 10.0),
      Container(
        child: filename == null
            ? Text('')
            : Column(children: <Widget>[
                MaterialButton(
                  color: Colors.red,
                  child: Icon(
                    Icons.delete_forever,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    ondelete();
                  },
                ),
              ]),
      )
    ],
  ));
  return objWidget;
}

Widget familyInfo(
    String hint1,
    String hint2,
    Color color,
    double fontsize,
    bool underline,
    TextEditingController txtcontroller,
    TextEditingController controller2) {
  Widget objWidget = Container(
    margin: EdgeInsets.only(top: 15),
    child: Row(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.only(right: 10.0),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    hint1,
                    style: TextStyle(
                      fontSize: fontsize,
                      color: color,
                      decoration: underline ? TextDecoration.underline : null,
                    ),
                  ),
                ),
                Container(
                    child: TextFormField(
                  style: TextStyle(color: Colors.black),
                  controller: txtcontroller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.black38,
                      ),
                      hintText: hint1,
                      filled: false),
                  validator: (String? value) {
                    return value!.contains('@')
                        ? 'Do not use the @ char.'
                        : null;
                  },
                )),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 10.0),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    hint2,
                    style: TextStyle(
                      fontSize: fontsize,
                      color: color,
                      decoration: underline ? TextDecoration.underline : null,
                    ),
                  ),
                ),
                Container(
                    child: TextFormField(
                  style: TextStyle(color: Colors.black),
                  controller: controller2,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.black38,
                      ),
                      hintText: hint2,
                      filled: false),
                  validator: (String? value) {
                    return value!.contains('@')
                        ? 'Do not use the @ char.'
                        : null;
                  },
                )),
              ],
            ),
          ),
        )
      ],
    ),
  );
  return objWidget;
}

Widget btn_double_dynamic(
    String txt1,
    String txt2,
    Color backcolor,
    Color txtcolor,
    double fontsize,
    Alignment centerRight,
    double margin,
    btnSubmit()) {
  Widget objWidget = Container(
    alignment: centerRight,
    margin: EdgeInsets.only(top: margin),
    child: Wrap(children: <Widget>[
      MaterialButton(
        color: Colors.orange,
        child: Icon(
          Icons.close,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
      SizedBox(width: 10.0),
      MaterialButton(
        color: backcolor,
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
        onPressed: () {
          btnSubmit();
        },
      ),
    ]),
  );
  return objWidget;
}

Widget btn_double_submit(
    String txt1,
    String txt2,
    Color backcolor,
    Color txtcolor,
    double fontsize,
    Alignment centerRight,
    double margin,
    btnSubmit(),
    btnCancel()) {
  Widget objWidget = Container(
    alignment: centerRight,
    margin: EdgeInsets.only(top: margin),
    child: Wrap(children: <Widget>[
      MaterialButton(
        color: Colors.orange,
        child: Icon(
          Icons.close,
          color: Colors.white,
        ),
        onPressed: () {
          btnCancel();
        },
      ),
      SizedBox(width: 10.0),
      MaterialButton(
        color: backcolor,
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
        onPressed: () {
          btnSubmit();
        },
      ),
    ]),
  );
  return objWidget;
}

Widget radio_dynamic(
    {Map<String, String>? map,
    String? selectedKey,
    Function(String)? onChange}) {
  Widget objWidget = Container(
    child: Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Row(
        children: [
          CupertinoRadioChoice(
              selectedColor: Colors.green,
              choices: map!,
              onChange: onChange!,
              initialKeyValue: selectedKey)
        ],
      ),
    ),
  );
  return objWidget;
}

errordialog(dialogContext, String title, String description) {
  var alertStyle = AlertStyle(
    animationType: AnimationType.grow,
    overlayColor: Colors.black87,
    isCloseButton: true,
    isOverlayTapDismiss: true,
    titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    descStyle:
        TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 16),
    animationDuration: Duration(milliseconds: 400),
  );

  Alert(
      context: dialogContext,
      style: alertStyle,
      title: title,
      desc: description,
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            Navigator.pop(dialogContext);
          },
          color: Colors.green,
        )
      ]).show();
}

ConfirmationAlertPopup(BuildContext context, String Title, String Desc,
    String Images, Function OkButonPressed) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset(
                Images,
                width: 50,
                height: 50,
                fit: BoxFit.contain,
              ),
              Text(
                Title,
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                    color: Colors.black),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                ),
                alignment: Alignment.topLeft,
              )
            ]),
        content: Text(
          Desc,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                color: Colors.green,
                minWidth: 100,
                child: Text(
                  "OK",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.white),
                ),
                onPressed: () {
//Put your code here which you want to execute on Yes button click.

                  OkButonPressed();
                },
              ),
            ],
          ),
        ],
      );
    },
  );
}

Widget txtFieldAlphanumericWithoutSymbol(
    String label, TextEditingController txtcontroller, bool focus, int length) {
  Widget objWidget = Container(
      child: Card(
    elevation: 2,
    color: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
      Radius.circular(5.0),
    )),
    child: Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: TextFormField(
          textCapitalization: TextCapitalization.characters,
          enabled: focus,
          style: TextStyle(color: Colors.black87),
          controller: txtcontroller,
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              hintStyle: TextStyle(
                color: Colors.black38,
              ),
              hintText: label,
              filled: false),
          validator: (String? value) {
            return value!.contains('@') ? 'Do not use the @ char.' : null;
          },
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp("[0-9A-Z]")),
            LengthLimitingTextInputFormatter(length),
          ]),
    ),
  ));
  return objWidget;
}

Widget txtfield_digits_integer(
    String label, TextEditingController txtcontroller, bool focus, int length) {
  Widget objWidget = Container(
      child: Card(
    elevation: 2,
    color: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
      Radius.circular(5.0),
    )),
    child: Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: TextFormField(
          enabled: focus,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          style: TextStyle(color: Colors.black87),
          controller: txtcontroller,
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              hintStyle: TextStyle(
                color: Colors.black38,
              ),
              hintText: label,
              filled: false),
          validator: (String? value) {
            return value!.contains('@') ? 'Do not use the @ char.' : null;
          },
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(length),
          ]),
    ),
  ));
  return objWidget;
}

Widget btn_double_submit_cancel(
    String txt1,
    String txt2,
    Color backcolor,
    Color txtcolor,
    double fontsize,
    Alignment centerRight,
    double margin,
    btnSubmit(),
    btnCancel()) {
  Widget objWidget = Container(
    alignment: centerRight,
    margin: EdgeInsets.only(top: margin),
    child: Wrap(children: <Widget>[
      MaterialButton(
        color: Colors.orange,
        child: Icon(
          Icons.close,
          color: Colors.white,
        ),
        onPressed: () {
          btnCancel();
        },
      ),
      SizedBox(width: 10.0),
      MaterialButton(
        color: backcolor,
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
        onPressed: () {
          btnSubmit();
        },
      ),
    ]),
  );
  return objWidget;
}

Widget RecordWidget(
    String label, bool _isRecording, bool _isPaused, int _recordDuration) {
  Widget objWidget = Container(
      child: Card(
    elevation: 2,
    color: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
      Radius.circular(5.0),
    )),
    child: Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: Text(label),
    ),
  ));
  return objWidget;
}

Widget signaturePad(SignatureController signatureController, ByteData img,
    String encode, Function() clearPressed, Function() savePressed) {
  Widget objWidget = Container(
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.all(0),
          width: 300,
          height: 180,
          child: Signature(
            controller: signatureController,
            height: 140,
            width: 280,
            backgroundColor: Colors.white,
          ),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
          height: 60,
          width: 300,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                width: 100,
                height: 42,
                child: Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 1.0,
                  color: Color(0xff001e48),
                  clipBehavior: Clip.antiAlias,
                  child: MaterialButton(
                    minWidth: 100,
                    height: 32,
                    color: Colors.red,
                    child: Text(
                      'Clear',
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                    onPressed: clearPressed,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                width: 100,
                height: 42,
                child: Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 1.0,
                  color: Color(0xff001e48),
                  clipBehavior: Clip.antiAlias,
                  child: MaterialButton(
                    minWidth: 100,
                    height: 32,
                    color: Colors.blue,
                    child: Text(
                      'Save',
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                    onPressed: savePressed,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  return objWidget;
}

Widget txtFieldLargeDynamic(
    String label, TextEditingController txtcontroller, bool focus, int length) {
  Widget objWidget = Container(
      child: Card(
    elevation: 2,
    color: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
      Radius.circular(5.0),
    )),
    child: Container(
      height: 70,
      padding: EdgeInsets.only(left: 5, right: 5),
      child: TextFormField(
          maxLines: 3,
          enabled: focus,
          style: TextStyle(color: Colors.black87),
          controller: txtcontroller,
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              filled: false),
          validator: (String? value) {
            return value!.contains('@') ? 'Do not use the @ char.' : null;
          },
          inputFormatters: <TextInputFormatter>[
            LengthLimitingTextInputFormatter(length),
          ]),
    ),
  ));
  return objWidget;
}

Widget txtFieldOnlyIntegerWithoutLeadingZero(
    String label, TextEditingController txtcontroller, bool focus, int length) {
  Widget objWidget = Container(
      child: Card(
    elevation: 2,
    color: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
      Radius.circular(5.0),
    )),
    child: Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: TextFormField(
          enabled: focus,
          keyboardType: TextInputType.number,
          style: TextStyle(color: Colors.black87),
          controller: txtcontroller,
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              hintStyle: TextStyle(
                color: Colors.black38,
              ),
              hintText: label,
              filled: false),
          validator: (String? value) {
            return value!.contains('@') ? 'Do not use the @ char.' : null;
          },
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp('^[1-9][0-9]*')),
            LengthLimitingTextInputFormatter(length)
          ]),
    ),
  ));
  return objWidget;
}

Widget txtFieldOnlyCharacter(
    String label, TextEditingController txtcontroller, bool focus, int length) {
  Widget objWidget = Container(
      child: Card(
    elevation: 2,
    color: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
      Radius.circular(5.0),
    )),
    child: Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: TextFormField(
          enabled: focus,
          keyboardType: TextInputType.number,
          style: TextStyle(color: Colors.black87),
          controller: txtcontroller,
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              hintStyle: TextStyle(
                color: Colors.black38,
              ),
              hintText: label,
              filled: false),
          validator: (String? value) {
            return value!.contains('@') ? 'Do not use the @ char.' : null;
          },
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
            LengthLimitingTextInputFormatter(length)
          ]),
    ),
  ));
  return objWidget;
}

Future<bool> alertPopup(BuildContext context, String alertMessage) async {
  return (await Alert(
        context: context,
        type: AlertType.warning,
        title: "Information",
        desc: alertMessage,
        buttons: [
          DialogButton(
            child: Text(
              "Ok",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            width: 120,
          ),
        ],
      ).show()) ??
      false;
}

List<String> list = ["Select the option"];

Widget multisearchDropdownHint(
    {String? hint,
    List<DropdownMenuItem>? itemlist,
    List<String>? selectedlist,
    Function(List<String>)? onChanged}) {
  List<String> dropdownitems = [];
  for (int i = 0; i < itemlist!.length; i++) {
    String item = itemlist[i].value;
    dropdownitems.add(item);
  }
  Widget objWidget = Container(
      child: Card(
    elevation: 2,
    color: Colors.green,
    shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
      Radius.circular(5.0),
    )),
    child: DropdownSearch<String>.multiSelection(
        mode: Mode.BOTTOM_SHEET,
        showSelectedItems: true,
        showSearchBox: true,
        items: dropdownitems,
        dropdownSearchDecoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
          hintText: hint,
          border: OutlineInputBorder(),
        ),
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
            labelText: "Search Option",
            prefixIcon: Icon(Icons.search),
          ),
        ),
        onChanged: onChanged!,
        selectedItems: selectedlist!),
  ));
  return objWidget;
}

/*
singlesearchDropdown(
    {List<DropdownMenuItem>? itemlist,
    String? selecteditem,
    String? hint,
    Function()? onClear,
    Function(String?)? onChanged}) {
  List<String> dropdownitems = [];
  for (int i = 0; i < itemlist!.length; i++) {
    String item = itemlist[i].value;
    dropdownitems.add(item);
  }
  Widget objWidget = new Container(
    child: Card(
      elevation: 2,
      color: Colors.green,
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
        Radius.circular(5.0),
      )),
      child: DropdownSearch<String>(
          mode: Mode.BOTTOM_SHEET,
          showSelectedItems: true,
          showSearchBox: true,
          items: dropdownitems,
          onFind: (String? filter) => getData(filter),
          dropdownSearchDecoration: InputDecoration(
            labelText: hint,
            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
            border: OutlineInputBorder(),
          ),
          onChanged: onChanged!,
          selectedItem: selecteditem),
    ),
  );
  return objWidget;
}
*/

Widget parallelWidget(
    {function,
    String? label,
    List<DropdownMenuItem>? itemlist,
    String? selecteditem,
    String? hint,
    Function()? onClear,
    Function(String?)? onChanged,
    bool? select,
    String? labelText,
    TextEditingController? txtcontroller,
    bool? focus,
    int? length}) {
  List<String> dropdownitems = [];
  for (int i = 0; i < itemlist!.length; i++) {
    String item = itemlist[i].value;
    dropdownitems.add(item);
  }
  Widget objWidget = Container(
    child: Row(
      children: <Widget>[
        Expanded(
          child: select == false
              ? Card(
                  elevation: 2,
                  color: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(
                    Radius.circular(5.0),
                  )),
                  child: DropdownSearch<String>(
                      mode: Mode.BOTTOM_SHEET,
                      showSelectedItems: true,
                      showSearchBox: true,
                      items: dropdownitems,
                      onFind: (String? filter) => getData(filter),
                      dropdownSearchDecoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                        border: OutlineInputBorder(),
                      ),
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                          labelText: "Search Option",
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                      onChanged: onChanged!,
                      selectedItem:
                          selecteditem!.length == 0 ? hint : selecteditem),
                )
              : Card(
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(
                    Radius.circular(5.0),
                  )),
                  child: Container(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: TextFormField(
                        enabled: focus,
                        style: TextStyle(color: Colors.black87),
                        controller: txtcontroller,
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.black38,
                            ),
                            hintText: labelText,
                            filled: false),
                        validator: (String? value) {
                          return value!.contains('@')
                              ? 'Do not use the @ char.'
                              : null;
                        },
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(length),
                        ]),
                  ),
                ),
          flex: 5,
        ),
        SizedBox(width: 7),
        Expanded(
            child: MaterialButton(
              color: Colors.green,
              child: Text(label!,
                  style: TextStyle(fontSize: 20, color: Colors.white)),
              onPressed: function,
            ),
            flex: 1)
      ],
    ),
  );

  return objWidget;
}

Widget singlesearchDropdown(
    {List<DropdownMenuItem>? itemlist,
    String? selecteditem,
    String? hint,
    Function()? onClear,
    Function(String?)? onChanged}) {
  List<String> dropdownitems = [];
  for (int i = 0; i < itemlist!.length; i++) {
    String item = itemlist[i].value;
    dropdownitems.add(item);
  }
  Widget objWidget = Container(
    child: Card(
      elevation: 2,
      color: Colors.green,
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
        Radius.circular(5.0),
      )),
      child: DropdownSearch<String>(
          mode: Mode.BOTTOM_SHEET,
          showSelectedItems: true,
          showSearchBox: true,
          items: dropdownitems,
          onFind: (String? filter) => getData(filter),
          dropdownSearchDecoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
            border: OutlineInputBorder(),
          ),
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
              labelText: "Search Option",
              prefixIcon: Icon(Icons.search),
            ),
          ),
          onChanged: onChanged!,
          selectedItem: selecteditem!.length == 0 ? hint : selecteditem),
    ),
  );
  return objWidget;
}

Widget txtfield_Password(
    String label,
    TextEditingController txtcontroller,
    bool focus,
    int length,
    bool isObscure,
    Function passwordFun,
    String textField) {
  Widget objWidget = Container(
      child: Card(
    elevation: 2,
    color: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
      Radius.circular(5.0),
    )),
    child: Row(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: TextFormField(
              style: TextStyle(color: Colors.black45),
              controller: txtcontroller,
              obscureText: isObscure,
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  /* icon: Icon(Icons.lock,
                                                          color: Colors.white),*/
                  icon: InkWell(
                    child: Icon(
                      isObscure ? Icons.visibility : Icons.visibility_off,
                      color: Colors.green,
                    ),
                    onTap: () {
                      passwordFun();
                    },
                  ),
                  hintText: textField,
                  labelStyle: TextStyle(
                    color: Colors.black45,
                  ),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                  fillColor: Colors.transparent,
                  filled: true),
              onSaved: (String? value) {
                // This optional block of code can be used to run
                // code when the user saves the form.
              },
              validator: (String? value) {
                return value!.contains('@') ? 'Do not use the @ char.' : null;
              },
            ),
          ),
        ),
      ],
    ),
  ));
  return objWidget;
}

/*
Widget txtfield_Password(
    String label,
    TextEditingController txtcontroller,
    bool focus,
    int length,
    bool isObscure,
    Function passwordFun,
    String textField) {
  Widget objWidget = new Container(
      child: Card(
    elevation: 2,
    color: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
      Radius.circular(5.0),
    )),
    child: Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: TextFormField(
        style: new TextStyle(color: Colors.black),
        controller: txtcontroller,
        obscureText: isObscure,
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            */
/* icon: Icon(Icons.lock,
                                                  color: Colors.white),*/ /*

            icon: InkWell(
                child: Icon(
                  isObscure ? Icons.visibility : Icons.visibility_off,
                  color: Colors.green,
                ),
                onTap: () {
                  passwordFun();
                }),
            labelStyle: TextStyle(
              color: Colors.black38,
            ),
            hintText: textField,
            hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
            fillColor: Colors.transparent,
            filled: true),
        onSaved: (String? value) {
          // This optional block of code can be used to run
          // code when the user saves the form.
        },
        validator: (String? value) {
          return value!.contains('@') ? 'Do not use the @ char.' : null;
        },
      ),
    ),
  ));
  return objWidget;
}
*/

Widget farmerDropDownWithModel(
    {List<DropdownModelFarmer>? itemlist,
    DropdownModelFarmer? selecteditem,
    String? hint,
    Function()? onClear,
    Function(DropdownModelFarmer?)? onChanged}) {
  if (selecteditem == null) {
    selecteditem = DropdownModelFarmer(hint!, hint, hint, hint);
  }
  Widget objWidget = Container(
    child: Card(
      elevation: 2,
      color: Colors.green,
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
        Radius.circular(5.0),
      )),
      child: DropdownSearch<DropdownModelFarmer>(
          mode: Mode.BOTTOM_SHEET,
          showSearchBox: true,
          items: itemlist,
          filterFn: (instance, filter) {
            if (instance!.name.toLowerCase().contains(filter!.toLowerCase())) {
              print(filter);
              return true;
            } else if (instance!.value2
                .toLowerCase()
                .contains(filter!.toLowerCase())) {
              return true;
            } else if (instance!.value3
                .toLowerCase()
                .contains(filter!.toLowerCase())) {
              return true;
            } else {
              return false;
            }
          },
          dropdownBuilder: (context, selectedItem) => Container(
                child: GestureDetector(
                  child: Text(
                    selecteditem!.name,
                    style: TextStyle(color: Colors.black, fontSize: 16.0),
                  ),
                  onTap: onClear,
                ),
              ),
          popupItemBuilder: (context, item, isSelected) => Container(
                padding: EdgeInsets.all(15),
                color: Colors.white,
                child: Text(
                  item.name,
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
              ),
          dropdownSearchDecoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
            border: OutlineInputBorder(),
          ),
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
              labelText: "Search Option",
              prefixIcon: Icon(Icons.search),
            ),
          ),
          onChanged: onChanged!,
          selectedItem: selecteditem!),
    ),
  );
  return objWidget;
}

Widget DropDownWithModel(
    {List<DropdownModel>? itemlist,
    DropdownModel? selecteditem,
    String? hint,
    Function()? onClear,
    Function(DropdownModel?)? onChanged}) {
  if (selecteditem == null) {
    selecteditem = DropdownModel(hint!, hint);
  }
  Widget objWidget = Container(
    child: Card(
      elevation: 2,
      color: Colors.green,
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
        Radius.circular(5.0),
      )),
      child: DropdownSearch<DropdownModel>(
          mode: Mode.BOTTOM_SHEET,
          showSearchBox: true,
          items: itemlist,
          filterFn: (instance, filter) {
            if (instance!.name.toLowerCase().contains(filter!.toLowerCase())) {
              print(filter);
              return true;
            } else {
              return false;
            }
          },
          dropdownBuilder: (context, selectedItem) => Container(
                child: GestureDetector(
                  child: Text(
                    selecteditem!.name,
                    style: TextStyle(color: Colors.black, fontSize: 16.0),
                  ),
                  onTap: onClear,
                ),
              ),
          popupItemBuilder: (context, item, isSelected) => Container(
                padding: EdgeInsets.all(15),
                color: Colors.white,
                child: Text(
                  item.name,
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
              ),
          dropdownSearchDecoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
            border: OutlineInputBorder(),
          ),
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
              labelText: "Search Option",
              prefixIcon: Icon(Icons.search),
            ),
          ),
          onChanged: onChanged!,
          selectedItem: selecteditem!),
    ),
  );
  return objWidget;
}

Widget fileUpload(
    {String? label,
    Function()? onPressed,
    filename,
    ondelete,
    String? uploadFileName}) {
  AssetImage assetimage = AssetImage('images/docs.png');
  Widget objWidget = Container(
      child: Row(
    children: <Widget>[
      Container(
        margin: EdgeInsets.only(top: 10),
        child: FloatingActionButton(
          heroTag: null,
          backgroundColor: Colors.green,
          onPressed: onPressed,
          tooltip: 'Pick Image',
          child: Icon(
            Icons.attach_file,
            color: Colors.white,
          ),
        ),
      ),
      VerticalDivider(width: 10.0),
      Center(
          child: filename == null
              ? Text("")
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: 200.0,
                    child: Center(
                      child: Text(
                        uploadFileName!,
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                    ),
                  ),
                )),
      VerticalDivider(width: 10.0),
      Container(
        child: filename == null
            ? Text('')
            : Column(children: <Widget>[
                MaterialButton(
                  color: Colors.red,
                  child: Icon(
                    Icons.delete_forever,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    ondelete();
                  },
                ),
              ]),
      )
    ],
  ));
  return objWidget;
}

class DropdownModel {
  String name, value;

  DropdownModel(this.name, this.value);
}

class DropdownModelFarmer {
  String name, value, value2, value3;

  DropdownModelFarmer(this.name, this.value, this.value2, this.value3);
}

Future<List<String>> getData(filter) async {
// toast(filter);

  return [];
}

class DropdownModel1 {
  String name, value, value1;

  DropdownModel1(this.name, this.value, this.value1);
}

Widget DropDownWithModel1(
    {List<DropdownModel1>? itemlist,
      DropdownModel1? selecteditem,
      String? hint,
      Function()? onClear,
      Function(DropdownModel1?)? onChanged}) {
  selecteditem ??= DropdownModel1(hint!, hint, hint);
  Widget objWidget = Container(
    child: Card(
      elevation: 2,
      color: Colors.green,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          )),
      child: DropdownSearch<DropdownModel1>(
          mode: Mode.BOTTOM_SHEET,
          showSearchBox: true,
          items: itemlist,
          filterFn: (instance, filter) {
            if (instance!.name.toLowerCase().contains(filter!.toLowerCase())) {
              print(filter);
              return true;
            } else {
              return false;
            }
          },
          dropdownBuilder: (context, selectedItem) => Container(
            child: Text(
              selecteditem!.name,
              style: const TextStyle(color: Colors.black, fontSize: 15.0),
            ),
          ),
          popupItemBuilder: (context, item, isSelected) => Container(
            padding: const EdgeInsets.all(15),
            color: Colors.white,
            child: Text(
              item.name,
              style: const TextStyle(color: Colors.black, fontSize: 18.0),
            ),
          ),
          dropdownSearchDecoration: const InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
            border: OutlineInputBorder(),
          ),
          searchFieldProps: TextFieldProps(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
              labelText: "Search Option",
              prefixIcon: Icon(Icons.search),
            ),
          ),
          onChanged: onChanged!,
          selectedItem: selecteditem),
    ),
  );
  return objWidget;
}