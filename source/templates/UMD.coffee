pathRelative = require('../pathRelative')
# todo: read javascript source and match with parser.
# todo: recognise define [], -> or require [], -> and adjust both node & browser amd accordingly
# todo: make node part really async with timeout
# todo: make unit tests

module.exports = (d)->
  pd = "       "
  """
    // generated by myRequire v#{d.version}, (C) AnoDyNoS 2012, License: MIT
    (function (root, factory) {
        if (typeof exports === 'object') {

              var makeRequire = require('myRequire').getMakeRequire();
              var asyncRequire = makeRequire('#{d.filePath}');
              module.exports = factory(asyncRequire#{
                # remove path logic from here - keep it a template only!
                (", require('#{pathRelative '$bundle/' + d.filePath, '$bundle/' + dep }')" for dep in d.deps).join('')

              });

        } else if (typeof define === 'function' && define.amd) {
            // AMD. Register as an anonymous module.
            define(['require'#{(", '#{dep}'" for dep in d.deps).join('')}], #{
            if d.rootExports # Adds browser/root globals if needed
              "function (require#{(', ' + par for par in d.args).join('')}) { \n" +
              "#{pd}   return (root.#{d.rootExports} = factory(require#{(', ' + par for par in d.args).join('')})); \n" +
              "#{pd} });"
            else
              'factory);'
            }
        }
    }(this, function(require#{ (", #{par}" for par in d.args).join ''}) {
        #{d.body}
    }));
 """

