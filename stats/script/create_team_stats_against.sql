DELETE FROM todays_games WHERE salary=0; 

DELETE FROM todays_games WHERE salary IS NULL;

UPDATE todays_games 
SET projected_fd_points = round((salary/1000*5),2); 

UPDATE todays_games 
SET plus_minus_percentage = round((avg_fd_points/projected_fd_points),2);


CREATE TABLE opponent_stats_by_pos (
team_name VARCHAR(32),
pg_avg_fd DECIMAL, sg_avg_fd DECIMAL, sf_avg_fd DECIMAL, pf_avg_fd DECIMAL, c_avg_fd DECIMAL, 
pg_points DECIMAL, pg_rebounds DECIMAL, pg_assists DECIMAL, pg_steals DECIMAL, pg_blocks DECIMAL, pg_turnovers DECIMAL, 
sg_points DECIMAL, sg_rebounds DECIMAL, sg_assists DECIMAL, sg_steals DECIMAL, sg_blocks DECIMAL, sg_turnovers DECIMAL, 
sf_points DECIMAL, sf_rebounds DECIMAL, sf_assists DECIMAL, sf_steals DECIMAL, sf_blocks DECIMAL, sf_turnovers DECIMAL, 
pf_points DECIMAL, pf_rebounds DECIMAL, pf_assists DECIMAL, pf_steals DECIMAL, pf_blocks DECIMAL, pf_turnovers DECIMAL, 
c_points DECIMAL, c_rebounds DECIMAL, c_assists DECIMAL, c_steals DECIMAL, c_blocks DECIMAL, c_turnovers DECIMAL);

INSERT INTO opponent_stats_by_pos (team_name) SELECT DISTINCT players.team_name
FROM players
WHERE players.team_name!='';

UPDATE opponent_stats_by_pos 
SET pg_avg_fd=(SELECT ROUND(AVG(boxscores.fd_points),2) 
FROM boxscores 
WHERE boxscores.pos='PG' 
AND opponent_stats_by_pos.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE opponent_stats_by_pos 
SET sg_avg_fd=(SELECT ROUND(AVG(boxscores.fd_points),2) 
FROM boxscores 
WHERE boxscores.pos='SG' 
AND opponent_stats_by_pos.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE opponent_stats_by_pos 
SET sf_avg_fd=(SELECT ROUND(AVG(boxscores.fd_points),2) 
FROM boxscores 
WHERE boxscores.pos='SF' 
AND opponent_stats_by_pos.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE opponent_stats_by_pos 
SET pf_avg_fd=(SELECT ROUND(AVG(boxscores.fd_points),2) 
FROM boxscores 
WHERE boxscores.pos='PF' 
AND opponent_stats_by_pos.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE opponent_stats_by_pos 
SET c_avg_fd=(SELECT ROUND(AVG(boxscores.fd_points),2) 
FROM boxscores 
WHERE boxscores.pos='C' 
AND opponent_stats_by_pos.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE opponent_stats_by_pos 
SET pg_points=(SELECT ROUND(AVG(boxscores.points),2) 
FROM boxscores 
WHERE boxscores.pos='PG' 
AND opponent_stats_by_pos.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE opponent_stats_by_pos 
SET sg_points=(SELECT ROUND(AVG(boxscores.points),2) 
FROM boxscores 
WHERE boxscores.pos='SG' 
AND opponent_stats_by_pos.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE opponent_stats_by_pos 
SET sf_points=(SELECT ROUND(AVG(boxscores.points),2) 
FROM boxscores 
WHERE boxscores.pos='SF' 
AND opponent_stats_by_pos.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE opponent_stats_by_pos 
SET pf_points=(SELECT ROUND(AVG(boxscores.points),2) 
FROM boxscores 
WHERE boxscores.pos='PF' 
AND opponent_stats_by_pos.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE opponent_stats_by_pos 
SET c_points=(SELECT ROUND(AVG(boxscores.points),2) 
FROM boxscores 
WHERE boxscores.pos='C' 
AND opponent_stats_by_pos.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE opponent_stats_by_pos 
SET pg_rebounds=(SELECT ROUND(AVG(boxscores.rebounds),2) 
FROM boxscores 
WHERE boxscores.pos='PG' 
AND opponent_stats_by_pos.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE opponent_stats_by_pos 
SET sg_rebounds=(SELECT ROUND(AVG(boxscores.rebounds),2) 
FROM boxscores 
WHERE boxscores.pos='SG' 
AND opponent_stats_by_pos.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE opponent_stats_by_pos 
SET sf_rebounds=(SELECT ROUND(AVG(boxscores.rebounds),2) 
FROM boxscores 
WHERE boxscores.pos='SF' 
AND opponent_stats_by_pos.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE opponent_stats_by_pos 
SET pf_rebounds=(SELECT ROUND(AVG(boxscores.rebounds),2) 
FROM boxscores 
WHERE boxscores.pos='PF' 
AND opponent_stats_by_pos.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE opponent_stats_by_pos 
SET c_rebounds=(SELECT ROUND(AVG(boxscores.rebounds),2) 
FROM boxscores 
WHERE boxscores.pos='C' 
AND opponent_stats_by_pos.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE opponent_stats_by_pos 
SET pg_assists=(SELECT ROUND(AVG(boxscores.assists),2) 
FROM boxscores 
WHERE boxscores.pos='PG' 
AND opponent_stats_by_pos.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE opponent_stats_by_pos 
SET sg_assists=(SELECT ROUND(AVG(boxscores.assists),2) 
FROM boxscores 
WHERE boxscores.pos='SG' 
AND opponent_stats_by_pos.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE opponent_stats_by_pos 
SET sf_assists=(SELECT ROUND(AVG(boxscores.assists),2) 
FROM boxscores 
WHERE boxscores.pos='SF' 
AND opponent_stats_by_pos.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE opponent_stats_by_pos 
SET pf_assists=(SELECT ROUND(AVG(boxscores.assists),2) 
FROM boxscores 
WHERE boxscores.pos='PF' 
AND opponent_stats_by_pos.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE opponent_stats_by_pos 
SET c_assists=(SELECT ROUND(AVG(boxscores.assists),2) 
FROM boxscores 
WHERE boxscores.pos='C' 
AND opponent_stats_by_pos.team_name=boxscores.opponent 
AND boxscores.mins>='10');


UPDATE opponent_stats_by_pos 
SET pg_steals=(SELECT ROUND(AVG(boxscores.steals),2) 
FROM boxscores 
WHERE boxscores.pos='PG' 
AND opponent_stats_by_pos.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE opponent_stats_by_pos 
SET sg_steals=(SELECT ROUND(AVG(boxscores.steals),2) 
FROM boxscores 
WHERE boxscores.pos='SG' 
AND opponent_stats_by_pos.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE opponent_stats_by_pos 
SET sf_steals=(SELECT ROUND(AVG(boxscores.steals),2) 
FROM boxscores 
WHERE boxscores.pos='SF' 
AND opponent_stats_by_pos.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE opponent_stats_by_pos 
SET pf_steals=(SELECT ROUND(AVG(boxscores.steals),2) 
FROM boxscores 
WHERE boxscores.pos='PF' 
AND opponent_stats_by_pos.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE opponent_stats_by_pos 
SET c_steals=(SELECT ROUND(AVG(boxscores.steals),2) 
FROM boxscores 
WHERE boxscores.pos='C' 
AND opponent_stats_by_pos.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE opponent_stats_by_pos 
SET pg_blocks=(SELECT ROUND(AVG(boxscores.blocks),2) 
FROM boxscores 
WHERE boxscores.pos='PG' 
AND opponent_stats_by_pos.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE opponent_stats_by_pos 
SET sg_blocks=(SELECT ROUND(AVG(boxscores.blocks),2) 
FROM boxscores 
WHERE boxscores.pos='SG' 
AND opponent_stats_by_pos.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE opponent_stats_by_pos 
SET sf_blocks=(SELECT ROUND(AVG(boxscores.blocks),2) 
FROM boxscores 
WHERE boxscores.pos='SF' 
AND opponent_stats_by_pos.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE opponent_stats_by_pos 
SET pf_blocks=(SELECT ROUND(AVG(boxscores.blocks),2) 
FROM boxscores 
WHERE boxscores.pos='PF' 
AND opponent_stats_by_pos.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE opponent_stats_by_pos 
SET c_blocks=(SELECT ROUND(AVG(boxscores.blocks),2) 
FROM boxscores 
WHERE boxscores.pos='C' 
AND opponent_stats_by_pos.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE opponent_stats_by_pos 
SET pg_turnovers=(SELECT ROUND(AVG(boxscores.turnovers),2) 
FROM boxscores 
WHERE boxscores.pos='PG' 
AND opponent_stats_by_pos.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE opponent_stats_by_pos 
SET sg_turnovers=(SELECT ROUND(AVG(boxscores.turnovers),2) 
FROM boxscores 
WHERE boxscores.pos='SG' 
AND opponent_stats_by_pos.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE opponent_stats_by_pos 
SET sf_turnovers=(SELECT ROUND(AVG(boxscores.turnovers),2) 
FROM boxscores 
WHERE boxscores.pos='SF' 
AND opponent_stats_by_pos.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE opponent_stats_by_pos 
SET pf_turnovers=(SELECT ROUND(AVG(boxscores.turnovers),2) 
FROM boxscores 
WHERE boxscores.pos='PF' 
AND opponent_stats_by_pos.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE opponent_stats_by_pos 
SET c_turnovers=(SELECT ROUND(AVG(boxscores.turnovers),2) 
FROM boxscores 
WHERE boxscores.pos='C' 
AND opponent_stats_by_pos.team_name=boxscores.opponent 
AND boxscores.mins>='10');

UPDATE todays_games
SET fd_points_vs_opp =
	(CASE
	WHEN todays_games.pos = 'PG' THEN opponent_stats_by_pos.pg_avg_fd
	WHEN todays_games.pos = 'SG' THEN opponent_stats_by_pos.sg_avg_fd
	WHEN todays_games.pos = 'SF' THEN opponent_stats_by_pos.sf_avg_fd
	WHEN todays_games.pos = 'PF' THEN opponent_stats_by_pos.pf_avg_fd
	WHEN todays_games.pos = 'C' THEN opponent_stats_by_pos.c_avg_fd
	END)
FROM opponent_stats_by_pos
WHERE opponent_stats_by_pos.team_name=todays_games.opponent;

