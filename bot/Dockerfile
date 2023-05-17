FROM python:3.9-slim-buster
WORKDIR /app

COPY ./bot ./bot
RUN pip install -r bot/requirements.txt

CMD ["python3", "-m", "bot.app"]