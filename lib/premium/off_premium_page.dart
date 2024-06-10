import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dots_indicator/dots_indicator.dart';

class OffPremiumPage extends StatefulWidget {
  @override
  _OffPremiumPageState createState() => _OffPremiumPageState();
}

class _OffPremiumPageState extends State<OffPremiumPage> {
  late PageController _pageController;
  int _currentPage = 0;
  bool _isLoading = false; // 결제 진행 상태를 추적하기 위한 변수

  final List<String> descriptions = [
    '투표자 초성 엿보기',
    '포인트 2배',
    '투표자에게 채팅 하기',
  ];

  final List<String> imagePaths = [
    'assets/juicy-pink-magnifier.png',
    'assets/juicy-gold-coin.png',
    'assets/juicy-envelope-with-heart.png',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Flirt Premium으로',
                  style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
                Text(
                  '누가 보냈는지 확인해보세요',
                  style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Container(
              margin: EdgeInsets.only(top: 15),
              height: 140.h,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemCount: descriptions.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Image.asset(imagePaths[index], height: 100.h),
                      SizedBox(height: 10.h),
                      Text(
                        descriptions[index],
                        style: TextStyle(fontSize: 17.sp),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              ),
            ),
            Center(
              child: DotsIndicator(
                dotsCount: descriptions.length,
                position: _currentPage.toDouble(),
                decorator: DotsDecorator(
                  activeColor: Colors.blue,
                  size: Size.square(8.0),
                  activeSize: Size(18.0, 8.0),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 13.h),
            Text('￦990/일주일', style: TextStyle(fontSize: 23.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 10.h),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true; // 로딩 상태로 변경
                });

                // 결제 API 호출 또는 기타 결제 로직 수행

                // 결제가 성공적으로 완료되면
                Future.delayed(Duration(seconds: 2), () {
                  setState(() {
                    _isLoading = false; // 로딩 상태 해제
                  });

                  // 결제 완료 메시지를 보여줄 수 있음

                  // 결제가 완료되었으므로 다른 작업 수행
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 30.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                minimumSize: Size(double.infinity, 40.h),
              ),
              child: Text(
                '구독하기',
                style: TextStyle(fontSize: 18.sp, color: Colors.white),
              ),
            ),
            SizedBox(height: 7.h),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // BottomSheet 닫기
              },
              child: Text(
                '다음에',
                style: TextStyle(fontSize: 13.sp, color: Colors.grey[350]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
