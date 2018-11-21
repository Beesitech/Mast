import Foundation
import UIKit
import Alamofire
import SwiftyJSON

enum SentimentAnalysisRequestType: String {
    case Text = "text"
    case URL = "url"
}

struct SentimentAnalysisRequest {
    private(set) var type: SentimentAnalysisRequestType!
    private(set) var parameterValue: String!
    
    var completionHandler: (() -> Void)?
    var successHandler: ((JSON) -> Void)?
    var failureHandler: ((NSError) -> Void)?
    
    private var encodedUrl: String {
        let characters = NSCharacterSet.urlQueryAllowed
        let encodedValue = parameterValue.addingPercentEncoding(withAllowedCharacters: characters)!
        
        let endpoint = AppConfig.SentimentAnalysisAPI.endpoint
        let key = AppConfig.SentimentAnalysisAPI.key
        
        return "\(endpoint)?\(type.rawValue)=\(encodedValue)&apikey=\(key)"
    }
    
    init(type: SentimentAnalysisRequestType, parameterValue: String) {
        self.type = type
        self.parameterValue = parameterValue
    }
    
    func makeRequest() {
        Alamofire.request(encodedUrl).responseJSON { response in
            self.completionHandler?()
            
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                self.successHandler?(json)
            case .failure(let _):
                print("err")
            }
        }
    }
}

enum SentimentType: String {
    case Negative = "negative"
    case Neutral = "neutral"
    case Positive = "positive"
}



struct AppConfig {
    /// The GitHub URL for this project.
    static let gitHubUrl = "https://milkeddit.com"
    
    struct SentimentAnalysisAPI {
        /// The url to the sentiment analysis API.
        static let endpoint = "https://api.havenondemand.com/1/api/sync/analyzesentiment/v1"
        
        /// The API key.
        static let key = "944316f6-814f-4a29-bbed-c2a414edc458"
    }
}

extension SentimentType {
    var color: UIColor {
        switch self {
        case .Negative: return .negativeColor()
        case .Neutral: return . neutralColor()
        case .Positive: return .positiveColor()
        }
    }
    
    var image: UIImage {
        return UIImage(named: "icon_sentiment_\(self.rawValue)")!
    }
}

extension UIColor {
    // MARK: - Sentiments
    
    class func negativeColor() -> UIColor {
        return UIColor(red: 0.957, green: 0.263, blue: 0.212, alpha: 1)
    }
    
    class func neutralColor() -> UIColor {
        return UIColor(red: 114/255, green: 159/255, blue: 207/255, alpha: 1)
    }
    
    class func positiveColor() -> UIColor {
        return UIColor(red: 90/255, green: 230/255, blue: 140/255, alpha: 1)
    }
    
    // MARK: - Grey
    
    class func grey500Color() -> UIColor {
        return UIColor(white: 0.62, alpha: 1)
    }
}

class SentimentAnalysisTextView: UITextView {
    let defaultAlignment: NSTextAlignment = .center
    let defaultTextColor = Colours.grayDark
    let defaultFontSize: CGFloat = 20
    let defaultLineSpacing: CGFloat = 2.5
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureView()
    }
    
    private func configureView() {
        textContainerInset = UIEdgeInsets(top:10, left:15, bottom:15, right:15)
        
        font = UIFont.systemFont(ofSize: defaultFontSize)
        textAlignment = defaultAlignment
        textColor = defaultTextColor
        
        layoutManager.delegate = self
    }
}

extension SentimentAnalysisTextView: NSLayoutManagerDelegate {
    func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return defaultLineSpacing
    }
}

extension SentimentAnalysisTextView {
    /// Updates the view with the `SentimentType` and analyzed text response.
    func updateWithSentiment(sentiment: SentimentType, response: JSON) {
        // Hides the view, processes the text and then shows the view.
        UIView.animate(withDuration: 0.1, delay: 0, options: [.beginFromCurrentState, .curveEaseOut], animations: {
            [unowned self] in
            self.alpha = 1
        }) {
            [unowned self] finished in
            self.normalizeText()
            self.highlightTextWithResponse(response: response)
            //self.tintColor = sentiment.color
            
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
                self.alpha = 1
            }, completion: nil)
        }
    }
    
    /// Normalizes the text (e.g. removes highlights and resets foreground color)
    func normalizeText() {
        textColor = defaultTextColor
        
        let normalizedText = NSMutableAttributedString(attributedString: attributedText)
        let range = (text as NSString).range(of: text)
        normalizedText.removeAttribute(.backgroundColor, range: range)
        
        attributedText = normalizedText
    }
    
    /// Highlights the "positive" and "negative" text from the response.
    func highlightTextWithResponse(response: JSON) {
        let highlightedText = NSMutableAttributedString(attributedString: attributedText)
        
        if let positiveElements = response["positive"].array {
            for element in positiveElements {
                guard let elementText = element["original_text"].string else {
                    continue
                }
                
                print("the element - \(element)")
                
                highlightedText.addAttribute(.foregroundColor,
                                             value: UIColor.white,
                                             range: (text as NSString).range(of: elementText)
                )
                
                highlightedText.addAttribute(.backgroundColor,
                                             value: UIColor.positiveColor(),
                                             range: (text as NSString).range(of: elementText)
                )
            }
        }
        
        if let negativeElements = response["negative"].array {
            for element in negativeElements {
                guard let elementText = element["original_text"].string else {
                    continue
                }
                
                highlightedText.addAttribute(.foregroundColor,
                                             value: UIColor.white,
                                             range: (text as NSString).range(of: elementText)
                )
                
                highlightedText.addAttribute(.backgroundColor,
                                             value: UIColor.negativeColor(),
                                             range: (text as NSString).range(of: elementText)
                )
            }
        }
        
        self.attributedText = highlightedText
    }
}

