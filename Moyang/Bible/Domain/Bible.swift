//
//  Bible.swift
//  Moyang
//
//  Created by kibo on 2022/08/23.
//

import Foundation

class BibleInfo {
    enum Old: Int, CaseIterable {
        case Genesis = 0
        case Exodus
        case Leviticus
        case Numbers
        case Deuteronomy
        case Joshua
        case Judges
        case Ruth
        case SamuelOne
        case SamuelTwo
        case KingsOne
        case KingsTow
        case ChroniclesOne
        case ChroniclesTwo
        case Ezra
        case Nehemiah
        case Esther
        case Job
        case Psalms
        case Proverbs
        case Ecclesiastes
        case SongOfSongs
        case Isaiah
        case Jeremiah
        case Lamentations
        case Ezekiel
        case Daniel
        case Hosea
        case Joel
        case Amos
        case Obadiah
        case Jonah
        case Micah
        case Nahum
        case Habakkuk
        case Zephaniah
        case Haggai
        case Zechariah
        case Malachi
        
        var bookName: String {
            switch self {
            case .Genesis:
                return "창세기"
            case .Exodus:
                return "출애굽기"
            case .Leviticus:
                return "레위기"
            case .Numbers:
                return "민수기"
            case .Deuteronomy:
                return "신명기"
            case .Joshua:
                return "여호수아"
            case .Judges:
                return "사사기"
            case .Ruth:
                return "룻기"
            case .SamuelOne:
                return "사무엘상"
            case .SamuelTwo:
                return "사무엘하"
            case .KingsOne:
                return "열왕기상"
            case .KingsTow:
                return "열왕기하"
            case .ChroniclesOne:
                return "역대상"
            case .ChroniclesTwo:
                return "역대하"
            case .Ezra:
                return "에스라"
            case .Nehemiah:
                return "느헤미야"
            case .Esther:
                return "에스더"
            case .Job:
                return "욥기"
            case .Psalms:
                return "시편"
            case .Proverbs:
                return "잠언"
            case .Ecclesiastes:
                return "전도서"
            case .SongOfSongs:
                return "아가"
            case .Isaiah:
                return "이사야"
            case .Jeremiah:
                return "예레미야"
            case .Lamentations:
                return "예레미야애가"
            case .Ezekiel:
                return "에스겔"
            case .Daniel:
                return "다니엘"
            case .Hosea:
                return "호세아"
            case .Joel:
                return "요엘"
            case .Amos:
                return "아모스"
            case .Obadiah:
                return "오바댜"
            case .Jonah:
                return "요나"
            case .Micah:
                return "미가"
            case .Nahum:
                return "나훔"
            case .Habakkuk:
                return "하박국"
            case .Zephaniah:
                return "스바냐"
            case .Haggai:
                return "학개"
            case .Zechariah:
                return "스가랴"
            case .Malachi:
                return "말라기"
            }
        }
        
        var short: String {
            switch self {
            case .Genesis:
                return "창"
            case .Exodus:
                return "출"
            case .Leviticus:
                return "레"
            case .Numbers:
                return "민"
            case .Deuteronomy:
                return "신"
            case .Joshua:
                return "수"
            case .Judges:
                return "삿"
            case .Ruth:
                return "룻"
            case .SamuelOne:
                return "삼상"
            case .SamuelTwo:
                return "삼하"
            case .KingsOne:
                return "왕상"
            case .KingsTow:
                return "왕하"
            case .ChroniclesOne:
                return "대상"
            case .ChroniclesTwo:
                return "대하"
            case .Ezra:
                return "스"
            case .Nehemiah:
                return "느"
            case .Esther:
                return "에"
            case .Job:
                return "욥"
            case .Psalms:
                return "시"
            case .Proverbs:
                return "잠"
            case .Ecclesiastes:
                return "전"
            case .SongOfSongs:
                return "아"
            case .Isaiah:
                return "사"
            case .Jeremiah:
                return "렘"
            case .Lamentations:
                return "애"
            case .Ezekiel:
                return "겔"
            case .Daniel:
                return "단"
            case .Hosea:
                return "호"
            case .Joel:
                return "욜"
            case .Amos:
                return "암"
            case .Obadiah:
                return "옵"
            case .Jonah:
                return "욘"
            case .Micah:
                return "미"
            case .Nahum:
                return "나"
            case .Habakkuk:
                return "합"
            case .Zephaniah:
                return "습"
            case .Haggai:
                return "학"
            case .Zechariah:
                return "슥"
            case .Malachi:
                return "말"
            }
        }
    }
    
    enum New: Int, CaseIterable {
        case Matthew = 39
        case Mark
        case Luke
        case John
        case Acts
        case Romans
        case CorinthiansOne
        case CorinthiansTwo
        case Galatians
        case Ephesians
        case Philippians
        case Colossians
        case ThessaloniansOne
        case ThessaloniansTwo
        case TimothyOne
        case TimothyTwo
        case Titus
        case Philemon
        case Hebrews
        case James
        case PeterOne
        case PeterTwo
        case JohnOne
        case JohnTwo
        case JohnThree
        case Jude
        case Revelation
        
        var bookName: String {
            switch self {
            case .Matthew:
                return "마태복음"
            case .Mark:
                return "마가복음"
            case .Luke:
                return "누가복음"
            case .John:
                return "요한복음"
            case .Acts:
                return "사도행전"
            case .Romans:
                return "로마서"
            case .CorinthiansOne:
                return "고린도전서"
            case .CorinthiansTwo:
                return "고린도후서"
            case .Galatians:
                return "갈라디아서"
            case .Ephesians:
                return "에베소서"
            case .Philippians:
                return "빌립보서"
            case .Colossians:
                return "골로새서"
            case .ThessaloniansOne:
                return "데살로니가전서"
            case .ThessaloniansTwo:
                return "데살로니가후서"
            case .TimothyOne:
                return "디모데전서"
            case .TimothyTwo:
                return "디모데후서"
            case .Titus:
                return "디도서"
            case .Philemon:
                return "빌레몬서"
            case .Hebrews:
                return "히브리서"
            case .James:
                return "야고보서"
            case .PeterOne:
                return "베드로전서"
            case .PeterTwo:
                return "베드로후서"
            case .JohnOne:
                return "요한일서"
            case .JohnTwo:
                return "요한이서"
            case .JohnThree:
                return "요한삼서"
            case .Jude:
                return "유다서"
            case .Revelation:
                return "요한계시록"
            }
        }
        
        var short: String {
            switch self {
            case .Matthew:
                return "마"
            case .Mark:
                return "막"
            case .Luke:
                return "눅"
            case .John:
                return "요"
            case .Acts:
                return "행"
            case .Romans:
                return "롬"
            case .CorinthiansOne:
                return "고전"
            case .CorinthiansTwo:
                return "고후"
            case .Galatians:
                return "갈"
            case .Ephesians:
                return "엡"
            case .Philippians:
                return "빌"
            case .Colossians:
                return "골"
            case .ThessaloniansOne:
                return "살전"
            case .ThessaloniansTwo:
                return "살후"
            case .TimothyOne:
                return "딤전"
            case .TimothyTwo:
                return "딤후"
            case .Titus:
                return "딛"
            case .Philemon:
                return "몬"
            case .Hebrews:
                return "히"
            case .James:
                return "약"
            case .PeterOne:
                return "벧전"
            case .PeterTwo:
                return "벧후"
            case .JohnOne:
                return "요일"
            case .JohnTwo:
                return "요이"
            case .JohnThree:
                return "요삼"
            case .Jude:
                return "유"
            case .Revelation:
                return "계"
            }
        }
    }
    
    // https://thebible.life/bible-books-and-number-of-chapters-old-testament/
    static let Genesis = BibleBookInfo(type: Old.Genesis.rawValue, category: "", bookName: Old.Genesis.bookName, author: "",
                                       chapterCount: [31,25,24,26,32,22,24,22,29,32,
                                                      32,20,18,24,21,16,27,33,38,18,
                                                      34,24,20,67,34,35,46,22,35,43,
                                                      55,32,20,31,29,43,36,30,23,23,
                                                      57,38,34,34,28,34,31,22,33,26])
    static let Exodus = BibleBookInfo(type: Old.Exodus.rawValue, category: "", bookName: Old.Exodus.bookName, author: "",
                                      chapterCount: [22,25,22,31,23,30,25,32,35,29,
                                                     10,51,22,31,27,36,16,27,25,26,
                                                     36,31,33,18,40,37,21,43,46,38,
                                                     18,35,23,35,35,38,29,31,43,38])
    static let Leviticus = BibleBookInfo(type: Old.Leviticus.rawValue, category: "", bookName: Old.Leviticus.bookName, author: "",
                                         chapterCount: [17,16,17,35,19,30,38,36,24,20,
                                                        47,8,59,57,33,34,16,30,37,27,
                                                        24,33,44,23,55,46,34])
    static let Numbers = BibleBookInfo(type: Old.Numbers.rawValue, category: "", bookName: Old.Numbers.bookName, author: "",
                                       chapterCount: [54,34,51,49,31,27,89,26,23,36,
                                                      35,16,33,45,41,50,13,32,22,29,
                                                      35,41,30,25,18,65,23,31,40,16,
                                                      54,42,56,29,34,13])
    static let Deuteronomy = BibleBookInfo(type: Old.Deuteronomy.rawValue, category: "", bookName: Old.Deuteronomy.bookName, author: "",
                                           chapterCount: [46,37,29,49,33,25,26,20,29,22,
                                                          32,32,18,29,23,22,20,22,21,20,
                                                          23,30,25,22,19,19,26,68,29,20,
                                                          30,52,29,12])
    static let Joshua = BibleBookInfo(type: Old.Joshua.rawValue, category: "", bookName: Old.Joshua.bookName, author: "",
                                      chapterCount: [18,24,17,24,15,27,26,35,27,43,
                                                     23,24,33,15,63,10,18,28,51,9,
                                                     45,34,16,33])
    static let Judges = BibleBookInfo(type: Old.Judges.rawValue, category: "", bookName: Old.Judges.bookName, author: "",
                                      chapterCount: [36,23,31,24,31,40,25,35,57,18,
                                                     40,15,25,20,20,31,13,31,30,48,
                                                     25])
    static let Ruth = BibleBookInfo(type: Old.Ruth.rawValue, category: "", bookName: Old.Ruth.bookName, author: "",
                                    chapterCount: [22,23,18,22])
    static let SamuelOne = BibleBookInfo(type: Old.SamuelOne.rawValue, category: "", bookName: Old.SamuelOne.bookName, author: "",
                                         chapterCount: [28,36,21,22,12,21,17,22,27,27,
                                                        15,25,23,52,35,23,58,30,24,42,
                                                        15,23,29,22,44,25,12,25,11,31,
                                                        13])
    static let SamuelTwo = BibleBookInfo(type: Old.SamuelTwo.rawValue, category: "", bookName: Old.SamuelTwo.bookName, author: "",
                                         chapterCount: [27,32,39,12,25,23,29,18,13,19,
                                                        27,31,39,33,37,23,29,33,43,26,
                                                        22,51,39,25])
    static let KingsOne = BibleBookInfo(type: Old.KingsOne.rawValue, category: "", bookName: Old.KingsOne.bookName, author: "",
                                        chapterCount: [53,46,28,34,18,38,51,66,28,29,
                                                       43,33,34,31,34,34,24,46,21,43,
                                                       29,53])
    static let KingsTow = BibleBookInfo(type: Old.KingsTow.rawValue, category: "", bookName: Old.KingsTow.bookName, author: "",
                                        chapterCount: [18,25,27,44,27,33,20,29,37,36,
                                                       21,21,25,29,38,20,41,37,37,21,
                                                       26,20,37,20,30])
    static let ChroniclesOne = BibleBookInfo(type: Old.ChroniclesOne.rawValue, category: "", bookName: Old.ChroniclesOne.bookName, author: "",
                                             chapterCount: [54,55,24,43,26,81,40,40,44,14,
                                                            47,40,14,17,29,43,27,17,19,8,
                                                            30,19,32,31,31,32,34,21,30])
    static let ChroniclesTwo = BibleBookInfo(type: Old.ChroniclesTwo.rawValue, category: "", bookName: Old.ChroniclesTwo.bookName, author: "",
                                             chapterCount: [17,18,17,22,14,42,22,18,31,19,
                                                            23,16,22,15,19,14,19,34,11,37,
                                                            20,12,21,27,28,23,9,27,36,27,
                                                            21,33,25,33,27,23])
    static let Ezra = BibleBookInfo(type: Old.Ezra.rawValue, category: "", bookName: Old.Ezra.bookName, author: "",
                                    chapterCount: [11,70,13,24,17,22,28,36,15,44])
    static let Nehemiah = BibleBookInfo(type: Old.Nehemiah.rawValue, category: "", bookName: Old.Nehemiah.bookName, author: "",
                                        chapterCount: [11,20,32,23,19,19,73,18,38,39,
                                                       36,47,31])
    static let Esther = BibleBookInfo(type: Old.Esther.rawValue, category: "", bookName: Old.Esther.bookName, author: "",
                                      chapterCount: [22,23,15,17,14,14,10,17,32,3])
    static let Job = BibleBookInfo(type: Old.Job.rawValue, category: "", bookName: Old.Job.bookName, author: "",
                                   chapterCount: [22,13,26,21,27,30,21,22,35,22,
                                                  20,25,28,22,35,22,16,21,29,29,
                                                  34,30,17,25,6,14,23,28,25,31,
                                                  40,22,33,37,16,33,24,41,30,24,
                                                  34,17])
    static let Psalms = BibleBookInfo(type: Old.Psalms.rawValue, category: "", bookName: Old.Psalms.bookName, author: "",
                                      chapterCount: [6,12,8,8,12,10,17,9,20,18,
                                                     7,8,6,7,5,11,15,50,14,9,
                                                     13,31,6,10,22,12,14,9,11,12,
                                                     24,11,22,22,28,12,40,22,13,17,
                                                     13,11,5,26,17,11,9,14,20,23,
                                                     19,9,6,7,23,13,11,11,17,12,
                                                     8,12,11,10,13,20,7,35,36,5,
                                                     24,20,28,23,10,12,20,72,13,19,
                                                     16,8,18,12,13,17,7,18,52,17,
                                                     16,15,5,23,11,13,12,9,9,5,
                                                     8,28,22,35,45,48,43,13,31,7,
                                                     10,10,9,8,18,19,2,29,176,7,
                                                     8,9,4,8,5,6,5,6,8,8,
                                                     3,18,3,3,21,26,9,8,24,13,
                                                     10,7,12,15,21,10,20,14,9,6])
    static let Proverbs = BibleBookInfo(type: Old.Proverbs.rawValue, category: "", bookName: Old.Proverbs.bookName, author: "",
                                        chapterCount: [33,22,35,27,23,35,27,36,18,32,31,28,25,35,33,33,28,24,29,30,31,29,35,34,28,28,27,28,27,33,31])
    static let Ecclesiastes = BibleBookInfo(type: Old.Ecclesiastes.rawValue, category: "", bookName: Old.Ecclesiastes.bookName, author: "",
                                            chapterCount: [18,26,22,16,20,12,29,17,18,20,10,14])
    static let SongOfSongs = BibleBookInfo(type: Old.SongOfSongs.rawValue, category: "", bookName: Old.SongOfSongs.bookName, author: "",
                                           chapterCount: [17,17,11,16,16,13,13,14])
    static let Isaiah = BibleBookInfo(type: Old.Isaiah.rawValue, category: "", bookName: Old.Isaiah.bookName, author: "",
                                      chapterCount: [31,22,26,6,30,13,25,22,21,34,
                                                     16,6,22,32,9,14,14,7,25,6,
                                                     17,25,18,23,12,21,13,29,24,33,
                                                     9,20,24,17,10,22,38,22,8,31,
                                                     29,25,28,28,25,13,15,22,26,11,
                                                     23,15,12,17,13,12,21,14,21,22,
                                                     11,12,19,12,25,24])
    static let Jeremiah = BibleBookInfo(type: Old.Jeremiah.rawValue, category: "", bookName: Old.Jeremiah.bookName, author: "",
                                        chapterCount: [19,37,25,31,31,30,34,22,26,25,
                                                       23,17,27,22,21,21,27,23,15,18,
                                                       14,30,40,10,38,24,22,17,32,24,
                                                       40,44,26,22,19,32,21,28,18,16,
                                                       18,22,13,30,5,28,7,47,39,46,
                                                       64,34])
    static let Lamentations = BibleBookInfo(type: Old.Lamentations.rawValue, category: "", bookName: Old.Lamentations.bookName, author: "",
                                            chapterCount: [22,22,66,22,22])
    static let Ezekiel = BibleBookInfo(type: Old.Ezekiel.rawValue, category: "", bookName: Old.Ezekiel.bookName, author: "",
                                       chapterCount: [28,10,27,17,17,14,27,18,11,22,
                                                      25,28,23,23,8,63,24,32,14,49,
                                                      32,31,49,27,17,21,36,26,21,26,
                                                      18,32,33,31,15,38,28,23,29,49,
                                                      26,20,27,31,25,24,23,35])
    static let Daniel = BibleBookInfo(type: Old.Daniel.rawValue, category: "", bookName: Old.Daniel.bookName, author: "",
                                      chapterCount: [21,49,30,37,31,28,28,27,27,21,45,13])
    static let Hosea = BibleBookInfo(type: Old.Hosea.rawValue, category: "", bookName: Old.Hosea.bookName, author: "",
                                     chapterCount: [11,23,5,19,15,11,16,14,17,15,12,14,16,9])
    static let Joel = BibleBookInfo(type: Old.Joel.rawValue, category: "", bookName: Old.Joel.bookName, author: "",
                                    chapterCount: [20,32,21])
    static let Amos = BibleBookInfo(type: Old.Amos.rawValue, category: "", bookName: Old.Amos.bookName, author: "",
                                    chapterCount: [15,16,15,13,27,14,17,14,15])
    static let Obadiah = BibleBookInfo(type: Old.Obadiah.rawValue, category: "", bookName: Old.Obadiah.bookName, author: "",
                                       chapterCount: [21])
    static let Jonah = BibleBookInfo(type: Old.Jonah.rawValue, category: "", bookName: Old.Jonah.bookName, author: "",
                                     chapterCount: [17,10,10,11])
    static let Micah = BibleBookInfo(type: Old.Micah.rawValue, category: "", bookName: Old.Micah.bookName, author: "",
                                     chapterCount: [16,13,12,13,15,16,20])
    static let Nahum = BibleBookInfo(type: Old.Nahum.rawValue, category: "", bookName: Old.Nahum.bookName, author: "",
                                     chapterCount: [15,13,19])
    static let Habakkuk = BibleBookInfo(type: Old.Habakkuk.rawValue, category: "", bookName: Old.Habakkuk.bookName, author: "",
                                        chapterCount: [17,20,19])
    static let Zephaniah = BibleBookInfo(type: Old.Zephaniah.rawValue, category: "", bookName: Old.Zephaniah.bookName, author: "",
                                         chapterCount: [18,15,20])
    static let Haggai = BibleBookInfo(type: Old.Haggai.rawValue, category: "", bookName: Old.Haggai.bookName, author: "",
                                      chapterCount: [15,23])
    static let Zechariah = BibleBookInfo(type: Old.Zechariah.rawValue, category: "", bookName: Old.Zechariah.bookName, author: "",
                                         chapterCount: [21,13,10,14,11,15,14,23,17,12,17,14,9,21])
    static let Malachi = BibleBookInfo(type: Old.Malachi.rawValue, category: "", bookName: Old.Malachi.bookName, author: "",
                                       chapterCount: [14,17,18,6])
    
    // https://thebible.life/bible-books-and-number-of-chapters/
    static let Matthew = BibleBookInfo(type: New.Matthew.rawValue, category: "", bookName: New.Matthew.bookName, author: "",
                                       chapterCount: [25,23,17,25,48,34,29,34,38,42,
                                                      30,50,58,36,39,28,27,35,30,34,
                                                      46,46,39,51,46,75,66,20])
    static let Mark = BibleBookInfo(type: New.Mark.rawValue, category: "", bookName: New.Mark.bookName, author: "",
                                    chapterCount: [45,28,35,41,43,56,37,38,50,52,
                                                   33,44,37,72,47,20])
    static let Luke = BibleBookInfo(type: New.Luke.rawValue, category: "", bookName: New.Luke.bookName, author: "",
                                    chapterCount: [80,52,38,44,39,49,50,56,62,42,
                                                   54,59,35,35,32,31,37,43,48,47,
                                                   38,71,56,53])
    static let John = BibleBookInfo(type: New.John.rawValue, category: "", bookName: New.John.bookName, author: "",
                                    chapterCount: [51,25,36,54,47,71,53,59,41,42,
                                                   57,50,38,31,27,33,26,40,42,31,
                                                   25])
    static let Acts = BibleBookInfo(type: New.Acts.rawValue, category: "", bookName: New.Acts.bookName, author: "",
                                    chapterCount: [26,47,26,37,42,15,60,40,43,48,
                                                   30,25,52,28,41,40,34,28,41,38,
                                                   40,30,35,27,27,32,44,31])
    static let Romans = BibleBookInfo(type: New.Romans.rawValue, category: "", bookName: New.Romans.bookName, author: "",
                                      chapterCount: [32,29,31,25,21,23,25,39,33,21,
                                                     36,21,14,26,33,25])
    static let CorinthiansOne = BibleBookInfo(type: New.CorinthiansOne.rawValue, category: "", bookName: New.CorinthiansOne.bookName, author: "",
                                              chapterCount: [31,16,23,21,13,20,40,13,27,33,
                                                             34,31,13,40,58,24])
    static let CorinthiansTwo = BibleBookInfo(type: New.CorinthiansTwo.rawValue, category: "", bookName: New.CorinthiansTwo.bookName, author: "",
                                              chapterCount: [24,17,18,18,21,18,16,24,15,18,
                                                             33,21,14])
    static let Galatians = BibleBookInfo(type: New.Galatians.rawValue, category: "", bookName: New.Galatians.bookName, author: "",
                                         chapterCount: [24,21,29,31,26,18])
    static let Ephesians = BibleBookInfo(type: New.Ephesians.rawValue, category: "", bookName: New.Ephesians.bookName, author: "",
                                         chapterCount: [23,22,21,32,33,24])
    static let Philippians = BibleBookInfo(type: New.Philippians.rawValue, category: "", bookName: New.Philippians.bookName, author: "",
                                           chapterCount: [30,30,21,23])
    static let Colossians = BibleBookInfo(type: New.Colossians.rawValue, category: "", bookName: New.Colossians.bookName, author: "",
                                          chapterCount: [29,23,25,18])
    static let ThessaloniansOne = BibleBookInfo(type: New.ThessaloniansOne.rawValue, category: "", bookName: New.ThessaloniansOne.bookName, author: "",
                                                chapterCount: [10,20,13,18,28])
    static let ThessaloniansTwo = BibleBookInfo(type: New.ThessaloniansTwo.rawValue, category: "", bookName: New.ThessaloniansTwo.bookName, author: "",
                                                chapterCount: [12,17,18])
    static let TimothyOne = BibleBookInfo(type: New.TimothyOne.rawValue, category: "", bookName: New.TimothyOne.bookName, author: "",
                                          chapterCount: [20,15,16,16,25,21])
    static let TimothyTwo = BibleBookInfo(type: New.TimothyTwo.rawValue, category: "", bookName: New.TimothyTwo.bookName, author: "",
                                          chapterCount: [18,26,17,22])
    static let Titus = BibleBookInfo(type: New.Titus.rawValue, category: "", bookName: New.Titus.bookName, author: "",
                                     chapterCount: [16,15,15])
    static let Philemon = BibleBookInfo(type: New.Philemon.rawValue, category: "", bookName: New.Philemon.bookName, author: "",
                                        chapterCount: [25])
    static let Hebrews = BibleBookInfo(type: New.Hebrews.rawValue, category: "", bookName: New.Hebrews.bookName, author: "",
                                       chapterCount: [14,18,19,16,14,20,28,13,28,39,40,29,25])
    static let James = BibleBookInfo(type: New.James.rawValue, category: "", bookName: New.James.bookName, author: "",
                                     chapterCount: [27,26,18,17,20])
    static let PeterOne = BibleBookInfo(type: New.PeterOne.rawValue, category: "", bookName: New.PeterOne.bookName, author: "",
                                        chapterCount: [25,25,22,19,14])
    static let PeterTwo = BibleBookInfo(type: New.PeterTwo.rawValue, category: "", bookName: New.PeterTwo.bookName, author: "",
                                        chapterCount: [21,22,18])
    static let JohnOne = BibleBookInfo(type: New.JohnOne.rawValue, category: "", bookName: New.JohnOne.bookName, author: "",
                                       chapterCount: [10,29,24,21,21])
    static let JohnTwo = BibleBookInfo(type: New.JohnTwo.rawValue, category: "", bookName: New.JohnTwo.bookName, author: "",
                                       chapterCount: [13])
    static let JohnThree = BibleBookInfo(type: New.JohnThree.rawValue, category: "", bookName: New.JohnThree.bookName, author: "",
                                         chapterCount: [14])
    static let Jude = BibleBookInfo(type: New.Jude.rawValue, category: "", bookName: New.Jude.bookName, author: "",
                                    chapterCount: [25])
    static let Revelation = BibleBookInfo(type: New.Revelation.rawValue, category: "", bookName: New.Revelation.bookName, author: "",
                                          chapterCount: [20,29,22,11,14,17,17,13,21,11,19,17,18,20,8,21,18,24,21,15,27,21])
    // Old
    static let books = [Genesis, Exodus, Leviticus, Numbers, Deuteronomy,
                        Joshua, Judges, Ruth, SamuelOne, SamuelTwo,
                        KingsOne, KingsTow, ChroniclesOne, ChroniclesTwo, Ezra,
                        Nehemiah, Esther, Job, Psalms, Proverbs,
                        Ecclesiastes, SongOfSongs, Isaiah, Jeremiah, Lamentations,
                        Ezekiel, Daniel, Hosea, Joel, Amos,
                        Obadiah, Jonah, Micah, Nahum, Habakkuk,
                        Zephaniah, Haggai, Zechariah, Malachi,
                        // New
                        Matthew, Mark, Luke, John, Acts,
                        Romans, CorinthiansOne, CorinthiansTwo, Galatians, Ephesians,
                        Philippians, Colossians, ThessaloniansOne, ThessaloniansTwo, TimothyOne,
                        TimothyTwo, Titus, Philemon, Hebrews, James,
                        PeterOne, PeterTwo, JohnOne, JohnTwo, JohnThree,
                        Jude, Revelation
    ]
}

struct BibleBookInfo: Codable {
    let type: Int
    let category: String
    let bookName: String
    let author: String
    let chapterCount: [Int]
    
    enum CodingKeys: String, CodingKey {
        case type
        case category = "category"
        case bookName = "book_name"
        case author
        case chapterCount = "chapter_count"
    }
}

struct SelectedBibleBookInfo: Codable {
    let id: String
    let type: Int
    let category: Int
    let bookName: String
    let author: String
    let chapter: Int
    let verses: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case category
        case bookName = "book_name"
        case author
        case chapter
        case verses
    }
}

struct BibleVerse: Equatable {
    let content: String
    let bookNo: Int
    let chapter: Int
    let verse: Int
    
    init(_ bookNo: Int,
         _ chapter: Int,
         _ verse: Int) {
        self.bookNo = bookNo
        self.chapter = chapter
        self.verse = verse
        if let old = BibleInfo.Old.init(rawValue: bookNo) {
            content = "\(old.short) \(chapter + 1)장 \(verse + 1)절"
        } else if let new = BibleInfo.New.init(rawValue: bookNo) {
            content = "\(new.short) \(chapter + 1)장 \(verse + 1)절"
        } else {
            content = ""
        }
    }
    
    static func == (lhs: BibleVerse, rhs: BibleVerse) -> Bool {
        let isBookEqual = lhs.bookNo == rhs.bookNo
        let isChapterEqual = lhs.chapter == rhs.chapter
        let isVerseEqual = lhs.verse == rhs.verse
        return (isBookEqual && isChapterEqual && isVerseEqual)
    }
}
