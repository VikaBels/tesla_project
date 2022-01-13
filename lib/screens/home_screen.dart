// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tesla_project/contanins.dart';
import 'package:tesla_project/home_controller.dart';

import 'components/battery_status.dart';
import 'components/door_lock.dart';
import 'components/tesla_bottom_navigationbar.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final HomeController _controller = HomeController();

  late AnimationController _batteryAnimetionController;
  late Animation<double> _animationBattery;
  late Animation<double> _animationBatteryStatus;

  void setupBatteryAnimation() {
    _batteryAnimetionController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    _animationBattery = CurvedAnimation(
      parent: _batteryAnimetionController,
      //here the animation end on 0.5
      //it ends on 300 millisec
      curve: Interval(0.0, 0.5),
    );

    _animationBatteryStatus = CurvedAnimation(
      parent: _batteryAnimetionController,
      //after a delay we start this animation
      //after 60 millisec delay it start
      //so it start an 360 and end on 600 millisec
      curve: Interval(0.6, 1),
    );
  }

  @override
  void initState() {
    setupBatteryAnimation();
    super.initState();
  }

  @override
  void dispose() {
    _batteryAnimetionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        //it rebuild the widget tree when any changes happend on our controller
        //тут мы меняем замки: lock or unlock
        //this animation need listenable
        animation: Listenable.merge([_controller, _batteryAnimetionController]),
        builder: (context, _) {
          return Scaffold(
            bottomNavigationBar: TeslaBottomNavigationBar(
              onTap: (index) {
                if (index == 1)
                  _batteryAnimetionController.forward();
                else if (_controller.selectedBottomTab == 1 && index != 1)
                  _batteryAnimetionController.reverse(from: 0.7);
                _controller.onBottomNavigationTabChange(index);
              },
              selectedTab: _controller.selectedBottomTab,
            ),
            body: SafeArea(
              child: LayoutBuilder(builder: (context, constrains) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: constrains.maxHeight * 0.1,
                      ),
                      child: SvgPicture.asset(
                        "assets/icons/Car.svg",
                        width: double.infinity,
                      ),
                    ),
                    AnimatedPositioned(
                      duration: defaultDuration,
                      right: _controller.selectedBottomTab == 0
                          ? constrains.maxWidth * 0.05
                          : constrains.maxWidth / 2,
                      // Now we need to animate the lock
                      // once user click on it
                      child: AnimatedOpacity(
                        duration: defaultDuration,
                        opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                        child: DoorLock(
                          //создаются в новом виджете ниже переменные для хранения
                          //значений и тут же передаются значения в виджет
                          //потому что при передачи просто контроллера параметры
                          //были бы недоступны/пустыми или что-то такое
                          isLock: _controller.isRightDoorLock,
                          press: _controller.updateRightDoorLock,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: defaultDuration,
                      left: _controller.selectedBottomTab == 0
                          ? constrains.maxWidth * 0.05
                          : constrains.maxWidth / 2,
                      //без этогой анимации замок остаётся и просто передвигается
                      child: AnimatedOpacity(
                        duration: defaultDuration,
                        opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                        child: DoorLock(
                          isLock: _controller.isLeftDoorLock,
                          press: _controller.updateLeftDoorLock,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: defaultDuration,
                      top: _controller.selectedBottomTab == 0
                          ? constrains.maxHeight * 0.13
                          : constrains.maxHeight / 2,
                      child: AnimatedOpacity(
                        duration: defaultDuration,
                        opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                        child: DoorLock(
                          isLock: _controller.isBonnetLock,
                          press: _controller.updateBonnetDoorLock,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: defaultDuration,
                      bottom: _controller.selectedBottomTab == 0
                          ? constrains.maxHeight * 0.17
                          : constrains.maxHeight / 2,
                      child: AnimatedOpacity(
                        duration: defaultDuration,
                        opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                        child: DoorLock(
                          isLock: _controller.isTrunkLock,
                          press: _controller.updateTrunkDoorLock,
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: _animationBattery.value,
                      child: SvgPicture.asset(
                        "assets/icons/Battery.svg",
                        width: constrains.maxWidth * 0.35,
                      ),
                    ),
                    Positioned(
                      top: 50 * (1 - _animationBatteryStatus.value),
                      height: constrains.maxHeight,
                      width: constrains.maxWidth,
                      child: Opacity(
                        child: BatteryStatus(constrains: constrains),
                        opacity: _animationBatteryStatus.value,
                      ),
                    )
                  ],
                );
              }),
            ),
          );
        });
  }
}
