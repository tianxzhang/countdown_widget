import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'countdown_widget.dart';

class CountdownScreen extends StatefulWidget {
  final int timeout;

  CountdownScreen(this.timeout);

  @override
  _CountdownScreenState createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: GestureDetector(
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onTap: () {
              exit(0);
            },
          ),
        ),
        body: Container(
            width: 1.sw,
            color: Colors.white,
            // padding: const EdgeInsets.only(top: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 25.w, right: 25.w),
                  child: Text(
                    "HElLO",
                    style: TextStyle(
                        color: Colors.orange,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                    child: CountdownWidget(widget.timeout))
              ],
            )));
  }
}
