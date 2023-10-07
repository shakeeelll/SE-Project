class DeletedUser {
  String? sId;
  String? fName;
  String? lName;
  String? role;
  String? email;
  String? deletedAt;
  int? iV;

  DeletedUser(
      {this.sId,
      this.fName,
      this.lName,
      this.role,
      this.email,
      this.deletedAt,
      this.iV});

  DeletedUser.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fName = json['f_name'];
    lName = json['l_name'];
    role = json['Role'];
    email = json['email'];
    deletedAt = json['deletedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['f_name'] = this.fName;
    data['l_name'] = this.lName;
    data['Role'] = this.role;
    data['email'] = this.email;
    data['deletedAt'] = this.deletedAt;
    data['__v'] = this.iV;
    return data;
  }
}
