from airflow.sdk import dag, task

@dag
def orchestrate():

    @task
    def ingest_cdc():
        return "CDC data ingested!"

    @task
    def clean_silver():
        return "Cleaned data!"

    ingest_cdc() >> clean_silver()

orchestrate_dag = orchestrate()