HTMLWidgets.widget({

    name: "dmaps",
    type: "output",

    initialize: function(el, width, height) {
        // return d3plus.viz();
    },

    resize: function(el, width, height, instance) {
        // instance.draw();
    },

    renderValue: function(el, x, instance) {

        vizId = el.id;
        // var d3plus = instance;

        // console.log(vizId)
        // select the viz element and remove existing children
        // d3.select(el).select(vizId).selectAll("*").remove();

        console.log("SETTINGS:\n",x.settings);
        console.log("DATA:\n",x.data);

        // var usrOpts = {
        //     mapType: "mpio",
        //     scale: 2,
        //     translateX: 0,
        //     translateY: 0,
        //     defaultFill: '#B3D5D7',
        //     borderWidth: 1,
        // };

        var usrOpts = x.settings;

        var mapType = usrOpts.mapType || "mpio"; // depto
        var mapTypeDefaults = {
            mpio: {
                scope: "mpio",
                dataUrl: "https://rm-public.s3.amazonaws.com/assets/topo/mpio.min.topo.json",
                geographyName: "NOMBRE_MPI"
            },
            depto: {
                scope: "depto",
                dataUrl: 'https://rm-public.s3.amazonaws.com/assets/topo/depto.topo.json',
                geographyName: "name"
            }
        };

        var opts = {
            scope: mapTypeDefaults[mapType].scope,
            dataUrl: mapTypeDefaults[mapType].dataUrl,
            geographyName: mapTypeDefaults[mapType].geographyName,
            scale: usrOpts.scale || 2,
            translateX: usrOpts.translateX || 0,
            translateY: usrOpts.translateY || 0,
            defaultFill: usrOpts.defaultFill || '#0C9EB2',
            borderColor: usrOpts.borderColor || '#F3F5FF',
            borderWidth: usrOpts.borderWidth || 0.5,
            highlightFillColor: usrOpts.highlightFillColor || '#516a52',
            highlightBorderColor: usrOpts.highlightBorderColor || '#279945',
            highlightBorderWidth: usrOpts.highlightBorderWidth || 0,
        };

        var data = {
            fillKeys: {
                defaultFill: opts.defaultFill,
                latam: '#458063',
                bubble1: '#432342',
                bubble2: '#485308',
                Guerrilla: '#f45298'
            },
            fills: {
                44847: {
                    fillKey: ['Guerrilla']
                },
                70400: {
                    fillKey: ['bubble1']
                },
                54670: {
                    fillKey: ['latam']
                }
            },
            bubblesdata: [{
                "name": "Medellín",
                "latitude": 6.2914,
                "longitude": -75.536,
                "radius": 16,
            }, {
                "name": "Apartadó",
                "latitude": 7.8856,
                "longitude": -76.635,
                "radius": 7,
                "fillKey": "Guerrilla"
            }, {
                "name": "Bello",
                "latitude": 6.3389,
                "longitude": -75.562,
                "radius": 6.3389,
                "fillKey": "Guerrilla"
            }, {
                "name": "Bello",
                "latitude": 6.3389,
                "longitude": -75.562,
                "radius": 6.3389,
                "fillKey": "C"
            }, {
                "name": "San José del Guaviare",
                "latitude": 2.5683,
                "longitude": -72.642,
                "radius": 5.25,
                "fillKey": "Guerrilla"
            }]
        };

        var data = x.data;

        //basic map config with custom fills, mercator projection
        var map = new Datamap({
            element: document.getElementById(vizId),
            geographyConfig: {
                borderColor: opts.borderColor,
                borderWidth: opts.borderWidth,
                highlightFillColor: opts.highlightFillColor,
                highlightBorderColor: opts.highlightBorderColor,
                highlightBorderWidth: opts.highlightBorderWidth,
                // dataUrl: 'js/municipios.col.json'
                popupTemplate: function(geography, data) {
                    // console.log(data)
                    var info = null;
                    if(data){
                        info = data.info || geography.properties[opts.geographyName] 
                    }
                    var htmlInfo = info || geography.properties[opts.geographyName] 
                    return '<div class="hoverinfo">' +  htmlInfo
                },
                dataUrl: opts.dataUrl,
            },
            scope: opts.scope,
            responsive: true,
            setProjection: function(element) {
                var projection = d3.geo.mercator()
                    .center([-73.5, 4.2])
                    .rotate([0, 0])
                    .scale(opts.scale * element.offsetWidth)
                    .translate([element.offsetWidth / 2 + opts.translateX, element.offsetHeight / 2 + opts.translateY]);
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
            }

        });

        if(usrOpts.legend){
            map.legend({
                legendTitle: usrOpts.legendTitle || "",
                defaultFillName: usrOpts.legendDefaultFillTitle,
            })
        }

        if(data.bubblesData.length){
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
