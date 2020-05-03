import 'dart:async';
import 'dart:convert';
import 'package:covid_19/constant.dart';
import 'package:covid_19/widgets/counter.dart';
import 'package:covid_19/widgets/my_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Covid 19',
      theme: ThemeData(
          scaffoldBackgroundColor: kBackgroundColor,
          fontFamily: "Poppins",
          textTheme: TextTheme(
            body1: TextStyle(color: kBodyTextColor),
          )),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  Future<void> _handleRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 3), () {
      completer.complete();
    });
    setState(() {
     WorldwideRun();
     PakistanRun();

    });
    return completer.future.then<void>((_) {
      _scaffoldKey.currentState?.showSnackBar(SnackBar(
          content: const Text('Updated!'),
//          action: SnackBarAction(
//              label: 'RETRY',
//              onPressed: () {
//
//              }
//              )
      )
      );
    });
  }


  String cases="";
  String deaths="";
  String recovered="";
  String ww_cases="";
  String ww_deaths="";
  String ww_recovered="";
  String pk_cases="";
  String pk_deaths="";
  String pk_recovered="";

  final String WorldwideRunAPI ="https://www.parsehub.com/api/v2/projects/tJegSev5P6mO/run";

  final String PakistanRunAPI ="https://www.parsehub.com/api/v2/projects/tKcYRS6VViyJ/run";

  final String WorldwideCovidAPI = "https://www.parsehub.com/api/v2/projects/tJegSev5P6mO/last_ready_run/data?api_key=tVMqvgqTik_0";

  final String PakistanCovidAPI = "https://www.parsehub.com/api/v2/projects/tKcYRS6VViyJ/last_ready_run/data?api_key=tVMqvgqTik_0";

  Future<Map<String, dynamic>> PakistanRun() async {

    final Map<String, dynamic> authData = {
      "api_key": "tVMqvgqTik_0",
    };

    final http.Response response = await http.post(PakistanRunAPI, body: authData,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        });
    print(response.body);
    final Map<String, dynamic> authResponseData = json.decode(response.body);
    if (authResponseData.containsKey("status")) {
      setState(() {
        print("Pakistan Run Success");
        PakistanData();
//          Future.delayed(Duration(seconds: 3)).then((value) {
//            pr.hide().whenComplete(() {
//              Navigator.push(context, MaterialPageRoute(
//                  builder: (context)=>Home(TOKEN,USER_ID)
//              ));
//            });
//
//          });

      });

    }
    else
    {
      print("Error Running Project Pakistan");

    }


  }

  Future<Map<String, dynamic>> WorldwideRun() async {

    final Map<String, dynamic> authData = {
      "api_key": "tVMqvgqTik_0",
    };

    final http.Response response = await http.post(WorldwideRunAPI, body: authData,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        });
    print(response.body);
    final Map<String, dynamic> authResponseData = json.decode(response.body);
    if (authResponseData.containsKey("status")) {
      setState(() {
        print("Worldwide Run Success");
        WorldwideData();
//          Future.delayed(Duration(seconds: 3)).then((value) {
//            pr.hide().whenComplete(() {
//              Navigator.push(context, MaterialPageRoute(
//                  builder: (context)=>Home(TOKEN,USER_ID)
//              ));
//            });
//
//          });

      });

    }
    else
    {
      print("Error Running Project Worldwide");

    }


  }

  Future<Map<String, dynamic>> PakistanData() async {
    final Map<String, dynamic> authData = {
      "api_key": "tVMqvgqTik_0",
    };

    final http.Response response = await http.get(PakistanCovidAPI,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        });
    print(response.body);
    final Map<String, dynamic> authResponseData = json.decode(response.body);
    pk_cases= authResponseData["cases_pk"];
    pk_deaths= authResponseData["deaths_pk"];
    pk_recovered= authResponseData["recovered_pk"];
    if (authResponseData.containsKey("cases_pk")) {
      setState(() {
        print("Pakistan Data Get Success");
//        Future.delayed(Duration(seconds: 3)).then((value) {
//          pr.hide().whenComplete(() {
//            Navigator.push(context, MaterialPageRoute(
//                builder: (context) => Home(cases)
//            ));
//          });
//        });
      });
    }
    else {
      print("Error in API Pakistan");
    }
  }

  Future<Map<String, dynamic>> WorldwideData() async {
    final Map<String, dynamic> authData = {
      "api_key": "tVMqvgqTik_0",
    };

    final http.Response response = await http.get(WorldwideCovidAPI,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        });
    print(response.body);
    final Map<String, dynamic> authResponseData = json.decode(response.body);
    ww_cases= authResponseData["cases"];
    if(cases.isEmpty)
      {
        cases=ww_cases;
      }
    ww_deaths= authResponseData["deaths"];
    if(deaths.isEmpty)
      {
        deaths=ww_deaths;
      }
    ww_recovered= authResponseData["recovered"];
    if(recovered.isEmpty)
      {
        recovered=ww_recovered;
      }
    if (authResponseData.containsKey("cases")) {
      setState(() {
        print("Worldwide Data Get Success");
//        Future.delayed(Duration(seconds: 3)).then((value) {
//          pr.hide().whenComplete(() {
//            Navigator.push(context, MaterialPageRoute(
//                builder: (context) => Home(cases)
//            ));
//          });
//        });
      });
    }
    else {
      print("Error in API");
    }
  }

  final controller = ScrollController();
  double offset = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(onScroll);
    WorldwideRun();
    PakistanRun();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  String selectedLocation="Worldwide";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: LiquidPullToRefresh(
          showChildOpacityTransition: false,
          color: Color(0xFF3383CD),
          onRefresh: _handleRefresh,
          key: _refreshIndicatorKey,
          child: SingleChildScrollView(
            controller: controller,
            child: Column(
              children: <Widget>[
                MyHeader(
                  image: "assets/icons/Drcorona.svg",
                  textTop: "Stay Home",
                  textBottom: "Save Lives",
                  offset: offset,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Color(0xFFE5E5E5),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      SvgPicture.asset("assets/icons/maps-and-flags.svg"),
                      SizedBox(width: 20),
                      Expanded(
                        child: DropdownButton(
                          focusColor: Colors.white,
                          isExpanded: true,
                          underline: SizedBox(),
                          icon: SvgPicture.asset("assets/icons/dropdown.svg"),
                          value: selectedLocation,
                          items: [
                            'Worldwide',
                            'Pakistan'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedLocation=value;
                              switch(value)
                              {
                                case "Pakistan":
                                  cases=pk_cases;
                                  deaths=pk_deaths;
                                  recovered=pk_recovered;
                                  break;
                                case "Worldwide":
                                  cases=ww_cases;
                                  deaths=ww_deaths;
                                  recovered=ww_recovered;
                                  break;

                              }
                            });

                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Case Update\n",
                                  style: kTitleTextstyle,
                                ),
                                TextSpan(
                                  text: "Updated 5 minutes ago",
                                  style: TextStyle(
                                    color: kTextLightColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Text(
                            "See details",
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 4),
                              blurRadius: 30,
                              color: kShadowColor,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Counter(
                              color: kInfectedColor,
                              number: cases,
                              title: "Infected",
                            ),
                            Counter(
                              color: kDeathColor,
                              number: deaths,
                              title: "Deaths",
                            ),
                            Counter(
                              color: kRecovercolor,
                              number: recovered,
                              title: "Recovered",
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Spread of Virus",
                            style: kTitleTextstyle,
                          ),
                          Text(
                            "See details",
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        padding: EdgeInsets.all(20),
                        height: 178,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 10),
                              blurRadius: 30,
                              color: kShadowColor,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          "assets/images/map.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
