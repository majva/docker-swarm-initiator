FROM python:3.7-alpine
WORKDIR /code
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
EXPOSE 9000
COPY . .
CMD ["python3", "/code/src/serverapp.py"]