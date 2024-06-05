import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - Controls
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var buttonYes: UIButton!
    @IBOutlet private var buttonNo: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Instance Variables
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticService?
    private var alertPresenter: ResultAlertPresenter?
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 0
        
        let questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        self.questionFactory = questionFactory
        
        self.statisticService = StatisticServiceImplementation()
        
        let alertPresenter = ResultAlertPresenter()
        alertPresenter.delegate = self
        self.alertPresenter = alertPresenter
        
        showLoadingIndicator()
        self.questionFactory?.loadData()
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        hideLoadingIndicator()
        guard let question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    func didFailToReceiveNextQuestion(with error: Error){
        hideLoadingIndicator()
        showQuestionLoadingError(message: error.localizedDescription)
    }
    
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        hideLoadingIndicator()
        showNetworkError(message: error.localizedDescription)
    }
    
    // MARK: - Private Methods
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        
    }
    
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = UIColor.ypBlack.cgColor
        
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        
        if isCorrect {
            correctAnswers+=1
        }
        
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        buttonNo.isEnabled = false
        buttonYes.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.buttonNo.isEnabled = true
            self.buttonYes.isEnabled = true
            self.showNextQuestionOrResults()
        }
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText) {[weak self] in
            guard let self = self else {return}
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
        }
        self.alertPresenter?.showAlert(alertModel)
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex < questionsAmount-1 {
            currentQuestionIndex+=1
            showLoadingIndicator()
            self.questionFactory?.requestNextQuestion()
            return
        }
        
        guard let statisticService = self.statisticService else {
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: "Ваш результат: \(correctAnswers)/\(questionsAmount)",
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
            return
        }
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        
        let text = """
            Ваш результат: \(correctAnswers)/\(questionsAmount)
            Количество сыгранных квизов: \(statisticService.gamesCount)
            Рекорд: \(statisticService.bestGame.correct)/\(questionsAmount) (\(statisticService.bestGame.date.dateTimeString))
            Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
            """
        
        let viewModel = QuizResultsViewModel(
            title: "Этот раунд окончен!",
            text: text,
            buttonText: "Сыграть ещё раз")
        show(quiz: viewModel)
        
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        let alertModel = AlertModel(title: "Что-то пошло не так(", message: message, buttonText: "Попробовать еще раз") {[weak self] in
            guard let self = self else {return}
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.showLoadingIndicator()
            self.questionFactory?.loadData()
        }
        self.alertPresenter?.showAlert(alertModel)

    }
    
    private func showQuestionLoadingError(message: String) {
        let alertModel = AlertModel(title: "Что-то пошло не так(", message: message, buttonText: "Попробовать еще раз") {[weak self] in
            guard let self = self else {return}
            self.showLoadingIndicator()
            self.questionFactory?.requestNextQuestion()
        }
        self.alertPresenter?.showAlert(alertModel)
        
    }
    
    // MARK: - Actions
    @IBAction
    private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == true)
    }
    
    @IBAction
    private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == false)
    }
    
}
