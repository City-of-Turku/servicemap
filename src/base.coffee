define ->
    mixOf: (base, mixins...) ->
        class Mixed extends base
            for mixin in mixins by -1 # earlier mixins override later ones
                for name, method of mixin::
                    Mixed::[name] = method
            Mixed

    resolveImmediately: ->
        $.Deferred().resolve().promise()

    withDeferred: (callback) ->
        deferred = $.Deferred()
        callback deferred
        deferred.promise()

    pad: (number) ->
        str = "" + number
        pad = "00000"
        pad.substring(0, pad.length - str.length) + str

    getIeVersion: () ->
        # From https://codepen.io/gapcode/pen/vEJNZN
        # courtesy of Mario

        ua = window.navigator.userAgent
        # Test values; Uncomment to check result …
        # IE 10
        # ua = 'Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.2; Trident/6.0)';
        # IE 11
        # ua = 'Mozilla/5.0 (Windows NT 6.3; Trident/7.0; rv:11.0) like Gecko';
        # Edge 12 (Spartan)
        # ua = 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.71 Safari/537.36 Edge/12.0';
        # Edge 13
        # ua = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2486.0 Safari/537.36 Edge/13.10586';
        msie = ua.indexOf 'MSIE '
        if msie > 0
            # IE 10 or older => return version number
            return parseInt ua.substring(msie + 5, ua.indexOf('.', msie)), 10

        trident = ua.indexOf 'Trident/'
        if trident > 0
            # IE 11 => return version number
            rv = ua.indexOf 'rv:'
            return parseInt ua.substring(rv + 3, ua.indexOf('.', rv)), 10

        edge = ua.indexOf 'Edge/'
        if edge > 0
            # Edge (IE 12+) => return version number
            return parseInt ua.substring(edge + 5, ua.indexOf('.', edge)), 10
        # other browser
        false
        matches = new RegExp(" MSIE ([0-9]+)\\.([0-9])").exec window.navigator.userAgent
        return parseInt matches[1]

    getLangURL: (code) ->
        languageSubdomain:
            fi: 'palvelukartta'
            sv: 'servicekarta'
            en: 'servicemap'
        href = window.location.href
        if href.match /^http[s]?:\/\/[^.]+\.hel\..*/
            return href.replace /\/\/[^.]+./, "//#{code}."
        else
            return href
