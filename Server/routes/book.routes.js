const express = require("express");
const multer = require("multer");
const router = express.Router();
const bookController = require("../controllers/book.controller");
const reviewController = require("../controllers/review.controller");
const { verifyToken } = require("../middleware/auth.middleware");
const storage = multer.memoryStorage();
const bookUpload = multer({
  storage: storage,
  limits: {
    fileSize: 10 * 1024 * 1024 // 10MB limit
  }
});

// Create a new book
router.post(
  "/",
  verifyToken,
  bookUpload.single("coverImage"),
  bookController.createBook
);

// Get all books with optional filters
router.get("/", bookController.getAllBooks);

router.get("/my", verifyToken, bookController.getMyBooks);

// Update book
router.put("/:id", verifyToken, bookController.updateBook);

// Delete book
router.delete("/:id", verifyToken, bookController.deleteBook);

// Get book by ID
router.get("/:id", bookController.getBookById);

// Review routes for books
// Get reviews for a book
router.get("/:bookId/reviews", reviewController.getBookReviews);

// Create a new review for a book
router.post("/:bookId/reviews", verifyToken, reviewController.createReview);

// Update a review
router.put("/:bookId/reviews/:id", verifyToken, reviewController.updateReview);

// Delete a review
router.delete("/:bookId/reviews/:id", verifyToken, reviewController.deleteReview);

module.exports = router;
