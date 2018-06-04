//
//  QuestionData.swift
//  EnhanceQuizStarter
//
//  Created by Jordan Leahy on 5/26/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//



struct Question {
    let question: String
    let option1: String
    let option2: String
    let option3: String
    let option4: String
    let answer: String
}


let question1 = Question(question: "This was the only US President to serve more than two consecutive terms.",
                         option1: "Obama",
                         option2: "Franklin D Roosevelt",
                         option3: "Woodrow Wilson",
                         option4: "Andrew Jackson",
                         answer: "Franklin D Roosevelt")


let question2 = Question(question: "In what year was the United Nations founded?",
                         option1: "1918",
                         option2: "1919",
                         option3: "1945",
                         option4: "1954",
                         answer: "1945")

let question3 = Question(question: "The Titanic departed from the United Kingdom, where was it supposed to arrive?",
                         option1: "Paris",
                         option2: "Washington DC",
                         option3: "New York City",
                         option4: "Boston",
                         answer: "New York City")

let question4 = Question(question: "Which nation produces the most oil?",
                         option1: "Iran",
                         option2: "Iraq",
                         option3: "Brazil",
                         option4: "Canada",
                         answer: "Canada")

let trivia = [question1, question2, question3, question4]
