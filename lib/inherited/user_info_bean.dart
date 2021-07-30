class UserInfoBean {
  String name;
  String address;
  UserInfoBean({this.name = "", this.address = ""});

  void fromBean(UserInfoBean? bean) {
    this.name = bean!.name;
    this.address = bean.address;
  }
}