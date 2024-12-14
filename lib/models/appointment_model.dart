class Appointment {
  DateTime date;
  String doctorId;
  String clientId;
  bool accepted;
  String doctorName; // New field for doctor's name
  String image; // New field for doctor's image URL
  String specialization; // New field for doctor's specialization
  String clientName; // New field for doctor's specialization
  String appointmentId; // New field for doctor's specialization

  Appointment({
    required this.date,
    required this.doctorId,
    required this.clientId,
    required this.doctorName,
    required this.image,
    required this.specialization,
    required this.clientName,
    required this.appointmentId,
    this.accepted = false,
  });

  // Constructor that creates an Appointment from a JSON object
  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      date: (json['date']).toDate(),
      doctorId: json['doctorId'],
      clientId: json['clientId'],
      doctorName: json['doctorName'],
      clientName: json['clientName'],
      image: json['image'],
      specialization: json['specialization'],
      accepted: json['accepted'],
      appointmentId: json['appointmentId'],
    );
  }

  // Method that converts an Appointment instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'date': date, // Convert DateTime to a string
      'doctorId': doctorId,
      'clientId': clientId,
      'doctorName': doctorName,
      'image': image,
      'specialization': specialization,
      'accepted': accepted,
      'clientName': clientName,
      'appointmentId': appointmentId,
    };
  }
}
