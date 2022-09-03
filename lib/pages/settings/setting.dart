import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:nlapp/firebase.dart';

class Setting extends StatelessWidget {
  final String name;
  final String setting;

  const Setting({
    Key key,
    @required this.name,
    @required this.setting,
  }) : super(key: key);

  int toggleValue() {
    switch (GetStorage().read(this.setting)) {
      case true:
        return 0;
        break;
      case false:
        return 1;
        break;
      default:
        return 2;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[600],
              border: Border(bottom: BorderSide(color: Colors.grey[800]))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              settingBody(),
            ],
          ),
        ));
  }

  Widget settingBody() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [settingHeader(), settingToggle()],
      ),
    );
  }

  Widget settingHeader() {
    return Padding(
        padding: EdgeInsets.only(top: 30, right: 14, left: 14, bottom: 30),
        child: Container(
          margin: const EdgeInsets.only(right: 5.0),
          child: Text(
            this.name,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
  }

  Widget settingToggle() {
    return Padding(
        padding: EdgeInsets.only(top: 20, bottom: 20, right: 14),
        child: ToggleSwitch(
          minWidth: 90.0,
          cornerRadius: 20.0,
          activeBgColors: [
            [Colors.green[800]],
            [Colors.red[800]]
          ],
          activeFgColor: Colors.white,
          inactiveBgColor: Colors.grey,
          inactiveFgColor: Colors.white,
          initialLabelIndex: toggleValue(),
          totalSwitches: 2,
          labels: ['On', 'Off'],
          radiusStyle: true,
          onToggle: (index) {
            switch (index) {
              case 0:
                messaging.subscribeToTopic(this.name.toLowerCase());
                return GetStorage().write(this.setting, true);
                break;
              case 1:
                messaging.unsubscribeFromTopic(this.name.toLowerCase());
                return GetStorage().write(this.setting, false);
                break;
            }
          },
        ));
  }
}
