import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - IB Outlets
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var buttonYes: UIButton!
    @IBOutlet private var buttonNo: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Instance Variables
    private var presenter: MovieQuizPresenter!
    private var alertPresenter: AlertPresenter?
    
    // MARK: - Instance Methods
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 0
        
        presenter = MovieQuizPresenter(viewController: self)
        
        let alertPresenter = AlertPresenter()
        alertPresenter.delegate = self
        self.alertPresenter = alertPresenter

    }
    
    // MARK: - Public Methods
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = UIColor.ypBlack.cgColor
        
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func highlightImageBorders(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func blockButtons(){
        buttonNo.isEnabled = false
        buttonYes.isEnabled = false
    }
    
    func unblockButtons(){
        self.buttonNo.isEnabled = true
        self.buttonYes.isEnabled = true
    }
    
    
    func show(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(id: "GameResult",
                                    title: result.title,
                                    message: result.text,
                                    buttonText: result.buttonText) {[weak self] in
            guard let self = self else {return}
            
            presenter.restartGame()
        }
        self.alertPresenter?.showAlert(alertModel)
    }
    
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        let alertModel = AlertModel(id: "NetworkErrorAlert",
                                    title: "Что-то пошло не так(",
                                    message: message,
                                    buttonText: "Попробовать еще раз") {[weak self] in
            guard let self = self else {return}
            presenter.reLoadData()
            presenter.restartGame()
        }
        self.alertPresenter?.showAlert(alertModel)

    }
    
    func showImageLoadingError(message: String) {
        let alertModel = AlertModel(id: "ImageLoadingErrorAlert",
                                    title: "Что-то пошло не так(",
                                    message: message,
                                    buttonText: "Попробовать еще раз") {[weak self] in
            guard let self = self else {return}
            presenter.showNextQuestionOrResults()
        }
        self.alertPresenter?.showAlert(alertModel)
        
    }
    
    // MARK: - Actions
    @IBAction
    private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction
    private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
}
