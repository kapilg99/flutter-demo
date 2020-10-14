class Member {
  String name, city;
  int phone_no, pin_no, id;
  static const table = "member",
      colId = "id",
      colName = "name",
      colPhone_no = "phone_no",
      colCity = "city",
      colPin_no = "pin_no";

  Member({this.id, this.name, this.phone_no, this.city, this.pin_no});

  Member.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    name = map[colName];
    phone_no = map[colPhone_no];
    city = map[colCity];
    pin_no = map[colPin_no];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colId: id,
      colName: name,
      colPhone_no: phone_no,
      colCity: city,
      colPin_no: pin_no,
    };
    return map;
  }

  @override
  String toString() {
    return 'Name : ' +
        name +
        "\nPhone : " +
        phone_no.toString() +
        "\nCity : " +
        city +
        "\nPin : " +
        pin_no.toString();
  }
}
