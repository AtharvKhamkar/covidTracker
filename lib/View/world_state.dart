import 'package:covidtracker/Model/world_states_model.dart';
import 'package:covidtracker/Services/Utilities/states_services.dart';
import 'package:covidtracker/View/countries_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

class WorldStateScreen extends StatefulWidget {
  const WorldStateScreen({super.key});

  @override
  State<WorldStateScreen> createState() => _WorldStateScreenState();
}

class _WorldStateScreenState extends State<WorldStateScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 3), vsync: this)
        ..repeat();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  final colorList = <Color>[
    const Color(0xff4285F4),
    const Color(0xff1aa260),
    const Color(0xffde5246),
  ];

  @override
  Widget build(BuildContext context) {
    StatesServices statesServices = StatesServices();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .01,
                ),
                FutureBuilder(
                    future: statesServices.fetchWorldStatesRecords(),
                    builder:
                        (context, AsyncSnapshot<WorldStatesModel> snapshot) {
                      if (!snapshot.hasData) {
                        return SpinKitFadingCircle(
                          color: Colors.white,
                          size: 50,
                          controller: _controller,
                        );
                      } else {
                        return Column(
                          children: [
                            PieChart(
                              chartRadius: double.tryParse('200'),
                              dataMap: {
                                "Total": double.parse(
                                    snapshot.data!.cases!.toString()),
                                "Recovery": double.parse(
                                    snapshot.data!.recovered.toString()),
                                "Deaths": double.parse(
                                    snapshot.data!.deaths!.toString())
                              },
                              chartValuesOptions: ChartValuesOptions(
                                  showChartValuesInPercentage: true),
                              legendOptions: LegendOptions(
                                  legendPosition: LegendPosition.left),
                              animationDuration: Duration(milliseconds: 1600),
                              chartType: ChartType.ring,
                              colorList: [
                                Color(0xff4285F4),
                                Color(0xff1aa260),
                                Color(0xffde5246),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      MediaQuery.of(context).size.height * .04),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Column(
                                  children: [
                                    ReusableRow(
                                        title: "Total",
                                        value: snapshot.data!.cases.toString()),
                                    ReusableRow(
                                        title: "Deaths",
                                        value:
                                            snapshot.data!.deaths.toString()),
                                    ReusableRow(
                                        title: "Recovered",
                                        value: snapshot.data!.recovered
                                            .toString()),
                                    ReusableRow(
                                        title: "Active",
                                        value:
                                            snapshot.data!.active.toString()),
                                    ReusableRow(
                                        title: "Critical",
                                        value:
                                            snapshot.data!.critical.toString()),
                                    ReusableRow(
                                        title: "Today Deaths",
                                        value: snapshot.data!.todayDeaths
                                            .toString()),
                                    ReusableRow(
                                        title: "Today Recovered",
                                        value: snapshot.data!.todayRecovered
                                            .toString()),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CountriesListScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.green[400],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Text("Track Contries"),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  String title, value;
  ReusableRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Divider()
        ],
      ),
    );
  }
}
