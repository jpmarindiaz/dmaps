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
        document.getElementById(el.id).appendChild(css);

        var title = document.createElement("h2");
        title.setAttribute("id", "title");
        title.innerHTML = x.settings.title.text;
        document.getElementById(el.id).insertBefore(title, el.childNodes[0]);

        var width = el.offsetWidth;
        var height = el.offsetHeight;

        vizId = el.id;


        // console.log("SETTINGS:\n", x.settings);
        // console.log("DATA:\n", x.data);
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
            bubbleBorderWidth: usrOpts.bubbleBorderWidth || 2,
            bubbleBorderColor: usrOpts.bubbleBorderColor || '#889C95',
            bubbleFillOpacity: usrOpts.bubbleFillOpacity || 0.5,
            bubbleHighlightOnHover: usrOpts.bubbleHighlightOnHover || true,
            bubbleHighlightFillColor: usrOpts.bubbleHighlightFillColor || '#ADC7BE',
            bubbleHighlightBorderColor: usrOpts.bubbleHighlightBorderColor || '#C3E2D9',
            bubbleHighlightBorderWidth: usrOpts.bubbleHighlightBorderWidth || 5,
            bubbleHighlightFillOpacity: usrOpts.bubbleHighlightFillOpacity || 0.85,
            minSizeFactor: usrOpts.minSizeFactor || 5,
            maxSizeFactor: usrOpts.maxSizeFactor || 50
        };


        var getProjection = function(projectionName, projectionOpts, element) {
            // console.log("projection: ", projectionName, projectionOpts)
            if (projectionName == "equirectangular") {
                var projection = d3.geo.equirectangular()
                    .center(projectionOpts.center)
                    .rotate(projectionOpts.rotate)
                    .scale(projectionOpts.scale * element.offsetWidth)
                    .translate([element.offsetWidth / 2 + projectionOpts.translate[0], element.offsetHeight / 2 + projectionOpts.translate[1]]);
                return (projection)
            }
            if (projectionName == "mercator") {
                var projection = d3.geo.mercator()
                    .center(projectionOpts.center)
                    .rotate(projectionOpts.rotate)
                    .scale(projectionOpts.scale * element.offsetWidth)
                    .translate([element.offsetWidth / 2 + projectionOpts.translate[0], element.offsetHeight / 2 + projectionOpts.translate[1]]);
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
                    .translate([element.offsetWidth / 2 + projectionOpts.translate[0], element.offsetHeight / 2 + projectionOpts.translate[1]]);
                return (projection)
            }
            if (projectionName == "orthographic") {
                var projection = d3.geo.orthographic()
                    .scale(projectionOpts.scale * element.offsetWidth)
                    .clipAngle(projectionOpts.clipAngle)
                    .rotate(projectionOpts.rotate)
                    .center(projectionOpts.center)
                    .translate([element.offsetWidth / 2 + projectionOpts.translate[0], element.offsetHeight / 2 + projectionOpts.translate[1]]);

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
                    .precision(projectionOpts.precision)
                    .scale(projectionOpts.scale * element.offsetWidth)
                    .translate([element.offsetWidth / 2 + projectionOpts.translate[0], element.offsetHeight / 2 + projectionOpts.translate[1]]);
                return (projection)
            }
            null
        };

        var data = x.data;

        // console.log("SCALING")
        // console.log(data.bubblesData)
        // console.log(opts)
        if (data.bubblesData) {
            if (data.bubblesData.radius) {
                // console.log("height",width)
                var minSize = opts.minSizeFactor * width / 100 | 1;
                var maxSize = opts.maxSizeFactor * width / 100 | 50;
                var originalRadius = data.bubblesData.radius;
                // console.log(minSize,maxSize)
                // console.log("SCALING")
                // console.log([d3.min(originalRadius), 
                //         d3.max(originalRadius)])
                if (d3.min(originalRadius) != d3.max(originalRadius)) {
                    var scale = d3.scale.sqrt()
                        .domain([d3.min(originalRadius),
                            d3.max(originalRadius)
                        ])
                        .range([minSize / 2, maxSize / 2]);
                    var rs = new Array;
                    for (i in originalRadius) {
                        rs.push(scale(originalRadius[i]));
                    }
                    data.bubblesData.radius = rs;
                    // console.log(data.bubblesData)
                }
            }
        }

        var getFills = function(data, opts) {
            if (data.fillKeys.length == 0) return ({
                defaultFill: opts.defaultFill
            })
            return (data.fillKeys)
        }

        // console.log("Opts: ", opts)

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


                // console.log("PROJ",opts.projectionName, opts.projectionOpts)
                var projection = getProjection(opts.projectionName, opts.projectionOpts, element);
                var path = d3.geo.path()
                    .projection(projection);

                return {
                    path: path,
                    projection: projection
                };
            },
            fills: getFills(data, opts),
            data: data.fills,
            bubblesConfig: {
                // borderWidth: 2,
                // borderColor: '#FFFFFF',
                // popupOnHover: true,
                // popupTemplate: function(geography, data) {
                //     return '<div class="hoverinfo"><strong>' + data.name + '</strong></div>';
                // },
                // fillOpacity: 0.75,
                // highlightOnHover: true,
                // highlightFillColor: '#FC8D59',
                // highlightBorderColor: 'rgba(250, 15, 160, 0.2)',
                // highlightBorderWidth: 2,
                // highlightFillOpacity: 0.85
            },
            arcConfig: {
                strokeColor: '#B8CDB9',
                strokeWidth: 1,
                arcSharpness: 1,
                animationSpeed: 600
            },
            done: function(datamap) {
                // console.log("datamap", datamap)
                // console.log("zoomable", datamap.options.zoomable)
                if (!datamap.options.zoomable) {
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

        // http://jsbin.com/abeXErat/21/edit?html,output
        // https://github.com/markmarkoh/datamaps/issues/45

        // function addLegend2(layer, data, options) {
        //     data = data || {};
        //     if (!this.options.fills) {
        //         return;
        //     }

        //     var html = '<ul class="list-inline">';
        //     var label = '';
        //     if (data.legendTitle) {
        //         html = '<h3>' + data.legendTitle + '</h3>' + html;
        //     }
        //     for (var fillKey in this.options.fills) {

        //         if (fillKey === 'defaultFill') {
        //             if (!data.defaultFillName) {
        //                 continue;
        //             }
        //             label = data.defaultFillName;
        //         } else {
        //             if (data.labels && data.labels[fillKey]) {
        //                 label = data.labels[fillKey];
        //             } else {
        //                 label = fillKey;
        //             }
        //         }
        //         html += '<li class="key" style="border-top-color:' + this.options.fills[fillKey] + '">' + label + '</li>'
        //     }
        //     html += '</ul>';

        //     var hoverover = d3.select(this.options.element).append('div')
        //         .attr('class', 'datamaps-legend')
        //         .html(html);
        // }



        function addColorLegend(layer, data, options) {
            data = data || {};

            var cells = data.cells || 6;
            var orient = data.orient || "vertical";
            var title = data.legendTitle;

            var legendDomain = x.data.legendData.key;
            var legendRange = x.data.legendData.keyColor;
            // console.log("DOMAIN", legendDomain, "\nRange", legendRange)


            var linear = d3.scale.linear()
                .domain(legendDomain)
                .range(legendRange);

            d3.select(this.options.element)
                .append('div')
                .style("z-index",1002)
                .style("position","absolute")
                .attr("id","dmapLegend")
                .append("svg");

            var legend = d3.select("#dmapLegend svg");

            legend.append("g")
                .attr("class", "legendLinear")
                .attr("transform", "translate(0,20)");

            var legendLinear = d3.legend.color()
                .shapeWidth(30)
                .cells(cells)
                // .cells([1,2,4,8,30])
                .title(title)
                .orient(orient)
                .scale(linear);

            legend.select(".legendLinear")
                .call(legendLinear);

            d3.select(".legendCells").attr("transform", "translate(0,5)");

            var svgSize = d3.select("#dmapLegend svg g").node().getBoundingClientRect();
            d3.select("#dmapLegend svg").attr("width",svgSize.width+10)
            d3.select("#dmapLegend svg").attr("height",svgSize.height+10)
        }

        map.addPlugin("mylegend", addLegend3);

        console.log(usrOpts.legend.title)

        if (usrOpts.showLegend) {
            map.mylegend({
                legendTitle: usrOpts.legend.title || "",
                defaultFillName: usrOpts.legend.defaultFillTitle,
                labels: data.fillKeyLabels
            })
        }

        data.bubblesData = HTMLWidgets.dataframeToD3(data.bubblesData);
        // console.log("bubbles: ", data.bubblesData)

        if (data.bubblesData.length) {

            map.bubbles(
                data.bubblesData, {
                    borderWidth: opts.bubbleBorderWidth,
                    borderColor: opts.bubbleBorderColor,
                    fillOpacity: opts.bubbleFillOpacity,
                    highlightOnHover: opts.bubbleHighlightOnHover,
                    highlightFillColor: opts.bubbleHighlightFillColor,
                    highlightBorderColor: opts.bubbleHighlightBorderColor,
                    highlightBorderWidth: opts.bubbleHighlightBorderWidth,
                    highlightFillOpacity: opts.bubbleHighlightFillOpacity,
                    popupOnHover: true,
                    popupTemplate: function(geo, data) {
                        // return "<div class='hoverinfo'>" + data.name + "";
                        // console.log(data)
                        var info = null;
                        if (data) {
                            info = data.info || ""
                        }
                        var htmlInfo = info || ""
                        return '<div class="hoverinfo">' + htmlInfo
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


        var notes = document.createElement("p");
        notes.setAttribute("id", "notes");
        notes.innerHTML = x.settings.notes.text;
        document.getElementById(el.id).appendChild(notes);

    }
});
