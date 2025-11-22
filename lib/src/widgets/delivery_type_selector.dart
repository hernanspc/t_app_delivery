import 'package:flutter/material.dart';

class DeliveryTypeSelector extends StatefulWidget {
  const DeliveryTypeSelector({super.key});

  @override
  State<DeliveryTypeSelector> createState() => _DeliveryTypeSelectorState();
}

class _DeliveryTypeSelectorState extends State<DeliveryTypeSelector> {
  String selected = "delivery"; // "delivery" o "pickup"

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Método de entrega",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            _optionCard(
              title: "Entrega a domicilio",
              subtitle: "Recibe tu pedido en tu ubicación",
              icon: Icons.delivery_dining,
              value: "delivery",
            ),
            _optionCard(
              title: "Recojo en tienda",
              subtitle: "Pasa a recoger tu pedido",
              icon: Icons.storefront,
              value: "pickup",
            ),
          ],
        ),
      ],
    );
  }

  /// 🔹 Componente reutilizable
  Widget _optionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
  }) {
    final isSelected = selected == value;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selected = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.amber.shade100 : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? Colors.amber : Colors.grey.shade300,
              width: 2,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: Colors.amber.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 28,
                color: isSelected ? Colors.amber.shade800 : Colors.grey,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.black : Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
