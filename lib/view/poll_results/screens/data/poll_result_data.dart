import 'package:menu_minder/view/meal_plan/screens/data/get_all_meal_plan_model.dart';

class SinglePollResult {
  int? status;
  String? message;
  List<Data>? data;

  SinglePollResult({this.status, this.message, this.data});

  SinglePollResult.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? userId;
  String? title;
  String? startTime;
  RecipeModel? recipeModel;
  String? endTime;
  List<String>? familyMembers;
  List<PollButton>? button;
  int? isDelete;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.sId,
      this.userId,
      this.title,
      this.startTime,
      this.endTime,
      this.familyMembers,
      this.button,
      this.isDelete,
      this.recipeModel,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    title = json['title'];
    //TODO: NEED RECIPIE ID HERE
    recipeModel = json['recipe_id'] != null
        ? RecipeModel.fromJson(json['recipe_id'])
        : null;
    startTime = json['start_time'];
    endTime = json['end_time'];
    familyMembers = json['family_members'].cast<String>();
    if (json['button'] != null) {
      button = <PollButton>[];
      json['button'].forEach((v) {
        button!.add(PollButton.fromJson(v));
      });
    }
    isDelete = json['is_delete'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user_id'] = userId;
    data['title'] = title;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['family_members'] = familyMembers;
    if (button != null) {
      data['button'] = button!.map((v) => v.toJson()).toList();
    }
    data['is_delete'] = isDelete;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class PollButton {
  String? sId;
  String? text;
  List<Voters>? voters;

  PollButton({this.sId, this.text, this.voters});

  PollButton.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    text = json['text'];
    if (json['voters'] != null) {
      voters = <Voters>[];
      json['voters'].forEach((v) {
        voters!.add(Voters.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['text'] = text;
    if (voters != null) {
      data['voters'] = voters!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Voters {
  String? sId;
  String? userId;
  String? poleId;
  String? buttonId;
  String? createdAt;
  String? updatedAt;
  String? suggestion;
  String? suggestionStatus;
  AnotherSuggestion? anotherSuggestion;
 // String? anotherSuggestion;
  FinalRecipe? finalRecipe;
  int? iV;
  UserData? userData;

  Voters(
      {this.sId,
      this.userId,
      this.poleId,
      this.buttonId,
      this.createdAt,
      this.updatedAt,
      this.suggestion,
      this.iV,
        this.finalRecipe,
      this.userData});

  Voters.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    poleId = json['pole_id'];
    buttonId = json['button_id'];
   // anotherSuggestion = json['another_suggestion'];
    suggestionStatus = json['suggestion_status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    suggestion = json['suggestion'];
    anotherSuggestion = json['another_suggestion'] != null
        ? new AnotherSuggestion.fromJson(json['another_suggestion'])
        : null;
    finalRecipe = json['final_recipe'] != null
        ? new FinalRecipe.fromJson(json['final_recipe'])
        : null;
    iV = json['__v'];
    userData =
        json['user_data'] != null ? UserData.fromJson(json['user_data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user_id'] = userId;
    data['pole_id'] = poleId;
    data['button_id'] = buttonId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    if (this.anotherSuggestion != null) {
      data['another_suggestion'] = this.anotherSuggestion!.toJson();
    }
    if (this.finalRecipe != null) {
      data['final_recipe'] = this.finalRecipe!.toJson();
    }
    if (userData != null) {
      data['user_data'] = userData!.toJson();
    }
    return data;
  }
}

class AnotherSuggestion {
  String? sId;
  String? title;
  int? servingSize;
  List<String>? recipeImages;
  String? discription;
  String? type;
  String? preference;
  List<Map<String, String>>? adminIngredients;
  String? instruction;
  int? isDelete;
  int? isSpooncular;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? description;

  AnotherSuggestion(
      {this.sId,
        this.title,
        this.servingSize,
        this.recipeImages,
        this.discription,
        this.type,
        this.preference,
        this.adminIngredients,
        this.instruction,
        this.isDelete,
        this.isSpooncular,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.description});

  AnotherSuggestion.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    servingSize = json['serving_size'];
    recipeImages = json['recipe_images'].cast<String>();
    discription = json['discription'];
    type = json['type'];
    preference = json['preference'];
    if (json['ingredients'] != null) {
      adminIngredients = [];
      json['ingredients'].forEach((v) {
        adminIngredients!.add(Map<String, String>.from(v));
      });
    }
    instruction = json['instruction'];
    isDelete = json['is_delete'];
    isSpooncular = json['is_spooncular'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['serving_size'] = this.servingSize;
    data['recipe_images'] = this.recipeImages;
    data['discription'] = this.discription;
    data['type'] = this.type;
    data['preference'] = this.preference;
    if (adminIngredients != null) {
      data['ingredients'] = adminIngredients!.map((v) => v).toList();
    }
    data['instruction'] = this.instruction;
    data['is_delete'] = this.isDelete;
    data['is_spooncular'] = this.isSpooncular;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['description'] = this.description;
    return data;
  }
}

class AdminIngredients {
  String? fusilliPasta;
  String? swissChard;
  String? unsaltedButter;
  String? allPurposeFlour;
  String? evaporatedMilk;
  String? onionPowder;
  String? kosherSalt;
  String? crushedRedPepper;
  String? partSkimMozzarellaCheeseShredded;
  String? parmesanCheeseGrated;

  AdminIngredients(
      {this.fusilliPasta,
        this.swissChard,
        this.unsaltedButter,
        this.allPurposeFlour,
        this.evaporatedMilk,
        this.onionPowder,
        this.kosherSalt,
        this.crushedRedPepper,
        this.partSkimMozzarellaCheeseShredded,
        this.parmesanCheeseGrated});

  AdminIngredients.fromJson(Map<String, dynamic> json) {
    fusilliPasta = json['fusilli pasta'];
    swissChard = json['Swiss chard'];
    unsaltedButter = json['unsalted butter'];
    allPurposeFlour = json['all-purpose flour'];
    evaporatedMilk = json['evaporated milk'];
    onionPowder = json['onion powder'];
    kosherSalt = json['kosher salt'];
    crushedRedPepper = json['crushed red pepper'];
    partSkimMozzarellaCheeseShredded =
    json['part-skim mozzarella cheese, shredded'];
    parmesanCheeseGrated = json['Parmesan cheese, grated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fusilli pasta'] = this.fusilliPasta;
    data['Swiss chard'] = this.swissChard;
    data['unsalted butter'] = this.unsaltedButter;
    data['all-purpose flour'] = this.allPurposeFlour;
    data['evaporated milk'] = this.evaporatedMilk;
    data['onion powder'] = this.onionPowder;
    data['kosher salt'] = this.kosherSalt;
    data['crushed red pepper'] = this.crushedRedPepper;
    data['part-skim mozzarella cheese, shredded'] =
        this.partSkimMozzarellaCheeseShredded;
    data['Parmesan cheese, grated'] = this.parmesanCheeseGrated;
    return data;
  }
}


class FinalRecipe {
  bool? vegetarian;
  bool? vegan;
  bool? glutenFree;
  bool? dairyFree;
  bool? veryHealthy;
  bool? cheap;
  bool? veryPopular;
  bool? sustainable;
  bool? lowFodmap;
  int? weightWatcherSmartPoints;
  String? gaps;
  dynamic preparationMinutes;
  dynamic cookingMinutes;
  int? aggregateLikes;
  int? healthScore;
  String? creditsText;
 // String? license;
  String? sourceName;
  double? pricePerServing;
  List<ExtendedIngredients>? extendedIngredients;
  int? id;
  String? title;
  int? readyInMinutes;
  int? servings;
  String? sourceUrl;
  String? image;
  String? imageType;
  String? summary;
  List<String>? cuisines;
  List<String>? dishTypes;
  List<String>? diets;
 // List<Null>? occasions;
  String? instructions;
  List<AnalyzedInstructions>? analyzedInstructions;
 // Null? originalId;
  double? spoonacularScore;
  String? spoonacularSourceUrl;

  FinalRecipe(
      {this.vegetarian,
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
      //  this.license,
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
       // this.occasions,
        this.instructions,
        this.analyzedInstructions,
       // this.originalId,
        this.spoonacularScore,
        this.spoonacularSourceUrl});

  FinalRecipe.fromJson(Map<String, dynamic> json) {
    vegetarian = json['vegetarian'];
    vegan = json['vegan'];
    glutenFree = json['glutenFree'];
    dairyFree = json['dairyFree'];
    veryHealthy = json['veryHealthy'];
    cheap = json['cheap'];
    veryPopular = json['veryPopular'];
    sustainable = json['sustainable'];
    lowFodmap = json['lowFodmap'];
    weightWatcherSmartPoints = json['weightWatcherSmartPoints'];
    gaps = json['gaps'];
    preparationMinutes = json['preparationMinutes'];
    cookingMinutes = json['cookingMinutes'];
    aggregateLikes = json['aggregateLikes'];
    healthScore = json['healthScore'];
    creditsText = json['creditsText'];
    //license = json['license'];
    sourceName = json['sourceName'];
    pricePerServing = json['pricePerServing'];
    if (json['extendedIngredients'] != null) {
      extendedIngredients = <ExtendedIngredients>[];
      json['extendedIngredients'].forEach((v) {
        extendedIngredients!.add(new ExtendedIngredients.fromJson(v));
      });
    }
    id = json['id'];
    title = json['title'];
    readyInMinutes = json['readyInMinutes'];
    servings = json['servings'];
    sourceUrl = json['sourceUrl'];
    image = json['image'];
    imageType = json['imageType'];
    summary = json['summary'];
    cuisines = json['cuisines'].cast<String>();
    dishTypes = json['dishTypes'].cast<String>();
    diets = json['diets'].cast<String>();
    // if (json['occasions'] != null) {
    //   occasions = <Null>[];
    //   json['occasions'].forEach((v) {
    //     occasions!.add(new Null.fromJson(v));
    //   });
    // }
    instructions = json['instructions'];
    if (json['analyzedInstructions'] != null) {
      analyzedInstructions = <AnalyzedInstructions>[];
      json['analyzedInstructions'].forEach((v) {
        analyzedInstructions!.add(new AnalyzedInstructions.fromJson(v));
      });
    }
   // originalId = json['originalId'];
    spoonacularScore = json['spoonacularScore'];
    spoonacularSourceUrl = json['spoonacularSourceUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vegetarian'] = this.vegetarian;
    data['vegan'] = this.vegan;
    data['glutenFree'] = this.glutenFree;
    data['dairyFree'] = this.dairyFree;
    data['veryHealthy'] = this.veryHealthy;
    data['cheap'] = this.cheap;
    data['veryPopular'] = this.veryPopular;
    data['sustainable'] = this.sustainable;
    data['lowFodmap'] = this.lowFodmap;
    data['weightWatcherSmartPoints'] = this.weightWatcherSmartPoints;
    data['gaps'] = this.gaps;
    data['preparationMinutes'] = this.preparationMinutes;
    data['cookingMinutes'] = this.cookingMinutes;
    data['aggregateLikes'] = this.aggregateLikes;
    data['healthScore'] = this.healthScore;
    data['creditsText'] = this.creditsText;
    //data['license'] = this.license;
    data['sourceName'] = this.sourceName;
    data['pricePerServing'] = this.pricePerServing;
    if (this.extendedIngredients != null) {
      data['extendedIngredients'] =
          this.extendedIngredients!.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    data['title'] = this.title;
    data['readyInMinutes'] = this.readyInMinutes;
    data['servings'] = this.servings;
    data['sourceUrl'] = this.sourceUrl;
    data['image'] = this.image;
    data['imageType'] = this.imageType;
    data['summary'] = this.summary;
    data['cuisines'] = this.cuisines;
    data['dishTypes'] = this.dishTypes;
    data['diets'] = this.diets;
    // if (this.occasions != null) {
    //   data['occasions'] = this.occasions!.map((v) => v.toJson()).toList();
    // }
    data['instructions'] = this.instructions;
    if (this.analyzedInstructions != null) {
      data['analyzedInstructions'] =
          this.analyzedInstructions!.map((v) => v.toJson()).toList();
    }
   // data['originalId'] = this.originalId;
    data['spoonacularScore'] = this.spoonacularScore;
    data['spoonacularSourceUrl'] = this.spoonacularSourceUrl;
    return data;
  }
}

class ExtendedIngredients {
  int? id;
  String? aisle;
  String? image;
  String? consistency;
  String? name;
  String? nameClean;
  String? original;
  String? originalName;
  dynamic amount;
  String? unit;
  List<String>? meta;
  Measures? measures;

  ExtendedIngredients(
      {this.id,
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
        this.measures});

  ExtendedIngredients.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    aisle = json['aisle'];
    image = json['image'];
    consistency = json['consistency'];
    name = json['name'];
    nameClean = json['nameClean'];
    original = json['original'];
    originalName = json['originalName'];
    amount = json['amount'];
    unit = json['unit'];
    meta = json['meta'].cast<String>();
    measures = json['measures'] != null
        ? new Measures.fromJson(json['measures'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['aisle'] = this.aisle;
    data['image'] = this.image;
    data['consistency'] = this.consistency;
    data['name'] = this.name;
    data['nameClean'] = this.nameClean;
    data['original'] = this.original;
    data['originalName'] = this.originalName;
    data['amount'] = this.amount;
    data['unit'] = this.unit;
    data['meta'] = this.meta;
    if (this.measures != null) {
      data['measures'] = this.measures!.toJson();
    }
    return data;
  }
}

class Measures {
  Us? us;
  Us? metric;

  Measures({this.us, this.metric});

  Measures.fromJson(Map<String, dynamic> json) {
    us = json['us'] != null ? new Us.fromJson(json['us']) : null;
    metric = json['metric'] != null ? new Us.fromJson(json['metric']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.us != null) {
      data['us'] = this.us!.toJson();
    }
    if (this.metric != null) {
      data['metric'] = this.metric!.toJson();
    }
    return data;
  }
}

class Us {
  dynamic amount;
  String? unitShort;
  String? unitLong;

  Us({this.amount, this.unitShort, this.unitLong});

  Us.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    unitShort = json['unitShort'];
    unitLong = json['unitLong'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['unitShort'] = this.unitShort;
    data['unitLong'] = this.unitLong;
    return data;
  }
}

class AnalyzedInstructions {
  String? name;
  List<Steps>? steps;

  AnalyzedInstructions({this.name, this.steps});

  AnalyzedInstructions.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['steps'] != null) {
      steps = <Steps>[];
      json['steps'].forEach((v) {
        steps!.add(new Steps.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.steps != null) {
      data['steps'] = this.steps!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Steps {
  int? number;
  String? step;
  List<Ingredients>? ingredients;
 // List<Equipment>? equipment;

  Steps({this.number, this.step, this.ingredients});

  Steps.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    step = json['step'];
    if (json['ingredients'] != null) {
      ingredients = <Ingredients>[];
      json['ingredients'].forEach((v) {
        ingredients!.add(new Ingredients.fromJson(v));
      });
    }
    // if (json['equipment'] != null) {
    //   equipment = <Equipment>[];
    //   json['equipment'].forEach((v) {
    //     equipment!.add(new Equipment.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    data['step'] = this.step;
    if (this.ingredients != null) {
      data['ingredients'] = this.ingredients!.map((v) => v.toJson()).toList();
    }
    // if (this.equipment != null) {
    //   data['equipment'] = this.equipment!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Ingredients {
  int? id;
  String? name;
  String? localizedName;
  String? image;

  Ingredients({this.id, this.name, this.localizedName, this.image});

  Ingredients.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    localizedName = json['localizedName'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['localizedName'] = this.localizedName;
    data['image'] = this.image;
    return data;
  }
}

class UserData {
  String? sId;
  String? userName;
  String? userImage;

  UserData({this.sId, this.userName, this.userImage});

  UserData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userName = json['user_name'];
    userImage = json['user_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user_name'] = userName;
    data['user_image'] = userImage;
    return data;
  }
}
