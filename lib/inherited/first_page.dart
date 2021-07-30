import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'detail_page.dart';
import 'inherited_user_info.dart';

class Page19PassByValue extends StatefulWidget {
  @override
  _Page19PassByValueState createState() => _Page19PassByValueState();
}

class _Page19PassByValueState extends State<Page19PassByValue> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PassByValue'),
      ),
      body: DefaultTextStyle(
        style: TextStyle(fontSize: 30, color: Colors.black),
        child: Column(
          children: [
            Text(UserInfoWidget.of(context)!.userInfoBean.name),
            Text(UserInfoWidget.of(context)!.userInfoBean.address),
            SizedBox(height: 40),
            TextButton(
              child: Text('点击跳转'),
              onPressed: (){
                Navigator.of(context).push(CupertinoPageRoute(builder: (context){
                  return DetailPage();
                }));
              },
            )
          ],
        ),
      ),
    );
  }
}