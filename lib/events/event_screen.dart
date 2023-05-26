import 'package:cached_network_image/cached_network_image.dart';
import 'package:endeavour22/events/entertain_eve.dart';
import 'package:endeavour22/events/event_detail_screen.dart';
import 'package:endeavour22/events/event_model.dart';
import 'package:endeavour22/events/event_main_provider.dart';
import 'package:endeavour22/helper/constants.dart';
import 'package:endeavour22/widgets/banner.dart';
import 'package:endeavour22/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class EventScreen extends StatefulWidget {
  final VoidCallback openDrawer;
  const EventScreen({Key? key, required this.openDrawer}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  void initState() {
    Provider.of<EventMainProvider>(context, listen: false).fetchEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    List<EventModel> Events = Provider.of<EventMainProvider>(context).Events;
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE),
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
                  onTap: widget.openDrawer,
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
                    'Events',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Consumer<EventMainProvider>(
                builder: (ctx, event, _) => event.completed
                    ? event.isEventsOpen
                        ? buildEventCardList(context, Events)
                        : const Center(
                            child: Text('Coming Soon!'),
                          )
                    : Center(
                        child: buildLoader(48.h),
                      ),
              ),
            ],
          )),
    );
  }

  Widget buildEventCardList(BuildContext context, List<EventModel> data) {
    var widgets = <Widget>[];
    for (EventModel model in data) {
      if (model.name != "Startup Expo") {
        widgets.add(buildEventCard(context, model));
      }
    }
    return Container(
      margin: EdgeInsets.only(top: 56.h),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
              ),
              child: Column(children: widgets)),
        ),
      ),
    );
  }

  Widget buildEventCard(BuildContext context, EventModel model) {
    return InkWell(
      onTap: () {
        model.name == 'Entertainment Eve'
            ? Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) =>
                        EveScreen(openDrawer: (() => Navigator.pop(context))))))
            : Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetail(model: model),
                ),
              );
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6.0,
              offset: Offset(0, 3),
            ),
          ],
        ),
        margin: EdgeInsets.symmetric(
          vertical: 12.w,
          horizontal: 6.w,
        ),
        height: 128.w,
        width: 314.w,
        child: Stack(
          children: [
            Positioned(
              width: 196.w,
              height: 46.w,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(16),
                  topLeft: Radius.circular(8),
                ),
                child: Container(
                  alignment: Alignment.center,
                  color: kPrimaryMid,
                  child: Text(
                    model.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              width: 186.w,
              height: 128.w - 46.w,
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(left: 12),
                child: Text(
                  model.desc,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Positioned(
              width: 128.w,
              height: 128.w,
              right: 0,
              child: model.isDis
                  ? ClipRect(
                      child: buildBanner(
                        child: Center(
                          child: Hero(
                              tag: model.index,
                              child: CachedNetworkImage(
                                  height: 64.w,
                                  width: 64.w,
                                  imageUrl: model.imgUri,
                                  placeholder: (context, url) => Center(
                                          child: Container(
                                        color: Colors.white,
                                        child: SpinKitFadingCircle(
                                          color: Colors.grey,
                                          size: 36.h,
                                        ),
                                      )))),
                        ),
                        oldP: model.price,
                        newP: model.discount,
                      ),
                    )
                  : Center(
                      child: Hero(
                          tag: model.index,
                          child: CachedNetworkImage(
                              height: 64.w,
                              width: 64.w,
                              imageUrl: model.imgUri,
                              placeholder: (context, url) => Center(
                                      child: Container(
                                    color: Colors.white,
                                    child: SpinKitFadingCircle(
                                      color: Colors.grey,
                                      size: 36.h,
                                    ),
                                  )))),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
