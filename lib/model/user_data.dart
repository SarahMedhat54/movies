UserData? currentUser;

class UserData {
  static UserData? currentUser;
  String id;
  String email;
  String name;
  String phoneNumber;
  String avatar ;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.avatar  ,
  });

  static UserData fromJson(Map<String, dynamic> json){
    return UserData(id: json["id"], name: json["name"], email: json["email"],
       phoneNumber: json["phone_number"],avatar: json["avatar"] ?? "");
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone_number": phoneNumber,
      "avatar": avatar,
    };
  }
}