import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical/pages/videocall/videocall.dart';
import 'package:medical/provider/user_provider.dart';
import 'package:medical/services/authservice.dart';
import 'package:medical/utils/colors.dart';
import 'package:medical/utils/icons.dart';
import 'package:medical/utils/images.dart';
import 'package:medical/widgets/textStyles.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

class PatientSearchDoctor extends StatefulWidget {
  String keyword;
   PatientSearchDoctor({super.key, required this.keyword});
  @override
  State<PatientSearchDoctor> createState() => _PatientSearchDoctor();
}

class _PatientSearchDoctor extends State<PatientSearchDoctor> {
  int _selectedIndex = 0;
  late UserProvider userProvider;
  bool loaded = false;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    controller.text = widget.keyword;
    if(!loaded) {
      loaded = true;
      print("new notify is true");
      userProvider.searchDoctors(widget.keyword);
    }
    print("new notify ${userProvider.doctorsSearchList!.length}");

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 246, 246, 254),
      body: Container(
        padding: EdgeInsets.only(top: 45),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // top
            SizedBox(
              height: 10,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('HI, ${userProvider.currentUser!.name}',
                          style: AppTextStyles()
                              .secondaryStyle
                              .copyWith(fontSize: 12)),
                      Text('Find your specialist',
                          style: AppTextStyles()
                              .primaryStyle
                              .copyWith(fontSize: 20)),
                    ],
                  ),


                ],
              ),
            ),
            //search bar
            SizedBox(
              height: 15,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.textFieldBgColor,
                  borderRadius: BorderRadius.circular(1000),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextField(
                          controller: controller,
                          style: AppTextStyles().hintStyle,
                          decoration: InputDecoration(
                              isDense: true,
                              hintStyle: AppTextStyles()
                                  .hintStyle
                                  .copyWith(color: AppColors.secondaryColor),
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide.none)),
                        ),
                      ),
                    ),
                    // filter icon
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(1000),
                        ),
                        child: Icon(
                          Icons.cancel,
                          color: AppColors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),




            Container(
              child: ListView.builder(
                padding: EdgeInsets.only(top: 10),
                shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: userProvider.doctorsSearchList!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Container(
                        decoration: ShapeDecoration(
                          color: Color(0xFFFFFFFD),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Color(0x0C000000),
                              blurRadius: 15.30,
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // profile images

                              Row(
                                children: [
                                  userProvider.doctorsSearchList![index].imageurl!= null ?
                                  SizedBox(
                                    height:50,
                                    width: 50,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        clipBehavior: Clip.hardEdge,
                                        child: CachedNetworkImage(imageUrl:  userProvider.doctorsSearchList![index].imageurl!)),
                                  )
                                      : Container(
                                    width: 50,
                                    height: 50,
                                    decoration: ShapeDecoration(
                                      image:  DecorationImage(
                                        image: AssetImage(AppImages.doctor),
                                        fit: BoxFit.cover,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(1000),
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    width: 10,
                                  ),
                                  // details and reviews
                                  // name
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // specialtity
                                      Opacity(
                                        opacity: 0.60,
                                        child: Text(
                                          userProvider.doctorsSearchList![index].specialization!,
                                          style: GoogleFonts.sora(
                                            color: AppColors.mainTextColor,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),

                                      // name
                                      Text(
                                        'Dr. ${ userProvider.doctorsSearchList![index].name!}',
                                        style: GoogleFonts.sora(
                                          color: AppColors.mainTextColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),


                                    ],
                                  ),
                                ],
                              ),

                              //
                              // book now button
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                decoration: ShapeDecoration(
                                  color: AppColors.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Book Now',
                                      style: GoogleFonts.sora(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
          ),
      )
        );
  }
}
