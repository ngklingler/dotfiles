import requests

url = 'https://endpoint.com/whatever.json'
myobj = {'data': 'value'}
x = requests.post(url, data=myobj)
print(x.text)
