HTMLWidgets.widget({

    name: "dmaps",
    type: "output",

    initialize: function(el, width, height) {},

    resize: function(el, width, height, instance) {},

    renderValue: function(el, x, instance) {
        d3.select(el).selectAll("*").remove()

        var css = document.createElement("style");
        css.type = "text/css";
        css.innerHTML = x.settings.styles;
        // css.innerHTML = "body {background-color:black; color: red}"
        document.body.appendChild(css);



        vizId = el.id;

        console.log("SETTINGS:\n", x.settings);
        console.log("DATA:\n", x.data);
        var usrOpts = x.settings;
        var dmap = x.dmap;

        var opts = {
            scope: dmap.scope,
            dataUrl: dmap.path,
            zoomable: usrOpts.zoomable || false,
            geographyName: dmap.geographyName,
            projectionName: usrOpts.projection,
            projectionOpts: usrOpts.projectionOpts,
            // projectionCenter: dmap.projection.center,
            // projectionRotate: dmap.projection.rotate,
            // scale: usrOpts.scale || dmap.projection.scale,
            // translateX: usrOpts.translateX || 0,
            // translateY: usrOpts.translateY || 0,
            defaultFill: usrOpts.defaultFill || '#0C9EB2',
            borderColor: usrOpts.borderColor || '#F3F5FF',
            borderWidth: usrOpts.borderWidth || 0.5,
            highlightFillColor: usrOpts.highlightFillColor || '#516a52',
            highlightBorderColor: usrOpts.highlightBorderColor || '#279945',
            highlightBorderWidth: usrOpts.highlightBorderWidth || 0,
        };

        var getProjection = function(projectionName, projectionOpts, element) {
            // console.log("projection: ", projectionName, projectionOpts)
            if (projectionName == "equirectangular") {
                var projection = d3.geo.equirectangular()
                    .center(projectionOpts.center)
                    .rotate(projectionOpts.rotate)
                    .scale(projectionOpts.scale * element.offsetWidth)
                    .translate([element.offsetWidth / 2 + projectionOpts.translateX, element.offsetHeight / 2 + projectionOpts.translateY]);
                return (projection)
            }
            if (projectionName == "mercator") {
                var projection = d3.geo.mercator()
                    .center(projectionOpts.center)
                    .rotate(projectionOpts.rotate)
                    .scale(projectionOpts.scale * element.offsetWidth)
                    .translate([element.offsetWidth / 2 + projectionOpts.translateX, element.offsetHeight / 2 + projectionOpts.translateY]);
                return (projection)
            }
            if (projectionName == "albers") {
                var projection = d3.geo.albers()
                    // .scale(projectionOpts.scale)
                    .scale(projectionOpts.scale * element.offsetWidth)
                    .rotate(projectionOpts.rotate)
                    .center(projectionOpts.center)
                    .parallels(projectionOpts.parallels)
                    // .translate(projectionOpts.translate);
                    .translate([element.offsetWidth / 2 + projectionOpts.translateX, element.offsetHeight / 2 + projectionOpts.translateY]);
                return (projection)
            }
            if (projectionName == "orthographic") {
                var projection = d3.geo.orthographic()
                    .scale(projectionOpts.scale * element.offsetWidth)
                    .clipAngle(projectionOpts.clipAngle)
                    .rotate(projectionOpts.rotate)
                    .center(projectionOpts.center)
                    .translate([element.offsetWidth / 2 + projectionOpts.translateX, element.offsetHeight / 2 + projectionOpts.translateY]);

                return (projection)
            }
            if (projectionName == "satellite") {
                var projection = d3.geo.satellite()
                    .scale(projectionOpts.scale)
                    .distance(projectionOpts.distance)
                    .rotate(projectionOpts.rotate)
                    .center(projectionOpts.center)
                    .tilt(projectionOpts.tilt)
                    .clipAngle(projectionOpts.clipAngle)
                    .precision(projectionOpts.precision);
                // .scale(projectionOpts.scale * element.offsetWidth)
                // .translate([element.offsetWidth / 2 + projectionOpts.translateX, element.offsetHeight / 2 + projectionOpts.translateY]);

                return (projection)
            }
            null
        };

        var data = x.data;

        console.log("Opts: ", opts)

        var map = new Datamap({
            element: document.getElementById(vizId),
            geographyConfig: {
                borderColor: opts.borderColor,
                borderWidth: opts.borderWidth,
                highlightFillColor: opts.highlightFillColor,
                highlightBorderColor: opts.highlightBorderColor,
                highlightBorderWidth: opts.highlightBorderWidth,
                dataUrl: opts.dataUrl,
                popupTemplate: function(geography, data) {
                    // console.log(data)
                    var info = null;
                    if (data) {
                        info = data.info || geography.properties[opts.geographyName]
                    }
                    var htmlInfo = info || geography.properties[opts.geographyName]
                    return '<div class="hoverinfo">' + htmlInfo
                },
            },
            scope: opts.scope,
            responsive: true,
            setProjection: function(element) {
                var projection = getProjection(opts.projectionName, opts.projectionOpts, element);
                var path = d3.geo.path()
                    .projection(projection);

                return {
                    path: path,
                    projection: projection
                };
            },
            fills: data.fillKeys,
            data: data.fills,
            bubblesConfig: {
                borderWidth: 2,
                borderColor: '#FFFFFF',
                popupOnHover: true,
                popupTemplate: function(geography, data) {
                    return '<div class="hoverinfo"><strong>' + data.name + '</strong></div>';
                },
                fillOpacity: 0.75,
                highlightOnHover: true,
                highlightFillColor: '#FC8D59',
                highlightBorderColor: 'rgba(250, 15, 160, 0.2)',
                highlightBorderWidth: 2,
                highlightFillOpacity: 0.85
            },
            arcConfig: {
                strokeColor: '#B8CDB9',
                strokeWidth: 1,
                arcSharpness: 1,
                animationSpeed: 600
            },
            done: function(datamap) {
                console.log("datamap",datamap)
                console.log("zoomable",datamap.options.zoomable)
                if(!datamap.options.zoomable){
                    return null
                }
                // https://github.com/markmarkoh/datamaps/pull/122
                datamap.svg.call(d3.behavior.zoom().on("zoom", redraw));
                function redraw() {
                    var prefix = '-webkit-transform' in document.body.style ?
                        '-webkit-' : '-moz-transform' in document.body.style ?
                        '-moz-' : '-ms-transform' in document.body.style ?
                        '-ms-' : '';
                    var x = d3.event.translate[0];
                    var y = d3.event.translate[1];
                    datamap.svg.selectAll("g")
                        .style(prefix + 'transform',
                            'translate(' + x + 'px, ' + y + 'px) scale(' + (d3.event.scale) + ')');
                }
            },
            zoomable: opts.zoomable

        });

        if (usrOpts.graticule) {
            map.graticule();
        }

        if (usrOpts.legend) {
            map.legend({
                legendTitle: usrOpts.legendTitle || "",
                defaultFillName: usrOpts.legendDefaultFillTitle,
            })
        }

        if (data.bubblesData.length) {
            map.bubbles(
                data.bubblesdata, {
                    borderWidth: 2,
                    // borderColor: '#ff6a37',
                    popupOnHover: true,
                    fillOpacity: 0.5,
                    highlightOnHover: true,
                    highlightFillColor: '#38fc65',
                    // highlightBorderColor: '#760143',
                    highlightBorderWidth: 5,
                    highlightFillOpacity: 0.85,
                    popupTemplate: function(geo, data) {
                        return "<div class='hoverinfo'>" + data.name + "";
                    }
                });
        }





        //sample of the arc plugin

        //bubbles, custom popup on hover template

        //make responsive
        //alternatively with d3
        d3.select(window).on('resize', function() {
            map.resize();
        });



    }
});
