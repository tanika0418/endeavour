import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FaqScreen extends StatelessWidget {
  final List faq;
  const FaqScreen({Key? key, required this.faq}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: statusBarHeight),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              width: 56.w,
              height: 56.h,
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                    margin: EdgeInsets.all(16.w),
                    child: Image.asset('assets/images/back.png')),
              ),
            ),
            Positioned(
              width: 360.w,
              height: 56.h,
              right: 0,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  'FAQ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 56.h,
              width: 360.w,
              height: 640.h - 56.h - statusBarHeight,
              child: Container(
                margin: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  bottom: 16.w,
                ),
                child: buildFaq(faq),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildFaq(List faq){
    var widgets = <Widget>[];
    for(var f in faq){
      widgets.add(faqTile(f.que, f.ans));
    }
    return Column(children: widgets);
  }

  Widget faqTile(String que, String ans) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        buildLine(que, 'Q'),
        SizedBox(height: 4.h),
        buildLine(ans, 'A'),
      ],
    );
  }

  Widget buildLine(String text, String tag) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(tag + ". "),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              color: tag == 'Q' ? Colors.black : Colors.black54,
            ),
          ),
        ),
      ],
    );
  }
}
