import 'package:flutter/material.dart';
import 'package:rsiap_dokter/components/cards/card_list_pasien.dart';
import 'package:rsiap_dokter/config/colors.dart';
import 'package:rsiap_dokter/config/strings.dart';
import 'package:rsiap_dokter/utils/fonts.dart';

class CreatePasienList extends StatefulWidget {
  final List pasien;
  final Function loadMore;
  final String title;

  const CreatePasienList({
    super.key,
    this.pasien = const [],
    required this.loadMore,
    required this.title,
  });

  @override
  State<CreatePasienList> createState() => _CreatePasienListState();
}

class _CreatePasienListState extends State<CreatePasienList> {
  List pasien = [];

  @override
  initState() {
    super.initState();
    pasien = widget.pasien;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: pasien.isEmpty ? 1 : pasien.length,
      padding: const EdgeInsets.all(10),
      itemBuilder: (context, index) {
        if (pasien.isEmpty) {
          return Container(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height / 5,
            ),
            child: Center(
              child: Text(
                noDataAvailableMsg,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor.withOpacity(0.5),
                ),
              ),
            ),
          );
        } else {
          if (index == 0) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: fontBold,
                        ),
                      ),
                      InkWell(
                        onTap: () => widget.loadMore(),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: primaryColor ,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.filter_list,
                            color: textWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                createCardPasien(pasien[index], context)
              ],
            );
          }

          // if last index
          if (index == pasien.length - 1) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                createCardPasien(pasien[index], context),
                InkWell(
                  onTap: () => widget.loadMore(),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.add,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            );
          }

          return createCardPasien(pasien[index],context);
        }
      },
    );
  }
}
