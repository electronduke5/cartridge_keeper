import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../data/models/repair.dart';

class RepairsPdf {
  static Future<pw.Page> repairsPage(
      List<Repair> list, DateTime startDate, DateTime endDate) async {
    final font = await rootBundle.load('assets/fonts/Times-New-Roman.ttf');
    final ttf = pw.Font.ttf(font);
    const pageSize = 40;
    Map<int, List<pw.TableRow>> rows = {};

    final numberOfPages = (list.length / pageSize).ceil();
    // int countOfInserts = 0;
    // for(int i = 0; i < list.length; i++) {
    //   if(i + 1 == list.length ||
    //       list[i].startDate != list[i + 1].startDate){
    //     countOfInserts++;
    //   }
    // }

    for (int page = 0; page < numberOfPages; page++) {
      rows[page] = [
        pw.TableRow(
          repeat: true,
          children: [
            pw.Text(
              'Инвентарный номер',
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                font: ttf,
              ),
            ),
            pw.Text(
              'Дата отправки',
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                font: ttf,
              ),
            ),
            pw.Text(
              'Дата возврата',
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                font: ttf,
              ),
            ),
          ],
        ),
      ];
      //var loopLimit = list.length + countOfInserts - (list.length - ((page) + 1) * pageSize);
      var loopLimit = list.length - (list.length - ((page) + 1) * pageSize);
      if (loopLimit > list.length) loopLimit = list.length;

      //for (int index = pageSize * page; index < loopLimit-countOfInserts; index++) {
      for (int index = pageSize * page; index < loopLimit; index++) {
        rows[page]!.add(
          pw.TableRow(
            children: [
              pw.Text(
                list[index].cartridge.inventoryNumber.toString(),
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(font: ttf),
              ),
              pw.Text(
                list[index].startDate,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(font: ttf),
              ),
              pw.Text(
                list[index].endDate ?? '',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(font: ttf),
              ),
            ],
          ),
        );
        if (index + 1 == list.length ||
            list[index].startDate != list[index + 1].startDate) {
          rows[page]!.add(
            pw.TableRow(
              decoration: const pw.BoxDecoration(
                color: PdfColor.fromInt(0xFFE0E0E0),
              ),
              children: [
                pw.Text(
                  'Итого: ${list.where((r) => r.startDate == list[index].startDate).length} шт.',
                  style: pw.TextStyle(font: ttf),
                ),
              ],
            ),
          );
        }
      }
    }

    return pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return List.generate(
          rows.keys.length,
          (index) {
            return pw.Column(
              children: [
                if (index == 0)
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 15),

                  ),
                pw.Table(
                  border: pw.TableBorder.all(),
                  children: rows[index]!,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
