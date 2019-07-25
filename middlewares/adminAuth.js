module.exports = (req, res, next) => {
    if (req.userData.type !== 'admin') {
        req.flash('error', "Restricted access for that route.");
        res.redirect('/');
    } else {
        next();
    }
};