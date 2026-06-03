import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../models/equipment.dart';
import '../../services/mock_database.dart';

class EquipmentFormScreen extends StatefulWidget {
  final Equipment? equipment;

  const EquipmentFormScreen({super.key, this.equipment});

  @override
  State<EquipmentFormScreen> createState() => _EquipmentFormScreenState();
}

class _EquipmentFormScreenState extends State<EquipmentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _typeController;
  late TextEditingController _descriptionController;
  late TextEditingController _stockController;
  late TextEditingController _priceController;
  late TextEditingController _imageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.equipment?.name ?? '');
    _typeController = TextEditingController(text: widget.equipment?.type ?? '');
    _descriptionController = TextEditingController(text: widget.equipment?.description ?? '');
    _stockController = TextEditingController(text: widget.equipment?.stock.toString() ?? '');
    _priceController = TextEditingController(text: widget.equipment?.price.toString() ?? '');
    _imageController = TextEditingController(text: widget.equipment?.image ?? 'https://placeholder.com');
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final db = context.read<MockDatabase>();
      final newEquipment = Equipment(
        id: widget.equipment?.id ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        type: _typeController.text.trim(),
        description: _descriptionController.text.trim(),
        stock: int.parse(_stockController.text),
        image: _imageController.text.trim(),
        price: double.parse(_priceController.text),
      );

      if (widget.equipment == null) {
        db.addEquipment(newEquipment);
      } else {
        db.updateEquipment(newEquipment);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.equipment == null ? 'Add Equipment' : 'Edit Equipment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) => value!.isEmpty ? 'Enter name' : null,
                ),
                TextFormField(
                  controller: _typeController,
                  decoration: const InputDecoration(labelText: 'Type'),
                  validator: (value) => value!.isEmpty ? 'Enter type' : null,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  validator: (value) => value!.isEmpty ? 'Enter description' : null,
                ),
                TextFormField(
                  controller: _stockController,
                  decoration: const InputDecoration(labelText: 'Stock'),
                  keyboardType: TextInputType.number,
                  validator: (value) => int.tryParse(value!) == null ? 'Enter valid stock' : null,
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) => double.tryParse(value!) == null ? 'Enter valid price' : null,
                ),
                TextFormField(
                  controller: _imageController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                  validator: (value) => value!.isEmpty ? 'Enter image URL' : null,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _saveForm,
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
