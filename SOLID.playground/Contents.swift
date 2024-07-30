// MARK: Single Responsibility Principle (SRP)
// Rule:class ya da structlar sadece bir şeyden sorumlu olmalı.

import Foundation

struct Product {
    let price:Double
}

struct Invoince {  // Violate ediyor SRP'yi birden fazla şey ile sorumlu
    var products:[Product]
    let id = UUID().uuidString
    var discountPercentage : Double = 0.0
    
    var total : Double {
        let total = products.map({$0.price}).reduce(0, { $0 + $1})
        let discountedAmount = total * (discountPercentage/100)
        return total - discountPercentage
    }
    func printInvoince(){
        print("---------------")
        print("Invoince id: \(id)")
        print("Total cost $: \(total)")
        print("Discounts: \(discountPercentage)")
        print("---------------")
    }
    func saveInvonince () {
        //TODO: ..
    }
}
struct InvoincePrinter {  // bu şekilde tek tek ayırmalıyız.
    let invonce : Invoince
    func printInvoince() {
        //TODO: print invoince
    }
}
// MARK: Open / Close Principle
// Extension yapabilirsin ama doğruduran koda dokunmadan yapabilirsin. Modife edemezsin.

extension Int {  // Viole ediyor direk olarak bu şekilde extension yazamazsın!
    func squared() -> Int {
        return self * self
    }
}

struct InvoincePersistenceOCP { // yeni metodlar geldiğinde extension olarak yazabilirsin classa
    let invoince : Invoince
/*  let persistance: Persistance
     
    func save(invoince:Invoince) {
        persistance.save(invoince:Invoince)
    }
     */
    
    func saveInvoinceToCoreData () {
        print("--coredata---")
    }
    func saveInvoinceToFirebase () {
        print("--firebase---")
    }
}
 // MARK: Bu şekilde hem ocp ye hem de srp'ye uyum sağladık.
protocol InvoincePersistable {
    func save(invoince:Invoince)
}

struct coreDataPersistence: InvoincePersistable {
    func save(invoince: Invoince) {
        print("saved to coredata")
    }
}

struct FirebasePersistence: InvoincePersistable {
    func save(invoince: Invoince) {
        print("saved to firebase")
    }
}

//MARK: Liskov Substitution Principle (LSP)
// Derived or child classes/structures must be substituable for their base or parent class

enum APIError: Error {  // error base classını substitude ettik custom typemiz için hem default olan hem de custom errorleri throw edebilir bu enum.
    case myErrorType1
    case myErrorType2
}

// MARK: - Inteface Segregation Principle (ISP)
// Hiçbir Clienti kendinden alakkasız bir interface implement etmesi için zorlama.

protocol GestureProtocol {
    func didTap()
    func didDoubleTap()
    func didLongPress()
}

 /*struct DoubleTapButton : GestureProtocol {
    func didTap() {
        
    }
                                  // MARK: Bize sadece doubleTap metodu gerekli ancak bu kurguda ISP Violaton var çünkü gereksiz methodları implement ediyoruz. Çözüm olarak ayrı ayrı protocol yazılabilir her gesture çeşidi.
    func didDoubleTap() {
            
    }
    
    func didLongPress() {
        
    }
    
    
} */
 // MARK: - Dependency Inversion Principle (DIP)

// Changes in one class could break another class.
// High level bir modul low level modullere depend olmamalı.
struct DebitCardPayment {
    func execute(amount:Double) {
        print("Debit card payment...")
    }
}

struct ApplePayPayment {
    func execute(amount:Double) {
        print("Apple pay payment...")
    }
}


struct Payment {
    var debitCardPayment : DebitCardPayment?
    var ApplePayment : ApplePayPayment?
}

let paymentMethod = DebitCardPayment()

let payment : Payment = .init(debitCardPayment: paymentMethod,ApplePayment: nil) // Violates DIP çünkü high level olan payment low level olana dependent

payment.debitCardPayment?.execute(amount: 100) // hangi payment metodunun nil olup olmadığı bilmek zor. bir sürü guard let gerekebilir.

