var Template = function(input) {
  if (input.source === null || input.source === undefined || typeof input.source !== 'string') {
    throw {
      name: 'TypeError',
      message: 'source must be a string'
    };
  }
  this.source = input.source;
};

Template.prototype = {
    render: function(variables) {
      var escapeHTML = function (text) {
        var character = {
          '<' : '&lt;',
          '>' : '&gt;',
          '&' : '&amp;',
          '"' : '&quot;'
        };

        return text.replace(/[<>&"]/g, function (c) {
          return character[c];
        });
      };

      return this.source.replace(/{%\s*(\w+)\s*%}/g, function (_, name) {
        return escapeHTML(variables[name]);
      });

    }
};
