import 'dart:async';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medical/models/usermodel.dart';
import 'package:medical/pages/videocall/call_screen.dart';
import 'package:medical/provider/firestore_provider.dart';
import 'package:medical/provider/user_provider.dart';
import 'package:medical/utils/colors.dart';
import 'package:medical/utils/images.dart';
import 'package:provider/provider.dart';


late LoginUser? remoteUser;
class RingScreen extends StatefulWidget {
  final String clientID;
  final String roomId;
  final String callerName;
  final String callerDetails;
  final String callingTo;
  const RingScreen({Key? key, this.clientID = "null", this.roomId = "null", this.callerName = "null", this.callerDetails="null", this.callingTo = "null"}) : super(key: key);

  @override
  RingScreenState createState() => RingScreenState();
}

class RingScreenState extends State<RingScreen> with TickerProviderStateMixin {
  String? userType;
  bool userInitialized = false;
  int i = 0;
  bool iAcceptedCall = false;
  bool muted = false;
  bool connected = false;
  String clientID = "";

  late Animation<double> _animation;
  late AnimationController _joinController;
  late AnimationController _controller;
  int totalleftMinutes = 0;
  String hostUser = "";

  final _auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  late var _uid;
  late StreamSubscription callSubscription;
  late StreamSubscription getUserSignals;
  bool notificationSent = false;
  bool ringingCall = false;
  bool hostNavigatedToCall = false;


  String? roomId;
  MediaStream? stream;
  bool? hangUpState;
  bool isRemoteConnected = false;
  bool endCallPressed = false;
  late DocumentReference calleeCandidate;
  late UserProvider userProvider;
  bool userIsconnected = false;
  late AudioPlayer player;

  String callerName = "";
  String callDescription = "";


  //TextEditingController textEditingController = TextEditingController(text: '');


  @override
  void initState() {
    _uid = _auth.currentUser?.uid;


    if(widget.roomId == "null") {

      hostUser = _uid;
      callSubscription =
          FirestoreProvider().getUser(widget.clientID).listen((
              List<LoginUser> data) {
            callSubscription.cancel();
            clientID = data[0].uid!;
            if (data[0].status == "Online") {
              if (data[0].beingcalled == null || data[0].beingcalled == "false") {
                // final docRef = db.collection("users").doc(data[0].uid).collection(
                //     "token").doc(data[0].uid);
                // docRef.get().then(
                //       (DocumentSnapshot doc) {
                calleeCandidate = db.collection('rooms').doc();
                roomId = calleeCandidate.id;

                // final data = doc.data() as Map<String, dynamic>;
                // String token = data["token"];

                calleeCandidate.set({'calleeConected': "null", "callerName":widget.callingTo, "callerDetail":widget.callerDetails}).then((
                    value) async {
                  getStringFieldStream();
                  // sendNotificationToUser("You have a Call from Anonymous", "Join Now", token, roomId!, _uid);
                  await db.collection("users").doc(clientID).update(
                      {"beingcalled": "true", "roomid": roomId});
                },
                );
              }else{
                Fluttertoast.showToast(msg: "Sorry the user is in another call");
              }
            }
            else {
              Fluttertoast.showToast(msg: "Sorry the user is not online");
            }
          });

    }
    getStringFieldStream();

    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.9, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut, // Change this curve as needed
      ),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    _joinController = AnimationController(
      duration: Duration(milliseconds: 700),
      vsync: this,
    )..repeat(reverse: true);

    _controller.forward();

    if(widget.roomId != "null" && widget.clientID == "null" ) {
      player = AudioPlayer();
      playAudio();
    }
    super.initState();
  }

  playAudio()async{
    //await player.setSource(AssetSource('/sounds/ringtone.mp3'));
    if(!ringingCall) {
      ringingCall = true;
      await player.play(AssetSource('sounds/ringtone.mp3')).then((value) async {
        await player.play(AssetSource('sounds/ringtone.mp3'));
      });
    }
  }


  @override
  void dispose() {
    getUserSignals.cancel();
    _joinController.dispose();
    _controller.dispose();

    if(connected) {
      connected = false;
    }

    super.dispose();
  }


  getStringFieldStream() {
    if (hostUser == "") {
      hostUser = widget.roomId;
      roomId = hostUser;
    }


    calleeCandidate = db.collection('rooms').doc('$roomId');
    final userDoc = db.collection('users').doc(_uid);

    userDoc.get().then(
          (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
      },
      onError: (e) => print("Error getting document: $e"),
    );

    getUserSignals =
        calleeCandidate.snapshots().listen((DocumentSnapshot snapshot) async {
          if (snapshot.exists) {
            String callStatus = snapshot.get('calleeConected') ?? "";
            if(widget.callerName == "null"){
              callerName = snapshot.get('callerName') ?? "";
              callDescription = snapshot.get('callerDetail') ?? "";
            }else{
              callerName = widget.callerName;
              callDescription  = widget.callerDetails;
            }

            setState(() {});


            if(callStatus!= "") {
              if (callStatus == "done") {
                connected = false;
              } else if (callStatus != "done" && callStatus != "null" &&
                  callStatus != "left") {
                if (widget.roomId == "null") {
                  if(!hostNavigatedToCall) {
                    getUserSignals.cancel();
                    hostNavigatedToCall = true;
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) =>
                            CallScreen(userType: "H", roomId: roomId!, clientName: callerName, clientDesc: callDescription, clientType: userProvider.currentUser!.userType!,)));
                  }
                }else{
                  if (!iAcceptedCall) {
                    if(widget.roomId != "null") {
                      player.stop();
                    }
                    Navigator.pop(context);
                  }
                }
              } else if (callStatus == "left") {
                if(widget.roomId != "null") {
                  player.stop();
                }
                Navigator.pop(context);
              }
            }
          } else {
            print("Not document existts");
          }
        });
  }


  void sendNotificationToUser(String title, String message, String userToken,String roomID, String hostUserID) async {
    final data = {
      "message": {
        "token": "token_1",
        "data": {
          "roomid": roomID,
          "hostid": "",
          "route": "/call",
        },
        "notification": {
          "title": title,
          "body": message,
        }
      }
    };


    try {
      http.Response response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': ' key=AAAAjjzunNg:APA91bHcobq3RAB3hFadQ65oTFZgdvxc2CTUw1-Pa6N28Y1EKgx67v368K52qwLjuBXUnYtXMRjZxRm8mgq57tdTzZQwAvfRN7EDQg3Ah5a9dTuqkXrIz6MZzaizNJQvGxO0cMP36ePA',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'title': title, 'body': message},
            'priority': 'high',
            'data': data,
            'to': userToken,
          },
        ),
      );

      if (response.statusCode == 200) {
        print("Notification sent successfully");
      } else {
        print("Error sending notification ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body:
      connected == false && userType == 'H' ?
      Container(
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: AssetImage(AppImages.profile),
            fit: BoxFit.cover,
            opacity: 0.45,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 45,
            ),



            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // profile pic
                  Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              userProvider.currentUser!.userType=="patient" ? AppImages.doctor : AppImages.patient,
                            ),
                            fit: BoxFit.cover,
                          ),
                          color: Color(0xFFEDEDED),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 1, color: Color(0xFF1877F2)),
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                      // name and speciality
                      SizedBox(
                        height: 10,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // speciality
                          Opacity(
                            opacity: 0.60,
                            child: Text(
                              callDescription.toUpperCase(),
                              style: GoogleFonts.sora(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),

                          // name
                          Text(
                           "",
                            style: GoogleFonts.sora(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),


                ],
              ),
            ),

            SizedBox(height: 32.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ):

      Container(
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: AssetImage(AppImages.profile),
            fit: BoxFit.cover,
            opacity: 0.45,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // profile pic
                    Column(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                userProvider.currentUser!.userType=="patient" ? AppImages.doctor : AppImages.patient,

                              ),
                              fit: BoxFit.cover,
                            ),
                            color: Color(0xFFEDEDED),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 1, color: Color(0xFF1877F2)),
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                        // name and speciality
                        SizedBox(
                          height: 10,
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // speciality
                            Opacity(
                              opacity: 0.60,
                              child: Text(
                                callDescription.toUpperCase(),
                                style: GoogleFonts.sora(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),

                            // name
                            Text(
                              callerName,
                              style: GoogleFonts.sora(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),


                  ],
                ),
              ),



              SizedBox(
                height: 100,
              ),

              Column(
                children: [



              if(widget.roomId != "null")
                GestureDetector(
                  onTap: ()async{

                    await db.runTransaction((transaction) async {

                      final userDoc = db.collection('users').doc(_uid);

                      final roomRef = await transaction.get(calleeCandidate);

                      if (roomRef.exists) {
                        final data = roomRef.data() as Map<String, dynamic>;
                        String calleeConnected = data["calleeConected"];

                        Map<String, dynamic> updateCalleeVal = {
                          'calleeConected': _uid,
                        };

                        Map<String, dynamic> updateUserVal = {
                          'callstatus': "oncall",
                        };

                        print("step 2");

                        if (calleeConnected == "null") { // Check for null instead of "null"
                          try {
                            print("step 3");
                            transaction.update(calleeCandidate, updateCalleeVal);

                            print("step 4");

                          } catch (e) {
                            print("Error joining room: $e");
                            // Handle error, optionally rethrow or return a specific value
                          }
                        }
                      }
                    }).then((value)async{
                      iAcceptedCall = true;
                      //await db.collection("users").doc(clientID).update({"beingcalled": "false",});
                      player.stop();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CallScreen(userType: "V", roomId: roomId!,clientName: callerName, clientDesc: callDescription, clientType: userProvider.currentUser!.userType!,)));
                    });
                  },
                  child: RotationTransition(
                    turns: Tween(begin: 0.0, end: 0.1).animate(
                      CurvedAnimation(
                        parent: _joinController,
                        curve: Curves.elasticIn,
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 45,
                      child: Icon(
                        Icons.phone,
                        size: 45.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

              SizedBox(height: 25,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: (){
                      endCallPressed = true;
                      if(roomId != null) {
                        getUserSignals.cancel();
                        if(clientID != "") {
                          db.collection("users").doc(clientID).update(
                              {"beingcalled": "false", "roomid": ""});
                        }

                        db.collection('users').doc(_uid).update(
                            clientID == "" ? {"callstatus":"","beingcalled": "false", "roomid": "" } : {"callstatus": "" }).then((value) {

                          db.collection('rooms').doc('$roomId').update(
                              {"calleeConected": "left"}).then((value) {
                            if(widget.roomId != "null") {
                              player.stop();
                            }
                            Navigator.pop(context);
                          });
                        });

                      }else{
                        if(widget.roomId != "null") {
                          player.stop();
                        }
                        Navigator.pop(context);
                      }
                    },
                    child:  Container(
                        padding: const EdgeInsets.all(16),
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: Color(0xFFF85454),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: Icon(
                          Icons.call_end,
                          color: Colors.white,
                          size: 50,
                        )),
                  ),

                ],
              ),

                ],
              ),

              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),




    );
  }



}




