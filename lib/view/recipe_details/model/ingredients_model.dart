import 'package:menu_minder/utils/dummy.dart';

class Ingredients {
  final String heading;
  final List<String> ingredients;

  Ingredients(this.heading, this.ingredients);
}

List<Ingredients> ingredientsList = [
  Ingredients("Lorem Ipsum", [
    "Duis aute irure dolor reprehenderit",
    "Duis aute irure dolor reprehenderit",
    "Duis aute irure dolor reprehenderit",
    "Duis aute irure dolor reprehenderit",
    "Duis aute irure dolor reprehenderit",
  ]),
  Ingredients("Lorem Ipsum", [
    "Duis aute irure dolor reprehenderit",
    "Duis aute irure dolor reprehenderit",
    "Duis aute irure dolor reprehenderit",
    "Duis aute irure dolor reprehenderit",
    "Duis aute irure dolor reprehenderit Duis aute irure dolor reprehenderit",
  ]),
];

List<Ingredients> instructionsList = [
  Ingredients("Step 01", [
    longText,
  ]),
  Ingredients("Step 02", [longText]),
  Ingredients("Step 03", [longText]),
  Ingredients("Step 04", [longText]),
  Ingredients("Step 05", [longText]),
  Ingredients("Step 06", [longText]),
];
