import Kitura
import Cocoa

let router = Router()

let dbObj = Database.getInstance()

// this code will get data in the body of POST method
router.all("/ClaimService/add", middleware: BodyParser())
router.get("/"){
    request, response, next in
    response.send("Hello! Welcome to the service")
    next()
}

// http://localhost:8020/ClaimService/add
router.post("/ClaimService/add") {
    request, response, next in
    let body = request.body
    let jObj = body?.asJSON
    if let jDict = jObj as? [String:String] {
        if let ct = jDict["title"], let cd = jDict["date"], let iss = jDict["isSolved"] {
            let uuid = UUID().uuidString
            let cObj = Claim(cid: uuid, ct:ct, cd:cd, iss:iss)
            ClaimDao().addClaim(cObj: cObj)
        }
    }
    response.send("The claim record was successfully inserted via POST method.")
    next()
}

router.get("/ClaimService/getAll"){
    request, response, next in
    let cList = ClaimDao().getAll()
    let jsonData : Data = try JSONEncoder().encode(cList)
    let jsonStr = String(data: jsonData, encoding: .utf8)
    response.status(.OK)
    response.headers["Content-Type"] = "application/json"
    response.send(jsonStr)
    next()
}

Kitura.addHTTPServer(onPort: 8020, with: router)
Kitura.run()

