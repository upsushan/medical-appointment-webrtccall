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

class MyAppointmentRequest extends StatefulWidget {
 const MyAppointmentRequest({super.key });

  @override
  State<MyAppointmentRequest> createState() =>
      _MyAppointmentRequestState();
}

class _MyAppointmentRequestState extends State<MyAppointmentRequest> {
  late UserProvider userProvider;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    if(userProvider.patientAppointment_All==null || userProvider.patientAppointment_All!.isEmpty){
      userProvider.showAllAppointments(false);
    }
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 246, 246, 254),
      body: Container(
        padding: EdgeInsets.only(top: 45),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("My Appointment Requests",
                      style:
                      AppTextStyles().primaryStyle.copyWith(fontSize: 20)),
                ],
              ),
            ),
            //search bar
            SizedBox(
              height: 15,
            ),



            if(userProvider.patientAppointment_All != null)
            Expanded(
              child: userProvider.patientAppointment_All!.isNotEmpty ? ListView.builder(
                padding: EdgeInsets.only(top: 5),
                  scrollDirection: Axis.vertical,
                  itemCount: userProvider.patientAppointment_All!.length,
                  itemBuilder: (context, index) {
                    bool accepted = userProvider.patientAppointment_All![index].accepted;
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
                            ),
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
                                  urlImage(userProvider.patientAppointment_All![index].doctorId) != "null" ?
                                  SizedBox(
                                    height:50,
                                    width: 50,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        clipBehavior: Clip.hardEdge,
                                        child: CachedNetworkImage(imageUrl:   urlImage(userProvider.patientAppointment_All![index].doctorId))),
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
                                          userProvider.patientAppointment_All![index].specialization!,
                                          style: GoogleFonts.sora(
                                            color: AppColors.mainTextColor,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),

                                      // name
                                      Text(
                                        'Dr. ${userProvider.patientAppointment_All![index].doctorName!}',
                                        style: GoogleFonts.sora(
                                          color: AppColors.mainTextColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),


                                      Text(
                                        formatDateTime(userProvider.patientAppointment_All![index].date),
                                        style: GoogleFonts.sora(
                                          color: AppColors.secondaryColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),

                              //
                              // book now button
                              GestureDetector(
                                onTap: (){

                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check_circle_rounded, color: accepted ? AppColors.primaryColor : Colors.grey,),
                                    SizedBox(height: 4,),
                                    Text(
                                      accepted ? 'Accepted' : "Not yet \n Accepted",
                                      style: GoogleFonts.sora(
                                        color: Colors.grey,
                                        fontSize: 8,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }) :
              Center(
                child: Text("You have not requested any appointments yet."),
              ),
            ),



            // end book appoinytment


          ],
        ),
      ),
    );
  }

  String urlImage(String DoctorId){
    var doctor  =  userProvider.doctorsList!.firstWhere((element) => element.uid == DoctorId);
    return doctor.imageurl != null ?  doctor.imageurl! : "null";
  }

  String formatDateTime(DateTime dateTime) {
    DateTime now = DateTime.now();
    if (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day + 1) {
      // Tomorrow, 6:30 pm
      return "Tomorrow, "+DateFormat("h:mm a").format(dateTime);
    }else if (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day ) {
      // In 3 Hours
      Duration difference = dateTime.difference(now);
      if (difference.inHours >= 1) {
        return "In ${difference.inHours} ${difference.inHours == 1 ? "Hour" : "Hours"}";
      }else  if (difference.inMinutes >= 1){
        return "In ${difference.inMinutes} Minutes";
      }else{
        return "Now";
      }
    } else  {
      // 14th May, 6:30 PM
      return DateFormat("d MMM, h:mm a").format(dateTime);
    }
  }

}




