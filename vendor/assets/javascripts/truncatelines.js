(function( $ ) {
$.fn.truncateLines = function(options) {
    options = $.extend($.fn.truncateLines.defaults, options);

    return this.each(function(index, container) {
        container = $(container);
        //var containerLineHeight = Math.ceil(parseFloat(container.css('line-height')));
        var containerLineHeight = 26;
        console.log('containerLineHeight: ', containerLineHeight);
        var maxHeight = options.lines * containerLineHeight;
        var truncated = false;
        var truncatedText = $.trim(container.text());
        var overflowRatio = container.height() / maxHeight;
        if (overflowRatio > 2) {
            truncatedText = truncatedText.substr(0, parseInt(truncatedText.length / (overflowRatio - 1), 10) + 1); // slice string based on how much text is overflowing
            container.text(truncatedText);
            truncated = true;
        }
        var oldTruncatedText; // verify that the text has been truncated, otherwise you'll get an endless loop
        while (container.height() > maxHeight && oldTruncatedText != truncatedText) {
            oldTruncatedText = truncatedText;
            truncatedText = truncatedText.replace(/\s.[^\s]*\s?$/, ''); // remove last word
            container.text(truncatedText);
            truncated = true;
        }
        if (truncated) {
            truncatedText = options.ellipsis ? truncatedText + ' ' + options.ellipsis : truncatedText;
            container.text(truncatedText);
            if (container.height() > maxHeight) {
                truncatedText = truncatedText.replace(/\s.[^\s]*\s?...$/, ''); // remove last word and ellipsis
                truncatedText = options.ellipsis ? truncatedText + ' ' + options.ellipsis : truncatedText;
                container.text(truncatedText);
            }
        }
    });
};
$.fn.truncateLines.defaults = {
    lines: 8,
    ellipsis: '...'
};
}( jQuery ));