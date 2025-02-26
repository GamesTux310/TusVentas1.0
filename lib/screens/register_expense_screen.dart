import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class RegisterExpenseScreen extends StatefulWidget {
  const RegisterExpenseScreen({super.key});

  @override
  State<RegisterExpenseScreen> createState() => _RegisterExpenseScreenState();
}

class _RegisterExpenseScreenState extends State<RegisterExpenseScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = 'Alimentos';
  // Remove the date variable
  // DateTime _selectedDate = DateTime.now();
  final List<String> _categories = ['Alimentos', 'Transporte', 'Entretenimiento', 'Salud'];

  @override
  void initState() {
    super.initState();
    _amountController.text = '\$ 0.00';
  }

  void _saveExpense() {
    final title = _titleController.text;
    final amountText = _amountController.text.replaceAll(RegExp(r'[^\d.]'), '');
    final amount = double.tryParse(amountText) ?? 0.0;
  
    if (title.isNotEmpty && amount > 0) {
      Navigator.pop(context, {
        'title': title,
        'amount': amount,
        'category': _selectedCategory,
        'date': DateTime.now(), // Set the date to the current date
      });
    }
  }

  void _addCategory(String category) {
    setState(() {
      _categories.add(category);
      _selectedCategory = category;
    });
  }

  void _showAddCategoryDialog() {
    final newCategoryController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A2E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Nueva categoría',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: newCategoryController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Nombre de la categoría',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.08),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE53935)),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white70,
              ),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (newCategoryController.text.isNotEmpty) {
                  _addCategory(newCategoryController.text);
                  Navigator.pop(context);
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFE53935),
              ),
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  // Remove the _selectDate method and any references to _selectedDate
  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: _selectedDate,
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2101),
  //   );
  //   if (picked != null && picked != _selectedDate) {
  //     setState(() {
  //       _selectedDate = picked;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.white, size: 24),
                onPressed: () => Navigator.pop(context),
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              ),
            ),
            const Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(right: 40),
                  child: Text(
                    'Nuevo Gasto',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(
                Icons.receipt_long_outlined,
                color: Color(0xFFE53935),  // Changed to a deeper red
                size: 56,
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Ingresa los detalles del gasto',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Título del gasto',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                filled: true,
                fillColor: Colors.white.withOpacity(0.08),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE53935)),  // Changed from salmon to deeper red
                ),
                prefixIcon: const Icon(Icons.title_outlined, color: Colors.white70),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              keyboardType: TextInputType.number,
              inputFormatters: [CurrencyInputFormatter()],
              decoration: InputDecoration(
                hintText: '\$ 0.00',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                filled: true,
                fillColor: Colors.white.withOpacity(0.08),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE53935)),
                ),
                prefixIcon: const Icon(Icons.attach_money_outlined, color: Colors.white70),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedCategory,
                dropdownColor: const Color(0xFF1A1A2E),
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Categoría',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.category_outlined, color: Colors.white70),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showAddCategoryDialog,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Nueva Categoría'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.08),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.white.withOpacity(0.1)),
                  ),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _saveExpense,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935),
                  foregroundColor: Colors.white,  // Aseguramos que el texto e icono sean blancos
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save_outlined),
                    SizedBox(width: 8),
                    Text(
                      'Guardar Gasto',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-digit characters
    String value = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    
    // Convert to double (cents)
    double amount = double.parse(value) / 100;
    
    // Format with currency
    String formatted = _formatter.format(amount);
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}