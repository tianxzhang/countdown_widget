import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

class CountdownWidget extends StatefulWidget {
  final int timeout;

  CountdownWidget(
    this.timeout,
  );

  @override
  _CountdownWidgetState createState() => _CountdownWidgetState(this.timeout);
}

class _CountdownWidgetState extends State<CountdownWidget>
    with TickerProviderStateMixin {
  late AnimationController controller;
  bool finish = false;
  late double current;
  TextEditingController timeController = TextEditingController();
  _CountdownWidgetState(this.timeout);
  bool started = false;
  int timeout;

  String get timerString {
    Duration duration = controller.duration! * controller.value;
    return '${(duration.inSeconds % 60).toString().padLeft(2, '0')}s';
  }

  void startOrder() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: timeout),
    );
    // controller.reverse(from: 1);
    current = controller.value * 10;

    controller.addStatusListener((status) {
      print(status);
      if (status == AnimationStatus.dismissed) {
        // Navigator.pop(context);
        setState(() {
          finish = true;
        });
        print("dismissed");
      }
    });

    controller.addListener(() {
      var timeRemain = controller.value * 10;
      if (current - timeRemain > 1) {
        current = timeRemain;
        print((controller.value * 10).toString() + "***");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.startOrder();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Offstage(
          offstage: finish,
          child: Container(
            margin: EdgeInsets.only(top: 100.h),
            width: 327.w,
            height: 56.h,
            decoration: new BoxDecoration(
                border: Border.all(
                    color: Colors.orange)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(child: Container(
                    child: TextField(
                      controller: timeController,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.black,
                      //设置光标
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.transparent)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          hintText: "请输入倒计时时间",
                          hintStyle: new TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.normal,
                              color: Colors.black)),
                      maxLines: 1,
                      //最大行数
                      autofocus: false,
                      //是否自动对焦
                      obscureText: false,
                      //是否是密码
//                  textAlign: TextAlign.center,//文本对齐方式
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                      //输入文本的样式
                      onChanged: (text) {

                      },
                      onSubmitted: (text) {
                        print('submit $text');
                        // FocusScope.of(context).requestFocus(FocusNode());
                      },
                    ))),
                InkWell(
                  child: Container(
                      width: 57.w,
                      height: 56.w,
                      color: Colors.orange,
                      alignment: Alignment.center,
                      child: Baseline(
                        baseline: 10.h,
                        baselineType: TextBaseline.alphabetic,
                        child: Text("OK",
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      )
                  ),
                  onTap: () {
                    setState(() {
                      timeout = int.parse(timeController.text);
                      started = true;
                      controller.duration = Duration(seconds: timeout);
                    });
                    controller.reverse(from: 1);

                  },
                ),

              ],
            ),
          ),
        ),
        Offstage(
          offstage: finish,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                child: Container(
                  color: Colors.orange,
                  width: 60.w,
                  height: 50.h,
                  child: Center(
                    child: Text(started ? "暂停" : "开始"),
                  ),
                ),
                onTap: () {
                  if(started) {
                    controller.stop();
                  }else {
                    controller.reverse();
                  }
                  setState(() {
                    started = !started;
                  });
                },
              )
            ],
          ),
        ),
        !finish
            ? Container(
                child: AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) {
                      return Stack(
                        children: <Widget>[
                          Align(
                            alignment: FractionalOffset.center,
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: Stack(
                                children: <Widget>[
                                  Positioned.fill(
                                    child: CustomPaint(
                                      painter: CustomTimerPainter(
                                        controller,
                                        Colors.orange,
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: FractionalOffset.center,
                                    child: Text(
                                      timerString,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 64.0,
                                          color: Color(0xFF182050)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    }),
              )
            : Container(
                margin: EdgeInsets.only(top: 120.h),
                width: 260.w,
                height: 260.w,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          "assets/oops_bg.png",
                        ),
                        fit: BoxFit.fill)),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Oops you ran",
                        style: TextStyle(
                            color: Colors.orange,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "out of time!",
                        style: TextStyle(
                            color: Colors.orange,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
        Offstage(
          offstage: !finish,
          child: GestureDetector(
            child: Container(
              margin: EdgeInsets.only(right: 10.w, top: 16.h, bottom: 65.h),
              width: 327.w,
              height: 56.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.w),
                color: Colors.orange,
              ),
              child: Center(
                child: Text(
                  "Try again",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            onTap: () async {
              controller.reverse(from: 1);
              current = controller.value * 10;
              if (finish) {
                setState(() {
                  finish = false;
                });
              }
            },
          ),
        )
      ],
    );
  }
}

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter(
    this.animation,
    this.backgroundColor,
    this.color,
  ) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.fill;

    canvas.drawCircle(size.center(Offset.zero), size.width / 3.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;

    canvas.drawArc(
        Rect.fromCenter(
            center: size.center(Offset.zero),
            width: size.width / 1.5,
            height: size.width / 1.5),
        math.pi * 1.5,
        -progress,
        true,
        paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
