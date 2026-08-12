import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum FieldType {
  text,
  number,
  date,
  singleSelect,
  searchableSelect,
  multiSelect,
  heightPicker,
}

class EditFieldDialog extends StatefulWidget {
  final String title;
  final String fieldKey;
  final dynamic initialValue;
  final FieldType fieldType;
  final List<String>? options;
  final String? Function(String?)? validator;

  const EditFieldDialog({
    super.key,
    required this.title,
    required this.fieldKey,
    required this.initialValue,
    required this.fieldType,
    this.options,
    this.validator,
  });

  static Future<dynamic> show({
    required BuildContext context,
    required String title,
    required String fieldKey,
    required dynamic initialValue,
    required FieldType fieldType,
    List<String>? options,
    String? Function(String?)? validator,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditFieldDialog(
        title: title,
        fieldKey: fieldKey,
        initialValue: initialValue,
        fieldType: fieldType,
        options: options,
        validator: validator,
      ),
    );
  }

  @override
  State<EditFieldDialog> createState() => _EditFieldDialogState();
}

class _EditFieldDialogState extends State<EditFieldDialog> {
  late TextEditingController _textController;
  late String _selectedSingle;
  late List<String> _selectedMulti;
  late String _searchQuery;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _searchQuery = '';
    if (widget.fieldType == FieldType.multiSelect) {
      if (widget.initialValue is List<String>) {
        _selectedMulti = List<String>.from(widget.initialValue);
      } else if (widget.initialValue is String) {
        _selectedMulti = (widget.initialValue as String)
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      } else {
        _selectedMulti = [];
      }
      _textController = TextEditingController();
      _selectedSingle = '';
    } else if (widget.fieldType == FieldType.singleSelect ||
        widget.fieldType == FieldType.searchableSelect ||
        widget.fieldType == FieldType.heightPicker) {
      _selectedSingle = widget.initialValue?.toString() ?? '';
      _textController = TextEditingController(text: _selectedSingle);
      _selectedMulti = [];
    } else {
      _textController = TextEditingController(text: widget.initialValue?.toString() ?? '');
      _selectedSingle = '';
      _selectedMulti = [];
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submit(dynamic val) {
    if (widget.validator != null) {
      final err = widget.validator!(val?.toString());
      if (err != null) {
        setState(() {
          _errorMessage = err;
        });
        return;
      }
    }
    Navigator.pop(context, val);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: keyboardPadding + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Edit ${widget.title}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Body Content depending on FieldType
          if (widget.fieldType == FieldType.text || widget.fieldType == FieldType.number) ...[
            TextFormField(
              controller: _textController,
              keyboardType: widget.fieldType == FieldType.number
                  ? TextInputType.number
                  : TextInputType.text,
              autofocus: true,
              inputFormatters: widget.fieldType == FieldType.number
                  ? [
                      FilteringTextInputFormatter.digitsOnly,
                      if (widget.fieldKey == 'phone' || widget.fieldKey == 'altPhone')
                        LengthLimitingTextInputFormatter(10),
                      if (widget.fieldKey == 'pincode')
                        LengthLimitingTextInputFormatter(6),
                      if (widget.fieldKey == 'age')
                        LengthLimitingTextInputFormatter(3),
                    ]
                  : null,
              decoration: InputDecoration(
                labelText: widget.title,
                hintText: 'Enter ${widget.title}',
                errorText: _errorMessage,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _submit(_textController.text.trim()),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC9003F)),
              child: const Text('Save Changes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ] else if (widget.fieldType == FieldType.date) ...[
            TextFormField(
              controller: _textController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Birth Date (DD/MM/YYYY)',
                suffixIcon: const Icon(Icons.calendar_today, color: Color(0xFFC9003F)),
                errorText: _errorMessage,
              ),
              onTap: () async {
                final now = DateTime.now();
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime(1995, 2, 2),
                  firstDate: DateTime(1940),
                  lastDate: now,
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(primary: Color(0xFFC9003F)),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  final formatted =
                      "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                  setState(() {
                    _textController.text = formatted;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _submit(_textController.text.trim()),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC9003F)),
              child: const Text('Save Changes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ] else if (widget.fieldType == FieldType.singleSelect) ...[
            Wrap(
              spacing: 8,
              runSpacing: 10,
              children: (widget.options ?? []).map((opt) {
                final isSelected = _selectedSingle == opt;
                return ChoiceChip(
                  label: Text(opt),
                  selected: isSelected,
                  selectedColor: const Color(0xFFC9003F),
                  disabledColor: Colors.grey.shade100,
                  backgroundColor: Colors.grey.shade100,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedSingle = opt;
                      });
                      _submit(opt);
                    }
                  },
                );
              }).toList(),
            ),
          ] else if (widget.fieldType == FieldType.searchableSelect) ...[
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                hintText: 'Search ${widget.title}...',
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val.toLowerCase();
                });
              },
            ),
            const SizedBox(height: 12),
            Container(
              constraints: const BoxConstraints(maxHeight: 250),
              child: ListView(
                shrinkWrap: true,
                children: (widget.options ?? [])
                    .where((opt) => opt.toLowerCase().contains(_searchQuery))
                    .map((opt) {
                  final isSel = _selectedSingle == opt;
                  return ListTile(
                    title: Text(
                      opt,
                      style: TextStyle(
                        fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                        color: isSel ? const Color(0xFFC9003F) : Colors.black87,
                      ),
                    ),
                    trailing: isSel
                        ? const Icon(Icons.check_circle, color: Color(0xFFC9003F))
                        : null,
                    onTap: () => _submit(opt),
                  );
                }).toList(),
              ),
            ),
          ] else if (widget.fieldType == FieldType.multiSelect) ...[
            Wrap(
              spacing: 8,
              runSpacing: 10,
              children: (widget.options ?? []).map((opt) {
                final isSelected = _selectedMulti.contains(opt);
                return FilterChip(
                  label: Text(opt),
                  selected: isSelected,
                  selectedColor: const Color(0xFFC9003F),
                  backgroundColor: Colors.grey.shade100,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedMulti.add(opt);
                      } else {
                        _selectedMulti.remove(opt);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _submit(_selectedMulti),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC9003F)),
              child: const Text('Save Selection', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ] else if (widget.fieldType == FieldType.heightPicker) ...[
            Container(
              constraints: const BoxConstraints(maxHeight: 220),
              child: ListView(
                shrinkWrap: true,
                children: [
                  "4.10 ft", "5.0 ft", "5.1 ft", "5.2 ft", "5.3 ft", "5.4 ft", "5.5 ft",
                  "5.6 ft", "5.7 ft", "5.8 ft", "5.9 ft", "5.10 ft", "5.11 ft", "6.0 ft", "6.1 ft", "6.2 ft"
                ].map((ht) {
                  final isSel = _selectedSingle == ht;
                  return ListTile(
                    title: Text(ht, style: TextStyle(fontWeight: isSel ? FontWeight.bold : FontWeight.normal, color: isSel ? const Color(0xFFC9003F) : Colors.black87)),
                    trailing: isSel ? const Icon(Icons.check_circle, color: Color(0xFFC9003F)) : null,
                    onTap: () => _submit(ht),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
