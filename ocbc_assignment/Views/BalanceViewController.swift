
import UIKit

class BalanceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var AmountLabel: UILabel!
    @IBOutlet weak var LogoutButton: UIButton!
    @IBOutlet weak var ActivitiesView: UITableView!
    @IBOutlet weak var TransferButton: UIButton!
    
    var dateArray = [String]()
    var descriptionArray = [String]()
    var amountArray = [String]()
    var descriptionCount : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "TransactionsTableViewCell", bundle: nil)
        ActivitiesView.register(nib, forCellReuseIdentifier: "TransactionsTableViewCell")
        ActivitiesView.delegate = self
        ActivitiesView.dataSource = self

        navigationItem.hidesBackButton = true
        TransferButton.layer.cornerRadius = 15
        
        RequestRouter.balances.send(BalancesResponse.self, then: balancesResponse)
        RequestRouter.transactions.send(TransactionsResponse.self, then: transactionsResponse)
        
    }
    
    var balancesResponse: HandleResponse<BalancesResponse> {
        
        return {[weak self] (response) in
            
            switch response {
            case .failure(let error):
                print(LoginViewController.defaultManager.authorisationHeader)
                self?.showAlert(for: "System Error")
        
                return
            case .success(let value):
                if(value.status?.caseInsensitiveCompare("success") == .orderedSame){
                      print("success")
                  if let balanceRemaining = value.balance {
                    DispatchQueue.main.async {
                        self?.AmountLabel.text = "SGD \(balanceRemaining)"
                    }
                  }
                    
                }  else {
                  self?.showAlert(for: "Please login again")
                    return
                }
                
            }
        }
    }
    
    var transactionsResponse: HandleResponse<TransactionsResponse> {
        
        return {[weak self] (response) in
            
            switch response {
            case .failure(let error):
                print(LoginViewController.defaultManager.authorisationHeader)
                self?.showAlert(for: "System Error")
        
                return
            case .success(let value):
                if(value.status?.caseInsensitiveCompare("success") == .orderedSame){
                      print("success")
                    
                    let dateFormatterOriginal = DateFormatter()
                    let dateFormatterNew = DateFormatter()
                    dateFormatterOriginal.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                    dateFormatterNew.dateFormat = "MMM d"
                    
                    if let transactionData = value.data {
                        self?.descriptionCount = transactionData.count
                        
                        for rowData in transactionData {
                            
                            let originalDate = dateFormatterOriginal.date(from: rowData.date!)
                            let newDate = dateFormatterNew.string(from: originalDate!)
                            
                            self?.dateArray.append("\(newDate)")
                            
                            if (rowData.type?.caseInsensitiveCompare("receive") == .orderedSame){
                                self?.amountArray.append("+\(rowData.amount!)")
                                self?.descriptionArray.append("Received from \(rowData.from!.accountHolderName!)")
                            } else {
                                self?.amountArray.append("-\(rowData.amount!)")
                                self?.descriptionArray.append("Transfered to \(rowData.to!.accountHolderName!)")
                            }
                        }
                    }
                    
                    self?.ActivitiesView.reloadData()
                    
                }  else {
                  self?.showAlert(for: "Please login again")
                    return
                }
                
            }
        }
    }
    
    func tableView(_ ActivitiesView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return descriptionCount
    }
    
    func tableView(_ ActivitiesView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ActivitiesView.dequeueReusableCell(withIdentifier: "TransactionsTableViewCell", for: indexPath) as! TransactionsTableViewCell
        
        cell.DateLabel.text = dateArray[indexPath.row]
        cell.DescriptionLabel.text = descriptionArray[indexPath.row]
        cell.AmountLabel.text = amountArray[indexPath.row]
        
        return cell
    }
    
    @IBAction func Logout(_ sender: UIButton) {
        LoginViewController.defaultManager.authorisationHeader = ""
        self.goToLoginPage()
        
    }
    
    func goToLoginPage() {
      
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      guard let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {
          return
      }
      guard let navigationController = navigationController else {
          return
      }
      navigationController.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func Transfer(_ sender: UIButton) {
        self.goToTransferPage()
        
    }
    
    func goToTransferPage() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "TransferViewController") as? TransferViewController else {
            return
        }
        guard let navigationController = navigationController else {
            return
        }
        navigationController.pushViewController(vc, animated: true)
        
    }
}


