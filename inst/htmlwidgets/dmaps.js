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


        // // THIS IS FACTOR SCALING FOR BUBBLES (Bubbles as % for mobile)
        // if (data.bubblesData) {
        //     if (data.bubblesData.radius) {
        //         // console.log("height",width)
        //         var minSize = opts.minSizeFactor * width / 100 | 1;
        //         var maxSize = opts.maxSizeFactor * width / 100 | 50;
        //         var originalRadius = data.bubblesData.radius;
        //         // console.log(minSize,maxSize)
        //         // console.log("SCALING")
        //         // console.log([d3.min(originalRadius), 
        //         //         d3.max(originalRadius)])
        //         if (d3.min(originalRadius) != d3.max(originalRadius)) {
        //             var scale = d3.scale.sqrt()
        //                 .domain([d3.min(originalRadius),
        //                     d3.max(originalRadius)
        //                 ])
        //                 .range([minSize / 2, maxSize / 2]);
        //             var rs = new Array;
        //             for (i in originalRadius) {
        //                 rs.push(scale(originalRadius[i]));
        //             }
        //             data.bubblesData.radius = rs;
        //             // console.log(data.bubblesData)
        //         }
        //     }
        // }

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



        function addChoroLegend(layer, data, options) {
            data = data || {};

            ;
            var orient = data.orient || "vertical";
            var title = data.legendTitle;
            var top = data.top.toString().concat("%") || "1%";
            var left = data.left.toString().concat("%") || "1%";
            var shapeWidth = data.shapeWidth || 30;

            var type = data.type || "categorical"

            var legendDomain = x.data.legendData.key;
            var legendRange = x.data.legendData.keyColor;

            var cells = data.cells || Math.min(legendDomain.length, 6);
            // console.log("DOMAIN", legendDomain, "\nRange", legendRange)
            // console.log("DOMAIN", legendDomain, "\nRange", legendRange)


            if (type == "numeric") {
                var scale = d3.scale.linear()
                    .domain(legendDomain)
                    .range(legendRange);
            }

            if (type == "categorical") {
                var scale = d3.scale.ordinal()
                    .domain(legendDomain)
                    .range(legendRange);
            }


            d3.select(this.options.element)
                .append('div')
                .style("z-index", 1002)
                .style("position", "absolute")
                .style("top", top)
                .style("left", left)
                .attr("id", "dmapLegend")
                .append("svg");

            var legend = d3.select("#dmapLegend svg");

            legend.append("g")
                .attr("class", "legendLinear")
                .attr("transform", "translate(10,10)");

            var legendLinear = d3.legend.color()
                .shapeWidth(shapeWidth)
                .cells(cells)
                .title(title)
                .orient(orient)
                .scale(scale);

            legend.select(".legendLinear").call(legendLinear);

            d3.select(".legendCells").attr("transform", "translate(0,5)");

            var svgSize = d3.select("#dmapLegend svg g").node().getBoundingClientRect();
            d3.select("#dmapLegend svg").attr("width", svgSize.width + 20)
            d3.select("#dmapLegend svg").attr("height", svgSize.height + 10)
        }

        map.addPlugin("mylegend", addChoroLegend);






        console.log("choroLegend\n", usrOpts.choroLegend)
        if (usrOpts.choroLegend.show) {
            map.mylegend(usrOpts.choroLegend)
        }

        data.bubblesData = HTMLWidgets.dataframeToD3(data.bubblesData);
        // console.log("bubbles: ", data.bubblesData)


        function addBubbleColorLegend(layer, data, options) {
            data = data || {};

            var cells = data.cells || 6;
            var orient = data.orient || "vertical";
            var title = data.legendTitle;
            var top = data.top.toString().concat("%") || "1%";
            var left = data.left.toString().concat("%") || "1%";
            var shapeWidth = data.shapeWidth || 30;

            var type = data.type || "categorical"

            var legendDomain = x.data.legendBubbles.key;
            var legendRange = x.data.legendBubbles.keyColor;
            // console.log("DOMAIN", legendDomain, "\nRange", legendRange)
            // console.log("DOMAIN", legendDomain, "\nRange", legendRange)


            if (type == "numeric") {
                var scale = d3.scale.linear()
                    .domain(legendDomain)
                    .range(legendRange);
            }

            if (type == "categorical") {
                var scale = d3.scale.ordinal()
                    .domain(legendDomain)
                    .range(legendRange);
            }


            d3.select(this.options.element)
                .append('div')
                .style("z-index", 1002)
                .style("position", "absolute")
                .style("top", top)
                .style("left", left)
                .attr("id", "dmapLegend2")
                .append("svg");

            var legend = d3.select("#dmapLegend2 svg");

            legend.append("g")
                .attr("class", "legendLinear")
                .attr("transform", "translate(10,10)");

            var legendLinear = d3.legend.color()
                .shapeWidth(shapeWidth)
                .cells(cells)
                .title(title)
                .orient(orient)
                .scale(scale);

            legend.select(".legendLinear").call(legendLinear);

            d3.select(".legendCells").attr("transform", "translate(0,5)");

            var svgSize = d3.select("#dmapLegend2 svg g").node().getBoundingClientRect();
            d3.select("#dmapLegend2 svg").attr("width", svgSize.width + 20)
            d3.select("#dmapLegend2 svg").attr("height", svgSize.height + 10)
        }

        map.addPlugin("mylegend2", addBubbleColorLegend);





        function addBubbleSizeLegend(layer, data, options) {
            data = data || {};

            var orient = data.orient || "vertical";
            var title = data.legendTitle;
            var top = data.top.toString().concat("%") || "1%";
            var left = data.left.toString().concat("%") || "1%";
            var shapeWidth = data.shapeWidth || 30;

            var legendDomain = x.data.legendBubblesSize.domain;
            var legendRange = x.data.legendBubblesSize.domain;


            // console.log(legendDomain.length)
            var cells = data.cells || Math.min(legendDomain.length, 3);
            // console.log("SIZE:\nDOMAIN", legendDomain, "\nRange", legendRange)
            // console.log("DOMAIN", legendDomain, "\nRange", legendRange)


            var scale = d3.scale.linear()
                .domain(legendDomain)
                .range(legendRange)

            d3.select(this.options.element)
                .append('div')
                .style("z-index", 1002)
                .style("position", "absolute")
                .style("top", top)
                .style("left", left)
                .attr("id", "dmapLegend3")
                .append("svg");

            var legend = d3.select("#dmapLegend3 svg");

            legend.append("g")
                .attr("class", "legendSize")
                .attr("transform", "translate(10,20)");

            var legendSize = d3.legend.size()
                .shape('circle')
                .cells(cells)
                .shapePadding(15)
                .labelOffset(20)
                .orient('horizontal')
                .scale(scale);

            legend.select(".legendSize").call(legendSize);

            d3.select(".legendCells").attr("transform", "translate(0,10)");

            var svgSize = d3.select("#dmapLegend3 svg g").node().getBoundingClientRect();
            d3.select("#dmapLegend3 svg").attr("width", svgSize.width + 20)
            d3.select("#dmapLegend3 svg").attr("height", svgSize.height + 10)
        }

        map.addPlugin("mylegend3", addBubbleSizeLegend);



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

            console.log("bubbleColorLegend\n", usrOpts.bubbleColorLegend)
            if (usrOpts.bubbleColorLegend.show) {
                map.mylegend2(usrOpts.bubbleColorLegend)
            }
            console.log("bubbleSizeLegend\n", usrOpts.bubbleSizeLegend)
            if (usrOpts.bubbleSizeLegend.show) {
                map.mylegend3(usrOpts.bubbleSizeLegend)
            }

        }


        function addBivariateLegend(layer, data, options) {

            data = data || {};
            var title = data.legendTitle;
            var top = data.top.toString().concat("%") || "1%";
            var left = data.left.toString().concat("%") || "1%";

            d3.select(this.options.element)
                .append('div')
                .style("z-index", 1002)
                .style("position", "absolute")
                .style("top", top)
                .style("left", left)
                .attr("id", "dmapLegend4")
                .append("svg")
                .append("g");

            var rectPalette = [
                { "x": 0, "y": 40, "width": 20, "height": 20, "color": "#e8e8e8" },
                { "x": 20, "y": 40, "width": 20, "height": 20, "color": "#e4acac" },
                { "x": 40, "y": 40, "width": 20, "height": 20, "color": "#c85a5a" },
                { "x": 0, "y": 20, "width": 20, "height": 20, "color": "#b0d5df" },
                { "x": 20, "y": 20, "width": 20, "height": 20, "color": "#ad93a5" },
                { "x": 40, "y": 20, "width": 20, "height": 20, "color": "#985356" },
                { "x": 0, "y": 0, "width": 20, "height": 20, "color": "#64acbe" },
                { "x": 20, "y": 0, "width": 20, "height": 20, "color": "#62718c" },
                { "x": 40, "y": 0, "width": 20, "height": 20, "color": "#574249" }
            ];

            var legend = d3.select("#dmapLegend4 svg g");
            legend.attr("transform", "translate(50,10)");

            var rects = legend.selectAll("rects")
                .data(rectPalette)
                .enter()
                .append("rect");

            var rectAttributes = rects
                .attr("x", function(d) {
                    return d.x;
                })
                .attr("y", function(d) {
                    return d.y;
                })
                .attr("width", function(d) {
                    return d.width;
                })
                .attr("height", function(d) {
                    return d.height;
                })
                .style("fill", function(d) {
                    return d.color;
                });


            //Create the Scale we will use for the Axis
            var axisScaleX = d3.scale.ordinal()
                .domain(["Bajo", "Alto"])
                .range([0, 60]);
            var axisScaleY = d3.scale.ordinal()
                .domain(["Alto", "Bajo"])
                .range([0, 60]);

            //Create the Axis
            var xAxis = d3.svg.axis().scale(axisScaleX)
            var xAxisGroup = legend.append("g")
                .attr("class", "axis")
                .call(xAxis)
                .attr("transform", "translate(0,65)");


            //Create the Axis
            var yAxis = d3.svg.axis().scale(axisScaleY).orient("left")
            var yAxisGroup = legend.append("g")
                .attr("class", "axis")
                .call(yAxis)
                .attr("transform", "translate(-5,0)");

            legend.append("text")
                .attr("class", "x label")
                .attr("text-anchor", "end")
                .attr("x", 60)
                .attr("y", 100)
                .text("Variable 1");

            legend.append("text")
                .attr("class", "y label")
                .attr("text-anchor", "end")
                .attr("y", -50)
                .attr("dy", ".75em")
                .attr("transform", "rotate(-90)")
                .text("Variable 2");

            // var svgSize = d3.select("#dmapLegend4 svg g").node().getBoundingClientRect();
            // d3.select("#dmapLegend3 svg").attr("width", svgSize.width + 20)
            // d3.select("#dmapLegend3 svg").attr("height", svgSize.height + 10)
        }

        map.addPlugin("mylegend4", addBivariateLegend);

        console.log("bivariateLegend\n", usrOpts.bivariateLegend)
        map.mylegend4(usrOpts.bivariateLegend)



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
