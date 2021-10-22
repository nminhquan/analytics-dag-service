from dagster import pipeline, solid, sensor, repository, daily_schedule
import datetime


@solid
def extract():
    return "extracted data from RDS source"

@solid
def transform(data: str):
    return f"transformed {data} from RDS source"


@solid
def send_slack(context, name: str):
    context.log.info(f"Sending report , {name}!")


@pipeline
def report_pipeline():
    data = extract();
    send_slack(transform(data))

@daily_schedule(
    pipeline_name="report_pipeline",
    start_date=datetime.datetime(2021, 6, 21),
    execution_time=datetime.time(11, 0),
    execution_timezone="US/Central",
)
def my_daily_schedule(date):
    return {"solids": {"process_data_for_date": {"config": {"date": date.strftime("%Y-%m-%d")}}}}


@repository
def my_repository():
    return [
        report_pipeline,
    ]