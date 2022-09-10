:: Initiate at the first time

:: Create python venv and activate
python -m venv .dbtenv
call .dbtenv\Scripts\activate

:: Install python libraries
pip install dbt-bigquery
pip install sqlfluff

:: Requirements files are used to hold the result from pip freeze for the purpose of achieving Repeatable Installs. In this case, your requirement file contains a pinned version of everything that was installed when pip freeze was run.
pip freeze > requirements.txt

:: Initiate DBT
dbt init
dbt deps

:: todo
:: sqlfluff
