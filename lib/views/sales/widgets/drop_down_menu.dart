import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class DropDownMenu extends StatefulWidget {
  const DropDownMenu({Key? key, required this.mode}) : super(key: key);
  final String mode;

  @override
  State<DropDownMenu> createState() => _DropDownMenuState();
}

class _DropDownMenuState extends State<DropDownMenu> {
  List<String> items = [];
  String? selectedValue;
  List<String> conditions = ['Excellent', 'Good', 'Fair', 'Poor'];
  List<String> categories = [
    'antiques',
    'appliances',
    'arts+crafts',
    'auto parts',
    'aviation',
    'baby+kid',
    'barter',
    'beauty & health',
    'bike parts',
    'bikes',
    'boat parts',
    'boats',
    'books',
    'business',
    'cars & trucks',
    'cds/dvd/vhs',
    'cell phones',
    'clothes+acc',
    'collectibles',
    'computer parts',
    'computers',
    'electronics',
    'farm+garden',
    'free',
    'furniture',
    'garage sale',
    'general',
    'heavy equip',
    'household',
    'jewelry',
    'materials',
    'motorcycle parts',
    'motorcycles',
    'musical instruments',
    'photo+video',
    'rvs & camp',
    'sporting',
    'tickets',
    'tools',
    'toys+games',
    'trailers',
    'video gaming',
    'wheels+tires'
  ];
  @override
  void initState() {
    widget.mode == 'Category'
        ? setState(() {
            items = categories;
          })
        : setState(() {
            items = conditions;
          });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          isExpanded: true,
          hint: Row(
            children: [
              Expanded(
                child: Text(
                  widget.mode,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          value: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value as String;
            });
          },
          icon: const Icon(
            Icons.arrow_downward_rounded,
          ),
          iconSize: 24,
          iconEnabledColor: Color(0xffA682FF),
          buttonHeight: 62,
          buttonWidth: 160,
          buttonPadding: const EdgeInsets.only(left: 14, right: 14),
          buttonDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(29),
            border: Border.all(color: Color(0xffA682FF), width: 2),
          ),
          buttonElevation: 0,
          itemHeight: 40,
          itemPadding: const EdgeInsets.only(left: 14, right: 14),
          dropdownMaxHeight: MediaQuery.of(context).size.height * 0.8,
          dropdownWidth: MediaQuery.of(context).size.width * 0.8,
          dropdownPadding: const EdgeInsets.only(left: 8),
          dropdownDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(29),
            color: Colors.white,
          ),
          dropdownElevation: 8,
          scrollbarRadius: const Radius.circular(40),
          scrollbarThickness: 6,
          scrollbarAlwaysShow: true,
          offset: const Offset(-20, 0),
        ),
      ),
    );
  }
}
