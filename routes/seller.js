const router = require('express').Router();
const sellerController = require('../controllers/sellerController');
const auth = require('../middlewares/auth');
const employeeAuth = require('../middlewares/sellerAuth');

module.exports = router;