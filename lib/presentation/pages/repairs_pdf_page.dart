import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../data/models/repair.dart';

class RepairsPdf {
  static Future<pw.Page> repairsPage(List<Repair> list) async {
    final font = await rootBundle.load('assets/fonts/Times-New-Roman.ttf');
    final ttf = pw.Font.ttf(font);
    return pw.MultiPage(
      build: (pw.Context context) {
        return [
          pw.Column(
            children: [
              pw.Text(
                'Отчёт по ремонтам',
                style: pw.TextStyle(
                  fontSize: 20,
                  font: ttf,
                ),
              ),
              pw.SizedBox(height: 15),
              pw.Table(border: pw.TableBorder.all(), children: [
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
                for (var i = 0; i < list.length; i++) ...[
                  pw.TableRow(
                    children: [
                      pw.Text(
                        list[i].cartridge.inventoryNumber.toString(),
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(font: ttf),
                      ),
                      pw.Text(
                        list[i].startDate,
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(font: ttf),
                      ),
                      pw.Text(
                        list[i].endDate ?? '',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(font: ttf),
                      ),
                    ],
                  ),
                  if (i + 1 == list.length ||
                      list[i].startDate != list[i + 1].startDate)
                    pw.TableRow(
                      decoration: const pw.BoxDecoration(
                        color: PdfColor.fromInt(0xFFE0E0E0),
                      ),
                      children: [
                        pw.Text(
                          'Итого: ${list.where((r) => r.startDate == list[i].startDate).length} шт.',
                          style: pw.TextStyle(font: ttf),
                        ),
                      ],
                    ),
                ],
              ]),
            ],
          ),
        ];
      },
    );
  }
}
