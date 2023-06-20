### FINALS FOR RAHUL RAJPUT
### RECIPES DATABASE

SELECT *
FROM Recipes LEFT JOIN Recipe_Classes ON Recipes.RecipeClassID = Recipe_Classes.RecipeClassID
LEFT JOIN Recipe_Ingredients ON Recipes.RecipeID = Recipe_Ingredients.RecipeID
LEFT JOIN Ingredients ON Recipe_Ingredients.IngredientID = Ingredients.IngredientID
LEFT JOIN Ingredient_Classes ON Ingredients.IngredientClassID = Ingredient_Classes.IngredientClassID
LEFT JOIN Measurements ON Recipe_Ingredients.MeasureAmountID = Measurements.MeasureAmountID
;

# Question 1
SELECT COUNT(RecipeClassDescription) FROM Recipes
INNER JOIN Recipe_Classes ON Recipes.RecipeClassID = Recipe_Classes.RecipeClassID
LEFT JOIN Recipe_Ingredients ON Recipes.RecipeID = Recipe_Ingredients.RecipeID
LEFT JOIN Measurements ON Recipe_Ingredients.MeasureAmountID = Measurements.MeasureAmountID
WHERE Recipe_Ingredients.IngredientID = (SELECT IngredientID FROM Ingredients WHERE IngredientName = 'Salt')
AND Measurements.MeasureAmountID = 3
AND Recipe_Ingredients.Amount > 3
;

# Question 2

SELECT A.RecipeID, B.RecipeID, COUNT(A.IngredientID) AS CommonIngredients
FROM Recipe_Ingredients A, Recipe_Ingredients B 
WHERE A.IngredientID = B.IngredientID
AND A.RecipeID <> B.RecipeID
AND A.RecipeID < B.RecipeID
GROUP BY A.RecipeID, B.RecipeID
HAVING CommonIngredients > 2
ORDER BY A.RecipeID, B.RecipeID
;

# Question 3
SELECT DISTINCT (Recipe_Ingredients.IngredientID), Ingredients.IngredientName
FROM Recipe_Ingredients LEFT JOIN Ingredients ON Recipe_Ingredients.IngredientID = Ingredients.IngredientID
WHERE Recipe_Ingredients.MeasureAmountID != Ingredients.MeasureAmountID
ORDER BY IngredientID
;

# Question 4
WITH cte4 AS (
SELECT Ingredients.IngredientID, RecipeID
FROM Ingredients LEFT JOIN Recipe_Ingredients ON Ingredients.IngredientID = Recipe_Ingredients.IngredientID
)
SELECT IngredientID, RecipeID, COUNT(RecipeID) OVER(PARTITION BY IngredientID) AS RecipesUsingIngredient
FROM cte4
;

# Question 5
SELECT RecipeID, RecipeTitle FROM Recipes WHERE RecipeID NOT IN (SELECT DISTINCT RecipeID
FROM Ingredients INNER JOIN Recipe_Ingredients ON Ingredients.IngredientID = Recipe_Ingredients.IngredientID
INNER JOIN Ingredient_Classes ON Ingredients.IngredientClassID = Ingredient_Classes.IngredientClassID
WHERE IngredientClassDescription = 'Dairy' 
OR IngredientClassDescription = 'Cheese'
OR IngredientClassDescription = 'Butter')
;












