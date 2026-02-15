import 'package:coffee_app/features/coffee/domain/entities/expense_entity.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';


class PdfService {
  Future<void> generateTransactionHistoryPdf(List<ExpenseEntity> expenses) async {
    final pdf = pw.Document();

    // Load a font that supports standard characters (optional, but good practice)
    // For now we use the default font.

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text("Transaction History", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            ),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              context: context,
              headers: ['Date', 'Items', 'Total Price', 'Payment Method', 'Status'],
              data: expenses.map((expense) {
                final date = expense.orderDate != null
                    ? DateFormat('yyyy-MM-dd HH:mm').format(expense.orderDate!)
                    : 'N/A';
                return [
                  date,
                  expense.totalItems.toString(),
                  '\$${expense.totalPrice.toStringAsFixed(2)}',
                  expense.paymentMethod,
                  expense.status,
                ];
              }).toList(),
              border: pw.TableBorder.all(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
              cellAlignment: pw.Alignment.centerLeft,
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
