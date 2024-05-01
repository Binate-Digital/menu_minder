class SpooncularRecipies {
  final List<Recipes>? recipes;

  SpooncularRecipies({
    this.recipes,
  });

  SpooncularRecipies.fromJson(Map<String, dynamic> json)
      : recipes = (json['recipes'] as List?)
            ?.map((dynamic e) => Recipes.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() =>
      {'recipes': recipes?.map((e) => e.toJson()).toList()};
}

class Recipes {
  final bool? vegetarian;
  final bool? vegan;
  final bool? glutenFree;
  final bool? dairyFree;
  final bool? veryHealthy;
  final bool? cheap;
  final bool? veryPopular;
  final bool? sustainable;
  final bool? lowFodmap;
  final int? weightWatcherSmartPoints;
  final String? gaps;
  final int? preparationMinutes;
  final int? cookingMinutes;
  final int? aggregateLikes;
  final int? healthScore;
  final String? creditsText;
  final String? license;
  final String? sourceName;
  final double? pricePerServing;
  final List<ExtendedIngredients>? extendedIngredients;
  final int? id;
  final String? title;
  final int? readyInMinutes;
  final int? servings;
  final String? sourceUrl;
  final String? image;
  final String? imageType;
  final String? summary;
  final List<dynamic>? cuisines;
  final List<String>? dishTypes;
  final List<String>? diets;
  final List<dynamic>? occasions;
  final String? instructions;
  final List<AnalyzedInstructions>? analyzedInstructions;
  final dynamic originalId;
  final double? spoonacularScore;
  final String? spoonacularSourceUrl;

  Recipes({
    this.vegetarian,
    this.vegan,
    this.glutenFree,
    this.dairyFree,
    this.veryHealthy,
    this.cheap,
    this.veryPopular,
    this.sustainable,
    this.lowFodmap,
    this.weightWatcherSmartPoints,
    this.gaps,
    this.preparationMinutes,
    this.cookingMinutes,
    this.aggregateLikes,
    this.healthScore,
    this.creditsText,
    this.license,
    this.sourceName,
    this.pricePerServing,
    this.extendedIngredients,
    this.id,
    this.title,
    this.readyInMinutes,
    this.servings,
    this.sourceUrl,
    this.image,
    this.imageType,
    this.summary,
    this.cuisines,
    this.dishTypes,
    this.diets,
    this.occasions,
    this.instructions,
    this.analyzedInstructions,
    this.originalId,
    this.spoonacularScore,
    this.spoonacularSourceUrl,
  });

  Recipes.fromJson(Map<String, dynamic> json)
      : vegetarian = json['vegetarian'] as bool?,
        vegan = json['vegan'] as bool?,
        glutenFree = json['glutenFree'] as bool?,
        dairyFree = json['dairyFree'] as bool?,
        veryHealthy = json['veryHealthy'] as bool?,
        cheap = json['cheap'] as bool?,
        veryPopular = json['veryPopular'] as bool?,
        sustainable = json['sustainable'] as bool?,
        lowFodmap = json['lowFodmap'] as bool?,
        weightWatcherSmartPoints = json['weightWatcherSmartPoints'] as int?,
        gaps = json['gaps'] as String?,
        preparationMinutes = json['preparationMinutes'] as int?,
        cookingMinutes = json['cookingMinutes'] as int?,
        aggregateLikes = json['aggregateLikes'] as int?,
        healthScore = json['healthScore'] as int?,
        creditsText = json['creditsText'] as String?,
        license = json['license'] as String?,
        sourceName = json['sourceName'] as String?,
        pricePerServing = json['pricePerServing'] as double?,
        extendedIngredients = (json['extendedIngredients'] as List?)
            ?.map((dynamic e) =>
                ExtendedIngredients.fromJson(e as Map<String, dynamic>))
            .toList(),
        id = json['id'] as int?,
        title = json['title'] as String?,
        readyInMinutes = json['readyInMinutes'] as int?,
        servings = json['servings'] as int?,
        sourceUrl = json['sourceUrl'] as String?,
        image = json['image'] as String?,
        imageType = json['imageType'] as String?,
        summary = json['summary'] as String?,
        cuisines = json['cuisines'] as List?,
        dishTypes = (json['dishTypes'] as List?)
            ?.map((dynamic e) => e as String)
            .toList(),
        diets =
            (json['diets'] as List?)?.map((dynamic e) => e as String).toList(),
        occasions = json['occasions'] as List?,
        instructions = json['instructions'] as String?,
        analyzedInstructions = (json['analyzedInstructions'] as List?)
            ?.map((dynamic e) =>
                AnalyzedInstructions.fromJson(e as Map<String, dynamic>))
            .toList(),
        originalId = json['originalId'],
        spoonacularScore = json['spoonacularScore'] as double?,
        spoonacularSourceUrl = json['spoonacularSourceUrl'] as String?;

  Map<String, dynamic> toJson() => {
        'vegetarian': vegetarian,
        'vegan': vegan,
        'glutenFree': glutenFree,
        'dairyFree': dairyFree,
        'veryHealthy': veryHealthy,
        'cheap': cheap,
        'veryPopular': veryPopular,
        'sustainable': sustainable,
        'lowFodmap': lowFodmap,
        'weightWatcherSmartPoints': weightWatcherSmartPoints,
        'gaps': gaps,
        'preparationMinutes': preparationMinutes,
        'cookingMinutes': cookingMinutes,
        'aggregateLikes': aggregateLikes,
        'healthScore': healthScore,
        'creditsText': creditsText,
        'license': license,
        'sourceName': sourceName,
        'pricePerServing': pricePerServing,
        'extendedIngredients':
            extendedIngredients?.map((e) => e.toJson()).toList(),
        'id': id,
        'title': title,
        'readyInMinutes': readyInMinutes,
        'servings': servings,
        'sourceUrl': sourceUrl,
        'image': image,
        'imageType': imageType,
        'summary': summary,
        'cuisines': cuisines,
        'dishTypes': dishTypes,
        'diets': diets,
        'occasions': occasions,
        'instructions': instructions,
        'analyzedInstructions':
            analyzedInstructions?.map((e) => e.toJson()).toList(),
        'originalId': originalId,
        'spoonacularScore': spoonacularScore,
        'spoonacularSourceUrl': spoonacularSourceUrl
      };
}

class ExtendedIngredients {
  final int? id;
  final String? aisle;
  final String? image;
  final String? consistency;
  final String? name;
  final String? nameClean;
  final String? original;
  final String? originalName;
  final dynamic amount;
  final String? unit;
  final List<String>? meta;
  final Measures? measures;

  ExtendedIngredients({
    this.id,
    this.aisle,
    this.image,
    this.consistency,
    this.name,
    this.nameClean,
    this.original,
    this.originalName,
    this.amount,
    this.unit,
    this.meta,
    this.measures,
  });

  ExtendedIngredients.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        aisle = json['aisle'] as String?,
        image = json['image'] as String?,
        consistency = json['consistency'] as String?,
        name = json['name'] as String?,
        nameClean = json['nameClean'] as String?,
        original = json['original'] as String?,
        originalName = json['originalName'] as String?,
        amount = json['amount'],
        unit = json['unit'] as String?,
        meta =
            (json['meta'] as List?)?.map((dynamic e) => e as String).toList(),
        measures = (json['measures'] as Map<String, dynamic>?) != null
            ? Measures.fromJson(json['measures'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'aisle': aisle,
        'image': image,
        'consistency': consistency,
        'name': name,
        'nameClean': nameClean,
        'original': original,
        'originalName': originalName,
        'amount': amount,
        'unit': unit,
        'meta': meta,
        'measures': measures?.toJson()
      };
}

class Measures {
  final Us? us;
  final Metric? metric;

  Measures({
    this.us,
    this.metric,
  });

  Measures.fromJson(Map<String, dynamic> json)
      : us = (json['us'] as Map<String, dynamic>?) != null
            ? Us.fromJson(json['us'] as Map<String, dynamic>)
            : null,
        metric = (json['metric'] as Map<String, dynamic>?) != null
            ? Metric.fromJson(json['metric'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() =>
      {'us': us?.toJson(), 'metric': metric?.toJson()};
}

class Us {
  final dynamic? amount;
  final String? unitShort;
  final String? unitLong;

  Us({
    this.amount,
    this.unitShort,
    this.unitLong,
  });

  Us.fromJson(Map<String, dynamic> json)
      : amount = json['amount'],
        unitShort = json['unitShort'] as String?,
        unitLong = json['unitLong'] as String?;

  Map<String, dynamic> toJson() =>
      {'amount': amount, 'unitShort': unitShort, 'unitLong': unitLong};
}

class Metric {
  final dynamic amount;
  final String? unitShort;
  final String? unitLong;

  Metric({
    this.amount,
    this.unitShort,
    this.unitLong,
  });

  Metric.fromJson(Map<String, dynamic> json)
      : amount = json['amount'],
        unitShort = json['unitShort'] as String?,
        unitLong = json['unitLong'] as String?;

  Map<String, dynamic> toJson() =>
      {'amount': amount, 'unitShort': unitShort, 'unitLong': unitLong};
}

class AnalyzedInstructions {
  final String? name;
  final List<Steps>? steps;

  AnalyzedInstructions({
    this.name,
    this.steps,
  });

  AnalyzedInstructions.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String?,
        steps = (json['steps'] as List?)
            ?.map((dynamic e) => Steps.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() =>
      {'name': name, 'steps': steps?.map((e) => e.toJson()).toList()};
}

class Steps {
  final int? number;
  final String? step;
  final List<Ingredients>? ingredients;
  final List<dynamic>? equipment;

  Steps({
    this.number,
    this.step,
    this.ingredients,
    this.equipment,
  });

  Steps.fromJson(Map<String, dynamic> json)
      : number = json['number'] as int?,
        step = json['step'] as String?,
        ingredients = (json['ingredients'] as List?)
            ?.map(
                (dynamic e) => Ingredients.fromJson(e as Map<String, dynamic>))
            .toList(),
        equipment = json['equipment'] as List?;

  Map<String, dynamic> toJson() => {
        'number': number,
        'step': step,
        'ingredients': ingredients?.map((e) => e.toJson()).toList(),
        'equipment': equipment
      };
}

class Ingredients {
  final int? id;
  final String? name;
  final String? localizedName;
  final String? image;

  Ingredients({
    this.id,
    this.name,
    this.localizedName,
    this.image,
  });

  Ingredients.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        localizedName = json['localizedName'] as String?,
        image = json['image'] as String?;

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'localizedName': localizedName, 'image': image};
}
