import 'package:flutter/material.dart';

class InventoryScreen extends StatefulWidget {
  final Map<String, dynamic>? newProduct;
  
  // Add this static getter
  static List<Map<String, dynamic>> get products => _InventoryScreenState._products;
  
  const InventoryScreen({this.newProduct, super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  static final List<Map<String, dynamic>> _products = [];

  static List<Map<String, dynamic>> getProducts() {
    return _products;
  }

  @override
  void initState() {
    super.initState();
    if (widget.newProduct != null) {
      setState(() {
        _products.add(widget.newProduct!);
      });
    }
  }

  void addProduct(Map<String, dynamic> product) {
    setState(() {
      _products.add(product);
    });
  }

  void _deleteProduct(int index) {
    setState(() {
      _products.removeAt(index);
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
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.white, size: 24),
                onPressed: () => Navigator.pop(context),
                padding: const EdgeInsets.all(8), // Consistente con income_detail_screen
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              ),
            ),
            const Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(right: 40),
                  child: Text(
                    'Inventario',
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
                color: Colors.white, // Cambiado a blanco
                size: 40,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1), // Cambiado a blanco
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2), // Cambiado a blanco
                  ),
                ),
                child: Text(
                  _products.isEmpty 
                      ? 'No hay productos en el inventario'
                      : 'Productos disponibles: ${_products.length}',
                  style: const TextStyle(
                    color: Colors.white, // Cambiado a blanco
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _products.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inventory_2,
                            size: 80,
                            color: Colors.white.withOpacity(0.1), // Cambiado a blanco
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05), // Cambiado a blanco
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Agrega productos a tu inventario',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7), // Cambiado a blanco
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        final product = _products[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05), // Cambiado a blanco
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1), // Cambiado a blanco
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1), // Cambiado a blanco
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.inventory_outlined,
                                color: Colors.white, // Cambiado a blanco
                                size: 20,
                              ),
                            ),
                            title: Text(
                              product['name'],
                              style: const TextStyle(
                                color: Colors.white, // Cambiado a blanco
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1), // Cambiado a blanco
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        '# ${product['quantity']}',
                                        style: const TextStyle(
                                          color: Colors.white, // Cambiado a blanco
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1), // Cambiado a blanco
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        '\$ ${product['price'].toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          color: Colors.white, // Cambiado a blanco
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.white, // Cambiado a blanco
                                size: 20,
                              ),
                              onPressed: () => _showDeleteDialog(context, product, index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Map<String, dynamic> product, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.yellow, size: 24), // Reducido el tamaño del icono
            SizedBox(width: 8),
            Expanded( // Añadido Expanded para evitar el desbordamiento
              child: Text(
                '¿Eliminar producto?',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Text(
          '¿Estás seguro de eliminar ${product['name']}?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white70,
            ),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              _deleteProduct(index);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}