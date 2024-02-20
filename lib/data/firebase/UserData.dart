class UserData
{
  String userName;
  String userEmail;
  String userAddress;
  String userPhoneNumber;
  DateTime userBirthday;
  String userImage;

  UserData({
    required this.userName,
    required this.userEmail,
    required this.userAddress,
    required this.userPhoneNumber,
    required this.userBirthday,
    this.userImage = ""
  });

  Map<String, dynamic> toMap()
  {
    return {
      'userName': userName,
      'userEmail': userEmail,
      'userAddress': userAddress,
      'userPhoneNumber': userPhoneNumber,
      'userBirthday': userBirthday,
      'userImage': userImage
    };
  }

  factory UserData.fromJson(Map<String, dynamic> data)
  {
    DateTime birthday = DateTime.parse(data['userBirthday'].toDate().toString());

    return UserData(
        userName: data['userName'],
        userEmail: data['userEmail'],
        userAddress: data['userAddress'],
        userPhoneNumber: data['userPhoneNumber'],
        userBirthday: birthday,
        userImage: data['userImage']);
  }
}