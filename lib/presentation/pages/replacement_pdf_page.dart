import 'package:cartridge_keeper/common/extensions/date_extension.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../data/models/office.dart';

class ReplacementPdf {
  static Future<pw.Page> replacementPage(
      List<Office> list, DateTime startDate, DateTime endDate) async {
    final font = await rootBundle.load('assets/fonts/Times-New-Roman.ttf');
    final ttf = pw.Font.ttf(font);
    const pageSize = 30;
    Map<int, List<pw.TableRow>> rows = {};

    final numberOfPages = (list.length / pageSize).ceil();

    for (int page = 0; page < numberOfPages; page++) {
      rows[page] = [
        pw.TableRow(
          repeat: true,
          children: [
            pw.Text(
              'Модель',
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                font: ttf,
              ),
            ),
            pw.Text(
              'Инвентарный номер',
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                font: ttf,
              ),
            ),
            pw.Text(
              'Филиал',
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                font: ttf,
              ),
            ),
            pw.Text(
              'Номер кабинета',
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                font: ttf,
              ),
            ),
            pw.Text(
              'Дата замены',
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                font: ttf,
              ),
            ),
          ],
        ),
      ];

      var loopLimit = list.length - (list.length - ((page) + 1) * pageSize);
      if (loopLimit > list.length) loopLimit = list.length;

      for (int index = pageSize * page; index < loopLimit; index++) {
        rows[page]!.add(
          pw.TableRow(
            children: [
              pw.Text(
                list[index].cartridge.model,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(font: ttf),
              ),
              pw.Text(
                list[index].cartridge.inventoryNumber.toString(),
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(font: ttf),
              ),
              pw.Text(
                list[index].department.name,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(font: ttf),
              ),
              pw.Text(
                list[index].officeNumber.toString(),
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(font: ttf),
              ),
              pw.Text(
                list[index].replacementDate,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(font: ttf),
              ),
            ],
          ),
        );

        if (index + 1 == list.length ||
            list[index].replacementDate != list[index + 1].replacementDate) {
          rows[page]!.add(
            pw.TableRow(
              decoration: const pw.BoxDecoration(
                color: PdfColor.fromInt(0xFFE0E0E0),
              ),
              children: [
                pw.Text(
                  'Итого: ${list.where((r) => r.replacementDate == list[index].replacementDate).length} шт.',
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
          return List.generate(rows.keys.length, (index) {
            return pw.Column(
              children: [
                if (index == 0)
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 15),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Text(
                          'Отчёт по заменам картриджей',
                          style: pw.TextStyle(
                            fontSize: 20,
                            font: ttf,
                          ),
                        ),
                        pw.Text(
                          'за период ${startDate.toLocalFormat} - ${endDate.toLocalFormat} (${list.length} шт.)',
                          style: pw.TextStyle(
                            fontSize: 20,
                            font: ttf,
                          ),
                        ),
                      ],
                    ),
                  ),
                pw.Table(
                  border: pw.TableBorder.all(),
                  children: rows[index]!,
                ),
              ],
            );
          });
        });
  }
}
