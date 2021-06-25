import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_feng_shui_mvvm/model/feng_shui_number_quality.dart';
import 'package:phone_feng_shui_mvvm/model/mobile_network_entity.dart';
import 'package:phone_feng_shui_mvvm/utils/helper.dart';
import 'package:phone_feng_shui_mvvm/view/widget/custom_input_view.dart';
import 'package:phone_feng_shui_mvvm/viewmodel/home_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late final TextEditingController _controller;
  late final HomeViewModel _homeViewModel;

  @override
  void initState() {
    super.initState();
    _homeViewModel = HomeViewModel();
    _controller = TextEditingController();
    _controller.addListener(() {
      if(_controller.text.isNotEmpty) {
        _homeViewModel.phoneSink.add(_controller.text);
        _homeViewModel.networkSink.add(_controller.text);
        _homeViewModel.resetStatusQualify();
      }
    });
  }

  @override
  void dispose() {
    _homeViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            StreamBuilder<String?>(
              stream: _homeViewModel.phoneStream,
              builder: (context, snapshot) {
                return CustomTextFormField(
                      controller: _controller,
                      label: 'Phone number',
                      prefix: StreamBuilder<MobileNetworkEntity?>(
                        stream: _homeViewModel.networkStream,
                        builder: (context, snapshotMobileNetwork) {
                          if (snapshotMobileNetwork.hasData) {
                            return Container(
                              height: 25,
                              margin: EdgeInsets.only(right: 20, top: 20),
                              width: 25,
                              child: Image.asset(snapshotMobileNetwork.data!.logo),
                            );
                          }
                          if (snapshot.hasData) {
                            return Container(
                                height: 25,
                                margin: EdgeInsets.only(right: 20, top: 20),
                                width: 25,
                                child: CircularProgressIndicator(color: Colors.black, strokeWidth: 1.5));
                          }
                          return SizedBox();
                        },
                      ),
                      errorText: snapshot.data is String
                          ? snapshot.data : '',
                      formatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10)
                      ],
                    );
                  },
            ),
            StreamBuilder<FengShuiNumberQuality?>(
              stream: _homeViewModel.qualityStream,
              builder: (context, snapshotQuality) {
                final _isQualified = snapshotQuality.hasData &&
                        snapshotQuality.data!.isGood;
                return snapshotQuality.hasData ? GestureDetector(
                  onTap: _isQualified ? () {
                    call(snapshotQuality.data!.phone!);
                  } : () {},
                  child: Text(snapshotQuality.data!.message!,
                    style: TextStyle(
                      color: snapshotQuality.data!.isGood ? Colors.green : Colors.red
                    ),
                  ),
                ) : SizedBox();
              },
            ),
            SizedBox(height: 30),
            StreamBuilder<bool>(
              stream: _homeViewModel.btnStream,
              builder: (context, snapshotButton) {
                bool _isEnable = snapshotButton.data == false ||
                    !snapshotButton.hasData;
                return MaterialButton(
                  minWidth: 200,
                  height: 50,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.grey, width: 0.5)
                  ),
                  child: Text('Submit', style: TextStyle(
                      color: _isEnable ? Colors.grey : Colors.white),),
                  onPressed: _isEnable ? null : () {
                    _homeViewModel.qualifyPhone(_controller.text);
                  },
                  color: Colors.black,
                );
              },
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void call(String number) {
    print('CCALLING $number');
    Helper.makePhoneCall(number);
  }
}
