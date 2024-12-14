import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical/utils/icons.dart';
import 'package:medical/utils/images.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {


  Offset _position =
      Offset(0, 0); // Initial position of the draggable container

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
              image: AssetImage(AppImages.profile),
              fit: BoxFit.cover,
              opacity: 0.45,
            ),
          ),
          child: Column(
            children: [
              // top name and timer
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
                                AppImages.profile,
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
                                'Cardiovascular'.toUpperCase(),
                                style: GoogleFonts.sora(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),

                            // name
                            Text(
                              'Dr. Alan Hathaway',
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

              // bottom call actions



              Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                margin: EdgeInsets.only(bottom: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    // hang up

                    Container(
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

                    // volume

                  ],
                ),
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
