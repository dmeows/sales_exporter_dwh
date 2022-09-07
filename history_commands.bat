:: make sure you have Python at least 3.6 and less than 3.10
:: Create and activate virtual environment
python -m venv .dbtenv

:: for mac/linux
:: source .dbtenv/bin/activate
call .dbtenv\Scripts\activate


:: install the dbt package you want
pip install dbt-bigquery
pip install sqlfluff

:: Requirements files are used to hold the result from pip freeze for the purpose of achieving Repeatable Installs. In this case, your requirement file contains a pinned version of everything that was installed when pip freeze was run.
pip freeze > requirements.txt


:: todo
:: sqlfluff
