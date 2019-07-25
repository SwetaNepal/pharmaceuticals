const fs = require('fs');
const pdfUtil = require('pdf-parse');

function matchPercentage(haystack, needles) {
    haystack = haystack.toLowerCase();
    if (needles.length < 1) return 0;

    let matches = 0;
    needles.forEach(needle => {
        if (haystack.indexOf(needle.trim()) !== -1) {
            matches++;
        }
    });

    return (matches / needles.length) * 100;
}

