//
//  Allergies.m
//  Allergy Assassin
//
//  Created by Matt Jackson on 28/04/2013.
//  Copyright (c) 2013 Matt Jackson. All rights reserved.
//

#import "Allergies.h"

NSString* const allergiesKey = @"allergies";

@interface Allergies ()

@property NSUserDefaults *defaults;
@property NSMutableArray *allergies;

@end

@implementation Allergies

@synthesize allergies;
@synthesize defaults;


- (id) init {
    return [self initWithAllergies:[NSArray arrayWithObjects:nil]];
}

- (id) initWithAllergies: (NSArray *) providedAllergies {
    self  = [super init];
    defaults = [NSUserDefaults standardUserDefaults];
    allergies = [[NSMutableArray alloc] initWithArray: [self loadAllergies]];
    
    if ([providedAllergies count] > 0) {
        [allergies addObjectsFromArray:providedAllergies];
        [self saveAllergies];
    }
    
    return self;
}

- (NSSet *) getAllergies {
    return [[NSSet alloc] initWithArray:(NSArray *)allergies];
}

- (NSArray *) loadAllergies {
    return [defaults objectForKey:allergiesKey];
}

- (void) saveAllergies {
    [defaults removeObjectForKey:allergiesKey];
    [defaults setObject:(NSArray *)allergies forKey:allergiesKey];
}

- (void) addAllergy:(NSString *)allergy {
    [allergies addObject:allergy];
    [self saveAllergies];
}

- (void) removeAllergy:(NSString *) allergy {
    [allergies removeObject:allergy];
    [self saveAllergies];
}

+ (NSArray *) typicalAllergiesList {
    //TODO: pull from http://api.allergyassassin.com/autocomplete/allergy and store locally
    
    return @[
             @"barley",
             @"egg",
             @"garlic",
             @"gluten",
             @"lime",
             @"milk",
             @"nut",
             @"peanut",
             @"shellfish",
             @"soy",
             @"wheat",
             @"seafood",
             @"dairy",
             @"kidney bean"
        ];
}

+ (NSArray *) recipeList {
    //TODO: pull this from http://api.allergyassassin.com/autocomplete/dish

    return @[@"Acorn Squash Soup", @"Afghans", @"African Peanut Soup", @"Aioli", @"Almond Biscotti", @"Apple Crisp", @"Asparagus Frittata", @"Baby Back Ribs", @"Baked Alaska", @"Baked Spaghetti", @"Baked Sweet Potatoes", @"Banana Bread", @"Banana Crumb Muffins", @"Bean Salad", @"Bearnaise Sauce", @"Beef Stifado", @"Beef Wellington", @"Best Chocolate Chip Cookies", @"Blueberry Coffee Cake", @"Bobotie", @"Boiled Fruit Cake", @"Bread Pudding", @"Butternut Squash Soup", @"Cabbage Rolls", @"Cabbage Salad", @"Caipirinha", @"Cajun Shrimp", @"Cajun Spice Mix", @"Calamari", @"Candied Sweet Potatoes", @"Caramel Sauce", @"Carrot Cake", @"Carrot Soup", @"Cheese Biscuits", @"Cheese Straws", @"Cheesy Potatoes", @"Chewy Chocolate Chip Cookies", @"Chicken Dijon", @"Chicken Jalfrezi", @"Chicken Jambalaya", @"Chicken Korma", @"Chicken Noodle Soup", @"Chicken Parmigiana", @"Chicken Salad", @"Chicken Saltimbocca", @"Chicken Spectacular", @"Chicken Stock", @"Chicken Tikka Masala", @"Chicken Tortilla Soup", @"Chickpea Curry", @"Chocolate Biscuits", @"Chocolate Bread Pudding", @"Chocolate Cheesecake", @"Chocolate Chip Cookies", @"Chocolate Date Squares", @"Chocolate Delight", @"Chocolate Pie", @"Chocolate Pound Cake", @"Chocolate Zucchini Bread", @"Cinnamon Toast", @"Coconut Rice", @"Colcannon", @"Creamy Cheesecake", @"Creamy Chicken Casserole", @"Creamy Tomato Soup", @"Crumpets", @"Cullen Skink", @"Curried Chicken Salad", @"Daiquiri", @"Danish Pastry", @"Dark Chocolate Truffles", @"Date Nut Bread", @"Double Chocolate Biscotti", @"Easter Bunny Cake", @"Easter Pie", @"Easy Chicken Casserole", @"Easy Chicken Curry", @"Easy Chocolate Mousse", @"Easy Chocolate Truffles", @"Easy Peach Cobbler", @"Easy Rice Pudding", @"Easy Tomato Sauce", @"Easy Vanilla Ice Cream", @"Easy Veggie Pizza", @"Eclair Cake", @"Egg Fried Rice", @"Eggs Benedict", @"Enchiladas", @"Feijoada", @"French Onion Soup", @"Fresh Tomato Sauce", @"Fruit Cobbler", @"Fruit Loaf", @"Fruit Muffins", @"Garden Pasta Salad", @"Garden Potato Salad", @"Garlic Aioli", @"Garlic Mayonnaise", @"Gingerbread", @"Gingerbread Men", @"Greek Lamb Stew", @"Green Salad", @"Guacamole", @"Habanero Salsa", @"Habanero Sauce", @"Halushki", @"Ham and Broccoli Quiche", @"Ham and Cheese Crescent Sandwiches", @"Ham and Cheese Croquettes", @"Ham and Cheese Quiche", @"Harira", @"Hearty Beef Stew", @"Honey Cookies", @"Honey Mustard Chicken", @"Hot Artichoke Dip", @"Hot Cross Buns", @"Ice Cream Cake", @"Ice Cream Sandwiches", @"Iced Coffee", @"Iced Pumpkin Cookies", @"Indian Pudding", @"Individual Beef Wellingtons", @"Irish Cream Cheesecake", @"Italian Chicken", @"Jaeger Schnitzel", @"Jalapeno Margaritas", @"Jam Cake", @"Jam Thumbprints", @"Jamaican Beef Patties", @"Jamaican Jerk Chicken", @"Jambalaya", @"Kaiserschmarren", @"Kaiserschmarrn", @"Kale Chips", @"Kale Soup", @"Kalua Pork", @"Kentucky Bourbon Balls", @"Kentucky Burgoo", @"Kentucky Hot Brown", @"Key Lime Pie", @"Ladyfingers", @"Lamb Curry", @"Lamb Tagine", @"Lasagna", @"Lemon Cheesecake", @"Lemon Chicken", @"Lemon Meringue Pie", @"Lemon Souffle", @"Lentil Soup", @"Limoncello", @"Mac and Cheese Soup", @"Macaroni Salad", @"Macaroons", @"Mango Chicken", @"Mexican Dip", @"Moist Carrot Cake", @"Mongolian Beef", @"Moussaka", @"Mushroom Burgers", @"Mushroom Rice Pilaf", @"Naan", @"Naan Bread", @"Natchitoches Meat Pies", @"Navy Bean Soup", @"New York Cheesecake", @"Oatmeal Cookies", @"Oatmeal Lace Cookies", @"Oatmeal Peanut Butter Bars", @"Oatmeal Soda Bread", @"Okra Fritters", @"Okra Salad", @"Okra and Tomatoes", @"Old-Fashioned Potato Salad", @"Olive Bread", @"Onion Rings", @"Orange Salmon", @"Oven-Fried Chicken", @"Pad Thai", @"Paella", @"Palmiers", @"Panzanella", @"Pasta Bake", @"Pasta Carbonara", @"Pastitsio", @"Peanut Butter Cookies", @"Peanut Butter Pie", @"Piccalilli", @"Pizza Muffins", @"Pizza Swirls", @"Profiteroles", @"Pumpkin Cake", @"Pumpkin Puree", @"Queso Fundido", @"Quick Chicken Mole", @"Quick Quiche", @"Quince Jelly", @"Ragu Bolognese", @"Raita", @"Ramos Gin Fizz", @"Ranch Potatoes", @"Red Velvet Cupcakes", @"Roasted Red Pepper Soup", @"Roasted Vegetables", @"Rocky Road", @"Rouladen", @"Royal Icing", @"Saffron Rice", @"Salad Nicoise", @"Salisbury Steak", @"Sausage Casserole", @"Scottish Tablet", @"Seafood Chowder", @"Selkirk Bannock", @"Shortbread", @"Spaghetti Bolognese", @"Spanakopita", @"Spicy Black Bean Soup", @"Spicy Onion Rings", @"Spicy Pasta", @"Split Pea Soup", @"Spring Vegetable Soup", @"Strawberries and Cream Cake", @"Strawberry Cheesecake Muffins", @"Strawberry Fudge", @"Strawberry Ice Cream", @"Strawberry Pavlova", @"Strawberry Rhubarb Pie", @"Stuffed Chicken", @"Stuffed Chicken Breasts", @"Stuffed Mushrooms", @"Stuffed Pork Tenderloin", @"Summer Salad", @"Sweet Potato Pie", @"Tabbouleh", @"Taco Salad", @"Tandoori Chicken Salad", @"Thai Beef Salad", @"Thai Fish Cakes", @"Tomato Soup", @"Tres Leches Cake", @"Tuscan White Bean Soup", @"Tzatziki", @"Ultimate Chocolate Chip Cookies", @"Vanilla Sugar", @"Veal Marsala", @"Vegetable Paella", @"Vegetable Samosas", @"Waffles", @"War Cake", @"Welsh Cakes", @"Yakitori Chicken", @"Yellow Squash Casserole", @"Yogurt Cake", @"Yogurt Cheese", @"Yogurt Chocolate Cake", @"Yogurt Pops", @"Yorkshire Pudding", @"Yule Log", @"Zabaglione", @"Zeppole", @"Zesty Potato Salad", @"Zucchini Cakes", @"Zucchini Frittata", @"Zucchini Gratin", @"Zucchini Lasagna", @"Zucchini Muffins", @"Zucchini Pancakes"];
}



@end
