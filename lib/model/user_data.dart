UserData? currentUser;

class UserData {
  static UserData? currentUser;
  String id;
  String email;
  String name;
  String address;
  String phoneNumber;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.phoneNumber,
  });

  static UserData fromJson(Map<String, dynamic> json){
    return UserData(id: json["id"], name: json["name"], email: json["email"],
        address: json["address"], phoneNumber: json["phone_number"]);
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "address": address,
      "phone_number": phoneNumber,
    };
  }
}