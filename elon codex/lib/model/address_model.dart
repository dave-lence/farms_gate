class AddressModel {
  int? id;
  String firstname;
  String lastname;
  String phonenumber;
  String address;
  String email;
  String state;
  String city;
  bool isDefault;

  // Constructor
  AddressModel({
    this.id,
    required this.firstname,
    required this.lastname,
    required this.phonenumber,
    required this.address,
    required this.email,
    required this.state,
    required this.city,
    this.isDefault = false,
  });

  // Convert AddressModel object to a map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstname,
      'lastName': lastname,
      'phoneNumber': phonenumber,
      'deliveryAddress': address,
      'additionalPhoneNumber': email,
      'region': state,
      'city': city,
      'defaultAddress': isDefault ? 1 : 0,
    };
  }
  
  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      'firstName': firstname,
      'lastName': lastname,
      'phoneNumber': phonenumber,
      'additionalPhoneNumber': email,
      'deliveryAddress': address,
      'region': state,
      'city': city,
      'defaultAddress': isDefault ? true : false,
    };
  }

  // Create an AddressModel object from a database map
  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'],
      firstname: map['firstName'],
      lastname: map['lastName'],
      phonenumber: map['phoneNumber'],
      address: map['deliveryAddress'],
      email: map['additionalPhoneNumber'],
      state: map['region'],
      city: map['city'],
      isDefault: map['defaultAddress'] == 1,
    );
  }
}
