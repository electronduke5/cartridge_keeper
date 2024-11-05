import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../data/models/office.dart';

class ReplacementPdf {
  static Future<pw.Page> replacementPage(List<Office> list) async {
    final font = await rootBundle.load('assets/fonts/Times-New-Roman.ttf');
    final ttf = pw.Font.ttf(font);
    return pw.MultiPage(
      build: (pw.Context context) {
        return [
          pw.Column(
            children: [
              pw.Text(
                'Отчёт по заменам картриджей',
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
                for (var i = 0; i < list.length; i++) ...[
                  pw.TableRow(
                    children: [
                      pw.Text(
                        list[i].cartridge.model,
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(font: ttf),
                      ),
                      pw.Text(
                        list[i].cartridge.inventoryNumber.toString(),
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(font: ttf),
                      ),
                      pw.Text(
                        list[i].department.name,
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(font: ttf),
                      ),
                      pw.Text(
                        list[i].officeNumber.toString(),
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(font: ttf),
                      ),
                      pw.Text(
                        list[i].replacementDate,
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(font: ttf),
                      ),
                    ],
                  ),
                  if (i + 1 == list.length ||
                      list[i].replacementDate != list[i + 1].replacementDate)
                    pw.TableRow(
                      decoration: const pw.BoxDecoration(
                        color: PdfColor.fromInt(0xFFE0E0E0),
                      ),
                      children: [
                        pw.Text(
                          'Итого: ${list.where((r) => r.replacementDate == list[i].replacementDate).length} шт.',
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
