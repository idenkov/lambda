FROM python:3

ENV AWS_SECRET_ACCESS_ID=$AWS_SECRET_ACCESS_ID
ENV AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY 

ADD python-app /

RUN pip install -r requirments.txt

CMD [ "python", "rds-details.py" ]

