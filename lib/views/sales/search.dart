import 'package:flutter/material.dart';
import '../messages/widgets/widgets.dart';

// Search Features
class Search extends StatelessWidget {
  /// Toggle the boolean that enables the All button.
  final Function setTagString;

  /// Tells the all button whether to enable (currently searching by tag) or
  /// disable (currently searching by all).
  final bool sortByRelevance;

  /// Toggles the tag search to off and then performs a search for all sales.
  final Function showAllSales;

  /// Toggle the boolean that changes the text for the newest oldest search.
  final Function toggleSortByDate;

  /// Boolean used to update the newest button to oldest so that the user can
  /// change the search criteria.
  final bool sortByNewest;

  /// Sets the toggle to sort the relevant search by price.
  final Function toggleSortByPrice;

  /// Boolean used to update the price button text so that the user can see the
  /// change in criteria.
  final bool sortByPrice;

  const Search(
      {Key? key,
      required this.setTagString,
      required this.sortByRelevance,
      required this.showAllSales,
      required this.toggleSortByDate,
      required this.sortByNewest,
      required this.toggleSortByPrice,
      required this.sortByPrice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String tag = '';

    Widget newestButton = customButton(
        sortByNewest ? 'Oldest' : 'Newest', context, toggleSortByDate);
    Widget priceButton = customButton(
        sortByPrice ? 'Price Highest' : 'Price lowest',
        context,
        toggleSortByPrice);
    Widget allButton =
        customAllButton('All', sortByRelevance, context, showAllSales);

    return Column(children: [
      Expanded(
          flex: 2,
          child: buttonRow(newestButton, allButton, priceButton, context)),
      Expanded(
          flex: 8,
          child: Form(
              key: formKey,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingSides(context),
                            vertical: paddingTopAndBottom(context)),
                        child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 2),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 2,
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(29),
                            ),
                            width: 350,
                            child: TextFormField(
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    filled: false,
                                    labelText: 'Search',
                                    labelStyle: const TextStyle(fontSize: 17),
                                    suffixIcon: IconButton(
                                        icon: const Icon(Icons.search),
                                        color: Theme.of(context).primaryColor,
                                        onPressed: () async {
                                          if (formKey.currentState!
                                              .validate()) {
                                            formKey.currentState!.save();
                                            setTagString(tag);
                                            formKey.currentState?.reset();
                                          }
                                        })),
                                maxLines: 3,
                                minLines: 1,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.text,
                                onSaved: (value) {
                                  tag = value!;
                                },
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value == '') {
                                    return 'Please enter a message';
                                  } else {
                                    return null;
                                  }
                                })))
                  ])))
    ]);
  }
}

Widget customButton(String label, BuildContext context, Function func) {
  /// Creates a button with [label] and specified function.
  
  final MaterialStateProperty<Color> buttonColor =
      MaterialStateProperty.all(Theme.of(context).primaryColor);

  return Semantics(
        child: (ElevatedButton(
          onPressed: () {
            func();
          },
          child: Text(label),
          style: ButtonStyle(backgroundColor: buttonColor))),
        button: true
  );
}

Widget customAllButton(
    String label, bool isEnabled, BuildContext context, Function func) {
  /// Creates a button with [label] and specified function.
  final MaterialStateProperty<Color> buttonColor =
      MaterialStateProperty.all(Theme.of(context).primaryColor);
  final MaterialStateProperty<Color> offColor =
      MaterialStateProperty.all(Colors.grey);

  return Semantics(
    child: (ElevatedButton(
        onPressed: () {
          isEnabled ? func() : null;
        },
        child: Text(label),
        style: ButtonStyle(
          backgroundColor: isEnabled ? buttonColor : offColor,
        ))),
    button: true,
    onTapHint: "Searches for all current sales."
               "If inactive, already on All search."
  );
}

Widget buttonRow(
    Widget button1, Widget button2, Widget button3, BuildContext context) {
  /// Adds three search buttons to the top of the search button.
  return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(flex: 1),
        button1, // Sort by newest or oldest.
        const Spacer(flex: 1),
        button2, // Sort by All or closest match.
        const Spacer(flex: 1),
        button3, // Sort by Highest and lowest price.
        const Spacer(flex: 1)
      ]);
}
