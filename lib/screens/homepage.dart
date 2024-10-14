import 'dart:async';
import 'package:intl/intl.dart';
import 'package:legacy/widgets/custom_loader.dart';
import 'package:legacy/widgets/legacy_coin.dart';
import 'package:legacy/widgets/decotile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  StreamController<bool> loadController = StreamController<bool>();
  StreamController<List<dynamic>> currController =
      StreamController<List<dynamic>>.broadcast();

  List<String> items = [];
  List<dynamic> rates = List.filled(24, 0.00);
  List<dynamic> past = List.filled(24, 0.00);
  double change = 0.00;
  Color color = Colors.white;
  dynamic temp1, temp2;

  void response() async {
    http.Response? res;
    try {
      res = await http
          .get(Uri.parse('https://chirayusoft.com/Gold/AGRA/AP-Jewellers'));
    } catch (error) {
      //
    }

    dom.Document html = dom.Document.html(res!.body);
    rates = html
        .querySelectorAll('table tr>td')
        .map((e) {
          temp1 = e.innerHtml.trim();
          temp2 = double.tryParse(temp1);
          if (temp2 == null && items.length != 26) {
            items.add(temp1);
          }
          return temp2;
        })
        .where((element) => element != null)
        .toList();
  }

  void updatePast(List<dynamic> current) async {
    await Future.delayed(const Duration(milliseconds: 750), () {
      past = current;
    });
  }

  roundUp(double text) => text.toStringAsFixed(2);

  @override
  void initState() {
    Timer.periodic(const Duration(milliseconds: 850), (timer) {
      response();
      updatePast(rates);

      currController.sink.add(rates);
      if (items.isEmpty) {
        Timer(const Duration(milliseconds: 850), () {
          loadController.sink.add(items.isEmpty);
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    currController.close();
    loadController.close();
  }

  coloredChange(dynamic present) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            (change > 0 ? '+${roundUp(change)}' : roundUp(change)),
          ),
          Text(
            '  [${((change * 100) / present).abs().toStringAsFixed(2)}%]',
          ),
        ],
      );

  coloredIcon() => Icon(
        change > 0
            ? Icons.arrow_drop_up_sharp
            : change < 0
                ? Icons.arrow_drop_down_sharp
                : Icons.timeline,
        color: change == 0 ? Colors.transparent : color,
        size: 20,
        shadows: [
          Shadow(blurRadius: 4, color: change == 0 ? Colors.transparent : color)
        ] //

        ,
      );

  appBar() => AppBar(
        toolbarHeight: 65,
        elevation: 2,
        shadowColor: Colors.black,
        scrolledUnderElevation: 0,
        title: const Text(" LEGACY"),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(25))),
        surfaceTintColor: Colors.transparent,
        backgroundColor: const Color.fromARGB(255, 10, 10, 10),
        titleTextStyle: GoogleFonts.montserrat(
          letterSpacing: 0,
          color: Colors.white,
          shadows: [const Shadow(color: Colors.white70, blurRadius: 5)],
          fontWeight: FontWeight.w200,
          fontSize: 23,
        ),
        actions: [
          LegacyCoin(
            action: () {
              setState(() {});
            },
          ),
        ],
      );

  bool notifyMe = false;

  @override
  Widget build(BuildContext context) {
    var indiaFormat = NumberFormat.currency(
        locale: 'en_IN', decimalDigits: 0, name: 'INR', symbol: '₹ ');
    var indiaDeciFormat = NumberFormat.currency(
        locale: 'en_IN', decimalDigits: 2, name: 'INR', symbol: '₹ ');
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 28, 28, 28),
        extendBodyBehindAppBar: true,
        appBar: appBar(),
        body: StreamBuilder<bool>(
            stream: loadController.stream,
            initialData: true,
            builder: (context, snapshot) {
              if (snapshot.data!) {
                return const CustomLoader();
              }

              return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 2,
                  ),
                  child: ListView.builder(
                    itemBuilder: (context, i) => DecoTile(
                      child: ListTile(
                        titleAlignment: ListTileTitleAlignment.titleHeight,
                        tileColor: Colors.transparent,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 14),
                        titleTextStyle: GoogleFonts.lato(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 13),
                        title: Text(
                          items[i + 2],
                          maxLines: 2,
                          softWrap: true,
                        ),
                        trailing: StreamBuilder<List<dynamic>>(
                            initialData: List.filled(26, 0.00),
                            stream: currController.stream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final data =
                                    snapshot.data ?? List.filled(26, 0.00);
                                change = data[i] - past[i];
                                if (change > 0) {
                                  color =
                                      const Color.fromARGB(255, 57, 204, 126);
                                } else if (change < 0) {
                                  color = Colors.redAccent;
                                } else {
                                  color = Colors.white;
                                }
                                return SizedBox(
                                  width: 180,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          coloredIcon(),
                                          Text(
                                            i < 3
                                                ? indiaDeciFormat
                                                    .format(data[i])
                                                : indiaFormat.format(data[i]),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w300),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      DefaultTextStyle(
                                        style: TextStyle(
                                            color: change == 0
                                                ? Colors.transparent
                                                : color,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                        child: coloredChange(data[i]),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              return const Center(
                                child: Text(
                                  "ERROR",
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.white),
                                ),
                              );
                            }),
                      ),
                    ),
                    itemCount: 24,
                    cacheExtent: 5000,
                    itemExtent: 80,
                    physics: const BouncingScrollPhysics(),
                  ));
            }));
  }
}
