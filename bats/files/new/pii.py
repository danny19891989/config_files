import requests

url = 'https://instagram.com/'

headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:133.0) Gecko/20100101 Firefox/133.0',
}

try:
    response = requests.get(url, headers=headers, timeout=3)
    print(f'\nresponse status code: {response.status_code}')
except requests.exceptions.Timeout:
    print('\nno response!')
except requests.exceptions.ConnectionError:
    print('\ncheck your net!')

