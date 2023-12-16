import http from 'k6/http';
import { check, sleep } from 'k6';

export let options = {
    stages: [
        { duration: '30s', target: 20 },
        { duration: '1m', target: 20 },
        { duration: '30s', target: 0 },
    ],
    thresholds: {
        'http_req_duration': ['p(95)<500'],
    },
};

const BASE_URL = 'http://puamdns.ddns.net/art_info';

function randomArtId(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

export default function () {
    let artId = randomArtId(10000, 20000);
    let response = http.get(`${BASE_URL}?artid=${artId}`);

    check(response, {
        'is status 200': (r) => r.status === 200,
        'is not error': (r) => !r.body.includes('error'),
    });

    sleep(1);
}
