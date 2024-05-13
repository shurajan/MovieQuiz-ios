import UIKit

struct QuizQuestion {
    let image: String
    let text: String
    let correctAnswer: Bool
}

struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
}

struct QuizResults {
    private(set) var currentQuestionIndex = 0
    private var correctAnswers = 0
    private var roundsNumber = 0
    private var maxResult = 0
    private var maxResultTime: String = ""
    private var totalNumberOfQuestions = 0
    private var totalNumberOfCorrectAnswers = 0
    private let dateFormatter = DateFormatter()
    
    init(){
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
    }
    
    mutating func startRound(){
        currentQuestionIndex = 0
        correctAnswers = 0
    }
    
    mutating func saveAnswerResults(isCorrect: Bool){
        if isCorrect {
            correctAnswers += 1
            totalNumberOfCorrectAnswers += 1
        }
    }
    
    mutating func moveNextQuestion(){
        currentQuestionIndex += 1
        totalNumberOfQuestions += 1
    }
    
    mutating func finishRound(){
        roundsNumber+=1
        if correctAnswers >= maxResult {
            maxResult = correctAnswers
            maxResultTime = ""
            if #available(iOS 15, *) {
                maxResultTime = "(\(dateFormatter.string(from: Date.now)))"
            } else {
                maxResultTime = "(\(dateFormatter.string(from: Date())))"
            }
        }
    }
    
    func string() -> String {
        let averageResult: Double = 100.0 * Double(totalNumberOfCorrectAnswers) / Double(totalNumberOfQuestions)
        let averageResultString = String(format: "%.2f", averageResult)
        
        return """
               Ваш результат: \(correctAnswers)/10
               Количество сыгранных квизов: \(roundsNumber)
               Рекорд: \(maxResult)/10 \(maxResultTime)
               Средняя точность: \(averageResultString)%
               """
    }
}

struct QuizResultsViewModel {
    let title: String
    let text: String
    let buttonText: String
}

final class MovieQuizViewController: UIViewController {
    // MARK: - Controls
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var buttonYes: UIButton!
    @IBOutlet private var buttonNo: UIButton!
    
    // MARK: - Instance Variables
    private var quizResults: QuizResults = QuizResults()
    
    // MARK: - Questions
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
    ]
    
    
    
    // MARK: - Instance Methods
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let firstQuestion = convert(model: questions[quizResults.currentQuestionIndex])
        show(quiz: firstQuestion)
    }
    
    // MARK: - Private Methods
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
                                 question: model.text,
                                 questionNumber: "\(quizResults.currentQuestionIndex + 1)/\(questions.count)")
        
    }
    
    
    private func show(quiz step: QuizStepViewModel) {
        let quizStep = convert(model: questions[quizResults.currentQuestionIndex])
        imageView.image = quizStep.image
        textLabel.text = quizStep.question
        counterLabel.text = quizStep.questionNumber
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = UIColor.ypBlack.cgColor
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        
        quizResults.saveAnswerResults(isCorrect: isCorrect)
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        buttonNo.isEnabled = false
        buttonYes.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.buttonNo.isEnabled = true
            self.buttonYes.isEnabled = true
            self.showNextQuestionOrResults()
        }
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.quizResults.startRound()
            let firstQuestion = self.questions[self.quizResults.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showNextQuestionOrResults() {
        quizResults.moveNextQuestion()
        if quizResults.currentQuestionIndex == questions.count {
            quizResults.finishRound()
            let text = quizResults.string()
            
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
            
        } else {
            imageView.layer.masksToBounds = false
            let nextQuestion = questions[quizResults.currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            show(quiz: viewModel)
        }
    }
    
    // MARK: - Actions
    @IBAction func yesButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[quizResults.currentQuestionIndex]
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == true)
    }
    
    @IBAction func noButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[quizResults.currentQuestionIndex]
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == false)
    }
    
}
