CREATE DATABASE pokedex_stats;

SELECT * FROM pokemon;

ALTER TABLE pokemon CHANGE COLUMN total total_stats INT;


SELECT 
	name, 
    count(*) 
FROM 
	pokemon
GROUP BY name, generation
HAVING count(*) > 1;

/* Pokedex per generation count*/

SELECT
	generation,
	count(*) as Pokedex_count
from pokemon
group by generation
order by generation;

/*count of unique elements*/

SELECT count(distinct(type1)) from pokemon; 

SELECT count(type1) as element_count, type1
FROM pokemon
GROUP BY type1
HAVING count(*);

/* Dual type pokemon*/

SELECT * 
FROM 
	pokemon
WHERE type2 not in (SELECT DISTINCT(type2) FROM pokemon
					WHERE type2 = "");

/* Strongest pokemon/legendary */

SELECT
	name,
    max(total_stats) as total_stats,
    type1,
    type2,
    generation,
    legendary
FROM 
	pokemon
GROUP BY generation, name
ORDER BY total_stats DESC;

SELECT
	name,
    max(total_stats) as total_stats,
    type1,
    type2,
    generation,
    legendary
FROM 
	pokemon
WHERE 
	legendary = "True"
GROUP BY generation, name
ORDER BY total_stats DESC;

CREATE VIEW Strongest_legendary AS 
SELECT
	name,
    max(total_stats) as total_stats,
    type1,
    type2,
    generation,
    legendary
FROM 
	pokemon
WHERE 
	legendary = "True"
GROUP BY generation, name;

SELECT * FROM strongest_legendary;

/* What pokemon to choose? in generation 1*/

SELECT
	avg(total_stats)
FROM pokemon
where generation = 1;

SELECT name, total_stats as "below_avg_pokemon", generation
FROM 
	pokemon 
WHERE total_stats < (SELECT
	avg(total_stats)
FROM pokemon) and generation = 1
ORDER BY total_stats desc;

SELECT name, total_stats,
case 
	when total_stats > (SELECT
		avg(total_stats)
		FROM pokemon
		where generation = 1) then "above_avg_pokemon"
	else "below_avg_pokemon"
end as "power_ranking"
FROM pokemon
WHERE generation = 1;

SELECT 
	name, 
	total_stats,
	avg(total_stats) over (partition by generation) as avg_stats, 
    generation
FROM 
	pokemon;

/* Fastest/slowest pokemon in all generation */

SELECT 
	name as "legendary_pokemon", 
    speed as Top_3, 
    generation
FROM 
	pokemon
WHERE 
	legendary = "True"
GROUP BY 
	name, generation
ORDER BY speed DESC
limit 3;

SELECT 
	name as "legendary_pokemon", 
    speed as third_slowest, 
    generation FROM pokemon
WHERE 
	legendary = "False"
GROUP BY 
	name, generation 
ORDER BY speed
limit 2,1;

SELECT 
	name as "pokemon", 
    speed as fastest, 
    generation 
FROM 
	pokemon
GROUP BY 
	name, generation
ORDER BY speed desc;

/* most damage_dealer */

select avg(attack) from pokemon;
select avg(sp_attack) from pokemon;

SELECT
	name,
    attack,
    type1
FROM
	pokemon
Where
	attack > (select avg(attack) from pokemon)
union
SELECT
	name,
    attack,
    type1
FROM
	pokemon
Where
	sp_attack > (select avg(sp_attack) from pokemon);

/* pokemon with mega evolutions limit to three elements*/

SELECT
	name,
    'Mega_Evolution' as Evolution
FROM
	pokemon
WHERE name REGEXP 'Mega' and type1 in ('fire','water','grass');

/* whos the highest defense/sp_defense per generations*/

SELECT
	max(defense),
    generation,
    name
FROM 
	pokemon
GROUP BY generation;

SELECT 
	name, 
    type1, 
    type2,
    generation
FROM
	pokemon
WHERE
	(defense, generation) in (SELECT
							max(defense),
							generation
							FROM pokemon
							GROUP BY generation)
ORDER BY generation;


SELECT *
FROM
	pokemon p1
WHERE
	sp_defense > (SELECT AVG(sp_defense)
				FROM
					pokemon p2
				WHERE p2.generation = p1.generation);



                    
