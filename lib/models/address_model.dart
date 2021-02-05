class AddressModel {
  var id;
  var name;
  var phone;
  var address;
  var addressName;
  var city;

  AddressModel(
      {this.addressName, this.name, this.phone, this.address, this.city});

  Map<String, dynamic> toMap() {
    return {
      'userID': id,
      'name': name,
      'phone': phone,
      'city': city,
      'address': address,
      'addressName': addressName,
    };
  }

  AddressModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        phone = map['phone'],
        city = map['city'],
        addressName = map['addressName'],
        address = map['address'];
}
