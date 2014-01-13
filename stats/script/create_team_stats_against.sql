CREATE TABLE team_stats_against (
team_name VARCHAR(32),
pg_points DECIMAL, pg_rebounds DECIMAL, pg_assists DECIMAL, pg_steals DECIMAL, pg_blocks DECIMAL, pg_turnovers DECIMAL, 
sg_points DECIMAL, sg_rebounds DECIMAL, sg_assists DECIMAL, sg_steals DECIMAL, sg_blocks DECIMAL, sg_turnovers DECIMAL, 
sf_points DECIMAL, sf_rebounds DECIMAL, sf_assists DECIMAL, sf_steals DECIMAL, sf_blocks DECIMAL, sf_turnovers DECIMAL, 
pf_points DECIMAL, pf_rebounds DECIMAL, pf_assists DECIMAL, pf_steals DECIMAL, pf_blocks DECIMAL, pf_turnovers DECIMAL, 
c_points DECIMAL, c_rebounds DECIMAL, c_assists DECIMAL, c_steals DECIMAL, c_blocks DECIMAL, c_turnovers DECIMAL);

INSERT INTO team_stats_against (team_name) SELECT DISTINCT players.team_name
FROM players
WHERE players.team_name!='';

UPDATE team_stats_against 
SET pg_points=(SELECT ROUND(AVG(boxscores.points),2) 
FROM boxscores 
WHERE boxscores.pos='PG' 
AND team_stats_against.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE team_stats_against 
SET sg_points=(SELECT ROUND(AVG(boxscores.points),2) 
FROM boxscores 
WHERE boxscores.pos='SG' 
AND team_stats_against.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE team_stats_against 
SET sf_points=(SELECT ROUND(AVG(boxscores.points),2) 
FROM boxscores 
WHERE boxscores.pos='SF' 
AND team_stats_against.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE team_stats_against 
SET pf_points=(SELECT ROUND(AVG(boxscores.points),2) 
FROM boxscores 
WHERE boxscores.pos='PF' 
AND team_stats_against.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE team_stats_against 
SET c_points=(SELECT ROUND(AVG(boxscores.points),2) 
FROM boxscores 
WHERE boxscores.pos='C' 
AND team_stats_against.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE team_stats_against 
SET pg_rebounds=(SELECT ROUND(AVG(boxscores.rebounds),2) 
FROM boxscores 
WHERE boxscores.pos='PG' 
AND team_stats_against.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE team_stats_against 
SET sg_rebounds=(SELECT ROUND(AVG(boxscores.rebounds),2) 
FROM boxscores 
WHERE boxscores.pos='SG' 
AND team_stats_against.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE team_stats_against 
SET sf_rebounds=(SELECT ROUND(AVG(boxscores.rebounds),2) 
FROM boxscores 
WHERE boxscores.pos='SF' 
AND team_stats_against.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE team_stats_against 
SET pf_rebounds=(SELECT ROUND(AVG(boxscores.rebounds),2) 
FROM boxscores 
WHERE boxscores.pos='PF' 
AND team_stats_against.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE team_stats_against 
SET c_rebounds=(SELECT ROUND(AVG(boxscores.rebounds),2) 
FROM boxscores 
WHERE boxscores.pos='C' 
AND team_stats_against.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE team_stats_against 
SET pg_assists=(SELECT ROUND(AVG(boxscores.assists),2) 
FROM boxscores 
WHERE boxscores.pos='PG' 
AND team_stats_against.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE team_stats_against 
SET sg_assists=(SELECT ROUND(AVG(boxscores.assists),2) 
FROM boxscores 
WHERE boxscores.pos='SG' 
AND team_stats_against.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE team_stats_against 
SET sf_assists=(SELECT ROUND(AVG(boxscores.assists),2) 
FROM boxscores 
WHERE boxscores.pos='SF' 
AND team_stats_against.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE team_stats_against 
SET pf_assists=(SELECT ROUND(AVG(boxscores.assists),2) 
FROM boxscores 
WHERE boxscores.pos='PF' 
AND team_stats_against.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE team_stats_against 
SET c_assists=(SELECT ROUND(AVG(boxscores.assists),2) 
FROM boxscores 
WHERE boxscores.pos='C' 
AND team_stats_against.team_name=boxscores.opponent 
AND boxscores.mins>='10');


UPDATE team_stats_against 
SET pg_steals=(SELECT ROUND(AVG(boxscores.steals),2) 
FROM boxscores 
WHERE boxscores.pos='PG' 
AND team_stats_against.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE team_stats_against 
SET sg_steals=(SELECT ROUND(AVG(boxscores.steals),2) 
FROM boxscores 
WHERE boxscores.pos='SG' 
AND team_stats_against.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE team_stats_against 
SET sf_steals=(SELECT ROUND(AVG(boxscores.steals),2) 
FROM boxscores 
WHERE boxscores.pos='SF' 
AND team_stats_against.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE team_stats_against 
SET pf_steals=(SELECT ROUND(AVG(boxscores.steals),2) 
FROM boxscores 
WHERE boxscores.pos='PF' 
AND team_stats_against.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE team_stats_against 
SET c_steals=(SELECT ROUND(AVG(boxscores.steals),2) 
FROM boxscores 
WHERE boxscores.pos='C' 
AND team_stats_against.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE team_stats_against 
SET pg_blocks=(SELECT ROUND(AVG(boxscores.blocks),2) 
FROM boxscores 
WHERE boxscores.pos='PG' 
AND team_stats_against.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE team_stats_against 
SET sg_blocks=(SELECT ROUND(AVG(boxscores.blocks),2) 
FROM boxscores 
WHERE boxscores.pos='SG' 
AND team_stats_against.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE team_stats_against 
SET sf_blocks=(SELECT ROUND(AVG(boxscores.blocks),2) 
FROM boxscores 
WHERE boxscores.pos='SF' 
AND team_stats_against.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE team_stats_against 
SET pf_blocks=(SELECT ROUND(AVG(boxscores.blocks),2) 
FROM boxscores 
WHERE boxscores.pos='PF' 
AND team_stats_against.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE team_stats_against 
SET c_blocks=(SELECT ROUND(AVG(boxscores.blocks),2) 
FROM boxscores 
WHERE boxscores.pos='C' 
AND team_stats_against.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE team_stats_against 
SET pg_turnovers=(SELECT ROUND(AVG(boxscores.turnovers),2) 
FROM boxscores 
WHERE boxscores.pos='PG' 
AND team_stats_against.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE team_stats_against 
SET sg_turnovers=(SELECT ROUND(AVG(boxscores.turnovers),2) 
FROM boxscores 
WHERE boxscores.pos='SG' 
AND team_stats_against.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE team_stats_against 
SET sf_turnovers=(SELECT ROUND(AVG(boxscores.turnovers),2) 
FROM boxscores 
WHERE boxscores.pos='SF' 
AND team_stats_against.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE team_stats_against 
SET pf_turnovers=(SELECT ROUND(AVG(boxscores.turnovers),2) 
FROM boxscores 
WHERE boxscores.pos='PF' 
AND team_stats_against.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE team_stats_against 
SET c_turnovers=(SELECT ROUND(AVG(boxscores.turnovers),2) 
FROM boxscores 
WHERE boxscores.pos='C' 
AND team_stats_against.team_name=boxscores.opponent 
AND boxscores.mins>='10');
