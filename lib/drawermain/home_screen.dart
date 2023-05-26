import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:endeavour22/auth/auth_provider.dart';
import 'package:endeavour22/drawermain/glimpses_provider.dart';
import 'package:endeavour22/helper/constants.dart';
import 'package:endeavour22/helper/http_exception.dart';
import 'package:endeavour22/widgets/button.dart';
import 'package:endeavour22/widgets/custom_loader.dart';
import 'package:endeavour22/widgets/custom_snackbar.dart';
import 'package:endeavour22/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gif_view/gif_view.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../events/event_pass.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback openDrawer;
  const HomeScreen({Key? key, required this.openDrawer}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  // @override
  // void initState() {
  //   final userId = Provider.of<Auth>(context, listen: false).userModel!.id;
  //   Provider.of<NotificationProvider>(context, listen: false)
  //       .fetchNotifications(userId);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final statusBar = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: 360.w,
              height: 328.h + statusBar,
              child: Stack(
                children: [
                  // Positioned(
                  //     child: Image.asset(
                  //   'assets/images/earth2.jpg',
                  //   width: 360.w,
                  //   height: 328.h + statusBar,
                  // )),
                  Positioned(
                    child: GifView.asset(
                      'assets/images/main_final.gif',
                      fit: BoxFit.cover,
                      frameRate: 15,
                    ),
                    height: 328.h + statusBar,
                    width: 360.w,
                  ),
                  Positioned(
                    top: 0 + statusBar,
                    right: 8.w,
                    width: 60.w,
                    height: 60.w,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => const EventPassScreen(),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.all(10.w),
                        child: Image.asset(
                          'assets/images/ticket.png',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0 + statusBar,
                    left: 8.w,
                    width: 56.w,
                    height: 56.w,
                    child: InkWell(
                      onTap: widget.openDrawer,
                      child: Container(
                        margin: EdgeInsets.all(16.w),
                        child: SvgPicture.asset(
                          'assets/images/hamburger.svg',
                          color: Colors.white,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 36.w,
                    bottom: 36.h,
                    //top: 124.h + statusBar,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          height: 50.h,
                        ),
                        Text(
                          "E-Summit\n2022-23",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: 24.w,
                right: 24.w,
                top: 16.h,
                bottom: 12.h,
              ),
              child: Text(
                'About Endeavour',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: 24.w,
                right: 24.w,
                bottom: 16.h,
              ),
              child: Text(
                "Endeavour is an annual Entrepreneurship Summit of KIET, Ghaziabad that brings a golden opportunity for budding entrepreneurs as well as for the tech-savvies to showcase flair. Our annual Techno-Entrepreneurial Summit, recognized as Endeavour, was initiated in 2015 and the rich legacy has been carried on for the past 8 years. It is a platform where experience, learnings, inspiration, and ideas converge to make it once in a lifetime experience for everyone. It comprises startup expo, business conclaves, technical, corporate, and other thrilling events along with encouraging sessions by highly illustrious speakers and entrepreneurs. The event is organized at an inter-college level, so the main intention of the event is to foster an entrepreneurial culture among the participants and to introduce them to the corporate world. Thus, they have a good window of opportunities to explore and win numerous prizes, gift hampers, and goodies!",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: 24.w,
                right: 24.w,
                bottom: 16.h,
              ),
              child: Text(
                'Glimpses',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            buildCarousel(),
            SizedBox(height: 24.w),
            Container(
              margin: EdgeInsets.only(
                left: 24.w,
                right: 24.w,
                bottom: 8.h,
              ),
              child: Text(
                'Contact Us',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 26.w),
              alignment: Alignment.centerLeft,
              child: Text(
                'Subject',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8.w),
            buildInputField(
                controller: _subjectController,
                name: 'Specify your subject',
                icon: 'assets/images/user.png',
                width: 318.w,
                hideIcon: true),
            SizedBox(height: 8.h),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 26.w),
              child: Text(
                'Message',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8.w),
            buildInputField(
                controller: _messageController,
                name: 'How can we help you?',
                icon: 'assets/images/user.png',
                width: 318.w,
                maxLines: 4,
                height: 96.h,
                hideIcon: true),
            SizedBox(height: 16.h),
            Center(
              child: _isLoading
                  ? SizedBox(
                      height: 48.h,
                      child: Center(
                        child: buildLoader(48.h),
                      ),
                    )
                  : InkWell(
                      onTap: submitContactUs,
                      child: buildButton(name: 'Submit', width: 184.w),
                    ),
            ),
            SizedBox(height: 16.h),
            Container(
              height: 1.w,
              color: Colors.black12,
            ),
            SizedBox(height: 8.h),
            Center(
              child: InkWell(
                onTap: () => showModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  context: context,
                  builder: (context) {
                    return const BottomSheet();
                  },
                ),
                child: Text(
                  'Technical Team - 2023',
                  style: TextStyle(fontSize: 16.sp, color: kPrimaryMid),
                ),
              ),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  void link(String url, BuildContext context) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showErrorFlush(
        context: context,
        message: 'Error loading URL, please try again!',
      );
    }
  }

  void submitContactUs() async {
    setState(() {
      _isLoading = true;
    });
    final subject = _subjectController.text.trim();
    final message = _messageController.text.trim();

    if (subject.isEmpty) {
      showErrorFlush(
        context: context,
        message: 'Subject field is empty!',
      );
      setState(() {
        _isLoading = false;
      });
      return;
    } else if (message.isEmpty) {
      showErrorFlush(
        context: context,
        message: 'Message field is empty!',
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // now send request here...
    final userData = Provider.of<Auth>(context, listen: false).userModel!;
    try {
      final response = await http.post(
        Uri.parse('$serverURL/contactus/'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'name': userData.name,
          'subject': subject,
          'email': userData.email,
          'message': message,
          'contact': userData.phoneNumber
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData['hasError']) {
        throw HttpException(responseData['message']);
      }
      // clear the form after submitting
      _subjectController.clear();
      _messageController.clear();
      // Form Send
      showNormalFlush(
        context: context,
        message: 'Contact Form submitted successfully!',
      );
    } on HttpException catch (error) {
      showErrorFlush(
        context: context,
        message: error.toString(),
      );
    } catch (error) {
      String errorMessage = 'Could not send form, please try again!';
      showErrorFlush(
        context: context,
        message: errorMessage,
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  Widget buildCarousel() {
    return Consumer<GlimpsesProvider>(builder: (ctx, value, _) {
      if (value.glimpses.isNotEmpty) {
        var widgets = <Widget>[];
        for (var element in value.glimpses) {
          widgets.add(
            SizedBox(
              height: 274.w,
              width: 274.w,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: CachedNetworkImage(
                  placeholder: (context, url) => Center(
                    child: Container(
                      color: Colors.white,
                      child: SpinKitFadingCircle(
                        color: Colors.grey,
                        size: 36.h,
                      ),
                    ),
                  ),
                  imageUrl: element,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }
        return CarouselSlider(
          items: widgets,
          options: CarouselOptions(
            autoPlay: true,
            height: 274.w,
            autoPlayCurve: Curves.easeInOut,
          ),
        );
      } else {
        return Container();
      }
    });
  }
}

class BottomSheet extends StatelessWidget {
  const BottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 6.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 16.w),
            Text(
              'Developed by',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16.w),
            Container(
              color: Colors.black26,
              height: 1.w,
            ),
            Container(
              width: 360.w,
              height: 126.h,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 98.w,
                    height: 136.h,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          width: 88.w,
                          height: 88.h,
                          child: Image.asset('assets/images/man.png'),
                        ),
                        Center(
                          child: Text(
                            'Parneet\nRaghuvanshi',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 98.w,
                    height: 136.h,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          width: 88.w,
                          height: 88.h,
                          child: Image.asset('assets/images/woman.png'),
                        ),
                        Center(
                          child: Text(
                            'Tanika\nGulati',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 98.w,
                    height: 136.h,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          width: 88.w,
                          height: 88.h,
                          child: Image.asset('assets/images/man.png'),
                        ),
                        Center(
                          child: Text(
                            'Dhruv\nRastogi',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
