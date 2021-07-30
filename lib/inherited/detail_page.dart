import 'package:flutter/material.dart';

import 'inherited_user_info.dart';

class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Detail'),
        ),
        body: DefaultTextStyle(
          style: TextStyle(fontSize: 30, color: Colors.black),
          child: Center(
            child: Column(
              children: [
                Text(UserInfoWidget.of(context)!.userInfoBean.name),
                Text(UserInfoWidget.of(context)!.userInfoBean.address),
                TextButton(
                    onPressed: () {
                      setState(() {
                        UserInfoWidget.of(context)!.updateBean('wf123','address123');
                      });
                    },
                    child: Text('点击修改'))
              ],
            ),
          ),
        )
    );
  }
}