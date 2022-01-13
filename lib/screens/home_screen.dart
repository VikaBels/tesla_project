import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tesla_project/contanins.dart';
import 'package:tesla_project/home_controller.dart';

import 'components/door_lock.dart';
import 'components/tesla_bottom_navigationbar.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final HomeController _controller = HomeController();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        //it rebuild the widget tree when any changes happend on our controller
        //тут мы меняем замки: lock or unlock
        //this animation need listenable
        animation: _controller,
        builder: (context, _) {
          return Scaffold(
            bottomNavigationBar: TeslaBottomNavigationBar(
              onTap: (index) {},
              selectedTab: 0,
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
                    Positioned(
                      right: constrains.maxWidth * 0.05,
                      // Now we need to animate the lock
                      // once user click on it
                      child: DoorLock(
                        //создаются в новом виджете ниже переменные для хранения
                        //значений и тут же передаются значения в виджет
                        //потому что при передачи просто контроллера параметры
                        //были бы недоступны/пустыми или что-то такое
                        isLock: _controller.isRightDoorLock,
                        press: _controller.updateRightDoorLock,
                      ),
                    ),
                    Positioned(
                      left: constrains.maxWidth * 0.05,
                      child: DoorLock(
                        isLock: _controller.isLeftDoorLock,
                        press: _controller.updateLeftDoorLock,
                      ),
                    ),
                    Positioned(
                      top: constrains.maxHeight * 0.13,
                      child: DoorLock(
                        isLock: _controller.isBonnetLock,
                        press: _controller.updateBonnetDoorLock,
                      ),
                    ),
                    Positioned(
                      bottom: constrains.maxHeight * 0.17,
                      child: DoorLock(
                        isLock: _controller.isTrunkLock,
                        press: _controller.updateTrunkDoorLock,
                      ),
                    ),
                  ],
                );
              }),
            ),
          );
        });
  }
}
