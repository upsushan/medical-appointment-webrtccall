class LoginUser {
  final String? email;
  final String? uid;
  final String? userType;
  final dynamic lastLogin;
  final String? disease;
  final String? name;
  final String? specialization;
  final String? status;
  final String? callstatus;
  final String? beingcalled;
  final String? callerhost;
  final String? roomid;
  final String? imageurl;

  LoginUser({
     this.email,
     this.uid,
     this.userType,
     this.lastLogin,
     this.disease,
     this.name,
     this.specialization,
     this.status,
     this.callstatus,
     this.beingcalled,
     this.callerhost,
     this.roomid,
     this.imageurl,
  });

  // Factory constructor to create a User object from a Map
  factory LoginUser.fromJson(Map<String, dynamic> json) {
    return LoginUser(
      uid: json['uid'],
      email: json['email'],
      userType: json['usertype'],
      lastLogin: (json['lastlogin'])?.toDate(),
      status: json['status'],
      name: json['name'],
      disease: json['disease'],
      specialization: json['specialization'],
      callstatus: json['callstatus'],
      beingcalled: json['beingcalled'],
      callerhost: json['callerhost'],
      roomid: json['roomid'],
      imageurl: json['imageurl'],
    );
  }

  // Convert User object to a Map
  Map<String, dynamic> toJson() {
    return {
      'uid':uid,
      'email': email,
      'usertype': userType,
      'lastlogin': lastLogin,
      'status': status,
      'name':name,
      'disease':disease,
      'specialization' : specialization,
      'callstatus' : callstatus,
      'beingcalled' : beingcalled,
      'callerhost' : callerhost,
      'roomid' : roomid,
      'imageurl' : imageurl
    };
  }
}
