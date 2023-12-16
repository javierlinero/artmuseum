import http from 'k6/http';
import { check, sleep } from 'k6';

export let options = {
    stages: [
        { duration: '2m', target: 1 }
    ],
};

const BASE_URL = 'http://puamdns.ddns.net/tinder_for_art';
const BEARER_TOKEN = 'token'; // Replace with your actual bearer token

let artId = 10000;
let ratings = [-1, 0, 1];
let currentRatingIndex = 0;

function nextArtworkRating() {
    let rating = ratings[currentRatingIndex];
    currentRatingIndex = (currentRatingIndex + 1) % ratings.length;
    return rating;
}

export default function () {
    let rating = nextArtworkRating();
    let payload = {
        artid: artId.toString(),
        rating: rating.toString(),
    };
    let params = {
        headers: {
            'Authorization': `Bearer ${BEARER_TOKEN}`,
            'Content-Type': 'application/x-www-form-urlencoded',
        },
    };

    let response = http.post(BASE_URL, payload, params);

    if (response.status !== 200) {
        console.error(`Request failed. Status: ${response.status}, Error: ${response.error}, URL: ${response.url}, Body: ${response.body}`);
    }

    artId++;
}
