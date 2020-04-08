<?php

$DB = pg_connect("host=localhost port=5432 dbname=[REPLACE_WITH_YOUR_DB_NAME]");

$WITH = "WITH";
$AS   = "AS";
$MAIN = "MAIN";
$TIEBREAK = "TIEBREAK";
$SPACE = " ";
$COMMA = ",";
$MAIN_TIE = "MAIN_TIE";
$SEC = "SEC";
$SEC_TIE = "SEC_TIE";
$EQUAL = "=";
$JOIN = "JOIN";
$ON = "ON";
$RANK = "rank";
$SIMPLE = "simple";
$EXTENDED = "extended";


function simpleEventsCompetition($competition_id, $databaseConnection) {

    $sql = "SELECT id, name, main_score_direction AS main, tiebreak_score_direction AS tie
			FROM   simple_events
			WHERE  simple_events.competition_id = $1";

    $transformations =  array("$1" => $competition_id);
    $sql    = strtr($sql, $transformations);
    $query  = pg_query($databaseConnection, $sql);
    $events = array();

    while ($currEvent = pg_fetch_object($query)) {
        $events[] = $currEvent;
    }
    return $events;
}



function extendedEventsCompetition($competition_id, $databaseConnection) {

    $sql = "SELECT id, name, time_cap AS cap, main_tiebreak_score_direction AS main_tie, secondary_score_direction AS sec, secondary_tiebreak_score_direction AS sec_tie
			FROM   extended_events
			WHERE  extended_events.competition_id = $1";

    $transformations =  array("$1" => $competition_id);
    $sql = strtr($sql, $transformations);
    $query = pg_query($databaseConnection, $sql);
    $events = array();

    while ($currEvent = pg_fetch_object($query)) {
        $events[] = $currEvent;
    }
    return $events;
}





function simpleEventSQL($tableAthletes,$tableName, $eventID, array $directions) {

    $sql =  " {SCORES} AS (

				SELECT athlete_id, main_time, main_count, tiebreak_time, tiebreak_count
				FROM   simple_scores
				WHERE  simple_scores.event_id = {EVENTID}
			),

			{RANKINGS} (athlete_id,rank) AS (

				SELECT {ATHLETES}.id, rank() OVER (ORDER BY main_time      {DIR-MAIN}    nulls last,
									   			   			main_count     {DIR-MAIN}    nulls last,
									   			   			tiebreak_time  {DIR-TIE}     nulls last, 
									   			   			tiebreak_count {DIR-TIE}     nulls last) 

				FROM {ATHLETES} LEFT JOIN {SCORES} ON {ATHLETES}.id = {SCORES}.athlete_id
			)";

    $transformations =  array (

        "{SCORES}"   => "SCORES".$eventID,
        "{RANKINGS}" => $tableName,
        "{DIR-MAIN}" => $directions["MAIN"],
        "{DIR-TIE}"  => ($directions["TIEBREAK"] == "N/A" ? "ASC" : $directions["TIEBREAK"]),
        "{EVENTID}"  => $eventID,
        "{ATHLETES}" => $tableAthletes
    );

    return strtr($sql, $transformations);
}




function extendedEventSQL($timeLimit, $athletes, $tableName, $eventID, array $directions) {

    $sql = "{AS} (athlete_id,MST,MTT,MTC,ST,SC,STT,STC) AS (

			    SELECT athlete_id,main_time,main_tiebreak_time,main_tiebreak_count,secondary_time,secondary_count,secondary_tiebreak_time,secondary_tiebreak_count     
			    FROM   extended_scores
			    WHERE  extended_scores.event_id = {EVENTID}
			),

			{SS} (athlete_id,MST,MTT,MTC,ST,SC,STT,STC) AS (

				SELECT {ATHLETES}.id, {AS}.MST, {AS}.MTT, {AS}.MTC, null, null, null, null
				FROM   {ATHLETES} JOIN {AS} ON {ATHLETES}.id = {AS}.athlete_id
				WHERE  {AS}.MST < {LIMIT}
            	
				UNION
                
				SELECT {ATHLETES}.id, null, null, null, {AS}.ST, {AS}.SC, {AS}.STT, {AS}.STC
				FROM   {ATHLETES} LEFT JOIN {AS} ON {ATHLETES}.id = {AS}.athlete_id
				WHERE  {AS}.MST >= {LIMIT} OR {AS}.MST IS NULL	
			),

			{RANKINGS} (athlete_id,rank) AS (

				SELECT {SS}.athlete_id, rank() OVER (ORDER BY      MST  ASC             nulls last,
									   						 	   MTT  {DIR-MAIN-TIE}  nulls last,
									   						  	   MTC  {DIR-MAIN-TIE}  nulls last, 
									   						  	   ST   {DIR-SEC}   	nulls last,
									   						  	   SC   {DIR-SEC}    	nulls last,
									   						  	   STT  {DIR-SEC-TIE}   nulls last,
									   						  	   STC  {DIR-SEC-TIE}   nulls last) 
				FROM {SS}
			)";

	$transformations =  array (

        "{AS}"       	=> "ALLSCORES".$eventID,
        "{SS}"       	=> "CURATEDSCORES".$eventID,
        "{DIR-MAIN-TIE}"=> ($directions["MAIN_TIE"] == "N/A" ? "ASC" : $directions["MAIN_TIE"]),
        "{DIR-SEC}" 	=> $directions["SEC"],
        "{DIR-SEC-TIE}" => ($directions["SECT_TIE"] == "N/A" ? "ASC" : $directions["SECT_TIE"]),
        "{EVENTID}"  	=> $eventID,
        "{ATHLETES}" 	=> $athletes,
        "{RANKINGS}" 	=> $tableName,
        "{LIMIT}"    	=> "'".$timeLimit."'"
    );

	return strtr($sql, $transformations);
}


function athletesSQL(array $conditions) {

    $sql = "SELECT athletes.name AS name, athletes.id AS id
			FROM   athletes JOIN registrations ON athletes.id = registrations.athlete_id
			WHERE  $1";

    $where = array();

    foreach ($conditions as $key => $val) {
        $where[] = $key.' = '.$val;
    }

    $where = implode(" AND ", $where);
    $transformations =  array("$1" => $where);

    return strtr($sql, $transformations);
}




function totalPointsSQL($athletesTable, array $events) {

    $sql =  " TOTALPOINTS (athlete_id,points) AS (

				SELECT {ATHLETES}.id, {SUM}
				FROM   {JOINS}
			)";

    global $RANK;
    $suffixed = array();
    $from = $athletesTable;

    foreach ($events as $event) {
        $suffixed[] = $event.".".$RANK;
    }

    $sum = implode(" + ", $suffixed);

    foreach ($events as $event) {
        $statement = " {PREVIOUS} JOIN {CURRENT_EVENT} ON {ATHLETES}.id = {CURRENT_EVENT}.athlete_id ";
        $transformations =  array ("{PREVIOUS}" => $from, "{CURRENT_EVENT}" => $event, "{ATHLETES}" => $athletesTable);
        $from = strtr($statement, $transformations);
    }

    $transformations =  array ("{ATHLETES}" => $athletesTable, "{SUM}" => $sum, "{JOINS}" => $from);
    return strtr($sql, $transformations);
}





function finalRanksSQL($athletesTable, array $events) {

    $sql = "SELECT $1.name AS name, rank() OVER (ORDER BY $2.points ASC nulls last) AS rank, $2.points , $3
			FROM   $4";

    global $RANK,$SPACE,$AS;
    $from = $athletesTable;
    $suffixed = array();
    $joins = $events;
    $joins[] = "TOTALPOINTS";

    foreach ($joins as $elem) {

        $statement = " {PREVIOUS} JOIN {CURRENT_EVENT} ON {ATHLETES}.id = {CURRENT_EVENT}.athlete_id ";
        $transformations =  array ("{PREVIOUS}" => $from, "{CURRENT_EVENT}" => $elem, "{ATHLETES}" => $athletesTable);
        $from = strtr($statement, $transformations);
    }

    foreach ($events as $event) {
        $suffixed[] = $event.".".$RANK.$SPACE.$AS.$SPACE.$event;
    }

    $select = implode(",", $suffixed);

    $transformations =  array("$1" => $athletesTable, "$2" => "TOTALPOINTS", "$3" => $select, "$4" => $from);
    return strtr($sql, $transformations);
}






function rankingsSQL($simpleEvents, $extendedEvents, $athletesCondition) {


    global $WITH,$SPACE,$AS,$COMMA,$SIMPLE,$MAIN,$TIEBREAK,$EXTENDED,$MAIN_TIE,$SEC,$SEC_TIE;

    $RANKINGS = "RANKINGS";
    $tableAthletes = "ath";
    $simpleEventsTableName = array();
    $extendedEventsTableName = array();

    $sql =  $WITH.$SPACE.$tableAthletes.$SPACE.$AS.$SPACE."(".athletesSQL($athletesCondition).")";

    foreach ($simpleEvents as $event) {

        $sql = $sql.$COMMA;
        $tableName = $RANKINGS.$SIMPLE.($event->id);
        $directions = array($MAIN => $event->main, $TIEBREAK => $event->tie);
        $simpleEventsTableName[] = $tableName;
        $sql = $sql.simpleEventSQL($tableAthletes, $tableName, $event->id, $directions);
    }

    foreach ($extendedEvents as $event) {

        $sql = $sql.$COMMA;
        $tableName = $RANKINGS.$EXTENDED.($event->id);
        $directions = array($MAIN_TIE => $event->main_tie, $SEC => $event->sec, $SEC_TIE => $event->sec_tie);
        $extendedEventsTableName[] = $tableName;
        $sql = $sql.extendedEventSQL($event->cap, $tableAthletes, $tableName, $event->id, $directions);
    }

    $events = array_merge($simpleEventsTableName, $extendedEventsTableName);
    $sql = $sql.$COMMA.totalPointsSQL($tableAthletes, $events).finalRanksSQL($tableAthletes,$events);

    return $sql;

}


// CHANGE THE COMPETITION ID.

$COMPETITION_ID = 10;

$simpleEvents = simpleEventsCompetition($COMPETITION_ID,$DB);
$extendedEvents = extendedEventsCompetition($COMPETITION_ID,$DB);

$allEvents = array_merge($simpleEvents,$extendedEvents);
$SQL = rankingsSQL($simpleEvents,$extendedEvents, array("registrations.competition_id " =>$COMPETITION_ID));

$result = pg_query($DB, $SQL);
$data = pg_fetch_all($result);


?>


<!DOCTYPE html>
<html>
<head>
    <style>
        table, th, td {
            border: 1px solid black;
        }
    </style>
</head>
<body>

<h2>COMPETITION</h2>
<p>Below is the results of this competition.</p>

<table style="width:100%" >

    <tr>
        <th>Name</th>
        <th>Rank</th>
        <th>Points</th>
        <?php foreach ($allEvents as $event) {?>
            <th><?php echo $event->name ?></th>
        <?php } ?>
    </tr>

    <?php foreach ($data as $object) {?>
        <tr>
        <?php foreach ($object as $property) {?>
            <td style="text-align:center"><?php echo $property ?></td>
        <?php } ?>
        </tr>
    <?php } ?>

</table>
</body>
</html>

