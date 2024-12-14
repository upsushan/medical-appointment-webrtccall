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
  bool isMuted = false;
  bool isMicOff = false;

  void toggleMute() {
    setState(() {
      isMuted = !isMuted;
    });
  }

  void toggleMic() {
    setState(() {
      isMicOff = !isMicOff;
    });
  }

  Offset _position =
      Offset(0, 0); // Initial position of the draggable container

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.profile),
              fit: BoxFit.cover,
              opacity: 0.85,
            ),
          ),
          child: Column(
            children: [
              // top name and timer
              SizedBox(
                height: 15,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          width: 10,
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // speciality
                            Opacity(
                              opacity: 0.60,
                              child: Text(
                                'Cardiovascular'.toUpperCase(),
                                style: GoogleFonts.sora(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),

                            // name
                            Text(
                              'Dr. Alan Hathaway',
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
                            '10:16 min',
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

              // bottom call actions

              Draggable(
                feedback: Image.asset('assets/images/picture.jpg',
                    width: 100, height: 100), // Picture to be dragged
                child: Image.asset('assets/images/picture.jpg',
                    width: 100, height: 100), // Picture displayed on screen
                childWhenDragging:
                    Container(), // Hide the picture when dragging
                onDraggableCanceled: (velocity, offset) {
                  setState(() {
                    _position =
                        offset; // Update position when dragging is complete
                  });
                },
              ),

              Spacer(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // camera
                    Container(
                      height: 40,
                      width: 40,
                      padding: const EdgeInsets.all(10),
                      decoration: ShapeDecoration(
                        color: Colors.black.withOpacity(0.20000000298023224),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: SvgPicture.asset(AppIcons.camera),
                    ),

                    // mic

                    GestureDetector(
                      onTap: toggleMic,
                      child: Container(
                        height: 40,
                        width: 40,
                        padding: EdgeInsets.all(10),
                        decoration: ShapeDecoration(
                          color: Colors.black.withOpacity(0.20000000298023224),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: isMicOff
                            ? SvgPicture.asset(AppIcons.mic)
                            : SvgPicture.asset(AppIcons.micon),
                      ),
                    ),

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
                        )),

                    // volume

                    GestureDetector(
                      onTap: toggleMute,
                      child: Container(
                        height: 40,
                        width: 40,
                        padding: EdgeInsets.all(10),
                        decoration: ShapeDecoration(
                          color: Colors.black.withOpacity(0.20000000298023224),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: isMuted
                            ? SvgPicture.asset(AppIcons.mute)
                            : SvgPicture.asset(AppIcons.volume),
                      ),
                    ),

                    // dashboard

                    Container(
                      height: 40,
                      width: 40,
                      padding: const EdgeInsets.all(10),
                      decoration: ShapeDecoration(
                        color: Colors.black.withOpacity(0.20000000298023224),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: SvgPicture.asset(AppIcons.dashboard),
                    ),
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
