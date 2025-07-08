import axios from "axios";

// Mock axios instance
const mockAxiosInstance = {
  get: jest.fn(),
  post: jest.fn(),
  put: jest.fn(),
  delete: jest.fn(),
  patch: jest.fn(),
};

// Mock axios.create
axios.create = jest.fn(() => mockAxiosInstance);

// Mock axios methods
axios.get = jest.fn();
axios.post = jest.fn();
axios.put = jest.fn();
axios.delete = jest.fn();
axios.patch = jest.fn();

// Helper functions for common mock responses
export const mockAxiosResponse = (data, status = 200, statusText = "OK") => ({
  data,
  status,
  statusText,
  headers: {},
  config: {},
});

export const mockAxiosError = (message, status = 400, data = {}) => {
  const error = new Error(message);
  error.response = {
    data,
    status,
    statusText: "Bad Request",
  };
  return error;
};

export const clearAxiosMocks = () => {
  jest.clearAllMocks();
  mockAxiosInstance.get.mockClear();
  mockAxiosInstance.post.mockClear();
  mockAxiosInstance.put.mockClear();
  mockAxiosInstance.delete.mockClear();
  mockAxiosInstance.patch.mockClear();
};

export { mockAxiosInstance };
