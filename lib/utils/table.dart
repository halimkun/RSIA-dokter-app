import 'package:flutter/material.dart';
import 'package:rsiap_dokter/components/blur.dart';

// ignore: must_be_immutable
class GenTable extends StatelessWidget {
  Map data;
  TextStyle? textStyle;
  TextAlign? textAlign;

  GenTable({
    super.key,
    required this.data,
    this.textStyle,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: IntrinsicColumnWidth(),
        1: FlexColumnWidth(),
      },
      border: TableBorder(
        horizontalInside: BorderSide(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      textBaseline: TextBaseline.alphabetic,
      children: data.entries.map((e) {
        return TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  e.key,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: BlurWidget(
                  child: Text(
                    e.value,
                    textAlign: textAlign ?? TextAlign.right,
                    style: textStyle,
                  ),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
