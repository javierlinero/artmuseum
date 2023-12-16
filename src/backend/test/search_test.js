import http from 'k6/http';
import { check, sleep } from 'k6';

export let options = {
    stages: [
        { duration: '30s', target: 20 },
        { duration: '1m', target: 20 },
        { duration: '30s', target: 0 },
    ],
    thresholds: {
        'http_req_duration': ['p(95)<1500'],
    },
};

const BASE_URL = 'http://puamdns.ddns.net/search';
const QUERIES = ['Table', 'John', 'Print', 'Teeth', 'Skull'];
const YEARS = [1500, 1600, 1700, 1800, 1900, 2000];
const LIMITS = [10, 20, 30, 40, 50];
const OFFSETS = [0, 10, 20, 30, 40];

export default function () {
    // Randomly select query, year, limit, and offset
    let query = QUERIES[Math.floor(Math.random() * QUERIES.length)];
    let year = YEARS[Math.floor(Math.random() * YEARS.length)];
    let limit = LIMITS[Math.floor(Math.random() * LIMITS.length)];
    let offset = OFFSETS[Math.floor(Math.random() * OFFSETS.length)];

    let payload = JSON.stringify({
        query: query,
        year: year,
        limit: limit,
        offset: offset
    });

    let params = {
        headers: {
            'Content-Type': 'application/json',
        },
    };

    let response = http.post(BASE_URL, payload, params);

    check(response, {
        'is status 200': (r) => r.status === 200,
        'is not error': (r) => !r.body.includes('error'),
    });

    sleep(1);
}
