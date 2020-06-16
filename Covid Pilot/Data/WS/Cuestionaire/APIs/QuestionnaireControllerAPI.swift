//
// QuestionnaireControllerAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire
import RxSwift


open class QuestionnaireControllerAPI {
    
    private let clientApi : SwaggerClientAPI
    
    init(clientApi : SwaggerClientAPI) {
        self.clientApi = clientApi;
    }
    
    /**
     Recupera las preguntas del cuestionario

     - parameter completion: completion handler to receive the data and the error objects
     */
    open func getQuestions(completion: @escaping ((_ data: [QuestionDto]?,_ error: Error?) -> Void)) {
        getQuestionsWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    /**
     Recupera las preguntas del cuestionario
     - returns: Observable<[QuestionDto]>
     */
    open func getQuestions() -> Observable<[QuestionDto]> {
        return Observable.create { [weak self] observer -> Disposable in
            self?.getQuestions() { data, error in
                if let error = error {
                    observer.on(.error(error))
                } else {
                    observer.on(.next(data!))
                }
                observer.on(.completed)
            }
            return Disposables.create()
        }
    }

    /**
     Recupera las preguntas del cuestionario
     - GET /questions
     -

     - examples: [{contentType=application/json, example=[ {
  "minValue" : 2,
  "question" : "question",
  "maxValue" : 7,
  "options" : [ {
    "id" : 5,
    "order" : 5,
    "option" : "option"
  }, {
    "id" : 5,
    "order" : 5,
    "option" : "option"
  } ],
  "id" : 0,
  "questionType" : 1,
  "mandatory" : true,
  "order" : 6
}, {
  "minValue" : 2,
  "question" : "question",
  "maxValue" : 7,
  "options" : [ {
    "id" : 5,
    "order" : 5,
    "option" : "option"
  }, {
    "id" : 5,
    "order" : 5,
    "option" : "option"
  } ],
  "id" : 0,
  "questionType" : 1,
  "mandatory" : true,
  "order" : 6
} ]}]

     - returns: RequestBuilder<[QuestionDto]>
     */
    open func getQuestionsWithRequestBuilder() -> RequestBuilder<[QuestionDto]> {
        let path = "/questions"
        let URLString = clientApi.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<[QuestionDto]>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

}
