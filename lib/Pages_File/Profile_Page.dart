import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mailing/Class/Class_database.dart';
import 'package:mailing/l10n/applocal.dart';



class Profile extends StatefulWidget {
  const Profile({required this.member, required this.type});

  @override
  Profile_State createState() => Profile_State();

  final Member member;
  final String type;
}

class Profile_State extends State<Profile> {
  late TextEditingController Profile_Email, Profile_Password;
  late double WidthDevice, HieghDevice;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidthDevice = MediaQuery.of(context).size.width;
    HieghDevice = MediaQuery.of(context).size.height;

    if (widget.member != null && widget.type == "info") {
      Profile_Email = TextEditingController(text: widget.member.Email);
      Profile_Password = TextEditingController();
    } else {
      Profile_Email = TextEditingController();
      Profile_Password = TextEditingController();
    }

    return Container(
        margin: EdgeInsets.only(top: 20,bottom: HieghDevice/3),
        child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
        child:  Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Container(
              width: WidthDevice / 1.15,
              margin: EdgeInsets.only(top: 140, left: 20, right: 20),
              child: Column(
                children: [
                  Text(
                    '${getLang(context, "Email")}',
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w600),
                  ),
                  Container(
                      child: TextFormField(
                        readOnly: true,
                        controller: Profile_Email,
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          suffix: IconButton(
                            onPressed: () {
                              setState(() {
                                print("Hello");
                              });
                            },icon:Icon(Icons.edit_outlined),
                          ),
                          hintText: "Exampl@gmail.com",
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
              margin: EdgeInsets.only(top: 260, left: 20, right: 20),
              child: Column(
                children: [
                  Text(
                    '${getLang(context, "Password")}',
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w600),
                  ),
                  Container(
                      child: TextFormField(
                    readOnly: true,
                    controller: Profile_Password,
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                      suffix: IconButton(
                        onPressed: () {
                          setState(() {
                            print("Hello");
                          });
                        },icon:Icon(Icons.edit_outlined,color: Colors.black54,),
                      ),
                      hintText: "***********",
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
                  imageUrl: widget.member.getImage,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(color: Colors.black38, blurRadius: 10)
                      ],
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
            Container(
              width: WidthDevice,
              margin: EdgeInsets.only(top: 380, left: 40, right: 20),
                child:Text(
                  '${getLang(context, "Pay_Total")} 100'+r"$",
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.w600,),
                  textAlign: TextAlign.start,
                ),
            ),
            Container(
              width: WidthDevice,
              margin: EdgeInsets.only(top: 420, left: 40, right: 20),
              child:Text(
                '${getLang(context, "Sell_Message_Count")} 5',
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.w600),
                textAlign: TextAlign.start,
              ),
            )
          ],
        )));
  }
}
