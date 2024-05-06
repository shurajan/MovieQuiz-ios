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
    
    // MARK: - Instance Variables
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
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
    
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let firstQuestion = convert(model: questions[currentQuestionIndex])
        show(quiz: firstQuestion)
    }
    
    // MARK: - Private Methods
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
                                 question: model.text,
                                 questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
        
    }
    
 
    private func show(quiz step: QuizStepViewModel) {
        let quizStep = convert(model: questions[currentQuestionIndex])
        imageView.image = quizStep.image
        textLabel.text = quizStep.question
        counterLabel.text = quizStep.questionNumber
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 0
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = UIColor.black.cgColor
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        // запускаем задачу через 1 секунду c помощью диспетчера задач
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            let text = "Ваш результат: \(correctAnswers)/10"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
        } else { // 2
            imageView.layer.masksToBounds = false
            currentQuestionIndex += 1
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            show(quiz: viewModel)
        }
    }
        
    // MARK: - Actions
    
    @IBAction func yesButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == true)
    }

    @IBAction func noButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == false)
    }
    
}
