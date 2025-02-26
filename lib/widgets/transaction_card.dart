import 'package:flutter/material.dart';

class TransactionCard extends StatefulWidget {
  final String title;
  final double amount;
  final DateTime date;
  final bool isIncome;
  final List<Map<String, dynamic>>? products; // Añadimos esta propiedad

  const TransactionCard({
    Key? key,
    required this.title,
    required this.amount,
    required this.date,
    required this.isIncome,
    this.products, // Opcional para mantener compatibilidad con ventas manuales
  }) : super(key: key);

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (widget.isIncome ? Colors.green : Colors.red).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.products != null && widget.products!.isNotEmpty
                          ? widget.products![0]['name'] // Mostrar el nombre del producto
                          : widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (widget.products != null && widget.products!.isNotEmpty)
                      Text(
                        'Cantidad: ${widget.products![0]['quantity']}', // Mostrar la cantidad
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                '${widget.isIncome ? '+' : '-'}\$${widget.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: widget.isIncome ? Colors.green : Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${widget.date.day}/${widget.date.month}/${widget.date.year}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}