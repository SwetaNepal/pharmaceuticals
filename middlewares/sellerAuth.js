module.exports = (req, res, next) => {
    if (req.userData.type !== 'seller'){
        req.flash('error', "Restricted access for that route.");
        res.redirect('/');
    } else {
        next();
    }
};