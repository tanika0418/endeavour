import 'dart:async';
import 'dart:io';

import 'package:endeavour22/widgets/button.dart';
import 'package:endeavour22/widgets/input_field.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../auth/auth_provider.dart';
import '../widgets/custom_loader.dart';
import '../widgets/custom_snackbar.dart';
import 'payment_provider.dart';

class PaymentScreen extends StatefulWidget {
  final int payableAmt;
  final String contextId;
  final String eventName;
  const PaymentScreen({
    Key? key,
    required this.payableAmt,
    required this.contextId,
    required this.eventName,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late File selectedimg;
  String temptext = "No file chosen";
  final _txidController = TextEditingController();
  final _payeeNameController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
        body: SingleChildScrollView(
      child: Stack(children: [
        Container(
          margin: EdgeInsets.only(top: statusBarHeight),
          child: Column(children: [
            Container(
                margin: EdgeInsets.only(top: 14.w),
                child: Text(
                  widget.eventName,
                  style: TextStyle(fontSize: 24.sp),
                )),
            Container(
                margin: EdgeInsets.only(top: 6.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('To be Paid:  ', style: TextStyle(fontSize: 14.sp)),
                    Text(
                      '₹ ' + ((widget.payableAmt)/100).toString(),
                      style: TextStyle(
                          fontSize: 22.sp, fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 18.sp, vertical: 6.w),
              child: Center(
                child: Text(
                  'Kindly pay using the QR Code and enter the payment details below. Your payment status will be updated within 24 hours after verification.',
                  style: TextStyle(fontSize: 12.sp),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(width: 1.w, color: Colors.black54)),
              height: 188.w,
              width: 198.w,
              child: FutureBuilder(
                future: qrprovider(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return SpinKitFadingCircle(
                          color: Colors.grey, size: 36.h);
                    case ConnectionState.done:
                      return Image.network(snapshot.data.toString(),
                          height: 174.w,
                          width: 182.w,
                          errorBuilder: (context, error, stackTrace) =>
                              SpinKitFadingCircle(
                                  size: 36.h, color: Colors.grey));
                    default:
                      return SpinKitFadingCircle(
                          color: Colors.grey, size: 36.h);
                  }
                },
              ),
              margin: EdgeInsets.all(6.w),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(children: [
                Container(
                    child: Text(
                  'Enter the details for verification',
                  style: TextStyle(fontSize: 14.sp),
                )),
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  //margin: EdgeInsets.only(left: 26.w),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Transaction ID',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                buildInputField(
                    controller: _txidController,
                    name: "Transaction ID",
                    icon: "assets/images/user.png",
                    width: (360 - 64).w,
                    hideIcon: true,
                    isMargin: false),
                SizedBox(height: 6.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Payee Name',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                buildInputField(
                    controller: _payeeNameController,
                    name: "Payee Name",
                    icon: "assets/images/user.png",
                    width: (360 - 64).w,
                    hideIcon: true,
                    isMargin: false),
                SizedBox(height: 6.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Payment Proof',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  width: (360 - 64).w,
                  height: 28.h,
                  padding: EdgeInsets.all(4.w),
                  child: Row(children: [
                    GestureDetector(
                      onTap: () => pickimage(),
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.black38,
                        ),
                        child: Text("Choose File", textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Container(
                        child: Text(
                      temptext,
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis),
                    ))
                  ]),
                ),
                SizedBox(height: 12.h),
                _isLoading
                    ? SizedBox(
                        height: 48.h,
                        child: Center(
                          child: buildLoader(48.h),
                        ),
                      )
                    : InkWell(
                        child: buildButton(name: "Submit", width: 184.w),
                        onTap: (() => submit()),
                      )
              ]),
            ),
            // SizedBox(height: 12.h)
          ]),
        ),
        Positioned(
            top: statusBarHeight,
            left: 0,
            width: 54.w,
            height: 54.w,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                  margin: EdgeInsets.all(16.w),
                  child: Image.asset('assets/images/back.png')),
            )),
      ]),
    ));
  }

  pickimage() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    if (image != null)
      setState(() {
        temptext = image.path.split('/').last;
        selectedimg = File(image.path);
      });
    // else
    //   print('some error');
  }

  submit() async {
    String token = '';
    setState(() {
      _isLoading = true;
    });
    if (temptext == "No file chosen") {
      showErrorFlush(
        context: context,
        message: 'No file is chosen!',
      );
    }
    final transaction = _txidController.text.trim();
    final payee = _payeeNameController.text.trim();
    if (transaction.isEmpty) {
      showErrorFlush(
        context: context,
        message: 'Transaction ID field is empty!',
      );
      setState(() {
        _isLoading = false;
      });
      return;
    } else if (payee.isEmpty) {
      showErrorFlush(
        context: context,
        message: 'Payee name field is empty!',
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }
    try {
      await Provider.of<Auth>(context, listen: false).refreshToken().then(
          (value) => token = Provider.of<Auth>(context, listen: false).token);
      await Provider.of<PaymentProvider>(context, listen: false)
          .saveUpiVerficationReq(
              selectedimg, token, transaction, payee, widget.contextId);
      _txidController.clear();
      _payeeNameController.clear();
      temptext='No file chosen';
      showNormalFlush(
          context: context, message: "Request Submitted for Verification");
    } on HttpException catch (error) {
      setState(() {
        _isLoading = false;
      });
      showErrorFlush(context: context, message: error.toString());
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      showErrorFlush(context: context, message: error.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<String> qrprovider() async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('paymentQr').get();
    return snapshot.value.toString();
  }
}
