import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
// Removed the unused _categoryController as it was not being utilized in the code.
  // Update categories to Spanish
  final List<String> _categories = ['Electrónicos', 'Ropa', 'Alimentos'];
  String? _selectedCategory; // Add this line

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
                borderSide: const BorderSide(color: Colors.white),
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
                foregroundColor: const Color.fromARGB(255, 255, 255, 255),
              ),
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

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
                    'Añadir Nuevo Producto',
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
                Icons.inventory_2_outlined,
                color: Color.fromARGB(255, 255, 255, 255),  // Changed from green to orange
                size: 56,
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Ingresa los detalles del producto',
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
              controller: _nameController,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Nombre del Producto',
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
                  borderSide: const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                ),
                prefixIcon: const Icon(Icons.inventory_outlined, color: Colors.white70),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _quantityController,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintText: 'Cantidad',
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
                        borderSide: const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                      prefixIcon: const Icon(Icons.numbers_outlined, color: Colors.white70),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _priceController,
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
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.white),  
                      ),
                      prefixIcon: const Icon(Icons.attach_money_outlined, color: Colors.white70),
                    ),
                  ),
                ),
              ],
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
              child: Theme(
                data: Theme.of(context).copyWith(
                  popupMenuTheme: PopupMenuThemeData(
                    color: const Color(0xFF1A1A2E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  inputDecorationTheme: const InputDecorationTheme(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),  // Cambiado de Color(0xFFFF6D00)
                    ),
                  ),
                ),
                child: DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  dropdownColor: const Color(0xFF1A1A2E),
                  icon: const Icon(
                    Icons.arrow_drop_down_circle_outlined,
                    color: Colors.white,  // Cambiar de Color(0xFFFF6D00)
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Categoría',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 16,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: InputBorder.none,
                    prefixIcon: const Icon(
                      Icons.category_outlined,
                      color: Colors.white70,
                    ),
                  ),
                  selectedItemBuilder: (BuildContext context) {
                    return _categories.map<Widget>((String item) {
                      return Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }).toList();
                  },
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.circle,
                              size: 8,
                              color: Colors.white,  // Cambiar de Color(0xFFFF6D00)
                            ),
                            const SizedBox(width: 12),
                            Text(
                              category,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
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
              child: ElevatedButton.icon(
                onPressed: () async {
                  final name = _nameController.text;
                  final quantityText = _quantityController.text;
                  final priceText = _priceController.text.replaceAll(RegExp(r'[^\d.]'), '');
                  
                  if (name.isNotEmpty && quantityText.isNotEmpty && priceText.isNotEmpty && _selectedCategory != null) {
                    final quantity = int.tryParse(quantityText) ?? 0;
                    final price = double.tryParse(priceText) ?? 0.0;
                    
                    // Show loading animation
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return Dialog(
                          backgroundColor: Colors.transparent,
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A2E),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Guardando producto...',
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );

                    // Simulate saving delay
                    await Future.delayed(const Duration(seconds: 1));
                    
                    // Create product data
                    final product = {
                      'name': name,
                      'quantity': quantity,
                      'price': price,
                      'category': _selectedCategory,
                    };
                    
                    // Close loading dialog and return to previous screen
                    Navigator.pop(context); // Close loading dialog
                    Navigator.pop(context, product); // Return to previous screen with product data

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('¡Producto guardado exitosamente!'),
                        backgroundColor: Color(0xFFFF6D00),
                      ),
                    );
                  } else {
                    // Show an error message if any field is empty
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Por favor, complete todos los campos'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6D00),  // Changed from green to orange
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  foregroundColor: Colors.white, // Asegura que el texto sea blanco
                ),
                icon: const Icon(Icons.save_outlined, color: Colors.white),
                label: const Text(
                  'Guardar Producto',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white, // Asegura que el texto sea blanco
                  ),
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