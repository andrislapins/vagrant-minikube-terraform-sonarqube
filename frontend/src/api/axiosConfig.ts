
import axios, { AxiosInstance } from 'axios';

declare global {
    interface Window { __NGROK_URL__: string; }
}

const baseURL = window.__NGROK_URL__ || "http://localhost:8080";

console.log("Using API Base URL:", baseURL);

const apiClient: AxiosInstance = axios.create({
    baseURL: baseURL,
    headers: { "ngrok-skip-browser-warning": "true" }
});

export default apiClient;