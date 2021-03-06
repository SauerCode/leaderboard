# Leaderboard

Name : Alexandru Sauer  
Student number : 300026641

## ER model :

![](ER-model.png)

## Schema Model :

![](Schema-model.png)

## Running :

#### 1) Create Database ####

Create a ***PostgreSQL*** database using any sofware or interface such as *DataGrip* or *Postico*.

#### 2) Run migrations ####

Execute the migrations in order using transactions mechanism. Currently, there is only one migration file.
The migrations are located in the following directory : ***/db/Migrations***.  


#### 3) Execute Seed ####

Fill up the databse with data using the file ***seeds.sql*** found in the ***/db*** directory. Use a single transaction if possible.


#### 4) Install PHP ####

Install PHP on your machine.

#### 5) Setting up PHP file ####

Open the file called ***main.php*** found in the current directory. At line three, change **dbname** to the name of the database you created.

```
$DB = pg_connect("host=localhost port=5432 dbname=[REPLACE_WITH_YOUR_DB_NAME]");
```

#### 6) Run PHP server ####

Run PHP server using any software you want.


#### Info ####

The ***main.php*** is currently displaying the rankings for the competition with the *ID* 10.
To see the rankings for another competition, go at line 274 and change the value of the variable **$COMPETITION_ID**.
```
$COMPETITION_ID = 10;
```


