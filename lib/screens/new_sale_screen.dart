import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'inventory_screen.dart';
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

class NewSaleScreen extends StatefulWidget {
  const NewSaleScreen({super.key});

  @override
  State<NewSaleScreen> createState() => _NewSaleScreenState();
}

// Add this import at the top of the file


class _NewSaleScreenState extends State<NewSaleScreen> {
  final Map<String, int> _selectedQuantities = {};
  double _totalAmount = 0.0;

  bool _isInventory = true;
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isFormValid = false;
  List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    _amountController.text = '\$ 0.00';
    _titleController.addListener(_checkFormValidity);
    _amountController.addListener(_checkFormValidity);
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _products = List.from(InventoryScreen.products); // Create a new list copy
    });
  }

  void _checkFormValidity() {
    setState(() {
      _isFormValid = _titleController.text.isNotEmpty &&
          _amountController.text != '\$ 0.00' &&
          _amountController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _titleController.removeListener(_checkFormValidity);
    _amountController.removeListener(_checkFormValidity);
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _saveSale(BuildContext context) {
  if (_isInventory) {
    // Para ventas de inventario
    if (_totalAmount <= 0) return;

    final sale = {
      'title': 'Venta de Inventario',
      'amount': _totalAmount,
      'date': DateTime.now(),
      'isIncome': true,
      'products': _selectedQuantities.entries.map((entry) {
        final productName = entry.key;
        final quantity = entry.value;
        final product = _products.firstWhere((p) => p['name'] == productName);
        return {
          'name': productName,
          'quantity': quantity,
          'price': product['price'],
          'total': product['price'] * quantity,
        };
      }).toList(),
    };

    // Actualizar el inventario
    for (var entry in _selectedQuantities.entries) {
      final productName = entry.key;
      final quantity = entry.value;
      final productIndex = _products.indexWhere((p) => p['name'] == productName);
      if (productIndex != -1) {
        _products[productIndex]['quantity'] -= quantity;
      }
    }

    Navigator.pop(context, sale);
  } else {
    // Para ventas manuales
    if (!_isFormValid) return;
    
    final amountStr = _amountController.text.replaceAll(RegExp(r'[^\d.]'), '');
    final amount = double.parse(amountStr);
    
    final sale = {
      'title': _titleController.text,
      'amount': amount,
      'date': DateTime.now(),
      'isIncome': true,
    };
    
    Navigator.pop(context, sale);
  }
}

  void _calculateTotal() {
    double total = 0.0;
    _selectedQuantities.forEach((productName, quantity) {
      final product = _products.firstWhere((p) => p['name'] == productName);
      total += (product['price'] as double) * quantity;
    });
    setState(() {
      _totalAmount = total;
    });
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
                    'Nueva Venta',
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Icon(
                Icons.shopping_cart_outlined,
                color: Color(0xFF4CAF50),
                size: 56,
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Selecciona cómo deseas registrar la venta',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isInventory = true),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 12), // Reducido de 16
                        decoration: BoxDecoration(
                          color: _isInventory
                              ? const Color(0xFF4CAF50).withOpacity(0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              color: _isInventory ? const Color(0xFF4CAF50) : Colors.white70,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Inventario',
                              style: TextStyle(
                                color: _isInventory ? const Color(0xFF4CAF50) : Colors.white70,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isInventory = false),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: !_isInventory
                              ? const Color(0xFF4CAF50).withOpacity(0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit_note_outlined,
                              color: !_isInventory ? const Color(0xFF4CAF50) : Colors.white70,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Manual',
                              style: TextStyle(
                                color: !_isInventory ? const Color(0xFF4CAF50) : Colors.white70,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            if (_isInventory) ...[
              if (_products.isEmpty) ...[
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Parece que no hay productos',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Agrega productos desde el menú principal',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                Expanded(
                  flex: 10,
                  child: ListView.builder(
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.inventory, color: Colors.green, size: 24),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product['name'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      '\$${product['price'].toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      'Cantidad: ${_selectedQuantities[product['name']] ?? 0}/${product['quantity']}',
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 255, 255, 255),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                    onPressed: (_selectedQuantities[product['name']] ?? 0) > 0
                                        ? () {
                                            setState(() {
                                              _selectedQuantities[product['name']] =
                                                  (_selectedQuantities[product['name']] ?? 0) - 1;
                                              _calculateTotal();
                                            });
                                          }
                                        : null,
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add_circle_outline,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                    onPressed: (_selectedQuantities[product['name']] ?? 0) < product['quantity']
                                        ? () {
                                            setState(() {
                                              _selectedQuantities[product['name']] =
                                                  (_selectedQuantities[product['name']] ?? 0) + 1;
                                              _calculateTotal();
                                            });
                                          }
                                        : null, // Disable button if no more stock
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                if (_totalAmount > 0)
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Resumen de compra:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ..._selectedQuantities.entries.map((entry) {
                          final productName = entry.key;
                          final quantity = entry.value;
                          final product = _products.firstWhere((p) => p['name'] == productName);
                          return Text(
                            '$productName x$quantity - \$${(product['price'] * quantity).toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          );
                        }).toList(),
                        const Divider(color: Colors.white70),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total de venta:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$${_totalAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ] else ...[
              TextField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Título de la venta',
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
                    borderSide: const BorderSide(color: Color(0xFF4CAF50)),
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
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF4CAF50)),
                  ),
                  prefixIcon: const Icon(Icons.attach_money_outlined, color: Colors.white70),
                ),
              ),
            ],

            // Update the save button
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 60, // Cambiado a 60
              child: ElevatedButton(
                onPressed: (_isInventory && _totalAmount > 0) || (!_isInventory && _isFormValid)
                    ? () => _saveSale(context)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  disabledBackgroundColor: Colors.white.withOpacity(0.08),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.save_outlined),
                    const SizedBox(width: 8),
                    Text(
                      'Guardar Venta',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: (_isInventory && _totalAmount > 0) || (!_isInventory && _isFormValid)
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
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