import 'dart:convert';

import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import 'package:rsiap_dokter/api/request.dart';
import 'package:rsiap_dokter/components/List/jadwal_operasi.dart';
import 'package:rsiap_dokter/components/List/pasien_ralan.dart';
import 'package:rsiap_dokter/components/List/pasien_ranap.dart';
import 'package:rsiap_dokter/components/loadingku.dart';
import 'package:rsiap_dokter/components/others/stats_home.dart';
import 'package:rsiap_dokter/config/config.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  int selectedTab = 0;

  // Data
  // var _jadwalOperasi = {};
  var _pasienNow = {};
  var _dokter = {};

  List dataPasien = [];

  @override
  void initState() {
    super.initState();
    fetchAllData().then((value) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  // ---------------------- Fetch Data

  Future<void> fetchAllData() async {
    List<Future> futures = [
      _getDokter(),
      _getPasienNow(),
      // _getJadwalOperasiNow(),
    ];

    await Future.wait(futures);
  }

  Future<void> _getDokter() async {
    var res = await Api().getData('/dokter');
    if (res.statusCode == 200) {
      var body = json.decode(res.body);
      setState(() {
        _dokter = body;
      });
    }
  }

  Future<void> _getPasienNow() async {
    var res = await Api().getData('/dokter/pasien/now');
    if (res.statusCode == 200) {
      var body = json.decode(res.body);
      setState(() {
        _pasienNow = body;
        dataPasien = body['data']['data'];
      });
    }
  }

  // ---------------------- End Fetch Data

  // ---------------------- Tab Home

  void _changeSelectedNavBar(int index) {
    setState(() {
      selectedTab = index;
    });
  }

  List tabsHome = [
    {
      "label": "Rawat Inap",
      "icon": Icons.close,
      "widget": const ListPasienRanap()
    },
    {
      "label": "Rawat Jalan",
      "icon": Icons.close,
      "widget": const ListPasienRalan()
    },
    {
      "label": "Jadwal Operasi",
      "icon": Icons.close,
      "widget": const ListJadwalOperasi()
    },
  ];

  loadMore() {
    print("Load More Home.dart");
  }

  // ---------------------- End Tab Home

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return loadingku(primaryColor);
    } else {
      return LazyLoadScrollView(
        onEndOfPage: () => loadMore(),
        child: DefaultTabController(
          length: tabsHome.length,
          child: DraggableHome(
            title: const Text("Draggable Home"),
            headerWidget: StatsHomeWidget(
              dokter: _dokter,
              pasienNow: dataPasien,
              totalHariIni: _pasienNow['data']['total'],
            ),
            body: [
              Row(
                children: [
                  const Spacer(),
                  Container(
                    height: 3,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.grey,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              tabsHome[selectedTab]['widget'] as Widget,
            ],
            fullyStretchable: false,
            backgroundColor: Colors.white,
            appBarColor: accentColor,
            bottomNavigationBar: Container(
              color: accentColor,
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: TabBar(
                onTap: _changeSelectedNavBar,
                labelColor: textColorLight,
                indicatorColor: Colors.transparent,
                unselectedLabelColor: textColor.withOpacity(.5),
                tabs: tabsHome.map(
                  (e) {
                    return Tab(
                      child: Text(e['label'] as String),
                    );
                  },
                ).toList(),
              ),
            ),
          ),
        ),
      );
    }
  }
}
