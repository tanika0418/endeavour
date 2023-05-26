
import 'package:endeavour22/events/payment.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../auth/auth_provider.dart';
import '../helper/http_exception.dart';
import '../widgets/custom_snackbar.dart';
import 'payment_provider.dart';

class EveScreen extends StatefulWidget {
  final VoidCallback openDrawer;
  const EveScreen({Key? key, required this.openDrawer}) : super(key: key);

  @override
  State<EveScreen> createState() => _EveScreenState();
}

bool _isLoading = false;

class _EveScreenState extends State<EveScreen> {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<Auth>(context, listen: false).userModel;

    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
        body: SingleChildScrollView(
            child: Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: statusBarHeight),
          child: Column(children: [
            SizedBox(
              height: 6.h,
            ),
            Text(
              "E-Cell KIET",
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
            ),
            Text(
              'Presents',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 4.h,
            ),
            Container(
                height: 558.h,
                child: ClipRRect(
                  child: Image.asset(
                    'assets/images/evemobile.png',
                    fit: BoxFit.cover,
                  ),
                )),

            //buildButton(name: "Grab your seat now", width: 180.w)
          ]),
        ),
        Positioned(
          top: statusBarHeight,
          left: 0,
          width: 56.w,
          height: 56.h,
          child: InkWell(
            onTap: widget.openDrawer,
            child: Container(
                margin: EdgeInsets.all(16.w),
                child: Image.asset('assets/images/back.png')),
          ),
        ),
        Positioned(
          top: statusBarHeight,
          right: 0,
          width: 58.w,
          height: 58.h,
          child: Container(
              margin: EdgeInsets.all(16.w),
              child: Image.asset('assets/images/logo.png')),
        ),
        Positioned(
          top: 530.h,
          left: 84.w,
          right: 84.w,
          child: _isLoading
              ? Center(child: SpinKitFadingCircle(color: Colors.grey, size: 35))
              : InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.w),
                    child: Text(
                      'Grab your seat',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(width: 1.w, color: Colors.white)),
                  ),
                  onTap: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    try {
                      String token = "";
                      setState(() {
                        _isLoading = true;
                      });
                      await Provider.of<Auth>(context, listen: false)
                          .refreshToken()
                          .then((value) => token =
                              Provider.of<Auth>(context, listen: false).token);
                      print(token);
                      Map data = await Provider.of<PaymentProvider>(context,
                              listen: false)
                          .createPaymentContext(token, "ENTERTAINMENT_EVE", "",
                              // "625494997fd659a5d160aca6",
                              [userData!.email]);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentScreen(
                                contextId: data['_id'],
                                payableAmt: data['payableAmount'],
                                eventName: "Entertainment Eve"),
                          ));
                      // add rest of the members in the list
                      setState(() {
                        _isLoading = false;
                      });
                    } on HttpException catch (error) {
                      setState(() {
                        _isLoading = false;
                      });
                      print('http ex');
                      showErrorFlush(
                          context: context, message: error.toString());
                    } catch (error) {
                      setState(() {
                        _isLoading = false;
                      });
                      showErrorFlush(
                          context: context, message: "Something went wrong");
                    }
                  },
                ),
        )
      ],
    )));
  }
}
