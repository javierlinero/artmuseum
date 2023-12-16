import http from 'k6/http';
import { check, sleep } from 'k6';

export let options = {
    stages: [
        { duration: '30s', target: 5 },
        { duration: '1m', target: 5 },
        { duration: '30s', target: 0 },
    ],
    thresholds: {
        http_req_duration: ['p(95)<5000'], // 95% of requests should be below 5s
    },
};

const BASE_URL = 'http://puamdns.ddns.net';
const TOKENS = ['token1',
'token2',
'token3',
'token4',
'token 5']; // Replace with your tokens

export default function () {
    // Select a token for each VU
    const token = TOKENS[__VU - 1];

    const params = {
        headers: {
            'Authorization': `Bearer ${token}`,
        },
    };

    const numArt = 5;
    const response = http.get(`${BASE_URL}/tinder_for_art?numart=${numArt}`, params);

    check(response, {
        'is status 200': (r) => r.status === 200,
        'is num suggestions correct': (r) => r.json().length === numArt,
    });

    sleep(1); // Think time between requests
}
