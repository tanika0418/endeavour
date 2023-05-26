import 'package:endeavour22/events/payment.dart';
import 'package:endeavour22/events/payment_provider.dart';
import 'package:endeavour22/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:endeavour22/events/faq_screen.dart';

import '../auth/auth_provider.dart';
import '../auth/user_model.dart';
import '../events/event_model.dart';
import '../helper/http_exception.dart';
import '../widgets/custom_loader.dart';
import '../widgets/custom_snackbar.dart';

class EventPassScreen extends StatefulWidget {
  const EventPassScreen({Key? key}) : super(key: key);

  @override
  State<EventPassScreen> createState() => _EventPassScreenState();
}

class _EventPassScreenState extends State<EventPassScreen> {
  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    final userData = Provider.of<Auth>(context, listen: false).userModel;
    List<dynamic> faq = [
      {
        'question':
            'Will purchasing the Student pass be economically good for us?',
        'answer':
            'Yes, it will be economically good for you as compared to purchasing multiple events separately.'
      },
      {
        'question': 'Can we have some discount on the Student pass?',
        'answer':
            'Yes, you can. Grab the early bird passes and enjoy the discount.'
      },
      {
        'question':
            'What if I want to make a team with someone who does not have the Student pass?',
        'answer':
            'If your teammate does not have the student pass then he/she would have to pay their share of the registration fee.For example, If you are participating in Bplan which has a registration fee of ₹299 and your teammates do not have the pass then they would have to pay ₹199 for participating and you do not need to spend a penny more.'
      },
      {
        'question':
            'Can 2 people with individual Student passes make a team and if so do they have to pay extra?',
        'answer':
            'Yes, they can form a team and they do not need to pay any amount.'
      },
      {
        'question': 'Is the Student pass transferable?',
        'answer':
            'No, the Student pass is non-transferable. Only those who have bought the Student pass can avail of the facilities available.'
      }
    ];
    List<FaqTile> temp = [];
    faq.forEach((element) {
      temp.add(FaqTile.fromMap(element as Map));
    });

    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: statusBarHeight),
                child: SizedBox(
                  height: 134.h,
                  width: 360.w,
                  child: Image.asset('assets/images/eventpasss.jpg',
                      fit: BoxFit.cover),
                ),
              ),
              Positioned(
                top: statusBarHeight,
                left: 0,
                width: 54.w,
                height: 54.w,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                      margin: EdgeInsets.all(14.w),
                      child: Image.asset(
                        'assets/images/back.png',
                        color: Colors.white,
                      )),
                ),
              ),
              Positioned(
                top: statusBarHeight,
                right: 0,
                width: 54.w,
                height: 54.w,
                child: InkWell(
                  onTap: (() => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FaqScreen(
                            faq: temp,
                          ),
                        ),
                      )),
                  child: Container(
                      margin: EdgeInsets.all(14.w),
                      child: Image.asset(
                        'assets/images/faq.png',
                        color: Colors.white,
                      )),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            child: Text(
              'E-Summit Pass',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22.sp),
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 6.h, left: 24.w, right: 24.w),
              child: Text(
                'Expert investor or an emerging entrepreneur or a quiz master, you think you know it all? Put that test to claim, battle it out in the field for the ultimate glory.',
                style: TextStyle(color: Colors.black, fontSize: 14.sp),
                textAlign: TextAlign.justify,
              )),
          SizedBox(height: 4.h),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 30.w),
            elevation: 0,
            child: Container(
              margin: EdgeInsets.all(20.h),
              child: Column(children: [
                Text('E-Summit Pass gives access to:',
                    style: TextStyle(
                        fontSize: 16.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(Icons.check_rounded, size: 14),
                    SizedBox(width: 5.w),
                    Text('All the events for free',
                        style: TextStyle(fontSize: 16.sp))
                  ],
                ),
                Row(children: [
                  Icon(Icons.check_rounded, size: 14),
                  SizedBox(width: 5.w),
                  Text('Keynote Speaker Sessions',
                      style: TextStyle(fontSize: 16.sp))
                ]),
                Row(children: [
                  Icon(Icons.check_rounded, size: 14),
                  SizedBox(width: 5.w),
                  Text('Content Creation Conclave',
                      style: TextStyle(fontSize: 16.sp))
                ]),
                Row(children: [
                  Icon(Icons.check_rounded, size: 14),
                  SizedBox(width: 5.w),
                  Text('Networking Arena', style: TextStyle(fontSize: 16.sp))
                ]),
                Row(children: [
                  Icon(Icons.check_rounded, size: 14),
                  SizedBox(width: 5.w),
                  Text('Panel Discussions', style: TextStyle(fontSize: 16.sp))
                ]),
                Row(
                  children: [
                    Icon(Icons.check_rounded, size: 14),
                    SizedBox(width: 5.w),
                    Text('Attendee Welcome Kit',
                        style: TextStyle(fontSize: 16.sp))
                  ],
                ),
                Row(children: [
                  Icon(Icons.check_rounded, size: 14),
                  SizedBox(width: 5.w),
                  Text('Food', style: TextStyle(fontSize: 16.sp))
                ]),
                Row(children: [
                  Icon(Icons.check_rounded, size: 14),
                  SizedBox(width: 5.w),
                  Text('Access to Workshops', style: TextStyle(fontSize: 16.sp))
                ]),
                SizedBox(height: 20.h),
                Row(children: [
                  Text(
                    'Price: ',
                    style: TextStyle(fontSize: 18.sp),
                  ),
                  Text('₹ ' + '599',
                      style: TextStyle(
                          color: Colors.black54,
                          decoration: TextDecoration.lineThrough,
                          fontSize: 14.sp)),
                  SizedBox(width: 12.w),
                  Text('20% discount',
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.bold))
                ]),
                Row(children: [
                  Text('₹ ' + '479 ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 22.sp)),
                  Text('/Student',
                      style: TextStyle(fontSize: 14.sp, color: Colors.black54))
                ]),
                SizedBox(height: 12.h),
                userData!.eventPass
                    ? buildButton(name: 'Bought', width: 160.w, isGreen: true)
                    : _isLoading
                        ? Center(child: buildLoader(35))
                        : InkWell(
                            child: buildButton(name: 'Buy Pass', width: 160.w),
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
                                    .then((value) => token = Provider.of<Auth>(
                                            context,
                                            listen: false)
                                        .token);
                                print(token);
                                Map data = await Provider.of<PaymentProvider>(
                                        context,
                                        listen: false)
                                    .createPaymentContext(token, "EVENT_PASS",
                                        "", [userData.email]);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PaymentScreen(
                                          contextId: data['_id'],
                                          payableAmt: data['payableAmount'],
                                          eventName: "Event Pass"),
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
                                    context: context,
                                    message: error.toString());
                              } catch (error) {
                                setState(() {
                                  _isLoading = false;
                                });
                                showErrorFlush(
                                    context: context,
                                    message: "Something went wrong");
                              }
                            },
                          ),
              ]),
            ),
          )
        ],
      )),
    );
  }

  bool _isLoading = false;
  buypassbutton(UserModel userData) {
    userData.eventPass
        ? buildButton(name: 'Bought', width: 160.w)
        : _isLoading
            ? Center(child: buildLoader(35))
            : InkWell(
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
                        .createPaymentContext(token, "EVENT_PASS", "",
                            //widget.model.mongoId,
                            [userData.email]);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentScreen(
                              contextId: data['_id'],
                              payableAmt: data['payableAmount'],
                              eventName: "Event Pass"),
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
                    showErrorFlush(context: context, message: error.toString());
                  } catch (error) {
                    setState(() {
                      _isLoading = false;
                    });
                    showErrorFlush(
                        context: context, message: "Something went wrong");
                  }
                },
              );
  }
}
