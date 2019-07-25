const router = require('express').Router();
const jwt = require('jwt-then');
const moment = require('moment');
const userController = require('../controllers/userController');
const medicineController = require('../controllers/medicineController');
const auth = require('../middlewares/auth');

router.get('/',async (req, res) => {
    const medicines = await poolQuery("SELECT * FROM medicines", []);
    res.render('index', {
        medicines
    });
});

router.get('/login', userController.loginPage);

router.post('/login', userController.login)

router.post('/register', userController.register);

router.get('/logout', userController.logout);

router.post('/medicines/order', medicineController.placeOrder);

module.exports = router;