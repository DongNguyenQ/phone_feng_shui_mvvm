import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_feng_shui_mvvm/model/feng_shui_number_quality.dart';
import 'package:phone_feng_shui_mvvm/model/mobile_network_entity.dart';
import 'package:phone_feng_shui_mvvm/service_locator.dart';
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
    _homeViewModel = locator<HomeViewModel>();
    _controller = TextEditingController();
    _controller.addListener(() {
      if(_controller.text.isNotEmpty) {
        _homeViewModel.phoneSink.add(_controller.text);
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
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
                            print('snapshotMobileNetwork : ${snapshotMobileNetwork.data}');
                            if (snapshotMobileNetwork.hasData) {
                              if (snapshotMobileNetwork.data != null) {
                                return Container(
                                  height: 25,
                                  margin: EdgeInsets.only(right: 20, top: 20),
                                  width: 25,
                                  child: Image.asset(snapshotMobileNetwork.data!.logo),
                                );
                              }
                              return SizedBox();
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
                        formatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10)
                        ],
                      );
                    },
              ),
              SizedBox(height: 30),
              StreamBuilder<dynamic>(
                stream: _homeViewModel.readyStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data is FengShuiNumberQuality) {
                      final data = snapshot.data as FengShuiNumberQuality;
                      if (data.isGood) {
                        return GestureDetector(
                          onTap: () {call(data.phone!);},
                          child: Text(
                            data.message!,
                            style: TextStyle(color: Colors.green),
                          ),
                        );
                      } else {
                        return Text(
                          data.message!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red),
                        );
                      }
                    }
                    return Text(snapshot.data, style: TextStyle(color: Colors.red));
                  }
                  return SizedBox();
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
      ),
    );
  }

  void call(String number) {
    Helper.makePhoneCall(number);
  }
}
