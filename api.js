// api.js - خدمات الاتصال بالخادم
import axios from 'axios';

const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:3001/api';

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json'
  }
});

// إضافة interceptor لإضافة token للمصادقة
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export const getCourses = () => api.get('/courses');
export const createCourse = (courseData) => api.post('/courses', courseData);
export const enrollCourse = (courseId) => api.post(`/courses/${courseId}/enroll`);