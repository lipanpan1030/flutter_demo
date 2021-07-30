import 'package:flutter/material.dart';
import 'package:flutter_demo/inherited/user_info_bean.dart';

class _UserInfoInheritedWidget extends InheritedWidget {
  _UserInfoInheritedWidget(
      {Key? key,
      required Widget child,
      required this.userInfoBean,
      this.update})
      : super(key: key, child: child);

  final UserInfoBean userInfoBean;
  final Function? update;

  updateBean(String name, String address) {
    update!(name, address);
  }

  @override
  bool updateShouldNotify(_UserInfoInheritedWidget oldWidget) {
    return oldWidget.userInfoBean != userInfoBean ||
        oldWidget.userInfoBean.name != userInfoBean.name ||
        oldWidget.userInfoBean.address != userInfoBean.address;
  }
}

class UserInfoWidget extends StatefulWidget {
  UserInfoWidget(
      {Key? key, required this.userInfoBean, required this.child})
      : super(key: key);
  late UserInfoBean userInfoBean;
  final Widget child;

  @override
  _UserInfoWidgetState createState() => _UserInfoWidgetState();

  static _UserInfoInheritedWidget? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_UserInfoInheritedWidget>();
  }
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  _update(String name, String address) {
    UserInfoBean bean = UserInfoBean(name: name, address: address);
    widget.userInfoBean = bean;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _UserInfoInheritedWidget(
      userInfoBean: widget.userInfoBean,
      child: widget.child,
      update: _update,
    );
  }
}
