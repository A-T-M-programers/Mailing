import 'dart:async';
import 'dart:convert';
import 'package:crypt/crypt.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_auth/http_auth.dart';
import 'package:mailing/Class/Get_Photo.dart';
import 'package:mailing/Home_Page.dart';
import 'package:mailing/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Login_Mailing.dart';
import '../Validate.dart';
import 'Constant.dart';
import 'Notification_OneSignal.dart';

class StorageManager {
  static void saveData(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is int) {
      prefs.setInt(key, value);
    } else if (value is String) {
      prefs.setString(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    } else {
      print("Invalid Type");
    }
  }

  static Future<dynamic> readData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    dynamic obj = prefs.get(key);
    return obj;
  }

  static Future<bool> deleteData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }
}

class Notification_Message {
  int? messaging_id;
  String? member, type, content, title, date;
  bool? Notifi_State;

  void set setmessaging(int? messaging_id) {
    this.messaging_id = messaging_id;
  }

  int? get getmessaging_id {
    return this.messaging_id!;
  }

  void set setmember(String? member) {
    this.member = member;
  }

  String? get getmember {
    return this.member!;
  }

  String? get gettitle {
    return this.title!;
  }

  void set setNotifiState(bool state) {
    this.Notifi_State = state;
  }

  bool get getNotifiState {
    return this.Notifi_State!;
  }

  Notification_Message() {
    this.member = "";
    this.messaging_id = 0;
    this.Notifi_State = true;
    this.content = "";
    this.type = "";
    this.title = "";
    this.date = "";
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
      MessageContent,
      MessageDate,
      MessageCountView;
  late double MessagePrice, MessageEntryPoint;

  void set setMessagePrice(double data) {
    this.MessagePrice = data;
  }

  double get getmessageprice {
    return this.MessagePrice;
  }

  Messaging() {
    this.MessageCountView = "0";
    this.MessageID = 0;
    this.MessageType = "5";
    this.MessageDate = "";
    this.MessageLink = "";
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
  List<String> list_image = [];

  void set setprogramtype(String type) {
    this.ProgramType = type;
  }

  String get gettype {
    return this.ProgramType;
  }

  void set setlistimage(List<String> list) {
    this.list_image = list;
  }

  List<String> get getlistimage {
    return this.list_image;
  }

  void set setlink(String link) {
    this.ProgramLink = link;
  }

  String get getlink {
    return this.ProgramLink;
  }

  void set setcontent(String content) {
    this.ProgramContent = content;
  }

  String get getcontent {
    return this.ProgramContent;
  }

  int get getID {
    return this.ProgramID;
  }

  void set setID(int ID) {
    this.ProgramID = ID;
  }

  Messaging_PR() {
    this.ProgramID = 0;
    this.ProgramType = "0";
    this.list_image.add("");
    this.ProgramLink = "";
    this.ProgramContent = "";
  }
}

class Messaging_PU {
  late int PublicID;
  late String PublicContent, Title, DatePu;
  late bool PublicType;

  void set setdatepu(String date) {
    this.DatePu = date;
  }

  String get getdatepu {
    return this.DatePu;
  }

  void set setTitle(String title) {
    this.Title = title;
  }

  String get gettitle {
    return this.Title;
  }

  void set setpublictype(bool type) {
    this.PublicType = type;
  }

  bool get gettype {
    return this.PublicType;
  }

  void set setcontent(String content) {
    this.PublicContent = content;
  }

  String get getcontent {
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

class Imagen {
  late String Id;
  late String Image_Link;

  Imagen() {
    this.Id = "1";
    this.Image_Link =
        "https://cdn.pixabay.com/photo/2017/10/17/16/10/fantasy-2861107_960_720.jpg";
  }
}

class Member {
  String? Email, Image, Password;
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
    if (Image != null && Image != "") {
      this.Image = Image;
    } else {
      this.Image =
          "https://jabbareh.files.wordpress.com/2011/12/personal-information.png";
    }
    this.Password = "";
  }

  factory Member.fromJson(Map<String, dynamic> json) =>
      Member(Email: json['email'], Image: json['picture']['data']['url']);

  static Future<String> _localPath() async {
    Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();
    return directory!.path;
  }

  static Future<File> _localFile() async {
    String path = await _localPath();
    if (!File('$path/InfoLogIn.txt').existsSync()) {
      File("${path}/Info_LogIn.txt").create();
    }
    return File("${path}/Info_LogIn.txt");
  }

  writeFileLogIn() async {
    // Write the file
    File file = await _localFile();

    file
        .openWrite(mode: FileMode.write)
        .write('${this.Email},${this.Image},${checkadmin ? 1 : 0}');
  }

  deletefile() async {
    File file = await _localFile();
    if (file.existsSync()) {
      await file.delete();
    }
  }

  Future<bool> readFileLogIn() async {
    try {
      File file = await _localFile();
      if (file.existsSync()) {
        // Read the file
        var string = file.readAsStringSync();
        List<String> profile = string.split(",");
        this.Email = profile[0];
        this.Image =
            profile[1] == null || profile[1] == "" ? this.Image : profile[1];
        checkadmin = profile[2] == "1" ? true : false;
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

  Future<bool> checkemail(String m) async {
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

  Future<List<dynamic>> Select();

  Future<bool> Status(int codestate);
}

class Messsage_DataBase extends DataBase_Access {
  @override
  Future<bool> Insert(List<String> list) async {
    if (list.isEmpty) {
      return false;
    } else {
      var secret = Crypt.sha256("insert_message");
      Uri url = Uri(
          host: host, path: 'Mailing_API/Insert/Insert.php', scheme: scheme);
      var response = await http.post(url, body: {
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
      });
      return Status(response.statusCode);
    }
  }

  @override
  Future<bool> Ubdate(List<String> list) async {
    if (list.isEmpty) {
      return false;
    } else {
      var secret = Crypt.sha256("ubdate_message");
      Uri url = Uri(
          host: host, path: 'Mailing_API/Ubdate/Ubdate.php', scheme: scheme);
      var response = await http.post(url, body: {
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
      });
      return Status(response.statusCode);
    }
  }

  @override
  Future<bool> Delete(String id) async {
    if (id.isEmpty) {
      return false;
    } else {
      var secret = Crypt.sha256("delete_message");
      Uri url = Uri(
          host: host, path: 'Mailing_API/Delete/Delete.php', scheme: scheme);
      var response =
          await http.post(url, body: {'id': id, 'secret': '$secret'});
      return Status(response.statusCode);
    }
  }

  @override
  Future<bool> Status(int codestate) async {
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
          errorMsg = 'Please check your internet connection and try again';
          showtoast(errorMsg);
          return false;
        }
    }
  }

  @override
  Future<List<Messaging>> Select() async {
    List<Messaging> listmessage = [];
    var secret = Crypt.sha256("select_message");
    Uri url = Uri(
        host: host, path: 'Mailing_API/Select/get_Message.php', scheme: scheme);
    var response = await http.post(url, body: {'secret': '$secret'});
    if (await Status(response.statusCode)) {
      List<dynamic> data = json.decode(response.body);
      for (int i = 0; i < data.length; i++) {
        listmessage.add(Messaging());
        listmessage[i].MessageID = int.parse(data.elementAt(i)['MessageID']);
        listmessage[i].MessageType = data.elementAt(i)['MessageType'];
        listmessage[i].MessageState = data.elementAt(i)['MessageState'];
        listmessage[i].MessageCountView = data.elementAt(i)['MessageCountView'];
        listmessage[i].MessagePrice =
            double.parse(data.elementAt(i)['MessagePrice']);
        listmessage[i].MessageDate = data.elementAt(i)['MessageDate'];
        listmessage[i].MessageSymbol = data.elementAt(i)['MessageSymbol'];
        listmessage[i].MessageLink = data.elementAt(i)['MessageLink'];
        listmessage[i].Target1 = data.elementAt(i)['Target1'];
        listmessage[i].Target2 = data.elementAt(i)['Target2'];
        listmessage[i].OrderStopLoss = data.elementAt(i)['OrderStopLoss'];
        listmessage[i].MessageContent = data.elementAt(i)['MessageContent'];
        listmessage[i].MessageEntryPoint =
            double.parse(data.elementAt(i)['EntryPoint']);
      }
      return listmessage;
    } else {
      return listmessage;
    }
  }
}

class Contentviewinfo_DataBase extends DataBase_Access {
  String? countview = "";

  @override
  Future<bool> Insert(List<String> list) async {
    if (list.isEmpty) {
      return false;
    } else {
      var secret = Crypt.sha256("insert_contentviewinfo");
      Uri url = Uri(
          host: host, path: 'Mailing_API/Insert/Insert.php', scheme: scheme);
      var response = await http.post(url, body: {
        'email_member': list.elementAt(0),
        'id_message': list.elementAt(1),
        'paymethod': list.elementAt(2),
        'secret': '$secret'
      });
      if (await Status(response.statusCode)) {
        countview = response.reasonPhrase;
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  Future<bool> Ubdate(List<String> list) async {
    if (list.isEmpty) {
      return false;
    } else {
      var secret = Crypt.sha256("ubdate_message");
      Uri url = Uri(
          host: host, path: 'Mailing_API/Ubdate/Ubdate.php', scheme: scheme);
      var response = await http.post(url, body: {
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
      });
      return Status(response.statusCode);
    }
  }

  @override
  Future<bool> Delete(String id) async {
    if (id.isEmpty) {
      return false;
    } else {
      var secret = Crypt.sha256("delete_message");
      Uri url = Uri(
          host: host, path: 'Mailing_API/Delete/Delete.php', scheme: scheme);
      var response =
          await http.post(url, body: {'id': id, 'secret': '$secret'});
      return Status(response.statusCode);
    }
  }

  @override
  Future<bool> Status(int codestate) async {
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
          errorMsg = 'Please check your internet connection and try again';
          showtoast(errorMsg);
          return false;
        }
    }
  }

  @override
  Future<List<int>> Select() async {
    List<int> listmessage = [];
    var secret = Crypt.sha256("select_contentview");
    Uri url = Uri(
        host: host, path: 'Mailing_API/Select/get_Message.php', scheme: scheme);
    var response = await http
        .post(url, body: {'email': member.getEmail, 'secret': '$secret'});
    if (await Status(response.statusCode)) {
      List<dynamic> data = json.decode(response.body);
      for (int i = 0; i < data.length; i++) {
        listmessage.add(int.parse(data.elementAt(i)['MessageID']));
      }
      return listmessage;
    } else {
      return listmessage;
    }
  }
}

class Public_DataBase extends DataBase_Access {
  @override
  Future<bool> Insert(List<String> list) async {
    var secret = Crypt.sha256("insert_public");
    Uri url =
        Uri(host: host, path: 'Mailing_API/Insert/Insert.php', scheme: scheme);
    var response = await http.post(url, body: {
      'title': list.elementAt(0),
      'content': list.elementAt(1),
      'secret': '$secret'
    });
    return Status(response.statusCode);
  }

  @override
  Future<bool> Ubdate(List<String> list) async {
    var secret = Crypt.sha256("ubdate_public");
    Uri url =
        Uri(host: host, path: 'Mailing_API/Ubdate/Ubdate.php', scheme: scheme);
    var response = await http.post(url, body: {
      'title': list.elementAt(0),
      'content': list.elementAt(1),
      'id': list.elementAt(2),
      'type': list.elementAt(3),
      'secret': '$secret'
    });
    return Status(response.statusCode);
  }

  @override
  Future<bool> Delete(String id) async {
    if (id.isEmpty) {
      return false;
    } else {
      var secret = Crypt.sha256("delete_program");
      Uri url = Uri(
          host: host, path: 'Mailing_API/Delete/Delete.php', scheme: scheme);
      var response =
          await http.post(url, body: {'id': id, 'secret': '$secret'});
      return Status(response.statusCode);
    }
  }

  @override
  Future<bool> Status(int codestate) async {
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
          errorMsg = 'Please check your internet connection and try again';
          showtoast(errorMsg);
          return false;
        }
    }
  }

  @override
  Future<List<Notification_Message>> Select({String? email}) async {
    List<Notification_Message> list = [];
    var secret = Crypt.sha256("select_notifi");
    Uri url = Uri(
        host: host, path: 'Mailing_API/Select/get_Message.php', scheme: scheme);
    var response =
        await http.post(url, body: {'email': email, 'secret': '$secret'});
    if (await Status(response.statusCode)) {
      List<dynamic> data = json.decode(response.body);
      for (int i = 0; i < data.length; i++) {
        list.add(Notification_Message());
        list[i].messaging_id = int.parse(data.elementAt(i)['MessageID']);
        list[i].title = data.elementAt(i)['Title_Notifi'] == null
            ? "Null"
            : data.elementAt(i)['Title_Notifi'];
        list[i].content = data.elementAt(i)['Content_Notifi'] == null
            ? "Null"
            : data.elementAt(i)['Content_Notifi'];
        list[i].date = data.elementAt(i)['Date_Notifi'];
        if (checkadmin) {
          list[i].Notifi_State = checkadmin;
        } else {
          list[i].Notifi_State =
              data.elementAt(i)['notificationStatus'] == "0" ? false : true;
        }
        list[i].type = data.elementAt(i)['Type_Notifi'];
      }
      return list;
    } else {
      return list;
    }
  }
}

class Program_DataBase extends DataBase_Access {
  get_photo send_image = get_photo();

  @override
  Future<bool> Insert(List<String> list) async {
    List<String> list_image_insert = [];
    if (list.isEmpty) {
      return false;
    } else {
      for (int i = 3; i < list.length; i++) {
        list_image_insert.add(await send_image.Upload(File(list[i])));
      }
      var secret = Crypt.sha256("insert_program");
      Uri url = Uri(
          host: host, path: 'Mailing_API/Insert/Insert.php', scheme: scheme);
      var response = await http.post(url, body: {
        'type': list.elementAt(0),
        'link': list.elementAt(1),
        'text': list.elementAt(2),
        'list_image': list_image_insert.toString(),
        'secret': '$secret'
      });
      if (response.statusCode == 200) {
        if (list_image_insert.isNotEmpty &&
            Validation.isValidnull(list_image_insert[0])) {
          await Notification_OneSignal_class.handleSendNotificationWithImage(
              list_image_insert[0],
              list.elementAt(2),
              list.elementAt(0) == "0" ? "Partner Program" : "Our Program");
        } else {
          try {
            await Notification_OneSignal_class.handleSendNotification(
                list.elementAt(2),
                list.elementAt(0) == "0" ? "Partner Program" : "Our Program");
          } catch (ex) {
            showtoast("Valid Local To Send Notification Trying");
          }
        }
        return Status(response.statusCode);
      }
      return Status(response.statusCode);
    }
  }

  @override
  Future<bool> Ubdate(List<String> list) async {
    List<String> list_image_update = [];
    if (list.isEmpty) {
      return false;
    } else {
      for (int i = 4; i < list.length; i++) {
        if (!list[i].contains("http")) {
          list_image_update.add(await send_image.Upload(File(list[i])));
        } else {
          list_image_update.add(list[i]);
        }
      }
      var secret = Crypt.sha256("ubdate_program");
      Uri url = Uri(
          host: host, path: 'Mailing_API/Ubdate/Ubdate.php', scheme: scheme);
      var response = await http.post(url, body: {
        'id': list.elementAt(0),
        'type': list.elementAt(1),
        'link': list.elementAt(2),
        'text': list.elementAt(3),
        'list_image': list_image_update.toString(),
        'secret': '$secret'
      });
      if (response.statusCode == 200) {
        if (list_image_update.isNotEmpty &&
            Validation.isValidnull(list_image_update[0])) {
          await Notification_OneSignal_class.handleSendNotificationWithImage(
              list_image_update[0],
              list.elementAt(2),
              list.elementAt(0) == "0" ? "Partner Program" : "Our Program");
        } else {
          await Notification_OneSignal_class.handleSendNotification(
              list.elementAt(2),
              list.elementAt(0) == "0" ? "Partner Program" : "Our Program");
        }
        return Status(response.statusCode);
      }
      return Status(response.statusCode);
    }
  }

  @override
  Future<bool> Delete(String id) async {
    if (id.isEmpty) {
      return false;
    } else {
      var secret = Crypt.sha256("delete_program");
      Uri url = Uri(
          host: host, path: 'Mailing_API/Delete/Delete.php', scheme: scheme);
      var response =
          await http.post(url, body: {'id': id, 'secret': '$secret'});
      return Status(response.statusCode);
    }
  }

  @override
  Future<bool> Status(int codestate) async {
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
          errorMsg = 'Please check your internet connection and try again';
          showtoast(errorMsg);
          return false;
        }
    }
  }

  @override
  Future<List<Messaging_PR>> Select({String? type}) async {
    List<Messaging_PR> listmessage = [];
    var secret = Crypt.sha256("select_program");
    Uri url = Uri(
        host: host, path: 'Mailing_API/Select/get_Message.php', scheme: scheme);
    var response =
        await http.post(url, body: {'type': type, 'secret': '$secret'});
    if (await Status(response.statusCode)) {
      List<dynamic> data = json.decode(response.body);
      for (int i = 0; i < data.length; i++) {
        listmessage.add(Messaging_PR());
        listmessage[i].setID = int.parse(data.elementAt(i)['ProgramID']);
        listmessage[i].setprogramtype = data.elementAt(i)['ProgramType'];
        listmessage[i].setlink = data.elementAt(i)['ProgramLink'];
        listmessage[i].setcontent = data.elementAt(i)['ProgramText'];
        if (data.elementAt(i)['ProgramImages'] != null) {
          listmessage[i].setlistimage = data
              .elementAt(i)['ProgramImages']
              .replaceAll('[', "")
              .replaceAll(']', "")
              .split(",");
        }
      }
      return listmessage;
    } else {
      return listmessage;
    }
  }
}

class PayPalServices {
  String domain = "https://api.sandbox.paypal.com";
  String clientid = "AQ44w5WyCPGDCOu5PovxLqNhnUZf7lK3W9aA1TChTPtgf75ZhXR0ss9MvQu4R8OG_WLN9vbYWuV6tkOa";
  String secret = "EImXHY_sXigrSUZgqIW07FDdGescR_3Xi-M673DioOV5-UMfrzW2RDRcszDjvDNZN_F0S3p61avOxkjj";

  Future<String> getAccessToken() async {
    try {
      var client = BasicAuthClient(clientid, secret);
      var responce = await client.post(
          Uri.parse('$domain/v1/oauth2/token?grant_type=client_credentials'));
      if (responce.statusCode == 200) {
        final body = jsonDecode(responce.body);
        return body["access_token"];
      }
      return "0";
    } catch (ex) {
      rethrow;
    }
  }

  Future<Map<String, String>> createPaypalPayment(
      transactions, accessToken) async {
    try {
      var response = await http.post(Uri.parse('$domain/v1/payments/payment'),
          body: jsonEncode(transactions),
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer ' + accessToken
          });
      final body = jsonDecode(response.body);
      if (response.statusCode == 201) {
        if (body["links"] != null && body["links"].length > 0) {
          List links = body["links"];
          String executeUrl = "";
          String approvalUrl = "";
          final item = links.firstWhere((o) => o["rel"] == "approval_url",
              orElse: () => null);
          if (item != null) {
            approvalUrl = item["href"];
          }
          final item1 = links.firstWhere((o) => o["rel"] == "execute",
              orElse: () => null);
          if (item1 != null) {
            executeUrl = item["href"];
          }
          return {"executeUrl": executeUrl, "approvalUrl": approvalUrl};
        }
        throw Exception("0");
      } else {
        throw Exception(body["message"]);
      }
    } catch (ex) {
      rethrow;
    }
  }

  Future<String> executePayment(uri, payerId, accessToken) async {
    try {
      var response = await http.post(uri,
          body: jsonEncode({"payer_id": payerId}),
          headers: {
            "content-type": "application/json",
            "Authorization": "Bearer" + accessToken
          });
      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return body["id"];
      }
      return "0";
    } catch (ex) {
      rethrow;
    }
  }
}
