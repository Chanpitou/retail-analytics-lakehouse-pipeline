import os
from airflow.sdk import dag, task
from datetime import datetime, timedelta
from databricks.sdk import WorkspaceClient
from databricks.sdk.service.jobs import RunLifeCycleState, RunResultState
import time


default_args = {
    'owner': 'umchanpitou@gmail.com',
    'retries': 2,
    'retry_delay': timedelta(minutes=5),
}

@dag(
    dag_id='Pipeline_Orchestration',
    default_args=default_args,
    description='Pipeline_Orchestration_DAG',
    start_date=datetime(2026, 7, 20),
    schedule="@daily"
)
def orchestrate():
    @task
    def ingest_cdc():
        ws = WorkspaceClient(
            host=os.getenv('HOST_DATABRICKS'),
            token=os.getenv('TOKEN_DATABRICKS')
        )

        job_trigger = ws.jobs.run_now(job_id=int(os.getenv('JOB_ID')))

        while True:
            job_run = ws.jobs.get_run(job_trigger.run_id)

            if job_run.state.life_cycle_state in [RunLifeCycleState.TERMINATED, RunLifeCycleState.SKIPPED,
                                                  RunLifeCycleState.INTERNAL_ERROR]:
                if job_run.state.result_state == RunResultState.SUCCESS:
                    print("Job completed successfully!")
                    break
                else:
                    raise Exception(f"Job failed with state: {job_run.state.result_state}")

            time.sleep(5)  # Wait for 5 seconds before checking the job status again

        return "CDC Ingestion Completed"

    @task.bash
    def dbt_clean():
        return "cd /opt/airflow/retail_dbt_project/ && dbt clean"

    @task.bash
    def dbt_source_freshness():
        return "cd /opt/airflow/retail_dbt_project/ && dbt source freshness"

    @task.bash
    def dbt_run_silver_models():
        return "cd /opt/airflow/retail_dbt_project/ && dbt run -s silver"

    @task.bash
    def dbt_data_quality_tests():
        return "cd /opt/airflow/retail_dbt_project/ && dbt test"

    @task.bash
    def dbt_snapshots():
        return "cd /opt/airflow/retail_dbt_project/ && dbt snapshot"

    @task.bash
    def dbt_run_gold_star_schema():
        return "cd /opt/airflow/retail_dbt_project/ && dbt run -s gold"

    # send_email_completion = EmailOperator(
    #     task_id='send_email_completion',
    #     to='umchanpitou@gmail.com',
    #     subject='DAG Complete: Success!',
    #     html_content='<p>Airflow DAG Run Successfully Completed!</p>',
    # )

    ingest_cdc() >> dbt_clean() >> dbt_source_freshness() >> dbt_run_silver_models() >> dbt_data_quality_tests() >> dbt_snapshots() >> dbt_run_gold_star_schema()
    # ingest_cdc() >> dbt_clean()
orchestrate_dag = orchestrate()