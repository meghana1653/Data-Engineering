
// 1–5: Create Users, Products, Categories, Brands, Reviews
CREATE 
(:User {name: 'Alice', email: 'alice@example.com'}),
(:User {name: 'Bob', email: 'bob@example.com'}),
(:User {name: 'Charlie', email: 'charlie@example.com'}),

(:Product {name: 'Product1', category: 'Electronics', price: 49.99}),
(:Product {name: 'Product2', category: 'Books', price: 29.99}),
(:Product {name: 'Product3', category: 'Clothing', price: 39.99}),

(:Category {name: 'Electronics'}),
(:Category {name: 'Books'}),
(:Category {name: 'Clothing'}),

(:Brand {name: 'BrandA'}),
(:Brand {name: 'BrandB'}),
(:Brand {name: 'BrandC'}),

(:Review {name: 'Review1', rating: 5}),
(:Review {name: 'Review2', rating: 4}),
(:Review {name: 'Review3', rating: 3});

// 6
MATCH (a:User {name:'Alice'}), (p:Product {name:'Product1'})
CREATE (a)-[:BOUGHT {date: date('2025-10-14'), quantity: 2, price_paid: 99.98}]->(p);

// 7
MATCH (b:User {name:'Bob'}), (p:Product {name:'Product2'})
CREATE (b)-[:BOUGHT {date: date('2025-10-13'), quantity: 1, price_paid: 29.99}]->(p);

// 8
MATCH (c:User {name:'Charlie'}), (p:Product {name:'Product3'})
CREATE (c)-[:VIEWED {date: date('2025-10-12'), duration_seconds: 120, device: 'mobile'}]->(p);

// 9
MATCH (p:Product {name:'Product1'}), (c:Category {name:'Electronics'})
CREATE (p)-[:BELONGS_TO {added_date: date('2025-01-01')}]->(c);

// 10
MATCH (p:Product {name:'Product1'}), (b:Brand {name:'BrandA'})
CREATE (p)-[:MADE_BY {launch_year: 2024}]->(b);

// 11
MATCH (a:User {name:'Alice'}), (r:Review {name:'Review1'}), (p:Product {name:'Product1'})
CREATE (a)-[:RATED {date: date('2025-10-14')}]->(r),
       (r)-[:REVIEWS]->(p);

// 12
MATCH (p1:Product {name:'Product1'}), (p3:Product {name:'Product3'})
CREATE (p1)-[:SIMILAR_TO {similarity_score: 0.85}]->(p3);

// 13
MATCH (a:User {name:'Alice'}), (b:User {name:'Bob'})
CREATE (a)-[:FRIENDS_WITH {since: date('2023-01-01'), interaction_count: 15}]->(b);

// 14
MATCH (c:User {name:'Charlie'}), (p:Product {name:'Product2'})
CREATE (c)-[:BOUGHT {date: date('2025-10-14'), quantity: 1, price_paid: 29.99}]->(p);

// 15
MATCH (a:User {name:'Alice'}), (p:Product {name:'Product2'})
CREATE (a)-[:VIEWED {date: date('2025-10-13'), duration_seconds: 45, device: 'desktop'}]->(p);
// 16
MATCH (a:User {name:'Alice'})-[b:BOUGHT]->(p:Product)
RETURN p.name AS Product, b.quantity AS Quantity, b.date AS PurchaseDate;

// 17
MATCH (a:User {name:'Alice'})-[:FRIENDS_WITH]->(b:User)-[bo:BOUGHT]->(p:Product)
WHERE bo.date >= date('2025-09-14')
AND NOT (a)-[:BOUGHT]->(p)
RETURN p.name AS RecommendedProduct, b.name AS Friend;

// 18
MATCH (p:Product)-[r:BELONGS_TO]->(c:Category {name:'Electronics'})
RETURN p.name AS Product, r.added_date AS AddedDate;

// 19
MATCH (r:Review)-[:REVIEWS]->(p:Product)
RETURN p.name AS Product, AVG(r.rating) AS AvgRating, MAX(r.date) AS LatestReviewDate
ORDER BY AvgRating DESC LIMIT 5;

// 20
MATCH (p:Product)-[m:MADE_BY]->(b:Brand {name:'BrandB'})
RETURN p.name AS Product, m.launch_year AS LaunchYear;

// 21
MATCH (u:User)-[v:VIEWED]->(p:Product {name:'Product3'})
WHERE NOT (u)-[:BOUGHT]->(p)
RETURN u.name AS User, v.duration_seconds AS Duration, v.device AS Device;

// 22
MATCH (u:User)-[b:BOUGHT]->(p:Product)-[:BELONGS_TO]->(c:Category)
RETURN c.name AS Category, SUM(b.quantity) AS TotalQuantity
ORDER BY TotalQuantity DESC LIMIT 1;

// 23
MATCH (u:User)-[r:RATED]->(rev:Review {rating:5})-[:REVIEWS]->(p:Product {name:'Product1'})
RETURN u.name AS User, r.date AS ReviewDate;

// 24
MATCH (p1:Product {name:'Product1'})-[s:SIMILAR_TO]->(p2:Product)
WHERE s.similarity_score > 0.8
RETURN p2.name AS SimilarProduct, s.similarity_score AS Score;

// 25
MATCH (a:User {name:'Alice'})-[:FRIENDS_WITH]->(f:User)-[b:BOUGHT]->(p:Product {name:'Product2'})
RETURN f.name AS Friend, b.date AS PurchaseDate;

// 26
MATCH (u:User)-[:RATED]->(r:Review)-[:REVIEWS]->(p:Product {name:'Product2'})
RETURN u.name AS Reviewer, r.rating AS Rating;

// 27
MATCH (u:User)-[:BOUGHT]->(p:Product)-[:BELONGS_TO]->(c:Category)
WITH u, COLLECT(DISTINCT c.name) AS Categories, COLLECT(p.name) AS Products
WHERE SIZE(Categories) > 1
RETURN u.name AS User, Products, Categories;

// 28
MATCH (u:User)-[v:VIEWED]->(p:Product)
WHERE v.duration_seconds > 100
RETURN u.name AS User, p.name AS Product, v.duration_seconds AS Duration;

// 29
MATCH (a:User {name:'Alice'})-[:FRIENDS_WITH]->(f:User)-[b:BOUGHT]->(p:Product)
WHERE b.date >= date('2025-09-14')
AND NOT (a)-[:BOUGHT]->(p)
RETURN f.name AS Friend, p.name AS RecommendedProduct;

// 30
MATCH (u:User)-[b1:BOUGHT]->(p1:Product {name:'Product2'})
MATCH (u)-[b2:BOUGHT]->(p2:Product)
WHERE p2 <> p1
RETURN p2.name AS CoPurchasedProduct, b1.date AS PurchaseDate;

// 31
MATCH (p:Product {name:'Product1'})
SET p.price = 99.99;

// 32
MATCH (p:Product {name:'Product1'})
MERGE (c:Category {name:'Gadgets'})
CREATE (p)-[:BELONGS_TO {added_date: date('2025-10-14')}]->(c);

// 33
MATCH (u:User {name:'Alice'})
SET u.email = 'alice_new@example.com';

// 34
MATCH (r:Review {name:'Review1'})
SET r.rating = 4, r.date = date('2025-10-15');

// 35
MATCH (c:User {name:'Charlie'}), (p:Product {name:'Product3'})
CREATE (c)-[:BOUGHT {date: date('2025-10-14'), quantity: 1, price_paid: 39.99}]->(p);

// 36
MATCH (p:Product {name:'Product3'})-[m:MADE_BY]->(:Brand)
DELETE m
WITH p
MERGE (b:Brand {name:'BrandD'})
CREATE (p)-[:MADE_BY {launch_year: 2025}]->(b);

// 37
MATCH (p:Product {name:'Product2'})
SET p.name = 'BookMaster 2025';

// 38
MATCH (u:User {name:'Bob'}) SET u.name = 'Robert';
MATCH (u:User {name:'Charlie'}) SET u.name = 'Charles';

// 39
MATCH (p:Product {name:'Product3'})-[r:BELONGS_TO]->(:Category)
DELETE r
WITH p
MERGE (c:Category {name:'Sports'})
CREATE (p)-[:BELONGS_TO {added_date: date('2025-10-14')}]->(c);

// 40
MATCH (p:Product {name:'Product1'})
SET p.discount = '10%';
// 41
MATCH (p:Product {name:'Product50'})
DETACH DELETE p;

// 42
MATCH (r:Review {name:'Review5', rating:2})
DETACH DELETE r;

// 43
MATCH (:User {name:'Alice'})-[b:BOUGHT]->(:Product {name:'Product2'})
DELETE b;

// 44
MATCH (c:Category {name:'OldCategory'})
DETACH DELETE c;

// 45
MATCH (u:User {name:'Tina'})
DETACH DELETE u;

// 46
MATCH (:Product {name:'Product1'})-[s:SIMILAR_TO]->(:Product {name:'Product3'})
DELETE s;

// 47
MATCH (b:Brand {name:'BrandJ'})<-[:MADE_BY]-(p:Product)
DETACH DELETE p;

// 48
MATCH (:User)-[v:VIEWED]->(p:Product {name:'Product3'})
WHERE v.date < date('2025-01-01')
DELETE v;

// 49
MATCH (p:Product)
WHERE p.name IN ['Product48','Product49']
  AND NOT ( (:User)-[:BOUGHT]->(p) OR (:Review)-[:REVIEWS]->(p) )
DETACH DELETE p;

// 50
MATCH (r:Review {name:'Review3'})
DETACH DELETE r;
// 51
MATCH (u:User)-[b:BOUGHT]->(p:Product)
WHERE b.date >= date('2025-10-01') AND b.date < date('2025-11-01')
RETURN u.name AS User, SUM(b.quantity) AS TotalQuantity
ORDER BY TotalQuantity DESC
LIMIT 5;

// 52
MATCH (a:User {name:'Alice'})-[:BOUGHT]->(:Product)-[:BELONGS_TO]->(cat:Category {name:'Electronics'})
MATCH (p:Product)-[:BELONGS_TO]->(cat)
WHERE NOT (a)-[:BOUGHT]->(p)
RETURN p.name AS RecommendedProduct, cat.name AS Category;

// 53
MATCH (u:User)-[b1:BOUGHT]->(p1:Product {name:'Product2'})
WHERE b1.date >= date('2025-09-15')
MATCH (u)-[b2:BOUGHT]->(p2:Product)
WHERE p2 <> p1
RETURN p2.name AS CoPurchasedProduct, COUNT(*) AS Frequency
ORDER BY Frequency DESC
LIMIT 5;

// 54
MATCH (p:Product)-[:MADE_BY]->(:Brand {name:'BrandA'})
OPTIONAL MATCH (r:Review)-[:REVIEWS]->(p)
RETURN p.name AS Product, AVG(r.rating) AS AverageRating;

// 55
MATCH (a:User {name:'Alice'})-[:FRIENDS_WITH]->(f:User)-[b:BOUGHT]->(p:Product)
WHERE NOT (a)-[:BOUGHT]->(p)
RETURN f.name AS Friend, p.name AS SuggestedProduct, b.date AS PurchaseDate
ORDER BY b.date DESC;

// 56
MATCH (u:User)-[b:BOUGHT]->(p:Product)
WHERE b.price_paid > 80
RETURN u.name AS User, p.name AS Product, b.price_paid AS PricePaid;

// 57
MATCH (p:Product)<-[b:BOUGHT]-(:User)
MATCH (p)-[:BELONGS_TO]->(c:Category)
RETURN c.name AS Category, ROUND(SUM(b.price_paid * b.quantity), 2) AS TotalRevenue
ORDER BY TotalRevenue DESC;

// 58
MATCH (u:User)-[v:VIEWED]->(p:Product)
WHERE v.duration_seconds > 100 AND NOT (u)-[:BOUGHT]->(p)
RETURN u.name AS User, p.name AS Product, v.duration_seconds AS Duration;

// 59
MATCH (p:Product)
OPTIONAL MATCH (r:Review)-[:REVIEWS]->(p)
RETURN p.name AS Product, COUNT(r) AS ReviewCount, ROUND(AVG(r.rating), 2) AS AvgRating
ORDER BY ReviewCount DESC, AvgRating DESC;

// 60
MATCH (u:User)-[:BOUGHT]->(p:Product)
WHERE p.name IN ['Product1','Product2','Product3']
WITH u, COLLECT(p.name) AS PurchasedProducts
WHERE SIZE(PurchasedProducts) > 1
RETURN u.name AS User, PurchasedProducts AS CoPurchasedBundle;
