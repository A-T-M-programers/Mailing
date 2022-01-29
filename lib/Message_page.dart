import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mailing/Class/Get_Photo.dart';
import 'package:mailing/Login_Mailing.dart';
import 'package:mailing/Pages_File/Notif_Page.dart';
import 'package:mailing/Pages_File/Program_Page.dart';
import 'package:mailing/Validate.dart';
import 'package:mailing/main.dart';

import 'Class/Class_database.dart';
import 'Home_Page.dart';
import 'l10n/applocal.dart';

late bool checkadmin, checkubdate = true;
BoxShadow? boxShadowOnClick =
        BoxShadow(color: Colors.white, spreadRadius: 10, blurRadius: 40),
    boxShadowS,
    boxShadowPu,
    boxShadowPr,
    boxShadowUpClick =
        BoxShadow(color: Color.fromARGB(500, 12, 0, 74), blurRadius: 10);

class message_page extends StatefulWidget {
  message_page(String type_page,var messaging) {
    this.type_page = type_page;
    this.messaging = messaging;
  }

  @override
  message_page_state createState() => message_page_state();

  late final String? type_page;
  late var messaging;

}

class message_page_state extends State<message_page> {
  Widget? body_message_contain;
  double WidthDevice = 0, HieghDevice = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.type_page == "S" || widget.type_page == "SI") {
      this.body_message_contain =
          body_message(message: widget.messaging, type: widget.type_page!);

      boxShadowS = boxShadowOnClick;
      boxShadowPu = boxShadowUpClick;
      boxShadowPr = boxShadowUpClick;
    } else if (widget.type_page == "P" || widget.type_page == "PI") {
      this.body_message_contain =
          body_message_pr(message: program!, type: widget.type_page!);

      boxShadowPr = boxShadowOnClick;
      boxShadowPu = boxShadowUpClick;
      boxShadowS = boxShadowUpClick;
    } else if (widget.type_page == "N" || widget.type_page == "NI") {
      this.body_message_contain = body_message_pu(
          messaging_pu: messaging_pu, typepage: widget.type_page!);

      boxShadowPu = boxShadowOnClick;
      boxShadowPr = boxShadowUpClick;
      boxShadowS = boxShadowUpClick;
    }
  }

  @override
  Widget build(BuildContext context) {
    checkadmin = true;
    WidthDevice = MediaQuery.of(context).size.width;
    HieghDevice = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          titleSpacing: WidthDevice / 3,
          title: Text(
            "${getLang(context, "Mailing")}",
          ),
          elevation: 10,
          toolbarHeight: HieghDevice / 12,
          backgroundColor: Color.fromARGB(500, 12, 0, 74),
        ),
        body: Stack(
          children: [
            Container(
                margin: EdgeInsets.only(top: checkadmin ? HieghDevice / 17 : 0),
                color: Color.fromARGB(500, 12, 0, 74),
                child: Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(color: Colors.white),
                        BoxShadow(color: Colors.white),
                        BoxShadow(color: Colors.white),
                        BoxShadow(color: Colors.white),
                        BoxShadow(color: Colors.white),
                        BoxShadow(color: Colors.white),
                        BoxShadow(color: Colors.white),
                      ],
                      border: Border.all(color: Colors.white, width: 10),
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50))),
                  width: WidthDevice,
                  height: HieghDevice / 14,
                  child: null,
                )),
            SingleChildScrollView(
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100),
                            bottomRight: Radius.circular(100)),
                        color: Colors.white70,
                        boxShadow: [
                          BoxShadow(color: Colors.black38, blurRadius: 10)
                        ]),
                    width: WidthDevice,
                    height: (HieghDevice -
                        ((HieghDevice / 17) + (HieghDevice / 20)) +
                        WidthDevice / 2.7),
                    margin: EdgeInsets.only(
                        top: checkadmin
                            ? (HieghDevice / 34) + (HieghDevice / 14)
                            : HieghDevice / 34,
                        left: 30,
                        right: 30,
                        bottom: 20),
                    child: body_message_contain)),
            if (checkadmin)
              Container(
                child: Row(
                  children: [
                    Container(
                      height: HieghDevice / 17,
                      width: WidthDevice / 3,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            boxShadowS = boxShadowUpClick;
                            boxShadowPu = boxShadowOnClick;
                            boxShadowPr = boxShadowUpClick;

                            this.body_message_contain = body_message_pu(
                                messaging_pu: messaging_pu!,
                                typepage: widget.type_page!);
                          });
                        },
                        child: Container(
                            decoration:
                                BoxDecoration(boxShadow: [boxShadowPu!]),
                            child:
                                Text('${getLang(context, "Message_Public")}')),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(500, 12, 0, 74),
                            ),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.zero)))),
                      ),
                    ),
                    Container(
                      height: HieghDevice / 17,
                      width: WidthDevice / 3,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            boxShadowS = boxShadowOnClick;
                            boxShadowPu = boxShadowUpClick;
                            boxShadowPr = boxShadowUpClick;
                            this.body_message_contain = body_message(
                                message: widget.messaging, type: widget.type_page!);
                          });
                        },
                        child: Container(
                            decoration: BoxDecoration(boxShadow: [boxShadowS!]),
                            child:
                                Text('${getLang(context, "Message_Sympole")}')),
                        style: ButtonStyle(
                            //elevation: MaterialStateProperty.all(5),
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromARGB(500, 12, 0, 74)),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.zero)))),
                      ),
                    ),
                    Container(
                      height: HieghDevice / 17,
                      width: WidthDevice / 3,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            boxShadowS = boxShadowUpClick;
                            boxShadowPu = boxShadowUpClick;
                            boxShadowPr = boxShadowOnClick;

                            this.body_message_contain = body_message_pr(
                                message: program!, type: widget.type_page!);
                          });
                        },
                        child: Container(
                            decoration:
                                BoxDecoration(boxShadow: [boxShadowPr!]),
                            child: Text(
                                '${getLang(context, "Message_Programing")}')),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(500, 12, 0, 74),
                            ),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.zero)))),
                      ),
                    )
                  ],
                ),
              ),
            checkubdate
                ? Container(
                    alignment:
                        notife ? Alignment.bottomLeft : Alignment.bottomRight,
                    child: Container(
                        constraints:
                            BoxConstraints(minWidth: 60, minHeight: 60),
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(color: Colors.black38, blurRadius: 10)
                            ],
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.green),
                        padding: EdgeInsets.only(bottom: 3),
                        margin: EdgeInsets.only(
                            top: HieghDevice / 1.7,
                            left: 10,
                            right: 10,
                            bottom: 30),
                        child: IconButton(
                          onPressed: _hundUbdateMessage,
                          icon: Icon(
                            Icons.update,
                            color: Colors.white70,
                            size: 35,
                          ),
                          constraints:
                              BoxConstraints(maxWidth: 60, maxHeight: 60),
                        )),
                  )
                : Container(
                    alignment:
                        notife ? Alignment.bottomLeft : Alignment.bottomRight,
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(color: Colors.black38, blurRadius: 10)
                          ],
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(50)),
                      padding: EdgeInsets.only(bottom: 3),
                      margin: EdgeInsets.only(
                          top: HieghDevice / 1.7,
                          left: 10,
                          right: 10,
                          bottom: 30),
                      child: IconButton(
                          onPressed: _hundSendMessage,
                          icon: Icon(
                            Icons.send_rounded,
                            color: Colors.white70,
                            size: 35,
                          )),
                    )),
          ],
        ),
      ),
    );
  }
  Future<void> _hundSendMessage() async{
    if (Validation.isValidnull(
        Message_Sympole_Price.text) &&
        Validation.isValidnull(
            Message_Sympole_MEP.text) &&
        Validation.isValidnull(
            Message_Sympole_OSL.text) &&
        Validation.isValidnull(
            Message_Sympole_Target2.text) &&
        Validation.isValidnull(
            Message_Sympole_Target1.text) &&
        Validation.isValidnull(
            Message_Sympole_Content.text) &&
        Validation.isValidnull(
            Message_Sympole.text) &&
        Validation.isValidnull(
            path)) {
      List<String> list = [];
      list.add(numberdropdownValue!);
      list.add("0");
      list.add(Message_Sympole_Price.text);
      list.add(Message_Sympole.text);
      list.add(path);
      list.add(Message_Sympole_Target1.text);
      list.add(Message_Sympole_Target2.text);
      list.add(Message_Sympole_OSL.text);
      list.add(Message_Sympole_Content.text);
      list.add(Message_Sympole_MEP.text);
      Messsage_DataBase message_database =
      Messsage_DataBase();

      if (await message_database.Insert(list)) {
    Message_Sympole_Price.clear();
    Message_Sympole_MEP.clear();
    Message_Sympole_OSL.clear();
    Message_Sympole_Target2.clear();
    Message_Sympole_Target1.clear();
    Message_Sympole_Content.clear();
    Message_Sympole.clear();
    path =
    "https://cdn.pixabay.com/photo/2017/10/17/16/10/fantasy-2861107_960_720.jpg";
    }else{
    showtoast('${getLang(context, "No_Insert")}');
    }
    } else {
    showtoast('${getLang(context, "Field_Empty")}');
    }
  }
  Future<void> _hundUbdateMessage() async{
    if (Validation.isValidnull(
        Message_Sympole_Price.text) &&
        Validation.isValidnull(
            Message_Sympole_MEP.text) &&
        Validation.isValidnull(
            Message_Sympole_OSL.text) &&
        Validation.isValidnull(
            Message_Sympole_Target2.text) &&
        Validation.isValidnull(
            Message_Sympole_Target1.text) &&
        Validation.isValidnull(
            Message_Sympole_Content.text) &&
        Validation.isValidnull(
            Message_Sympole.text) &&
        Validation.isValidnull(
            path)) {
      List<String> list = [];
      list.add(widget.messaging.MessageID.toString());
      list.add(numberdropdownValue!);
      list.add("0");
      list.add(Message_Sympole_Price.text);
      list.add(Message_Sympole.text);
      list.add(path);
      list.add(Message_Sympole_Target1.text);
      list.add(Message_Sympole_Target2.text);
      list.add(Message_Sympole_OSL.text);
      list.add(Message_Sympole_Content.text);
      list.add(Message_Sympole_MEP.text);
      Messsage_DataBase message_database =
      Messsage_DataBase();

      if (await message_database.Ubdate(list)) {
        Message_Sympole_Price.clear();
        Message_Sympole_MEP.clear();
        Message_Sympole_OSL.clear();
        Message_Sympole_Target2.clear();
        Message_Sympole_Target1.clear();
        Message_Sympole_Content.clear();
        Message_Sympole.clear();
        path =
        "https://cdn.pixabay.com/photo/2017/10/17/16/10/fantasy-2861107_960_720.jpg";
      }else{
        showtoast('${getLang(context, "No_Ubdate")}');
      }
    } else {
      showtoast('${getLang(context, "Field_Empty")}');
    }
  }
}

class body_message extends StatefulWidget {
  const body_message({required this.message, required this.type});

  @override
  body_message_state createState() => body_message_state();

  final Messaging message;
  final String type;
}

late TextEditingController Message_Sympole,
    Message_Sympole_Content,
    Message_Sympole_Target1,
    Message_Sympole_Target2,
    Message_Sympole_OSL,
    Message_Sympole_MEP,
    Message_Sympole_Price;
late String? numberdropdownValue = "0";

class body_message_state extends State<body_message> {
  double WidthDevice = 0, HieghDevice = 0;

  late String? dropdownValue = "Buy";
  late bool colortype = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dropdownValue =
        Message_type.values.elementAt(int.parse(widget.message.MessageType));
    numberdropdownValue = widget.message.MessageType;
  }

  @override
  Widget build(BuildContext context) {
    WidthDevice = MediaQuery.of(context).size.width;
    HieghDevice = MediaQuery.of(context).size.height;

    if (widget.message != null && widget.type == "S") {
      Message_Sympole =
          TextEditingController(text: widget.message.MessageSymbol);
      Message_Sympole_Content =
          TextEditingController(text: widget.message.MessageContent);
      Message_Sympole_Target1 =
          TextEditingController(text: widget.message.Target1.toString());
      Message_Sympole_Target2 =
          TextEditingController(text: widget.message.Target2.toString());
      Message_Sympole_OSL =
          TextEditingController(text: widget.message.OrderStopLoss);
      Message_Sympole_MEP = TextEditingController(
          text: widget.message.MessageEntryPoint.toString());
      Message_Sympole_Price =
          TextEditingController(text: widget.message.MessagePrice.toString());
    } else {
      Message_Sympole = TextEditingController();
      Message_Sympole_Content = TextEditingController();
      Message_Sympole_Target1 = TextEditingController();
      Message_Sympole_Target2 = TextEditingController();
      Message_Sympole_OSL = TextEditingController();
      Message_Sympole_MEP = TextEditingController();
      Message_Sympole_Price = TextEditingController();
    }

    return Form(
        autovalidateMode: AutovalidateMode.always,
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Container(
              width: WidthDevice / 1.15,
              margin: EdgeInsets.only(top: 590, left: 20, right: 20),
              child: Row(
                children: [
                  Text(
                    "${getLang(context, "Price")} :",
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                      width: WidthDevice / 2.5,
                      child: TextFormField(
                        controller: Message_Sympole_Price,
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.cyan),
                          labelText: "${getLang(context, "Enter_Price")}",
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color: Colors.black54, width: 5),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) => Validation.isValidnull(value!)
                            ? null
                            : '${getLang(context, "ValidContent")}',
                        onSaved: (val) =>
                            widget.message.setMessagePrice = val! as double,
                      ))
                ],
              ),
            ),
            Container(
              width: WidthDevice / 1.15,
              margin: EdgeInsets.only(top: 120, left: 20, right: 20),
              child: Row(
                children: [
                  Text(
                    '${getLang(context, "Order_Type")}',
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                      width: WidthDevice / 2.5,
                      child: DropdownButton<String>(
                        dropdownColor: Colors.white,
                        value: dropdownValue,
                        icon: const Icon(Icons.filter_list_rounded),
                        elevation: 16,
                        style: TextStyle(
                            color: colortype ? Colors.blue : Colors.redAccent),
                        underline: Container(
                          height: 2,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                            for(int i = 0 ; i<Message_type.length;i++){
                              if(newValue == Message_type.values.elementAt(i)){
                                numberdropdownValue = i.toString();
                              }
                            }
                          });
                        },
                        items: <String>['0', '1', '2', '3', '4', '5']
                            .map<DropdownMenuItem<String>>((String value) {
                          colortype = (int.parse(value) < 3)
                              ? true
                              : false;
                          return DropdownMenuItem<String>(
                            value:
                                Message_type.values.elementAt(int.parse(value)),
                            child: Text(
                              Message_type.values.elementAt(int.parse(value)),
                              style: TextStyle(
                                  color: colortype
                                      ? Colors.blue
                                      : Colors.redAccent),
                            ),
                          );
                        }).toList(),
                      ))
                ],
              ),
            ),
            Container(
              width: WidthDevice / 1.15,
              margin: EdgeInsets.only(top: 520, left: 20, right: 20),
              child: Row(
                children: [
                  Text(
                    '${getLang(context, "Entry_Point")}',
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                      width: WidthDevice / 2.5,
                      child: TextFormField(
                        controller: Message_Sympole_MEP,
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.cyan),
                          labelText: '${getLang(context, "Enter_Entry_Point")}',
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color: Colors.black54, width: 5),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) => Validation.isValidnull(value!)
                            ? null
                            : '${getLang(context, "ValidContent")}',
                        onSaved: (val) =>
                            widget.message.MessageEntryPoint = val! as double,
                      ))
                ],
              ),
            ),
            Container(
              width: WidthDevice / 1.15,
              margin: EdgeInsets.only(top: 440, left: 20, right: 20),
              child: Row(
                children: [
                  Text(
                    '${getLang(context, "Stop_Loss")}',
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                      width: WidthDevice / 2.5,
                      child: TextFormField(
                        controller: Message_Sympole_OSL,
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.cyan),
                          labelText: '${getLang(context, "Enter_Stop_Loss")}',
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color: Colors.black54, width: 5),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) => Validation.isValidnull(value!)
                            ? null
                            : '${getLang(context, "ValidContent")}',
                        onSaved: (val) => widget.message.OrderStopLoss = val!,
                      ))
                ],
              ),
            ),
            Container(
              width: WidthDevice / 1.15,
              margin: EdgeInsets.only(top: 370, left: 20, right: 20),
              child: Row(
                children: [
                  Text(
                    '${getLang(context, "Target2")}',
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                      width: WidthDevice / 2.5,
                      child: TextFormField(
                        controller: Message_Sympole_Target2,
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.cyan),
                          labelText: '${getLang(context, "Enter_Target2")}',
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color: Colors.black54, width: 5),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) => Validation.isValidnull(value!)
                            ? null
                            : '${getLang(context, "ValidContent")}',
                        onSaved: (val) => widget.message.Target2 = val!,
                      ))
                ],
              ),
            ),
            Container(
              width: WidthDevice / 1.15,
              margin: EdgeInsets.only(top: 300, left: 20, right: 20),
              child: Row(
                children: [
                  Text(
                    '${getLang(context, "Target1")}',
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                      width: WidthDevice / 2.5,
                      child: TextFormField(
                        controller: Message_Sympole_Target1,
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.cyan),
                          labelText: '${getLang(context, "Enter_Target1")}',
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color: Colors.black54, width: 5),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) => Validation.isValidnull(value!)
                            ? null
                            : '${getLang(context, "ValidContent")}',
                        onSaved: (val) => widget.message.Target1 = val!,
                      ))
                ],
              ),
            ),
            Container(
              width: WidthDevice / 1.15,
              margin: EdgeInsets.only(top: 230, left: 20, right: 20),
              child: Row(
                children: [
                  Text(
                    '${getLang(context, "Order_Content")}',
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                      width: WidthDevice / 2.5,
                      child: TextFormField(
                        controller: Message_Sympole_Content,
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.cyan),
                          labelText: '${getLang(context, "Enter_Content")}',
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color: Colors.black54, width: 5),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) => Validation.isValidnull(value!)
                            ? null
                            : '${getLang(context, "ValidContent")}',
                        onSaved: (val) => widget.message.MessageContent = val!,
                      ))
                ],
              ),
            ),
            Container(
              width: WidthDevice / 1.15,
              margin: EdgeInsets.only(top: 160, left: 20, right: 20),
              child: Row(
                children: [
                  Text(
                    '${getLang(context, "Sympole_Name")}',
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                      width: WidthDevice / 2.5,
                      child: TextFormField(
                        controller: Message_Sympole,
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.cyan),
                          labelText: '${getLang(context, "Enter_Sympole")}',
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color: Colors.black54, width: 5),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) => Validation.isValidnull(value!)
                            ? null
                            : '${getLang(context, "ValidContent")}',
                        onSaved: (val) => widget.message.MessageSymbol = val!,
                      ))
                ],
              ),
            ),
            Container(
              height: 100,
              width: 100,
              child: Stack(children: [
                GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => show_photo(
                                      path: widget.message.MessageLink,
                                    )));
                      });
                    },
                    child: CachedNetworkImage(
                      imageUrl: widget.message.MessageLink,
                      imageBuilder: (context, imageProvider) {
                        return Container(
                            decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(color: Colors.black38, blurRadius: 10)
                          ],
                          borderRadius: BorderRadius.circular(50),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.fill,
                          ),
                        ));
                      },
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )),
                if (checkadmin)
                  Container(
                      margin: EdgeInsets.only(top: 62, left: 62),
                      child: IconButton(
                        onPressed: () async {
                          await get_photo.showSelectionDialog(context);
                          setState(() {
                            print("Hello");
                          });
                        },
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.green,
                          size: 30,
                        ),
                      ))
              ]),
            ),
          ],
        ));
  }
}

class body_message_pr extends StatefulWidget {
  const body_message_pr({required this.message, required this.type});

  @override
  body_message_pr_state createState() => body_message_pr_state();

  final Messaging_PR message;
  final String type;
}

class body_message_pr_state extends State<body_message_pr> {
  late TextEditingController Program_Link, Program_Content;
  double WidthDevice = 0, HieghDevice = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidthDevice = MediaQuery.of(context).size.width;
    HieghDevice = MediaQuery.of(context).size.height;

    if (widget.message != null && widget.type == "P") {
      Program_Link = TextEditingController(text: widget.message.getlink);
      Program_Content = TextEditingController(text: widget.message.getcontent);
    } else {
      Program_Link = TextEditingController();
      Program_Content = TextEditingController();
    }

    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        Container(
          width: WidthDevice / 1.15,
          margin: EdgeInsets.only(top: 200, left: 20, right: 20),
          child: Row(
            children: [
              Text(
                '${getLang(context, "Program_Content")}',
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                  width: WidthDevice / 2.5,
                  child: TextField(
                    controller: Program_Content,
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.cyan),
                      labelText: '${getLang(context, "Enter_Content")}',
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.black54, width: 5),
                      ),
                    ),
                  ))
            ],
          ),
        ),
        Container(
          width: WidthDevice / 1.15,
          margin: EdgeInsets.only(top: 120, left: 20, right: 20),
          child: Row(
            children: [
              Text(
                '${getLang(context, "Program_Link")}',
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                  width: WidthDevice / 2.5,
                  child: TextField(
                    controller: Program_Link,
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.cyan),
                      labelText: '${getLang(context, "Link")}',
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.black54, width: 5),
                      ),
                    ),
                  ))
            ],
          ),
        ),
        Container(
          height: 100,
          width: 100,
          child: Stack(children: [
            CachedNetworkImage(
              imageUrl: widget.message.getlistimage[0].Image_Link,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 10)],
                  borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            if (checkadmin)
              Container(
                  margin: EdgeInsets.only(top: 62, left: 62),
                  child: IconButton(
                    onPressed: () => {},
                    icon: Icon(
                      Icons.camera_alt,
                      color: Colors.green,
                      size: 30,
                    ),
                  ))
          ]),
        ),
      ],
    );
  }
}

class body_message_pu extends StatefulWidget {
  @override
  body_message_pu_state createState() => body_message_pu_state();

  body_message_pu({required this.typepage, required this.messaging_pu});

  final String typepage;
  final Messaging_PU? messaging_pu;
}

class body_message_pu_state extends State<body_message_pu> {
  late TextEditingController Public_Content, Public_Title;
  double WidthDevice = 0, HieghDevice = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidthDevice = MediaQuery.of(context).size.width;
    HieghDevice = MediaQuery.of(context).size.height;

    if (widget.messaging_pu != null && widget.typepage == "N") {
      Public_Content =
          TextEditingController(text: widget.messaging_pu!.getcontent);
      Public_Title = TextEditingController(text: widget.messaging_pu!.gettitle);
    } else {
      Public_Content = TextEditingController();
      Public_Title = TextEditingController();
    }

    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        Container(
          width: WidthDevice / 1.15,
          margin: EdgeInsets.only(top: 200, left: 20, right: 20),
          child: Column(
            children: [
              Text(
                '${getLang(context, "Public_Title")}',
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                  width: WidthDevice / 1.15,
                  child: TextField(
                    controller: Public_Title,
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.cyan),
                      labelText: '${getLang(context, "Enter_Content")}',
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.black54, width: 5),
                      ),
                    ),
                  )),
              SizedBox(
                height: 40,
              ),
              Text(
                '${getLang(context, "Public_Content")}',
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                  width: WidthDevice / 1.15,
                  child: TextField(
                    controller: Public_Content,
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.cyan),
                      labelText: '${getLang(context, "Enter_Content")}',
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.black54, width: 5),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ],
    );
  }
}
