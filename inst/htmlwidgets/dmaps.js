HTMLWidgets.widget({

    name: "dmaps",
    type: "output",

    initialize: function(el, width, height) {
        console.log("initializing")
        d3.select(el).selectAll("*").remove();
        d3.select(".datamaps-legend").remove();
        return {}
    },

    resize: function(el, width, height, instance) {
        console.log("resizing")
        d3.select(".datamaps-legend").remove();


        console.log(instance)
        var map = instance.map;
        map.resize();

        if (instance.legend) {
            if (instance.legend.name == "choroLegend") {
                map.choroLegend(instance.legend)
            }
            if (instance.legend.name == "bubbleColorLegend") {
                map.bubbleColorLegend(instance.legend)
            }
            if (instance.legend.name == "bubbleSizeLegend") {
                map.bubbleColorLegend(instance.legend)
            }
            if (instance.legend.name == "bivariateLegend") {
                map.bivariateLegend(instance.legend)
            }


        }


    },

    renderValue: function(el, x, instance) {


        // d3.select(el.id).html("");
        // console.log(d3.select(el))
        //var theel = document.getElementById(el.id);
        //theel.innerHTML = '';    
        // console.log(d3.select("#dmapLegend"))
        // d3.select("#dmapLegend").remove();

        // d3.select(el).select("#dmapLegend").selecAll("*").remove();

        // document.getElementById(el.id).innerHTML="";
        // d3.select("#dmapLegend").select("svg").selectAll("*").remove();
        
        console.log("rendering")
        d3.select(el).selectAll("*").remove();
        d3.select(".datamaps-legend").remove();

        // d3.select(el).select("svg").selectAll("*").remove();
        // console.log(d3.select(el.id).selectAll("*"))
        // d3.select(el).selectAll("svg").remove()

        var css = document.createElement("style");
        css.type = "text/css";
        css.innerHTML = x.settings.styles;
        document.getElementById(el.id).appendChild(css);

        if (x.settings.zoomable) {
            var zoomButtons = document.createElement("div");
            zoomButtons.style["position"] = "absolute";
            zoomButtons.style["right"] = "1%";
            zoomButtons.style["z-index"] = 1001;
            zoomButtons.innerHTML = '<button data-zoom="+1" id="zoom_in">+</button><button data-zoom="-1" id="zoom_out">-</button><button id="zoom_reset">&#x25A1;</button>';
            document.getElementById(el.id).appendChild(zoomButtons);

        }


        var title = document.createElement("h2");
        title.setAttribute("id", "title");
        title.innerHTML = x.settings.title.text;
        document.getElementById(el.id).insertBefore(title, el.childNodes[0]);

        var width = el.offsetWidth;
        var height = el.offsetHeight;

        vizId = el.id;


        console.log("SETTINGS:\n", x.settings);
        console.log("DATA:\n", x.data);
        var usrOpts = x.settings;
        var dmap = x.dmap;

        var opts = {
            scope: dmap.scope,
            dataUrl: dmap.path,
            // dataJson: dmap.path,
            zoomable: usrOpts.zoomable || false,
            geographyName: dmap.geographyName,
            projectionName: usrOpts.projectionName,
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
            if (projectionName == "albersUsa") {
                var projection = d3.geo.albersUsa()
                    // .scale(projectionOpts.scale)
                    .scale(projectionOpts.scale * element.offsetWidth)
                    // .rotate(projectionOpts.rotate)
                    // .center(projectionOpts.center)
                    // .parallels(projectionOpts.parallels)
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

        // function redraw() {
        //         var prefix = '-webkit-transform' in document.body.style ?
        //             '-webkit-' : '-moz-transform' in document.body.style ?
        //             '-moz-' : '-ms-transform' in document.body.style ?
        //             '-ms-' : '';
        //         var x = d3.event.translate[0];
        //         var y = d3.event.translate[1];
        //         d3.selectAll(".datamaps-subunits") // OJO puede que no funcione con bubbles!
        //             .style(prefix + 'transform',
        //                 'translate(' + x + 'px, ' + y + 'px) scale(' + (d3.event.scale) + ')');
        //     }

        // console.log("Opts: ", opts)

        var map = new Datamap({
            element: document.getElementById(vizId),
            geographyConfig: {
                borderColor: opts.borderColor,
                borderWidth: opts.borderWidth,
                highlightFillColor: opts.highlightFillColor,
                highlightBorderColor: opts.highlightBorderColor,
                highlightBorderWidth: opts.highlightBorderWidth,
                // dataJson: opts.dataJson,
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
                // Handle clicks before zooms
                d3.select('.datamap').select('g').selectAll('.datamaps-subunit').on('click', function(event, data) {
                    // console.log("CLICKED REGION", data)
                    console.log("CLICKED REGION", event.id)
                    if (typeof Shiny != "undefined") {
                        Shiny.onInputChange('dmaps_clicked_region', event.id)
                    }

                });

                if (!datamap.options.zoomable) {
                    return null
                }

                var ww = d3.select("svg").style("width").replace("px", "");
                // var ww = el.offsetWidth;
                var hh = d3.select("svg").style("height").replace("px", "");
                // var ww = el.offsetWidth;
                var center = [ww / 2, hh / 2];

                var zoom = d3.behavior.zoom().scaleExtent([1, 15]).on("zoom", zoomed);
                // http://bl.ocks.org/mbostock/8fadc5ac9c2a9e7c5ba2
                // http://bl.ocks.org/mgold/c2cc7242c8f800c736c4
                // http://bl.ocks.org/mgold/bbc451a7b9f902954e7c
                datamap.svg.call(zoom).call(zoom.event)


                function zoomed() {
                    var prefix = '-webkit-transform' in document.body.style ?
                        '-webkit-' : '-moz-transform' in document.body.style ?
                        '-moz-' : '-ms-transform' in document.body.style ?
                        '-ms-' : '';
                    console.log("translate", zoom.translate()[0])
                    console.log("d3.event.translate", zoom.translate()[1])
                    var x = zoom.translate()[0];
                    var y = zoom.translate()[1];
                    datamap.svg.selectAll(".datamaps-subunits")
                        .style(prefix + 'transform',
                            'translate(' + x + 'px, ' + y + 'px) scale(' + (zoom.scale()) + ')');
                }


                d3.selectAll("button[data-zoom]").on("click", function() {
                    d3.event.preventDefault();
                    var scale = zoom.scale(),
                        extent = zoom.scaleExtent(),
                        translate = zoom.translate(),
                        x = translate[0],
                        y = translate[1],
                        factor = (this.id === 'zoom_in') ? 1.2 : 1 / 1.2,
                        target_scale = scale * factor;
                    // If we're already at an extent, done
                    if (target_scale === extent[0] || target_scale === extent[1]) {
                        return false;
                    }
                    // If the factor is too much, scale it down to reach the extent exactly
                    var clamped_target_scale = Math.max(extent[0], Math.min(extent[1], target_scale));
                    if (clamped_target_scale != target_scale) {
                        target_scale = clamped_target_scale;
                        factor = target_scale / scale;
                    }

                    // Center each vector, stretch, then put back
                    x = (x - center[0]) * factor + center[0];
                    y = (y - center[1]) * factor + center[1];

                    // Transition to the new view over 350ms
                    d3.transition().duration(200).tween("zoom", function() {
                        var interpolate_scale = d3.interpolate(scale, target_scale),
                            interpolate_trans = d3.interpolate(translate, [x, y]);
                        return function(t) {
                            zoom.scale(interpolate_scale(t))
                                .translate(interpolate_trans(t));
                            zoomed();
                        };
                    });
                });
                d3.selectAll("#zoom_reset").on("click", function() {
                    // console.log("zoom.translate", zoom.translate())
                    //    console.log("center", center)
                    //    console.log("scale",zoom.scale())
                    // Center each vector, stretch, then put back
                    var scale = zoom.scale(),
                        translate = zoom.translate(),
                        x = 0,
                        y = 0,
                        target_scale = 1;
                    // console.log("x y",[x,y])
                    // Transition to the new view over 350ms
                    d3.transition().duration(350).tween("zoom", function() {
                        var interpolate_scale = d3.interpolate(scale, target_scale),
                            interpolate_trans = d3.interpolate(translate, [x, y]);
                        return function(t) {
                            zoom.scale(interpolate_scale(t))
                                .translate(interpolate_trans(t));
                            zoomed();
                        };
                    });
                });
            },
            zoomable: opts.zoomable
        });

        if (usrOpts.graticule) {
            map.graticule();
        }


        function addChoroLegend(layer, data, options) {
            data = data || {};
            console.log("Chorolegend data", data)
            var orient = data.orient || "vertical";
            var title = data.title;
            var top = data.top.toString().concat("%") || "1%";
            var left = data.left.toString().concat("%") || "1%";
            var shapeWidth = data.shapeWidth || 30;
            var type = data.type || "categorical"
            var legendDomain = data.domain;
            var legendRange = data.range;
            var nLevels = data.nLevels;
            var cells = data.cells || Math.min(legendDomain.length, nLevels);
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

            var legend = d3.select("svg");

            legend.append("g")
                .attr("id", "dmapLegend")
                .attr("class", "datamaps-legend")
                .attr("transform", "translate(10,10)");

            var legendLinear = d3.legend.color()
                .shapeWidth(shapeWidth)
                .cells(cells)
                .title(title)
                .orient(orient)
                .scale(scale);

            legend.select("#dmapLegend").call(legendLinear);
            d3.select(".legendCells").attr("transform", "translate(0,5)");
            var svgSize = d3.select("#dmapLegend").node().getBoundingClientRect();
            d3.select("#dmapLegend").attr("width", svgSize.width + 20)
            d3.select("#dmapLegend").attr("height", svgSize.height + 10)
        }
        map.addPlugin("choroLegend", addChoroLegend);

console.log("usrOpts.legend",usrOpts.legend)
        if (usrOpts.legend.show) {
            usrOpts.legend.choropleth.domain = x.data.legendData.key;
            usrOpts.legend.choropleth.range = x.data.legendData.keyColor;
            usrOpts.legend.choropleth.nLevels = x.settings.nLevels;
            instance.legend = usrOpts.legend.choropleth;
            instance.legend.name = "choroLegend";
            map.choroLegend(usrOpts.legend.choropleth)
        }
        // console.log("outIf",d3.select(el).select("#dmapLegend"));

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

            var legendDomain = data.domain;
            var legendRange = data.range;

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

            var legend = d3.select("svg");

            legend.append("g")
                .attr("id", "dmapLegend")
                .attr("class", "datamaps-legend")
                .attr("transform", "translate(10,10)");

            var legendLinear = d3.legend.color()
                .shapeWidth(shapeWidth)
                .cells(cells)
                .title(title)
                .orient(orient)
                .scale(scale);

            legend.select("#dmapLegend").call(legendLinear);
            d3.select(".legendCells").attr("transform", "translate(0,5)");
            var svgSize = d3.select("#dmapLegend").node().getBoundingClientRect();
            d3.select("#dmapLegend").attr("width", svgSize.width + 20)
            d3.select("#dmapLegend").attr("height", svgSize.height + 10)
        }

        map.addPlugin("bubbleColorLegend", addBubbleColorLegend);

        function addBubbleSizeLegend(layer, data, options) {
            data = data || {};

            var orient = data.orient || "vertical";
            var title = data.legendTitle;
            var top = data.top.toString().concat("%") || "1%";
            var left = data.left.toString().concat("%") || "1%";
            var shapeWidth = data.shapeWidth || 30;

            var legendDomain = data.domain;
            var legendRange = data.range;


            // console.log(legendDomain.length)
            var cells = data.cells || Math.min(legendDomain.length, 3);


            var scale = d3.scale.linear()
                .domain(legendDomain)
                .range(legendRange)


            var legend = d3.select("svg");

            legend.append("g")
                .attr("id", "dmapLegend")
                .attr("class", "datamaps-legend")
                .attr("transform", "translate(10,10)");

            var legendSize = d3.legend.size()
                .shape('circle')
                .cells(cells)
                .shapePadding(15)
                .labelOffset(20)
                .orient('horizontal')
                .scale(scale);


            legend.select("#dmapLegend").call(legendSize);
            d3.select(".legendCells").attr("transform", "translate(0,5)");
            var svgSize = d3.select("#dmapLegend").node().getBoundingClientRect();
            d3.select("#dmapLegend").attr("width", svgSize.width + 20)
            d3.select("#dmapLegend").attr("height", svgSize.height + 10)

            var svgSize = d3.select("#dmapLegend3 svg g").node().getBoundingClientRect();
            d3.select("#dmapLegend3 svg").attr("width", svgSize.width + 20)
            d3.select("#dmapLegend3 svg").attr("height", svgSize.height + 10)
        }

        map.addPlugin("bubbleSizeLegend", addBubbleSizeLegend);



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

            // console.log("bubbleColorLegend\n", usrOpts.bubbleColorLegend)
            if (usrOpts.bubbleColorLegend.show) {
                usrOpts.bubbleColorLegend.domain = x.data.legendData.key;
                usrOpts.bubbleColorLegend.range = x.data.legendData.keyColor;
                instance.legend = usrOpts.bubbleColorLegend;
                instance.legend.name = "bubbleColorLegend";
                map.bubbleColorLegend(usrOpts.bubbleColorLegend)
            }
            // console.log("bubbleSizeLegend\n", usrOpts.bubbleSizeLegend)
            if (usrOpts.bubbleSizeLegend.show) {
                usrOpts.bubbleSizeLegend.domain = x.data.legendData.key;
                usrOpts.bubbleSizeLegend.range = x.data.legendData.keyColor;
                instance.legend = usrOpts.bubbleSizeLegend;
                instance.legend.name = "bubbleSizeLegend";
                map.bubbleSizeLegend(usrOpts.bubbleSizeLegend)
            }

        }


        function addBivariateLegend(layer, data, options) {

            data = data || {};
            var title = data.legendTitle;
            var var1Label = data.var1Label;
            var var2Label = data.var2Label;
            var top = data.top.toString().concat("%") || "1%";
            var left = data.left.toString().concat("%") || "1%";

            var legend = d3.select("svg")
                .append("g")
                .attr("id", "dmapLegend")
                // .style("z-index", 1002)
                // .style("position", "absolute")
                // .style("top", top)
                // .style("left", left)
                .attr("transform", "translate(50,10)")
                .attr("class", "datamaps-legend");

            var rectPalette = [{
                "x": 0,
                "y": 40,
                "width": 20,
                "height": 20,
                "color": "#e8e8e8"
            }, {
                "x": 20,
                "y": 40,
                "width": 20,
                "height": 20,
                "color": "#e4acac"
            }, {
                "x": 40,
                "y": 40,
                "width": 20,
                "height": 20,
                "color": "#c85a5a"
            }, {
                "x": 0,
                "y": 20,
                "width": 20,
                "height": 20,
                "color": "#b0d5df"
            }, {
                "x": 20,
                "y": 20,
                "width": 20,
                "height": 20,
                "color": "#ad93a5"
            }, {
                "x": 40,
                "y": 20,
                "width": 20,
                "height": 20,
                "color": "#985356"
            }, {
                "x": 0,
                "y": 0,
                "width": 20,
                "height": 20,
                "color": "#64acbe"
            }, {
                "x": 20,
                "y": 0,
                "width": 20,
                "height": 20,
                "color": "#62718c"
            }, {
                "x": 40,
                "y": 0,
                "width": 20,
                "height": 20,
                "color": "#574249"
            }];

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
                .domain(["-", "+"])
                .range([0, 60]);
            var axisScaleY = d3.scale.ordinal()
                .domain(["+", "-"])
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

            d3.selectAll(".axis path")
                .style("stroke", "#000");

            legend.append("text")
                .attr("class", "x label")
                .attr("text-anchor", "end")
                .attr("x", 60)
                .attr("y", 100)
                .text(var1Label);

            legend.append("text")
                .attr("class", "y label")
                .attr("text-anchor", "end")
                .attr("y", -40)
                .attr("dy", ".75em")
                .attr("transform", "rotate(-90)")
                .text(var2Label);

            // var svgSize = d3.select("#dmapLegend4 svg g").node().getBoundingClientRect();
            // d3.select("#dmapLegend3 svg").attr("width", svgSize.width + 20)
            // d3.select("#dmapLegend3 svg").attr("height", svgSize.height + 10)
        }

        map.addPlugin("bivariateLegend", addBivariateLegend);

        // console.log("bivariateLegend\n", usrOpts.bivariateLegend)
        if (usrOpts.legend.bivariate.show) {
            usrOpts.legend.bivariate.domain = x.data.legendData.key;
            usrOpts.legend.bivariate.range = x.data.legendData.keyColor;
            instance.legend = usrOpts.legend.bivariate;
            instance.legend.name = "bivariateLegend";
            map.bivariateLegend(usrOpts.legend.bivariate)
        }

        // Do not scale geoboundaries on zoom
        d3.select('.datamap').select('g').selectAll('path.datamaps-subunit').style('vector-effect', 'non-scaling-stroke');

        //make responsive
        // d3.select(window).on('resize', function() {
        //     map.resize();

        // });

        instance.map = map;
        // instance.mapData = getMapData();

        console.log("instance", instance)

        var notes = document.createElement("p");
        notes.setAttribute("id", "notes");
        notes.innerHTML = x.settings.notes.text;
        document.getElementById(el.id).appendChild(notes);


    }
});
