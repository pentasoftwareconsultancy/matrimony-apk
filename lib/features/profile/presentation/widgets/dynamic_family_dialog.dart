import 'package:flutter/material.dart';
import '../../domain/models/profile_model.dart';

enum DynamicFamilyType {
  brothers,
  sisters,
  maternalUncles,
  uncles,
}

class DynamicFamilyDialog extends StatefulWidget {
  final DynamicFamilyType type;
  final List<BrotherDetail>? initialBrothers;
  final List<SisterDetail>? initialSisters;
  final List<UncleDetail>? initialMaternalUncles;
  final List<UncleDetail>? initialUncles;

  const DynamicFamilyDialog({
    super.key,
    required this.type,
    this.initialBrothers,
    this.initialSisters,
    this.initialMaternalUncles,
    this.initialUncles,
  });

  static Future<dynamic> show({
    required BuildContext context,
    required DynamicFamilyType type,
    List<BrotherDetail>? initialBrothers,
    List<SisterDetail>? initialSisters,
    List<UncleDetail>? initialMaternalUncles,
    List<UncleDetail>? initialUncles,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DynamicFamilyDialog(
        type: type,
        initialBrothers: initialBrothers,
        initialSisters: initialSisters,
        initialMaternalUncles: initialMaternalUncles,
        initialUncles: initialUncles,
      ),
    );
  }

  @override
  State<DynamicFamilyDialog> createState() => _DynamicFamilyDialogState();
}

class _DynamicFamilyDialogState extends State<DynamicFamilyDialog> {
  int _count = 0;
  final TextEditingController _countInputController = TextEditingController();

  // In-memory persistent caches so count changes don't lose entered text
  final List<Map<String, TextEditingController>> _brotherControllers = [];
  final List<Map<String, dynamic>> _sisterData = [];
  final List<Map<String, TextEditingController>> _maternalUncleControllers = [];
  final List<Map<String, TextEditingController>> _uncleControllers = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    switch (widget.type) {
      case DynamicFamilyType.brothers:
        final list = widget.initialBrothers ?? [];
        _count = list.length;
        for (final b in list) {
          _brotherControllers.add({
            'name': TextEditingController(text: b.name),
            'occupation': TextEditingController(text: b.occupation),
          });
        }
        break;

      case DynamicFamilyType.sisters:
        final list = widget.initialSisters ?? [];
        _count = list.length;
        for (final s in list) {
          _sisterData.add({
            'name': TextEditingController(text: s.name),
            'occupation': TextEditingController(text: s.occupation),
            'isMarried': s.isMarried,
            'husbandName': TextEditingController(text: s.husbandName),
            'husbandProfession': TextEditingController(text: s.husbandProfession),
          });
        }
        break;

      case DynamicFamilyType.maternalUncles:
        final list = widget.initialMaternalUncles ?? [];
        _count = list.length;
        for (final u in list) {
          _maternalUncleControllers.add({
            'name': TextEditingController(text: u.name),
            'occupation': TextEditingController(text: u.occupation),
          });
        }
        break;

      case DynamicFamilyType.uncles:
        final list = widget.initialUncles ?? [];
        _count = list.length;
        for (final u in list) {
          _uncleControllers.add({
            'name': TextEditingController(text: u.name),
            'occupation': TextEditingController(text: u.occupation),
          });
        }
        break;
    }

    _countInputController.text = _count.toString();
    _ensureCapacity(_count);
  }

  void _ensureCapacity(int targetCount) {
    switch (widget.type) {
      case DynamicFamilyType.brothers:
        while (_brotherControllers.length < targetCount) {
          _brotherControllers.add({
            'name': TextEditingController(),
            'occupation': TextEditingController(),
          });
        }
        break;
      case DynamicFamilyType.sisters:
        while (_sisterData.length < targetCount) {
          _sisterData.add({
            'name': TextEditingController(),
            'occupation': TextEditingController(),
            'isMarried': false,
            'husbandName': TextEditingController(),
            'husbandProfession': TextEditingController(),
          });
        }
        break;
      case DynamicFamilyType.maternalUncles:
        while (_maternalUncleControllers.length < targetCount) {
          _maternalUncleControllers.add({
            'name': TextEditingController(),
            'occupation': TextEditingController(),
          });
        }
        break;
      case DynamicFamilyType.uncles:
        while (_uncleControllers.length < targetCount) {
          _uncleControllers.add({
            'name': TextEditingController(),
            'occupation': TextEditingController(),
          });
        }
        break;
    }
  }

  void _setCount(int newCount) {
    if (newCount < 0) newCount = 0;
    if (newCount > 15) newCount = 15;
    _ensureCapacity(newCount);
    setState(() {
      _count = newCount;
      _countInputController.text = newCount.toString();
    });
  }

  @override
  void dispose() {
    _countInputController.dispose();
    for (final map in _brotherControllers) {
      map['name']?.dispose();
      map['occupation']?.dispose();
    }
    for (final map in _sisterData) {
      (map['name'] as TextEditingController?)?.dispose();
      (map['occupation'] as TextEditingController?)?.dispose();
      (map['husbandName'] as TextEditingController?)?.dispose();
      (map['husbandProfession'] as TextEditingController?)?.dispose();
    }
    for (final map in _maternalUncleControllers) {
      map['name']?.dispose();
      map['occupation']?.dispose();
    }
    for (final map in _uncleControllers) {
      map['name']?.dispose();
      map['occupation']?.dispose();
    }
    super.dispose();
  }

  String get _title {
    switch (widget.type) {
      case DynamicFamilyType.brothers:
        return 'Brothers Details';
      case DynamicFamilyType.sisters:
        return 'Sisters Details';
      case DynamicFamilyType.maternalUncles:
        return 'Maternal Uncle Details';
      case DynamicFamilyType.uncles:
        return 'Uncle (Paternal) Details';
    }
  }

  String get _singularLabel {
    switch (widget.type) {
      case DynamicFamilyType.brothers:
        return 'Brother';
      case DynamicFamilyType.sisters:
        return 'Sister';
      case DynamicFamilyType.maternalUncles:
        return 'Maternal Uncle';
      case DynamicFamilyType.uncles:
        return 'Uncle';
    }
  }

  void _save() {
    switch (widget.type) {
      case DynamicFamilyType.brothers:
        final result = <BrotherDetail>[];
        for (int i = 0; i < _count; i++) {
          final name = _brotherControllers[i]['name']!.text.trim();
          final occ = _brotherControllers[i]['occupation']!.text.trim();
          result.add(BrotherDetail(name: name, occupation: occ));
        }
        Navigator.pop(context, result);
        break;

      case DynamicFamilyType.sisters:
        final result = <SisterDetail>[];
        for (int i = 0; i < _count; i++) {
          final name = (_sisterData[i]['name'] as TextEditingController).text.trim();
          final occ = (_sisterData[i]['occupation'] as TextEditingController).text.trim();
          final isMarried = _sisterData[i]['isMarried'] as bool;
          final hName = (_sisterData[i]['husbandName'] as TextEditingController).text.trim();
          final hProf = (_sisterData[i]['husbandProfession'] as TextEditingController).text.trim();
          result.add(SisterDetail(
            name: name,
            occupation: occ,
            isMarried: isMarried,
            husbandName: isMarried ? hName : '',
            husbandProfession: isMarried ? hProf : '',
          ));
        }
        Navigator.pop(context, result);
        break;

      case DynamicFamilyType.maternalUncles:
        final result = <UncleDetail>[];
        for (int i = 0; i < _count; i++) {
          final name = _maternalUncleControllers[i]['name']!.text.trim();
          final occ = _maternalUncleControllers[i]['occupation']!.text.trim();
          result.add(UncleDetail(name: name, occupation: occ));
        }
        Navigator.pop(context, result);
        break;

      case DynamicFamilyType.uncles:
        final result = <UncleDetail>[];
        for (int i = 0; i < _count; i++) {
          final name = _uncleControllers[i]['name']!.text.trim();
          final occ = _uncleControllers[i]['occupation']!.text.trim();
          result.add(UncleDetail(name: name, occupation: occ));
        }
        Navigator.pop(context, result);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(maxHeight: screenHeight * 0.88),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
        bottom: bottomInset + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(height: 16),

          // Question: How many?
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7F9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFDDE5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How many ${_singularLabel.toLowerCase()}s do you have?',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Quick chips 0, 1, 2, 3, 4
                    for (int c = 0; c <= 4; c++)
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ChoiceChip(
                          label: Text('$c'),
                          selected: _count == c,
                          selectedColor: const Color(0xFFC9003F),
                          labelStyle: TextStyle(
                            color: _count == c ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          onSelected: (selected) {
                            if (selected) _setCount(c);
                          },
                        ),
                      ),
                    const Spacer(),
                    // Stepper buttons for 5+
                    InkWell(
                      onTap: _count > 0 ? () => _setCount(_count - 1) : null,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: _count > 0 ? Colors.grey.shade200 : Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.remove,
                          size: 18,
                          color: _count > 0 ? Colors.black87 : Colors.grey,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '$_count',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFC9003F),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: _count < 15 ? () => _setCount(_count + 1) : null,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: _count < 15 ? Colors.grey.shade200 : Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add,
                          size: 18,
                          color: _count < 15 ? Colors.black87 : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Dynamic Cards List
          Flexible(
            child: _count == 0
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.people_outline, size: 48, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          Text(
                            'No ${_singularLabel.toLowerCase()}s specified.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Select 1 or more above to add details.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _count,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _buildItemCard(index);
                    },
                  ),
          ),
          const SizedBox(height: 16),

          // Save button
          ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC9003F),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              'Save $_title',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(int index) {
    final number = index + 1;

    switch (widget.type) {
      case DynamicFamilyType.brothers:
        return _buildBrotherCard(index, number);
      case DynamicFamilyType.sisters:
        return _buildSisterCard(index, number);
      case DynamicFamilyType.maternalUncles:
        return _buildMaternalUncleCard(index, number);
      case DynamicFamilyType.uncles:
        return _buildUncleCard(index, number);
    }
  }

  Widget _buildBrotherCard(int index, int number) {
    final controllers = _brotherControllers[index];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Color(0xFFC9003F),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$number',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Brother $number',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controllers['name'],
            decoration: InputDecoration(
              labelText: 'Brother $number Name',
              hintText: 'Enter name',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: controllers['occupation'],
            decoration: InputDecoration(
              labelText: 'Brother $number Occupation',
              hintText: 'Enter occupation (e.g. Software Engineer)',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSisterCard(int index, int number) {
    final data = _sisterData[index];
    final isMarried = data['isMarried'] as bool;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Color(0xFFC9003F),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$number',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Sister $number',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: data['name'] as TextEditingController,
            decoration: InputDecoration(
              labelText: 'Sister $number Name',
              hintText: 'Enter name',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: data['occupation'] as TextEditingController,
            decoration: InputDecoration(
              labelText: 'Sister $number Occupation',
              hintText: 'Enter occupation',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
          const SizedBox(height: 10),

          // Married status row
          Row(
            children: [
              const Text(
                'Married?',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 16),
              ChoiceChip(
                label: const Text('Yes'),
                selected: isMarried,
                selectedColor: const Color(0xFFC9003F),
                labelStyle: TextStyle(
                  color: isMarried ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                onSelected: (val) {
                  if (val) {
                    setState(() {
                      data['isMarried'] = true;
                    });
                  }
                },
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('No'),
                selected: !isMarried,
                selectedColor: const Color(0xFFC9003F),
                labelStyle: TextStyle(
                  color: !isMarried ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                onSelected: (val) {
                  if (val) {
                    setState(() {
                      data['isMarried'] = false;
                    });
                  }
                },
              ),
            ],
          ),

          // If married == true, dynamically show husband fields
          if (isMarried) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7F9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFFDDE5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Husband Details",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFC9003F),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: data['husbandName'] as TextEditingController,
                    decoration: InputDecoration(
                      labelText: "Husband's Name",
                      hintText: "Enter husband's name",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      isDense: true,
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: data['husbandProfession'] as TextEditingController,
                    decoration: InputDecoration(
                      labelText: "Husband's Profession",
                      hintText: "Enter husband's profession",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      isDense: true,
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMaternalUncleCard(int index, int number) {
    final controllers = _maternalUncleControllers[index];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Color(0xFFC9003F),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$number',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Maternal Uncle $number',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controllers['name'],
            decoration: InputDecoration(
              labelText: 'Maternal Uncle $number Name',
              hintText: 'Enter name',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: controllers['occupation'],
            decoration: InputDecoration(
              labelText: 'Maternal Uncle $number Occupation',
              hintText: 'Enter occupation',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUncleCard(int index, int number) {
    final controllers = _uncleControllers[index];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Color(0xFFC9003F),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$number',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Uncle $number',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controllers['name'],
            decoration: InputDecoration(
              labelText: 'Uncle $number Name',
              hintText: 'Enter name',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: controllers['occupation'],
            decoration: InputDecoration(
              labelText: 'Uncle $number Occupation',
              hintText: 'Enter occupation',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
