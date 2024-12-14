import 'dart:async';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical/utils/colors.dart';
import 'package:medical/utils/images.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:medical/helpers/painter.dart';
import 'package:medical/models/filesent_model.dart';
import 'package:medical/models/message_model.dart';
import 'package:medical/helpers/signaling.dart';
import 'package:medical/wrapper.dart';

class CallScreen extends StatefulWidget {
  final String userType;
  final String roomId;
  final String clientName;
  final String clientDesc;
  final String clientType;
  const CallScreen({Key? key, required this.userType, required this.roomId, required this.clientName, required this.clientDesc, required this.clientType}) : super(key: key);
  @override
  CallScreenState createState() => CallScreenState();
}

class CallScreenState extends State<CallScreen> {
  String? userType;
  DateTime? compareDate;
  int i = 0;
  bool loudspeaker = true;
  bool muted = false;
  bool videoClosed = false;
  bool shareScreen = false;
  bool endCallPressed = false;
  bool messageTapped = false;
  int newMessagecount = 0;
  bool greenColorSelected = true;
  bool cameraPermissionGranted = true;


  //HomePageState(this.userType);
  Signaling signaling = Signaling();
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomId;
  MediaStream? stream;
  bool? hangUpState;
  bool isRemoteConnected = false;
  //TextEditingController textEditingController = TextEditingController(text: '');
  final db = FirebaseFirestore.instance;
  List<Messages> chatMessages = [];
  List<Files> receivedFiles = [];
  TextEditingController sendText = new TextEditingController();

// Initialize your RTCPeerConnection
  late RTCDataChannel messageChannel;
  late RTCDataChannel fileChannel;
  List<Uint8List> _receivedData = [];

  ScrollController _controller = ScrollController();
  
  List<Offset?> points = [];
  double strokeWidth = 5;
  List<Uint8List> receivedFileData = [];
  bool sendingFile = false;
  bool receivingFile = false;
  bool imageReceived = false;
  late Uint8List currentImage;
  double receivingPercentage = 0;
  double sendingPercentage = 0;
  double totalFileSize = 0;
  String sendingFileUpdate = "";
  String receivedFileName = "";
  bool imagesTapped = false;
  bool viewImage = false;
  bool moveImage = false;
  late StreamSubscription getUserSignals;
  late Timer _timer;
  int _minutes = 0;
  int _seconds = 0;

  late FlutterSoundRecorder _recorder;
  late FlutterSoundPlayer _player;
  bool _isRecording = false;
  bool _isPlaying = false;
  late String _filePath;

  @override
  void initState() {


    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();
    _init();

    hangUpState = false;
    userType = widget.userType;
    _localRenderer.initialize();
    _remoteRenderer.initialize();
     if (userType == 'H') {
      signaling
          .openUserMedia(_localRenderer, _remoteRenderer)
          .then((value) async {

          await signaling.createRoom(_localRenderer, widget.roomId!);
          // textEditingController.text = roomId!;

          initializeDataTransfer();

      });
    } else if (userType == 'V') {
      signaling.openUserMedia(_localRenderer, _remoteRenderer);

      Future.delayed(const Duration(seconds: 7)).then((val)async{
        await signaling.joinRoom(
            widget.roomId, _remoteRenderer);
        initializeDataTransfer();
      });
      //signaling.getData();
    }
    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {
        isRemoteConnected = (!isRemoteConnected);
      });
    });
    // final tsToMillis = DateTime.now().millisecond;
    // final compareDate = DateTime(tsToMillis - (24 * 60 * 60 * 1000));
    roomId  = widget.roomId;
    getStringFieldStream();
    startTimer();
    super.initState();
  }


  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
        if (_seconds == 60) {
          _minutes++;
          _seconds = 0;
        }
      });
    });
  }


    void endCall() async{
    if (!endCallPressed) {
      if(userType == "H") {
      }

      setState(() {
        endCallPressed = true;
      });

       await signaling.hangUp(_localRenderer);

      final batch = db.batch();
      String _uid = FirebaseAuth.instance.currentUser!.uid;
      final calleCandidate = db.collection('rooms').doc('$roomId');
       final userDoc = db.collection('users').doc(_uid);

      Map<String, dynamic> updateUserVal = {
        "callstatus": "",
        "beingcalled": "false",
        "roomid": "",
      };

      if(roomId != null) {
        batch.update(calleCandidate, {"calleeConected": "done"});
      }

      batch.update(userDoc, updateUserVal);

// Commit the batch
      batch.commit().then((_) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) =>
                Wrapper()), (Route<dynamic> route) => false);
      }).catchError((error) {
        // Commit failed with an error
        print("Error during batch commit: $error");
        // You can handle the error here, e.g., show a message to the user
      });
    }else{
      Fluttertoast.showToast(msg: "Please wait");
    }
  }

  //We are using this function to end call in remote users device.
  getStringFieldStream() {
    var calleeCandidate = db.collection('rooms').doc('${widget.roomId}');
    getUserSignals =
        calleeCandidate.snapshots().listen((DocumentSnapshot snapshot) async {
          if (snapshot.exists) {
            String callStatus = snapshot.get('calleeConected');
            if (callStatus == "done") {
                endCall();
               // getUserSignals.cancel();
            }
          }
        });
  }

  //Transferring data. We are delaying the function for 6 seconds because I noticed it not working properly when the
  //function runs directly at load.
  initializeDataTransfer()async{
   cameraPermissionGranted = await  Permission.camera.isGranted;

    Future.delayed(const Duration(seconds: 6)).then((val)async {
      if(!cameraPermissionGranted){
        setState(() {});
      }
      messageChannel = await signaling.messageDataChannel;
      fileChannel = await signaling.fileDataChannel;
      messageChannel.onMessage = (RTCDataChannelMessage data) {
        print("received a message");
        onReceiveTextMessage(data.binary);
        setState(() {});
      };

      _receivedData.clear();

        fileChannel.onMessage = (RTCDataChannelMessage message) {
          // Handle incoming data
          _receivedData.add(message.binary);

          receivingFile = true;
          // Calculate and print progress percentage
          if(totalFileSize != 0) {

            var currentfilesize = _receivedData.isEmpty ? 0 : (_receivedData
                .length.toDouble() * 16384);
            receivingPercentage =
              ((currentfilesize / totalFileSize) * 100);
         //   print("x&*% $receivingPercentage && $totalFileSize && $currentfilesize");
          }

          //The progress percentage is accessed from remote device and sent to the file sender.
          // This is because the sender device immediately shows the file sending completed.
          signaling.sendTextMessage("x&*% Sending ${receivingPercentage.toInt()}%");

          // Check if the file is fully received
          if (receivingPercentage > 100 || message.binary.length < 16384) {
            if (receivingFile) {
              signaling.sendTextMessage("x&*% File Sent");
              receivingFile = false;

              imageReceived = true;
              Uint8List currentImg = Uint8List.fromList(
                  _receivedData.expand((chunk) => chunk).toList());
              receivedFiles.add(Files(name: receivedFileName,
                  size: "${(totalFileSize) / 1000} kb",
                  image: currentImg));
              _receivedData.clear();
              totalFileSize = 0;
              Future.delayed(const Duration(seconds: 5)).then((val) async {
                setState(() {
                  imageReceived = false;
                });
              });
            }
          }

          setState(() {});
        };

    });


  }

  //We are using special keys for example x&*S% to share valuable information like file size, etc through
  //text because receiver doesnot have all this details
  void onReceiveTextMessage(Uint8List data) {
    String receivedMessage = String.fromCharCodes(data);
    if(receivedMessage.startsWith("x&*S%")){
      totalFileSize =  double.parse(receivedMessage.replaceAll("x&*S%", "").trim());
      print("Receingin files $totalFileSize");
    }else if(receivedMessage.startsWith("x&*%")){
      print("Sending files");
      sendingFile = true;
      sendingFileUpdate  = receivedMessage.replaceAll("x&*%", "").trim();
      if(sendingFileUpdate.contains("File Sent")){
        Future.delayed(const Duration(seconds: 5)).then((val)async {
          setState(() {
            sendingFile = false;
          });
        });
      }
    }else if(receivedMessage.startsWith("x&*N%")){
      receivedFileName =  receivedMessage.replaceAll("x&*N%", "").trim();
    }
    else{
      chatMessages.add(Messages(message: receivedMessage, sent: false));
      if (!messageTapped) {
        newMessagecount = newMessagecount + 1;
      }
    }
    setState(() {
    });
  }


  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _timer.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    String minutesStr = _minutes.toString().padLeft(2, '0');
    String secondsStr = _seconds.toString().padLeft(2, '0');


    if(chatMessages.length>3)
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.animateTo(
        _controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [



            SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width ,
                child: RTCVideoView(_remoteRenderer, objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,)),


            Container(
              margin: EdgeInsets.only(top: 20),
              height: 80,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // profile pic
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                               widget.clientType != "doctor" ?  AppImages.doctor : AppImages.patient,
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
                          width: 10,
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // speciality
                            Opacity(
                              opacity: 0.60,
                              child: Text(
                                widget.clientDesc.toUpperCase(),
                                style: GoogleFonts.sora(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),

                            // name
                            Text(
                              widget.clientName,
                              style: GoogleFonts.sora(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 10,),

                    // record time
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      decoration: ShapeDecoration(
                        color: Color(0x1E030A19),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: ShapeDecoration(
                              color: Color(0xFFF85454),
                              shape: OvalBorder(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$minutesStr:$secondsStr min',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.sora(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

            if(!videoClosed)
            Positioned(
              right: 5,
              top: 5,
              child: Container(
                  height: 195,
                  width: 110,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: RTCVideoView(_localRenderer, mirror: true, objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,))),
            ),



            // if(imageReceived)
            //   Image.memory(image, width: MediaQuery.of(context).size.width-100,),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isRecording ? _stopRecording : _startRecording,
                  child: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isPlaying ? _stopPlaying : _startPlaying,
                  child: Text(_isPlaying ? 'Stop Playing' : 'Start Playing'),
                ),
              ],
            ),


            Positioned(
              bottom: 10,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                width: MediaQuery.of(context).size.width,
                child:
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [


                        GestureDetector(
                          onTap: (){
                            if(videoClosed){
                              videoClosed = false;
                            }else{
                              videoClosed = true;
                            }
                            setState(() {});
                            signaling.closeVideo(!videoClosed);
                          },

                          child: CircleAvatar(
                            backgroundColor: Colors.black54,
                            radius: 25,
                            child: Icon(
                              videoClosed ? Icons.videocam_off_rounded : Icons.videocam_rounded,
                              size: 38.0,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: (){
                            if(muted){
                              muted = false;
                            }else{
                              muted = true;
                            }
                            setState(() {});
                            signaling.muteAudio(!muted);

                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.black54,
                            radius: 25,
                            child: Icon(
                              muted ? Icons.mic_off : Icons.mic,
                              size: 30.0,
                              color: Colors.white,
                            ),
                          ),
                        ),





                        GestureDetector(
                          onTap: (){
                            endCall();
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 32,
                            child: Icon(
                              Icons.call_end_rounded,
                              size: 32.0,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: ()async{

                            setState(() {});

                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.black54,
                            radius: 25,
                            child: Icon(
                               Icons.cameraswitch_rounded,
                              size: 30.0,
                              color: Colors.white,
                            ),
                          ),
                        ),


                        GestureDetector(
                          onTap: ()async{
                            if(loudspeaker){
                              loudspeaker = false;
                            }else{
                              loudspeaker = true;
                            }
                            setState(() {});
                            signaling.loudSpeaker(loudspeaker);
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.black54,
                            radius: 25,
                            child: Icon(
                              loudspeaker ? Icons.volume_up : Icons.volume_off,
                              size: 25.0,
                              color: Colors.white,
                            ),
                          ),
                        ),


                      ],
                    ),

              ),
            ),

            if(viewImage)
            Positioned(
              top: 70,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InteractiveViewer(
                      maxScale: 3,
                      child:  Container(
                               height:MediaQuery.of(context).size.height - 190,
                             alignment: Alignment.topCenter,
                             child: Image.memory(currentImage, width: MediaQuery.of(context).size.width,)),
                    ),
                  ],
                ),
              ),
            ),



            if(shareScreen && !moveImage)
            GestureDetector(
                  onPanStart: (details) {
                  setState(() {
                  points = List.from(points)..add(details.globalPosition);
                  });
              },

              onPanUpdate: (details) {
                setState(() {
                  points = List.from(points)..add(details.globalPosition);
                });
              },
              onPanEnd: (details) => points.add(null),
              child: Container(),
            ),





            if(!cameraPermissionGranted)
             Positioned(
               top: 70,
               left: 10,
               child: Column(
                 children: [
                   Text("Camera Permission is not granted!", style: TextStyle(fontSize: 12, color:  Colors.red, fontWeight: FontWeight.bold),),
                 ],
               )) ,


           if(endCallPressed)
           Container(
             height: MediaQuery.of(context).size.height,
             width: MediaQuery.of(context).size.width,
             color: Colors.black.withOpacity(0.3),
             child: Center(
               child: Container(
                 decoration:BoxDecoration(
                   color: AppColors.primaryColor,
                   borderRadius:
                   BorderRadius.all(Radius.circular(15)),
                 ),
                 height: 180,
                 width: 180,
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     CircularProgressIndicator(color: Colors.white,),
                     SizedBox(height: 10,),
                     Text("Closing Call..",style: TextStyle(color: Colors.white),),
                   ],
                 ),
               ),
             ),
           ),
          ],
        ),
      ),
    );
  }

  Widget ChatBubble(bool sent, String text){
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: Align(
        alignment:  !sent ? Alignment.centerLeft : Alignment.centerRight,
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color:  !sent? Colors.green : Colors.grey,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }


  Future<void> _init() async {
    _recorder.openRecorder();
    _player.openPlayer();
    final tempDir = await getTemporaryDirectory();
    _filePath = '${tempDir.path}/recorded_audio.aac';
  }

  void _startRecording() async {
    if (_isRecording) return;
    await _recorder.startRecorder(toFile: _filePath,);
    setState(() {
      _isRecording = true;
    });
  }

  void _stopRecording() async {
    if (!_isRecording) return;
    await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
    });
  }

  void _startPlaying() async {
    if (_isPlaying) return;
    await _player.startPlayer(fromURI: _filePath, codec: Codec.aacADTS);
    setState(() {
      _isPlaying = true;
    });
  }

  void _stopPlaying() async {
    if (!_isPlaying) return;
    await _player.stopPlayer();
    setState(() {
      _isPlaying = false;
    });
  }
}

