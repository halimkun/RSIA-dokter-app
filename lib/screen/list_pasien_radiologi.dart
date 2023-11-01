import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rsiap_dokter/api/request.dart';
import 'package:rsiap_dokter/components/cards/card_list_pasien_radiologi.dart';
import 'package:rsiap_dokter/config/colors.dart';
import 'package:rsiap_dokter/screen/detail/radiologi.dart';
import 'package:rsiap_dokter/utils/box_message.dart';
import 'package:rsiap_dokter/utils/msg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListPasienRadiologi extends StatefulWidget {
  const ListPasienRadiologi({super.key});

  @override
  State<ListPasienRadiologi> createState() => _ListPasienRadiologiState();
}

class _ListPasienRadiologiState extends State<ListPasienRadiologi> {
  SharedPreferences? pref;

  String nextPageUrl = '';
  String prevPageUrl = '';
  String currentPage = '';
  String lastPage = '';

  List dataPasien = [];

  bool isLoading = true;
  bool btnLoading = false;

  String? spesialis;

  @override
  void initState() {
    super.initState();
    fetchPasien().then((value) {
      if (mounted) {
        _setData(value);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchPasien().then((value) {
      if (mounted) {
        _setData(value);
      }
    });
  }

  void _setData(value) {
    if (mounted) {
      if (value['data']['total'] != 0) {
        setState(() {
          dataPasien = value['data']['data'] ?? [];

          nextPageUrl = value['data']['next_page_url'] ?? '';
          prevPageUrl = value['data']['prev_page_url'] ?? '';
          currentPage = value['data']['current_page'].toString();
          lastPage = value['data']['last_page'].toString();

          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          dataPasien = value['data']['data'] ?? [];
        });
      }
    }
  }

  Future fetchPasien() async {
    var res = await Api().getData("/pasien/radiologi");
    if (res.statusCode == 200) {
      var body = json.decode(res.body);
      return body;
    } else {
      var body = json.decode(res.body);
      Msg.error(context, body['message']);
      return body;
    }
  }

  // Load More
  Future<void> loadMore() async {
    if (nextPageUrl.isNotEmpty) {
      var res = await Api().getDataUrl(nextPageUrl);
      if (res.statusCode == 200) {
        var body = json.decode(res.body);
        setState(() {
          dataPasien.addAll(body['data']['data']);

          nextPageUrl = body['data']['next_page_url'] ?? '';
          prevPageUrl = body['data']['prev_page_url'] ?? '';
          currentPage = body['data']['current_page'].toString();
          lastPage = body['data']['last_page'].toString();
        });
      } else {
        var body = json.decode(res.body);
        Msg.error(context, body['message']);

        setState(() {
          btnLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: MediaQuery.of(context).size.height / 3,
        child: Center(
          child: CircularProgressIndicator(
            color: primaryColor,
          ),
        ),
      );
    } else {
      return Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dataPasien.isEmpty ? 1 : dataPasien.length,
            padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
            itemBuilder: (context, index) {
              if (dataPasien.isEmpty) {
                return const BoxMessage(
                  title: "Tidak ada pasien",
                  body: "Belum ada pasien radiologi yang masuk",
                );
              }

              var pasien = dataPasien[index];
              var penjab = "";

              if (pasien['reg_periksa']['penjab']['png_jawab'].toString().contains('/')) {
                penjab = pasien['reg_periksa']['penjab']['png_jawab'].toString().split('/').last;
                penjab = "BPJS$penjab";
              } else {
                penjab = pasien['reg_periksa']['penjab']['png_jawab'];
              }

              return InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DetailRadiologi(
                      penjab: penjab,
                      noRawat: pasien['no_rawat'],
                      tanggal: pasien['tgl_hasil'],
                      jam: pasien['jam_hasil'],
                    ),
                  ),
                ),
                child: CardListPasienRadiologi(
                  penjab: penjab,
                  pasien: pasien,
                ),
              );
            },
          ),
          if (nextPageUrl.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: textColor, width: 1.5),
                borderRadius: BorderRadius.circular(5),
              ),
              child: btnLoading
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: textColor,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    )
                  : IconButton(
                      onPressed: () async {
                        setState(() {
                          btnLoading = true;
                        });

                        await loadMore();
                        setState(() {
                          btnLoading = false;
                        });
                      },
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: textColor,
                      ),
                    ),
            ),
        ],
      );
    }
  }
}