import * as blogService from "./blog.service.js";

export const createBlog = async (req, res, next) => {
  try {
    const response = await blogService.createBlog(req);
    return res.status(response.statusCode).json(response);
  } catch (error) {
    next(error);
  }
};

export const getAllBlogs = async (req, res, next) => {
  try {
    const response = await blogService.getAllBlogs();
    return res.status(response.statusCode).json(response);
  } catch (error) {
    next(error);
  }
};

export const getBlogById = async (req, res, next) => {
  try {
    const response = await blogService.getBlogById(req.params.id);
    return res.status(response.statusCode).json(response);
  } catch (error) {
    next(error);
  }
};

export const updateBlog = async (req, res, next) => {
  try {
    const response = await blogService.updateBlog(req);
    return res.status(response.statusCode).json(response);
  } catch (error) {
    next(error);
  }
};

export const deleteBlog = async (req, res, next) => {
  try {
    const response = await blogService.deleteBlog(req.params.id);
    return res.status(response.statusCode).json(response);
  } catch (error) {
    next(error);
  }
};