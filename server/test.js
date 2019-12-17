//express_demo.js 文件
var express = require('express');
var app = express();
var bodyParser = require('body-parser');
var multer = require('multer'); // v1.0.5
var upload = multer(); // for parsing multipart/form-data
var fs = require("fs")
app.use(bodyParser.json()); // for parsing application/json
app.use(bodyParser.urlencoded({ extended: false })); // for parsing application/x-www-form-urlencoded

app.get('/search', function (req, res) {
    console.log("search req for:", req.originalUrl)
    console.log("param:", req.query.q)
    var searchResult = {
        "resultList":[{"filename":"1","description":"someDescript1"},{"filename":"2","description":"something2"}] 
    }
    res.send(searchResult);
})

app.all('/get_file/*', function(req,res) {
    console.log("get req for:", req.originalUrl)
    //TODO: read from file and send as json
    var buf = new Buffer.alloc(1024);
    res.sendfile(__dirname + "/MetroMap/" + "DefaultMapName.json", 'r+', function(err, fd) {
        if (err) {
            return console.error(err);
        }
    })
})

app.post('/', upload.array(), function (req, res, next) {
    var filename = req.body.mapName + '.json'
    fs.writeFile(__dirname + "/MetroMap/" + filename, JSON.stringify(req.body),function(err) {
        console.log(filename, " saved")
    })
    console.log("get post request: ", req.baseUrl)
    console.log("req body: \n", JSON.stringify(req.body))
    res.send(req.body)
  
})

var server = app.listen(8081, function () {
 
  var host = server.address().address
  var port = server.address().port
 
  console.log("server started at: http://%s:%s", host, port)
 
})
//{"lines":[{"stations":[{"metroLine":"1","coordinateInMap":[468.8092041015625,468.1934814453125],"adjacentNodes":["1234"],"stationName":"123"},{"metroLine":"1","coordinateInMap":[0,0],"adjacentNodes":["123","1a"],"stationName":"1234"},{"metroLine":"1","coordinateInMap":[-214.70411682128906,357.35205078125],"adjacentNodes":["1234","test"],"stationName":"1a"},{"metroLine":"1","coordinateInMap":[-303.2763671875,-12.786685943603516],"adjacentNodes":["1a"],"stationName":"test"}],"color":"YnBsaXN0MDDUAQIDBAUGBwpYJHZlcnNpb25ZJGFyY2hpdmVyVCR0b3BYJG9iamVjdHMSAAGGoF8QD05TS2V5ZWRBcmNoaXZlctEICVRyb290gAGkCwwdHlUkbnVsbNkNDg8QERITFBUWFxgYGRobFxxfEBVVSUNvbG9yQ29tcG9uZW50Q291bnRXVUlHcmVlblZVSUJsdWVXVUlBbHBoYVVOU1JHQl8QEVVJU3lzdGVtQ29sb3JOYW1lViRjbGFzc1VVSVJlZFxOU0NvbG9yU3BhY2UQBCIAAAAAIj+AAABFMCAwIDGAAoADEAJZYmx1ZUNvbG9y0x8gISIjJVokY2xhc3NuYW1lWCRjbGFzc2VzWyRjbGFzc2hpbnRzV1VJQ29sb3KiIiRYTlNPYmplY3ShJldOU0NvbG9yAAgAEQAaACQAKQAyADcASQBMAFEAUwBYAF4AcQCJAJEAmACgAKYAugDBAMcA1ADWANsA4ADmAOgA6gDsAPYA\/QEIAREBHQElASgBMQEzAAAAAAAAAgEAAAAAAAAAJwAAAAAAAAAAAAAAAAAAATs=","lineName":"1"},{"stations":[{"metroLine":"2","coordinateInMap":[246.80386352539062,131.72590637207031],"adjacentNodes":["2b"],"stationName":"2a"},{"metroLine":"2","coordinateInMap":[-52.477058410644531,-132.12614440917969],"adjacentNodes":["2a","test2"],"stationName":"2b"},{"metroLine":"2","coordinateInMap":[-271.57684326171875,-235.61582946777344],"adjacentNodes":["2b"],"stationName":"test2"}],"color":"YnBsaXN0MDDUAQIDBAUGBwpYJHZlcnNpb25ZJGFyY2hpdmVyVCR0b3BYJG9iamVjdHMSAAGGoF8QD05TS2V5ZWRBcmNoaXZlctEICVRyb290gAGkCwwdHlUkbnVsbNkNDg8QERITFBUWFxcYGRobGBxfEBVVSUNvbG9yQ29tcG9uZW50Q291bnRXVUlHcmVlblZVSUJsdWVXVUlBbHBoYVVOU1JHQl8QEVVJU3lzdGVtQ29sb3JOYW1lViRjbGFzc1VVSVJlZFxOU0NvbG9yU3BhY2UQBCIAAAAAIj+AAABFMSAwIDCAAoADEAJYcmVkQ29sb3LTHyAhIiMlWiRjbGFzc25hbWVYJGNsYXNzZXNbJGNsYXNzaGludHNXVUlDb2xvcqIiJFhOU09iamVjdKEmV05TQ29sb3IACAARABoAJAApADIANwBJAEwAUQBTAFgAXgBxAIkAkQCYAKAApgC6AMEAxwDUANYA2wDgAOYA6ADqAOwA9QD8AQcBEAEcASQBJwEwATIAAAAAAAACAQAAAAAAAAAnAAAAAAAAAAAAAAAAAAABOg==","lineName":"2"}],"mapInfo":{}}