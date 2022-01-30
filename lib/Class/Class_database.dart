import 'dart:async';
import 'dart:convert';
import 'package:crypt/crypt.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../Login_Mailing.dart';
import 'Constant.dart';

class Notification_Message {
  Messaging? messaging;
  Member? member;
  bool? Notifi_State;

  void set setmessaging(Messaging messaging){
    this.messaging = messaging;
  }
  Messaging get getmessaging{
    return this.messaging!;
  }
  void set setmember(Member member){
    this.member = member;
  }
  Member get getmember{
    return this.member!;
  }
  void set setNotifiState(bool state){
    this.Notifi_State = state;
  }
  bool get getNotifiState{
    return this.Notifi_State!;
  }

  Notification_Message(){
    this.member = Member();
    this.messaging = Messaging();
    this.Notifi_State = true;
}
}


class Messaging {
  late int MessageID;
  late String MessageType,
      MessageState,
      MessageSymbol,
      MessageLink,
      Target1,
      Target2,
      OrderStopLoss,
      MessageContent,MessageDate,MessageCountView;
  late double MessagePrice, MessageEntryPoint;

  void set setMessagePrice(double data){
    this.MessagePrice = data;
  }
  double get getmessageprice{
    return this.MessagePrice;
  }

  Messaging() {
    this.MessageCountView = "0";
    this.MessageID = 1;
    this.MessageType = "5";
    this.MessageDate = "";
    this.MessageLink =
        "https://cdn.pixabay.com/photo/2017/10/17/16/10/fantasy-2861107_960_720.jpg";
    this.MessagePrice = 0.0;
    this.MessageState = "O";
    this.MessageSymbol = "ASDFGASAS";
    this.MessageContent = "ASDFGASASIOURYJKGBFCNAB ";
    this.OrderStopLoss = "0.2563";
    this.Target1 = "2.3333";
    this.Target2 = "3.2222";
    this.MessageEntryPoint = 2.33333;
  }
}

class Messaging_PR {
  late int ProgramID;
  late String ProgramType, ProgramLink, ProgramContent;
  List<Imagen> list_image = [];

  void set setprogramtype(String type){
    this.ProgramType = type;
  }
  String get gettype{
    return this.ProgramType;
  }
  void set setlistimage(List<Imagen> list){
    this.list_image = list;
  }
  List<Imagen> get getlistimage{
    return this.list_image;
  }
  void set setlink(String link){
    this.ProgramLink = link;
  }
  String get getlink{
    return this.ProgramLink;
  }
  void set setcontent(String content){
    this.ProgramContent = content;
  }
  String get getcontent{
    return this.ProgramContent;
  }

  Messaging_PR() {
    this.ProgramID = 1;
    this.ProgramType = "Sell Stop";
    this.list_image.add(Imagen());
    this.ProgramLink =
        "https://cdn.pixabay.com/photo/2017/10/17/16/10/fantasy-2861107_960_720.jpg";
    this.ProgramContent = "ASDFGASASIOURYJKGBFCNAB ";
  }
}

class Messaging_PU {
  late int PublicID;
  late String PublicContent,Title,DatePu;
  late bool PublicType;

  void set setdatepu(String date){
    this.DatePu = date;
  }
  String get getdatepu{
    return this.DatePu;
  }

  void set setTitle(String title){
    this.Title = title;
  }
  String get gettitle{
    return this.Title;
  }

  void set setpublictype(bool type){
    this.PublicType = type;
  }
  bool get gettype{
    return this.PublicType;
  }
  void set setcontent(String content){
    this.PublicContent = content;
  }
  String get getcontent{
    return this.PublicContent;
  }

  Messaging_PU() {
    this.DatePu = "01/03/2022 05:33:02";
    this.Title = "Hi...";
    this.PublicID = 1;
    this.PublicType = true;
    this.PublicContent = "ASDFGASASIOURYJKGBFCNAB ";
  }
}

class Imagen{
  late String Id;
  late String Image_Link;
  Imagen(){
    this.Id = "1";
    this.Image_Link = "https://cdn.pixabay.com/photo/2017/10/17/16/10/fantasy-2861107_960_720.jpg";
  }
}

class Member {
  String? Email, Image , Password;
  bool? checkemailfound;

  String get getEmail {
    return this.Email!;
  }

  String get getImage {
    return this.Image!;
  }

  String get getPassword {
    return this.Password!;
  }

  set setEmail(String email) {
    this.Email = email;
  }

  set setImage(String image) {
    this.Image = image;
  }

  set setPassword(String password) {
    this.Password = password;
  }

  Member({Email, Image}) {
    this.Email = Email;
    if(Image!=null && Image!=""){
      this.Image = Image;
    }else {
      this.Image = "https://jabbareh.files.wordpress.com/2011/12/personal-information.png";
    }
    this.Password = "";
  }

  factory Member.fromJson(Map<String,dynamic> json)=>Member(
    Email: json['email'],
    Image: json['picture']['data']['url']
  );

   static Future<String> _localPath()async {
     Directory? directory = Platform.isAndroid
         ? await getExternalStorageDirectory()
         : await getApplicationSupportDirectory();

    // if(!Directory("/storage/emulated/0/Android/data/com.example.mailing/files").existsSync()) {
    //   Directory("/storage/emulated/0/Android/data/com.example.mailing/files").createSync();
    // }
    // Directory directory = Directory("/storage/emulated/0/Android/data/com.example.mailing/files");
    //
    return directory!.path;
  }

  static Future<File> _localFile() async {
    String path = await _localPath();
    if(!File('$path/InfoLogIn.txt').existsSync()){
      File("${path}/Info_LogIn.txt").create();
    }
    return File("${path}/Info_LogIn.txt");
  }

  writeFileLogIn() async {
    // Write the file
    File file = await _localFile();

    file.openWrite(mode: FileMode.write).write('${this.Email},${this.Image}');
  }
  deletefile() async{
    File file = await _localFile();

    await file.delete();
  }

  Future<bool> readFileLogIn()async {
    try {
      File file = await _localFile();
      if (file.existsSync()) {
        // Read the file
        var string = file.readAsStringSync();
        List<String> profile = string.split(",");
        this.Email = profile[0];
        this.Image = profile[1];
        return await checkemail(this.Email!);
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      // If encountering an error, return 0
    }
    return false;
  }

  Future<bool> checkemail(String m)async{
    var secret = Crypt.sha256("mailing_validemail");
    Uri url =
    Uri(host: host, path: 'Mailing_API/validemail.php', scheme: scheme);
    var response =
        await http.post(url, body: {'email': m, 'secret': '$secret'});
    int status = response.statusCode;
    switch (status) {
      case 200:
        {
          return true;
        }
      default:
        {
          return false;
        }
    }
  }

}
abstract class DataBase_Access {
  Future<bool> Insert(List<String> list);

  Future<bool> Ubdate(List<String> list);
  Future<bool> Delete(String id);

  Future<List<Messaging>> Select();

  Future<bool> Status(int codestate);
}

class Messsage_DataBase extends DataBase_Access{

  @override
  Future<bool> Insert(List<String> list)async{
    if(list.isEmpty){
      return false;
    }else {
      var secret = Crypt.sha256("insert_message");
      Uri url = Uri(
          host: host, path: 'Mailing_API/Insert/Insert.php', scheme: scheme);
      var response =
      await http.post(url, body: {
        'type': list.elementAt(0),
        'state': list.elementAt(1),
        'price': list.elementAt(2),
        'name': list.elementAt(3),
        'link': list.elementAt(4),
        'target1': list.elementAt(5),
        'target2': list.elementAt(6),
        'stoploss': list.elementAt(7),
        'content': list.elementAt(8),
        'entrypoint': list.elementAt(9),
        'secret': '$secret'
      }
      );
      return Status(response.statusCode);
    }
  }

  @override
  Future<bool> Ubdate(List<String> list)async{
    if(list.isEmpty){
      return false;
    }else {
      var secret = Crypt.sha256("ubdate_message");
      Uri url = Uri(
          host: host, path: 'Mailing_API/Ubdate/Ubdate.php', scheme: scheme);
      var response =
      await http.post(url, body: {
        'id': list.elementAt(0),
        'type': list.elementAt(1),
        'state': list.elementAt(2),
        'price': list.elementAt(3),
        'name': list.elementAt(4),
        'link': list.elementAt(5),
        'target1': list.elementAt(6),
        'target2': list.elementAt(7),
        'stoploss': list.elementAt(8),
        'content': list.elementAt(9),
        'entrypoint': list.elementAt(10),
        'secret': '$secret'
      }
      );
      return Status(response.statusCode);
    }
  }

  @override
  Future<bool> Delete(String id)async{
    if(id.isEmpty){
      return false;
    }else {
      var secret = Crypt.sha256("delete_message");
      Uri url = Uri(
          host: host, path: 'Mailing_API/Delete/Delete.php', scheme: scheme);
      var response =
      await http.post(url, body: {
        'id': id,
        'secret': '$secret'
      }
      );
      return Status(response.statusCode);
    }
  }

  @override
  Future<bool> Status(int codestate)async{
    String errorMsg = '';
    switch (codestate) {
      case 200:
        {
          errorMsg = 'Successfully';
          showtoast(errorMsg);
          return true;
        }
      case 400:
        {
          errorMsg = 'Please check your data and try again';
          showtoast(errorMsg);
          return false;
        }
      case 500:
        {
          errorMsg = 'Something went wrong! please try again later';
          showtoast(errorMsg);
          return false;
        }
      default:
        {
          errorMsg =
          'Please check your internet connection and try again';
          showtoast(errorMsg);
          return  false;
        }
    }
  }
  @override
  Future<List<Messaging>> Select()async{
    List<Messaging> listmessage = [];
    var secret = Crypt.sha256("select_message");
    Uri url = Uri(
        host: host,
        path: 'Mailing_API/Select/get_Message.php',
        scheme: scheme);
    var response = await http.post(url, body: {'secret': '$secret'
    });
    if(await Status(response.statusCode)){

      List<dynamic> data = json.decode(response.body);
      for(int i = 0 ;i<data.length;i++){
        listmessage.add(Messaging());
        listmessage[i].MessageID =int.parse(data.elementAt(i)['MessageID']);
        listmessage[i].MessageType = data.elementAt(i)['MessageType'];
        listmessage[i].MessageState = data.elementAt(i)['MessageState'];
        listmessage[i].MessageState = data.elementAt(i)['MessageCountView'];
        listmessage[i].MessagePrice =double.parse(data.elementAt(i)['MessagePrice']);
        listmessage[i].MessageDate = data.elementAt(i)['MessageDate'];
        listmessage[i].MessageSymbol = data.elementAt(i)['MessageSymbol'];
        listmessage[i].MessageLink = data.elementAt(i)['MessageLink'];
        listmessage[i].Target1 = data.elementAt(i)['Target1'];
        listmessage[i].Target2 = data.elementAt(i)['Target2'];
        listmessage[i].OrderStopLoss = data.elementAt(i)['OrderStopLoss'];
        listmessage[i].MessageContent = data.elementAt(i)['MessageContent'];
        listmessage[i].MessageEntryPoint =double.parse(data.elementAt(i)['EntryPoint']);
      }
      return listmessage;
    }else{
      return listmessage;
    }
  }
}

