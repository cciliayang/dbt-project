
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.utils.dates import days_ago

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
}

dag = DAG(
    'dbt_project_dag',
    default_args=default_args,
    description='A simple dbt Airflow DAG',
    schedule_interval='@daily',
    start_date=days_ago(1),
    catchup=False,
)


# Task to run staging models
run_staging = BashOperator(
    task_id='run_staging',
    bash_command='dbt run --models staging',
    dag=dag,
)

# Task to run intermediate models
run_intermediate = BashOperator(
    task_id='run_intermediate',
    bash_command='dbt run --models intermediate',
    dag=dag,
)

# Task to run marts models
run_marts = BashOperator(
    task_id='run_marts',
    bash_command='dbt run --models marts',
    dag=dag,
)

# Order of task execution
run_staging >> run_intermediate >> run_marts
