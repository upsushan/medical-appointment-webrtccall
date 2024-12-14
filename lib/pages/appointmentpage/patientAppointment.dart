

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:medical/models/usermodel.dart';
import 'package:medical/provider/firestore_provider.dart';
import 'package:medical/provider/user_provider.dart';
import 'package:medical/utils/colors.dart';
import 'package:medical/utils/icons.dart';
import 'package:medical/utils/images.dart';
import 'package:medical/widgets/buttonStyles.dart';
import 'package:medical/widgets/textStyles.dart';
import 'package:provider/provider.dart';

class PatientAppointmentScreen extends StatefulWidget {
  LoginUser doctor;
   PatientAppointmentScreen({super.key, required this.doctor});

  @override
  State<PatientAppointmentScreen> createState() =>
      _PatientAppointmentScreenState();
}

class _PatientAppointmentScreenState extends State<PatientAppointmentScreen> {
  int _selectedIndex = 0;
  List<String> nextSevenDays_month = [];
  List<String> nextSevenDays_day = [];
  List<String> nextSevenDays_date = [];
  String thisMonthName = "";
  int selectedTime = -1;
  int startHour = 8;
  bool startToday = true;
  String selectedCallTime = "";
  late UserProvider userProvider;

  @override
  void initState() {
    // TODO: implement initState


    int hour = DateTime.now().hour;
    if(hour > 8 && hour < 18){
      startHour = hour;
    }else{
      startToday = false;
    }

    getNextSevenDays();
    super.initState();
  }




  @override
  Widget build(BuildContext context) {

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 246, 246, 254),
        body: Container(
          padding: EdgeInsets.only(top: 50),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                        onTap:(){

                            Navigator.pop(context);

                        },
                        child: Icon(Icons.arrow_back_ios,)),

                    Text("Book an Appointment",
                        style:
                        AppTextStyles().primaryStyle.copyWith(fontSize: 20)),
                  ],
                ),
              ),

              //search bar
              SizedBox(
                height: 15,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    widget.doctor.imageurl!=null?
                    SizedBox(
                      height:50,
                      width: 50,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          clipBehavior: Clip.hardEdge,
                          child: CachedNetworkImage(imageUrl:  widget.doctor.imageurl!)),
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
                        // time
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 13, vertical: 4),
                          decoration: ShapeDecoration(
                            color: AppColors.secondaryColor
                                .withOpacity(0.75),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(100),
                            ),
                          ),
                          child: Text(
                            'Available',
                            style: GoogleFonts.sora(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        // specialtity
                        Opacity(
                          opacity: 0.60,
                          child: Text(
                            widget.doctor.specialization!,
                            style: GoogleFonts.sora(
                              color: AppColors.mainTextColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),

                        // name
                        Text(
                          'Dr. ${widget.doctor.name}',
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
              ),

              SizedBox(height: 25,),
              // select date
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('SELECT DATE',
                            style: AppTextStyles()
                                .secondaryStyle
                                .copyWith(fontSize: 12)),
                        Text(thisMonthName,
                            style: AppTextStyles()
                                .primaryStyle
                                .copyWith(fontSize: 20)),
                      ],
                    ),

                    //  toggle buttons
                  ],
                ),
              ),
              //dates
              SizedBox(
                height: 10,
              ),

              Container(
                height: 80,
                child: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: nextSevenDays_month.length,
                      itemBuilder: (context, index) {
                        // sun
                        return Container(
                          width: 64,
                          margin: EdgeInsets.symmetric(horizontal: 3),
                          child: InkWell(
                            onTap: () {
                              setState(() {

                                if(startToday) {
                                  if (index == 0) {
                                    int hour = DateTime
                                        .now()
                                        .hour;
                                    if (hour > 8) {
                                      startHour = hour;
                                    }
                                  } else {
                                    startHour = 10;
                                  }
                                }

                                _selectedIndex = index;
                                selectedTime = -1;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: _selectedIndex == index
                                    ? Border.all(color: Colors.transparent)
                                    : Border.all(
                                    width: 1, color: AppColors.secondaryColor),
                                color: _selectedIndex == index
                                    ? AppColors.primaryColor
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      nextSevenDays_month[index],
                                      style: GoogleFonts.sora(
                                        color: _selectedIndex == index
                                            ? AppColors.white.withOpacity(0.5)
                                            : AppColors.mainTextColor.withOpacity(
                                            0.5),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(height: 2,),
                                    Text(
                                      nextSevenDays_day[index],
                                      style: GoogleFonts.sora(
                                        color: _selectedIndex == index
                                            ? AppColors.white
                                            : AppColors.mainTextColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Container(
                                      height: 20,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .end,
                                        children: [
                                          Text(
                                            nextSevenDays_date[index],
                                            style: GoogleFonts.sora(
                                              color: _selectedIndex == index
                                                  ? AppColors.white
                                                  : AppColors.mainTextColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(width: 2,),

                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
              // mo
                      }
                  ),
                ),
              ),

              // end dates
              SizedBox(
                height: 15,
              ),
              // book appointments


              SizedBox(
                height: 270,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: 18 - startHour,
                    padding: EdgeInsets.only(top:0),
                    itemBuilder: (context, index) {
                      return Opacity(
                        opacity: selectedTime == index ? 1 : 0.7,
                        child: GestureDetector(
                          onTap: () {
                            selectedCallTime = '${startHour + index > 12
                                ? startHour + index - 12
                                : startHour + index}:00 ${startHour + index > 11
                                ? "PM"
                                : "AM"}';
                            setState(() {
                              selectedTime = index;
                            });
                          },
                          child: Padding(
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
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    // profile images

                                    Row(
                                      children: [
                                        widget.doctor.imageurl!=null?
                                        SizedBox(
                                          height:50,
                                          width: 50,
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.circular(50),
                                              clipBehavior: Clip.hardEdge,
                                              child: CachedNetworkImage(imageUrl:  widget.doctor.imageurl!)),
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
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 13, vertical: 4),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .start,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(
                                                '${startHour + index > 12
                                                    ? startHour + index - 12
                                                    : startHour +
                                                    index}:00 ${startHour +
                                                    index > 11 ? "PM" : "AM"}',
                                                style: GoogleFonts.sora(
                                                  color: Colors.black.withOpacity(
                                                      0.7),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),

                                              Text(
                                                ' 1 Hour Call',
                                                style: GoogleFonts.sora(
                                                  color: Colors.black.withOpacity(
                                                      0.5),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    //
                                    // three dots

                                    Icon(Icons.check_circle_rounded,
                                      color: selectedTime == index ? AppColors
                                          .primaryColor : Colors.grey,)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),

              SizedBox(
                height: 10,
              ),


              // end book appoinytment
              GestureDetector(
                onTap: () {
                  if (selectedTime != -1) {
                    String dateString = "2024 ${nextSevenDays_month[_selectedIndex]} ${nextSevenDays_date[_selectedIndex]} ${nextSevenDays_day[_selectedIndex]} $selectedCallTime";
                    DateFormat inputFormat = DateFormat(
                        "yyyy MMM dd EEE hh:mm a", "en_US");
                    // Parse the date string into a DateTime object
                    DateTime bookedTime = inputFormat.parse(dateString);

                    LoginUser currentDoc = widget.doctor;
                    UserProvider provider = Provider.of<UserProvider>(context, listen: false);

                    FirestoreProvider().createNewAppointment(
                        currentDoc.uid!,
                        bookedTime,
                        currentDoc.name!,
                        provider.currentUser!.name!,
                        currentDoc.imageurl!,
                        currentDoc.specialization!,
                            () {
                              showModalBottomSheet(
                                isDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return AppointmentRequestedPopup();
                                },
                              );
                        }, () {
                      Fluttertoast.showToast(msg: "Sorry, there was an issue");
                    }
                    );
                  } else {
                    Fluttertoast.showToast(msg: "Please select a time to submit appointment.");
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: DottedBorder(
                     strokeCap: StrokeCap.round,
                    strokeWidth: 1.5,
                    borderType: BorderType.RRect,
                    radius: Radius.circular(100),
                    dashPattern: [10, 10],
                    color: AppColors.primaryColor,
                    // space
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AppIcons.add,
                          height: 24,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Submit Appointment',
                          style: GoogleFonts.sora(
                            color: AppColors.primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  void getNextSevenDays() {
    DateTime today = DateTime.now();
    String mName = "";


    for (int i = startHour < 17 ? 0 : 1; i <= 7; i++) {
      DateTime nextDay = today.add(Duration(days: i));
      String suffix = getDaySuffix(nextDay.day);
      String monthName = DateFormat('MMM').format(nextDay);
      if (mName != monthName) {
        mName = monthName;
        String monthh = DateFormat('MMMM').format(nextDay);
        thisMonthName = thisMonthName != "" ? "$thisMonthName/$monthh" : monthh;
      }
      nextSevenDays_day.add(DateFormat('E').format(nextDay));
      nextSevenDays_month.add(monthName);
      nextSevenDays_date.add(DateFormat('dd').format(nextDay));
    }
  }

  String getDaySuffix(int day) {
    if (!(day >= 1 && day <= 31)) {
      throw ArgumentError('Invalid day of the month');
    }

    if (day >= 11 && day <= 13) {
      return 'th';
    }

    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

}



class AppointmentRequestedPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity, // Adjust height as needed
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          SizedBox(
            height: 15,
          ),
          Text(
            'Appointment Requested!',
            style: GoogleFonts.sora(
              color: AppColors.mainTextColor,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Call Appointment has been requested successfully. If the appointment is accepted, it will be listed in your home screen.',
              textAlign: TextAlign.center,
              style: AppTextStyles().secondaryStyle,
            ),
          ),

          SizedBox(height: 20),

          Container(
           padding: EdgeInsets.symmetric(horizontal: 20),
            child: MainButton(
              text: "Go to Home",
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

